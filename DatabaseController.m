//
//  DatabaseController.m
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-06.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import "DatabaseController.h"
#import "NewConnectionController.h"

@implementation DatabaseController

@synthesize connectionInfo;

-(id)initWithConnectionOptions:(NSDictionary *)connectionOptions {
  if (![super initWithWindowNibName:@"Database"]) return nil;
  NSLog(@"DatabaseController: connecting to: %@", connectionOptions);
  self.connectionInfo = connectionOptions;
  return self;
}

-(void)dealloc {
  [self.connectionInfo release];
  [super dealloc];
}

-(void)windowDidLoad {
  NSLog(@"DatabaseController window did load: %@", self.connectionInfo);
  self.window.title = [self.connectionInfo objectForKey:MEHost];
}

@end
