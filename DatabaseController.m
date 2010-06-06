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

@synthesize connectionInfo;

-(id)initWithConnectionOptions:(NSDictionary *)connectionOptions {
  if (![super initWithWindowNibName:@"Database"]) return nil;
  NSLog(@"DatabaseController: connecting to: %@", connectionOptions);
  self.connectionInfo = connectionOptions;
  return self;
}

-(void)dealloc {
  if (connection) {
    mongo_disconnect(connection);
    free(connection);
  }

  [self.connectionInfo release];
  [super dealloc];
}

-(void)windowDidLoad {
  self.window.title = [NSString stringWithFormat:@"%@:%@", [self.connectionInfo objectForKey:MEHost], [self.connectionInfo objectForKey:MEPort]];

  mongo_connection_options opts;
  strcpy(opts.host, [[self.connectionInfo objectForKey:MEHost] cString]);
  opts.port = [[self.connectionInfo objectForKey:MEPort] intValue];
  if (0 == opts.port) opts.port = 27017; /* mongo doesn't have a default port constant or define */

  connection = (mongo_connection *)malloc(sizeof(mongo_connection));
  if (!connection) return;
  
  mongo_conn_return result = mongo_connect(connection, &opts);
  if (mongo_conn_success == result) return;

  NSAlert *alert = [[NSAlert alloc] init];
  [alert setMessageText: @"Connection Failure"];
  [alert setInformativeText: [NSString stringWithFormat:@"Failed to connect to %s:%d - mongo_connect() returned: %d",
                              opts.host, opts.port, result]];
  [alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
  [alert release];
}

@end
