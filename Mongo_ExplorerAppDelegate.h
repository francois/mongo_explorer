//
//  Mongo_ExplorerAppDelegate.h
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-05.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class NewConnectionController;

@interface Mongo_ExplorerAppDelegate : NSObject {
  NSWindowController *newConnectionController;
}

-(IBAction)newConnection:(id)sender;

@end
