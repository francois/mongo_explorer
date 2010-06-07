//
//  DatabaseController.h
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-06.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "mongo.h"

@interface DatabaseController : NSWindowController {
  mongo_connection *connection;
}

@property(nonatomic, copy) NSDictionary *connectionInfo;
@property(nonatomic, retain) IBOutlet NSDrawer *drawer;
@property(nonatomic, copy) NSArray *databases;

-(id)initWithConnectionOptions:(NSDictionary *)connectionOptions;

@end
