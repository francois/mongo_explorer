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
@class MECollection;

@interface DatabaseController : NSWindowController <NSTableViewDataSource> {
  MEConnection *connection;
}

@property(nonatomic, retain) IBOutlet NSDrawer *drawer;
@property(nonatomic, retain) IBOutlet NSArrayController *databasesArrayController;
@property(nonatomic, retain) IBOutlet NSArrayController *collectionsArrayController;
@property(nonatomic, retain) IBOutlet NSTableView *documentsTable;

@property(nonatomic, copy) NSDictionary *connectionInfo;
@property(nonatomic, copy) NSArray *databases;
@property(nonatomic, retain) MEDatabase *database;
@property(nonatomic, retain) MECollection *currentCollection;

-(id)initWithConnectionOptions:(NSDictionary *)connectionOptions;

@end
