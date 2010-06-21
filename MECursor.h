//
//  MECursor.h
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-19.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "mongo.h"

@class MECollection;

@interface MECursor : NSEnumerator {
  mongo_cursor *cursor;
}

@property(nonatomic, retain) MECollection *collection;
@property(nonatomic, copy) NSDictionary *params;
@property(nonatomic, assign) int skipCount;
@property(nonatomic, assign) int returnCount;
@property(nonatomic, copy) NSDictionary *order;

-(id)initWithCollection:(MECollection *)aCollection query:(NSDictionary *)params;

-(MECursor *)skip:(int)number;
-(MECursor *)limit:(int)number;
-(MECursor *)order:(NSDictionary *)ordering;

-(NSArray *)documents;

@end
