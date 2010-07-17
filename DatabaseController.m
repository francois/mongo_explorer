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

@synthesize connectionInfo, drawer, databases, databasesArrayController, collectionsArrayController, documentsArrayController, database, currentCollection, documentsTable, currentQuery, documentKeysArrayController;

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

-(NSString *)connectionString {
  if (connection && [connection connected]) {
    return [NSString stringWithFormat:@"%@ (connected)", [connection connectionString]];
  } else {
    return [NSString stringWithFormat:@"%@:%@ (disconnected)", [self.connectionInfo objectForKey:MEHost], [self.connectionInfo objectForKey:MEPort]];
  }
}

-(void)windowDidLoad {
  [self.window makeKeyWindow];
  [self.drawer openOnEdge:NSMinXEdge];

  self.databasesArrayController.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
  self.documentKeysArrayController.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES]];
  self.collectionsArrayController.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
  [self.collectionsArrayController addObserver:self forKeyPath:@"selection" options:NSKeyValueObservingOptionNew context:nil];

  [self willChangeValueForKey:@"connectionString"];
  connection = [[MEConnection alloc] initWithConnectionInfo:self.connectionInfo];
  int result = [connection connect];
  if (0 == result) {
    self.databases = [[connection databases] allObjects];
  } else {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText: @"Connection Failure"];
    [alert setInformativeText: [NSString stringWithFormat:@"Failed to connect to %@ - mongo_connect() returned: %d",
                                connection.connectionString, result]];
    [alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
    [alert release];
  }
  
  [self didChangeValueForKey:@"connectionString"];
  return;
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

-(IBAction)resetFilters:(id)sender {
  NSLog(@"Calling -[NSTableView reloadData] because of filter changes");
  [self.documentsTable reloadData];
}

-(IBAction)changeDisplayedKey:(id)sender {
  NSString *newValue = [[sender selectedItem] title];
  NSTableColumn *column = [documentsTable tableColumnWithIdentifier:@"OID"];

  /* Replace title */
  [[column headerCell] setStringValue:newValue];

  /* Bind to the new keyPath */
  NSString *newKeyPath = [@"arrangedObjects.data." stringByAppendingString:newValue];
  [column bind:@"value"
      toObject:documentsArrayController
   withKeyPath:newKeyPath
       options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSRaisesForNotApplicableKeysBindingOption, [NSNumber numberWithBool:YES], NSCreatesSortDescriptorBindingOption, nil]];
  [documentsTable reloadData];
}

@end
