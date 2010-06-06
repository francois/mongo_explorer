//
//  DatabaseController.h
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-06.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DatabaseController : NSWindowController {

}

@property(nonatomic, copy) NSDictionary *connectionInfo;

-(id)initWithConnectionOptions:(NSDictionary *)connectionOptions;

@end
