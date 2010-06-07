//
//  DatabaseController.h
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-06.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MEConnection;

@interface DatabaseController : NSWindowController {
  MEConnection *connection;
}

@property(nonatomic, copy) NSDictionary *connectionInfo;
@property(nonatomic, retain) IBOutlet NSDrawer *drawer;
@property(nonatomic, copy) NSArray *databases;

-(id)initWithConnectionOptions:(NSDictionary *)connectionOptions;

@end
