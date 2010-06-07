//
//  DatabaseController.m
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-06.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import "DatabaseController.h"
#import "NewConnectionController.h"
#import "mongo.h"

@implementation DatabaseController

@synthesize connectionInfo, drawer, databases;

-(id)initWithConnectionOptions:(NSDictionary *)connectionOptions {
  if (![super initWithWindowNibName:@"Database"]) return nil;
  NSLog(@"DatabaseController: connecting to: %@", connectionOptions);
  self.connectionInfo = connectionOptions;
  return self;
}

-(void)dealloc {
  if (connection) {
    mongo_destroy(connection);
    free(connection);
  }

  [self.connectionInfo release];
  [super dealloc];
}

-(void)windowDidLoad {
  self.window.title = [NSString stringWithFormat:@"%@:%@", [self.connectionInfo objectForKey:MEHost], [self.connectionInfo objectForKey:MEPort]];
  [self.drawer openOnEdge:NSMinXEdge];

  mongo_connection_options opts;
  strcpy(opts.host, [[self.connectionInfo objectForKey:MEHost] cString]);
  opts.port = [[self.connectionInfo objectForKey:MEPort] intValue];
  if (0 == opts.port) opts.port = 27017; /* mongo doesn't have a default port constant or define */

  connection = (mongo_connection *)malloc(sizeof(mongo_connection));
  if (!connection) return;
  
  mongo_conn_return result = mongo_connect(connection, &opts);
  if (mongo_conn_success == result) {
    bson query, out;
    bson_buffer qbuffer;
    bson_buffer_init(&qbuffer);
    bson_append_int(&qbuffer, "listDatabases", 1);
    
    /*
      {
        "databases" : [
          {
            "name" : "adgear_development",
            "sizeOnDisk" : 218103808,
            "empty" : false
          }
        ]
      }
    */

    mongo_run_command(connection, "admin", bson_from_buffer(&query, &qbuffer), bson_empty(&out));

    bson_iterator it;
    bson_iterator_init(&it, out.data);
    int depth = 0;

    NSMutableSet *dbs = [[NSMutableSet alloc] init];
    while(bson_iterator_next(&it)){
      if (0 == strcmp(bson_iterator_key(&it), "databases")) {
        depth++;
        bson_iterator it0;
        bson_iterator_subiterator(&it, &it0);
        while(bson_iterator_next(&it0)) {
          if (bson_object == bson_iterator_type(&it0)) {
            bson_iterator it1;
            bson_iterator_subiterator(&it0, &it1);
            depth++;
            NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
            while(bson_iterator_next(&it1)) {
              if (0 == strcmp("name", bson_iterator_key(&it1))) {
                const char* name = bson_iterator_string(&it1);
                [row setObject:[[[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding] autorelease] forKey:@"name"];
              } else if (0 == strcmp("sizeOnDisk", bson_iterator_key(&it1))) {
                [row setObject:[NSNumber numberWithLong:bson_iterator_long(&it1)] forKey:@"sizeOnDisk"];
              }
            }

            if ([row count] > 0) [dbs addObject:row];
          }
        }
      }
    }

    self.databases = [dbs allObjects];
    [dbs release];

    bson_destroy(&out);
    bson_destroy(&query);

    return;
  }

  NSAlert *alert = [[NSAlert alloc] init];
  [alert setMessageText: @"Connection Failure"];
  [alert setInformativeText: [NSString stringWithFormat:@"Failed to connect to %s:%d - mongo_connect() returned: %d",
                              opts.host, opts.port, result]];
  [alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
  [alert release];
}

@end
