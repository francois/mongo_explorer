//
//  MEConnection.m
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-06.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import "MEConnection.h"
#import "MEConnection-Private.h"
#import "MEDatabase.h"
#import "MECollection.h"
#import "MEUtils.h"
#include <assert.h>

NSString * const MEDBName = @"name";
NSString * const MEDBSize = @"sizeOnDisk";

NSString * const MEHost = @"Host";
NSString * const MEPort = @"Port";
NSString * const MEUsername = @"Username";
NSString * const MEPassword = @"Password";

@implementation MEConnection

@synthesize host, port, username, password;

-(id)initWithConnectionInfo:(NSDictionary *)connectionInfo {
  if (![super init]) return nil;

  self.host = [connectionInfo objectForKey:MEHost];
  self.port = [[connectionInfo objectForKey:MEPort] intValue];
  if (0 == self.port) self.port = 27017; /* mongo.h doesn't have a #define for the default port */
  self.username = [connectionInfo objectForKey:MEUsername];
  self.password = [connectionInfo objectForKey:MEPassword];

  return self;
}

-(void)dealloc {
  [self disconnect];
  
  self.host = nil;
  self.port = 0;
  self.username = nil;
  self.password = nil;

  [super dealloc];
}

-(NSString *)connectionString {
  if ([self.username length]) {
    if ([self.password length]) {
      return [NSString stringWithFormat:@"mongodb://%@@%@:%d", self.username, self.host, self.port];
    } else {
      return [NSString stringWithFormat:@"mongodb://%@:%@@%@:%d", self.username, self.password, self.host, self.port];
    }
  } else {
    return [NSString stringWithFormat:@"mongodb://%@:%d", self.host, self.port];
  }
}

-(int)connect {
  if (connection) return mongo_conn_success;

  [self willChangeValueForKey:@"connected"];

  mongo_connection_options opts;
  strcpy(opts.host, [self.host cStringUsingEncoding:NSUTF8StringEncoding]);
  opts.port = self.port;

  mongo_conn_return result;
  connection = (mongo_connection *)malloc(sizeof(mongo_connection));
  if (connection) {
    NSLog(@"Connecting to %@", [self connectionString]);
    result = mongo_connect(connection, &opts);
  } else {
    result = mongo_conn_fail; /* Hard-coded failure: could not allocate memory */
  }

  [self didChangeValueForKey:@"connected"];
  return result;
}

-(void)disconnect {
  if (!connection) return;

  NSLog(@"Disconnecting from %@", [self connectionString]);
  [self willChangeValueForKey:@"connected"];

  mongo_destroy(connection);
  free(connection);
  connection = NULL;

  [self didChangeValueForKey:@"connected"];
}

-(BOOL)connected {
  return connection ? YES : NO;
}

/* Mongo returns databases in a BSON document with the following structure:
 * {
 *   "databases" : [
 *     {
 *       "name" : "adgear_development",
 *       "sizeOnDisk" : 218103808,
 *       "empty" : false
 *     }
 *   ]
 * }
 *
 * This method essentially returns the contents of the "databases" object.
 */
-(NSSet *)databases {
  if ([self connect]) return [NSSet set];

  bson query, out;
  bson_buffer qbuffer;
  bson_buffer_init(&qbuffer);
  bson_append_int(&qbuffer, "listDatabases", 1);

  bson_bool_t result;
  result = mongo_run_command(connection, "admin", bson_from_buffer(&query, &qbuffer), bson_empty(&out));
  if (!result) {
    bson_destroy(&out);
    bson_destroy(&query);
    bson_buffer_destroy(&qbuffer);

    return [NSSet set];
  }
  
  bson_iterator it;
  bson_iterator_init(&it, out.data);
  NSDictionary *dict = [MEUtils dictionaryFromBsonIterator:&it];
  NSMutableArray *output = [[[NSMutableArray alloc] initWithCapacity:[[dict objectForKey:@"databases"] count]] autorelease];
  for(NSDictionary *dbinfo in [dict objectForKey:@"databases"]) {
    [output addObject:[[[MEDatabase alloc] initWithInfo:dbinfo connection:self] autorelease]];
  }

  bson_destroy(&out);
  bson_destroy(&query);
  return [NSSet setWithArray:output];
}

-(long)documentsInCollection:(NSString *)collectionName database:(NSString *)dbname {
  // adgear_staging.$cmd { count: "segmented_inventory_43", query: {}, fields: {} }
  if ([self connect]) return 0;

  bson query, out;
  bson_buffer qbuffer;
  bson_buffer_init(&qbuffer);
  bson_append_string(&qbuffer, "count", [collectionName cStringUsingEncoding:NSUTF8StringEncoding]);

  bson_bool_t result;
  result = mongo_run_command(connection, [dbname cStringUsingEncoding:NSUTF8StringEncoding], bson_from_buffer(&query, &qbuffer), bson_empty(&out));
  bson_buffer_destroy(&qbuffer);
  if (!result) return 0;

  bson_iterator it;
  bson_iterator_init(&it, out.data);
  long n = -1;
  while(bson_iterator_next(&it)) {
    if (0 == strcmp("n", bson_iterator_key(&it))) {
      n = bson_iterator_long(&it);
      break;
    }
  }

  NSAssert(-1 != n, @"Never hit the 'n' key in the returned document");

  return n;
}

-(mongo_connection *)mongo_connection {
  if ([self connect]) return NULL;
  return connection;
}

-(unsigned long)documentsCountFromCollection:(NSString *)collectionName database:(NSString *)databaseName {
  if ([self connect]) return 0;

  
  bson empty;
  bson_empty(&empty);
  int64_t count;
  count = mongo_count(connection,
                      [databaseName cStringUsingEncoding:NSUTF8StringEncoding],
                      [collectionName cStringUsingEncoding:NSUTF8StringEncoding],
                      &empty);
  return count;
}

-(mongo_cursor *)cursorForNamespace:(NSString *)namespace query:(NSDictionary *)aQuery fields:(NSDictionary *)aFields skipCount:(int)skipCount returnCount:(int)returnCount {
  if ([self connect]) return NULL;

  bson query;
  bson_empty(&query);

  bson fields;
  bson_empty(&fields);

  mongo_cursor *cursor;
  cursor = mongo_find(connection, [namespace cStringUsingEncoding:NSUTF8StringEncoding], &query, &fields, returnCount, skipCount, 0);
  if (!cursor) return NULL;
  
  return cursor;
}

-(MEDatabase *)databaseNamed:(NSString *)aName {
  for(MEDatabase *db in [self databases]) {
    if ([db.name isEqual:aName]) return db;
  }

  return nil;
}

@end
