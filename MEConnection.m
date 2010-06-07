//
//  MEConnection.m
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-06.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import "MEConnection.h"

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

-(int)connect {
  if (connection) return mongo_conn_success;

  [self willChangeValueForKey:@"connected"];

  mongo_connection_options opts;
  strcpy(opts.host, [self.host cStringUsingEncoding:NSUTF8StringEncoding]);
  opts.port = self.port;

  mongo_conn_return result;
  connection = (mongo_connection *)malloc(sizeof(mongo_connection));
  if (connection) {
    NSLog(@"Connecting to mongo://%@:%@@%@:%d", self.username, self.password, self.host, self.port);
    result = mongo_connect(connection, &opts);
  } else {
    result = mongo_conn_fail; /* Hard-coded failure: could not allocate memory */
  }

  [self didChangeValueForKey:@"connected"];
  return result;
}

-(void)disconnect {
  if (!connection) return;

  NSLog(@"Disconnecting from mongo://%@:%@@%@:%d", self.username, self.password, self.host, self.port);
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
  if (!result) return [NSSet set];
  
  bson_iterator it;
  bson_iterator_init(&it, out.data);
  
  NSMutableSet *dbs = [NSMutableSet set];
  while(bson_iterator_next(&it)){
    if (0 == strcmp(bson_iterator_key(&it), "databases")) {
      bson_iterator it0;
      bson_iterator_subiterator(&it, &it0);
      while(bson_iterator_next(&it0)) {
        if (bson_object == bson_iterator_type(&it0)) {
          bson_iterator it1;
          bson_iterator_subiterator(&it0, &it1);
          NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
          while(bson_iterator_next(&it1)) {
            if (0 == strcmp("name", bson_iterator_key(&it1))) {
              const char* dbname = bson_iterator_string(&it1);
              [row setObject:[NSString stringWithCString:dbname encoding:NSUTF8StringEncoding] forKey:@"name"];
            } else if (0 == strcmp("sizeOnDisk", bson_iterator_key(&it1))) {
              [row setObject:[NSNumber numberWithLong:bson_iterator_long(&it1)] forKey:@"sizeOnDisk"];
            }
          }
          
          if ([row count] > 0) [dbs addObject:row];
        }
      }
    }
  }
  
  bson_destroy(&out);
  bson_destroy(&query);

  return dbs;
}

@end
