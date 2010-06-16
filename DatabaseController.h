//
//  DatabaseController.h
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-06.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MEConnection;
@class MEDatabase;

@interface DatabaseController : NSWindowController {
  MEConnection *connection;
}

@property(nonatomic, copy) NSDictionary *connectionInfo;
@property(nonatomic, retain) IBOutlet NSDrawer *drawer;
@property(nonatomic, copy) NSArray *databases;
@property(nonatomic, retain) IBOutlet NSArrayController *arrayController;
@property(nonatomic, retain) MEDatabase *database;

-(id)initWithConnectionOptions:(NSDictionary *)connectionOptions;

@end
