//
//  MECursor.h
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-19.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "mongo.h"

@interface MECursor : NSEnumerator {
}

-(id)initWithCursor:(mongo_cursor *)cursor;

-(MECursor *)skip:(int)number;
-(MECursor *)limit:(int)number;
-(MECursor *)order:(NSDictionary *)ordering;

-(NSArray *)documents;

@end
