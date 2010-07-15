//
//  Mongo_ExplorerAppDelegate.m
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-05.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import "Mongo_ExplorerAppDelegate.h"
#import "NewConnectionController.h"
#import "DatabaseController.h"

@implementation Mongo_ExplorerAppDelegate

-(void)dealloc {
  [newConnectionController release];
  [super dealloc];
}
   
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openConnection:) name:MEConnectionRequest object:nil];
  [self newConnection:self];
}

-(void)openConnection:(NSNotification *)aNotification {
  DatabaseController *controller = [[DatabaseController alloc] initWithConnectionOptions:[aNotification userInfo]];
  [controller showWindow:self];
}

-(IBAction)newConnection:(id)sender {
  if (!newConnectionController) {
    newConnectionController = [[NewConnectionController alloc] init];
  }

  [newConnectionController showWindow:self];
}

@end
