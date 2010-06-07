//
//  NewConnectionController.m
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-05.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import "NewConnectionController.h"
#import "MEConnection.h"

NSString * const MEConnectionRequest = @"ConnectionRequest";

@implementation NewConnectionController

@synthesize host, port, username, password;

-(id)init {
  if (![super initWithWindowNibName:@"Connection"]) return nil;
  return self;
}

-(void)resetFields {
  [[self host] setStringValue:@"127.0.0.1"];
  [[self port] setStringValue:@"27017"];
  [[self username] setStringValue:@""];
  [[self password] setStringValue:@""];  
}

-(void)windowDidLoad {
  [self resetFields];
  [[self window] makeKeyWindow];
}

-(IBAction)connect:(id)sender {
  NSDictionary *connectionOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [[self host] stringValue], MEHost,
                                     [NSNumber numberWithInt:[[self port] intValue]], MEPort,
                                     [[self username] stringValue], MEUsername,
                                     [[self password] stringValue], MEPassword, nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:MEConnectionRequest object:self userInfo:connectionOptions];
  [connectionOptions release];

  [self resetFields];
  [[self window] close];
}

-(IBAction)cancel:(id)sender {
  [self resetFields];
  [[self window] close];
}

@end
