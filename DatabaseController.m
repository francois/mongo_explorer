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
#import "MECollection.h"

@implementation DatabaseController

@synthesize connectionInfo, drawer, databases, databasesArrayController, collectionsArrayController, database, currentCollection, documentsTable;

-(id)initWithConnectionOptions:(NSDictionary *)connectionOptions {
  if (![super initWithWindowNibName:@"Database"]) return nil;
  NSLog(@"DatabaseController: connecting to: %@", connectionOptions);
  self.connectionInfo = connectionOptions;
  return self;
}

-(void)dealloc {
  [self.collectionsArrayController removeObserver:self forKeyPath:@"selection"];

  self.collectionsArrayController = nil;
  self.databasesArrayController = nil;
  self.databases = nil;
  self.database = nil;
  self.currentCollection = nil;
  self.documentsTable = nil;
  self.drawer = nil;

  [connection disconnect];
  [connection release];

  self.connectionInfo = nil;
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

  [self.collectionsArrayController addObserver:self forKeyPath:@"selection" options:NSKeyValueObservingOptionNew context:nil];

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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//  NSLog(@"observeValueForKeyPath:%@ ofObject:%@ change:%@ context:%@", keyPath, object, change, context);
  if ([keyPath isEqual:@"selection"] && object == self.collectionsArrayController) {
    if (NSNotFound == [self.collectionsArrayController selectionIndex]) {
      self.currentCollection = nil;
    } else {
      MEDatabase *db = [self.databases objectAtIndex:[self.databasesArrayController selectionIndex]];
      self.currentCollection = [db.collections objectAtIndex:[self.collectionsArrayController selectionIndex]];
    }

    NSLog(@"Calling -[NSTableView reloadData], currentCollection: %@", self.currentCollection);
    [self.documentsTable reloadData];
  }

  // If super ever implements, we'll have to call it
  // [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark NSTableViewDataSource

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  NSLog(@"numberOfRowsInTableView:");
  return [self.currentCollection documentsCount];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
  NSLog(@"tableView:objectValueForColumn:row:%d", row);
  return @"tada";
}

@end
