//
//  DatabaseController.m
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-06.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import "DatabaseController.h"
#import "NewConnectionController.h"
#import "MEConnection.h"
#import "MEDatabase.h"

@implementation DatabaseController

@synthesize connectionInfo, drawer, databases, arrayController, database;

-(id)initWithConnectionOptions:(NSDictionary *)connectionOptions {
  if (![super initWithWindowNibName:@"Database"]) return nil;
  NSLog(@"DatabaseController: connecting to: %@", connectionOptions);
  self.connectionInfo = connectionOptions;
  return self;
}

-(void)dealloc {
  [connection disconnect];
  [connection release];

  [self.connectionInfo release];
  [super dealloc];
}

-(void)updateWindowTitle {
  if (connection && [connection connected]) {
    self.window.title = [NSString stringWithFormat:@"%@ (connected)", [connection connectionString]];
  } else {
    self.window.title = [NSString stringWithFormat:@"%@:%@ (disconnected)", [self.connectionInfo objectForKey:MEHost], [self.connectionInfo objectForKey:MEPort]];
  }
}

-(void)windowDidLoad {
  [self updateWindowTitle];
  [self.window makeKeyWindow];
  [self.drawer openOnEdge:NSMinXEdge];

  connection = [[MEConnection alloc] initWithConnectionInfo:self.connectionInfo];
  int result = [connection connect];
  if (0 == result) {
    [self updateWindowTitle];
    self.databases = [[connection databases] allObjects];
    return;
  }

  NSAlert *alert = [[NSAlert alloc] init];
  [alert setMessageText: @"Connection Failure"];
  [alert setInformativeText: [NSString stringWithFormat:@"Failed to connect to %@ - mongo_connect() returned: %d",
                              connection.connectionString, result]];
  [alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
  [alert release];
}

@end
