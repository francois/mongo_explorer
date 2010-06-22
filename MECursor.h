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
@property(nonatomic, assign) NSUInteger skipCount;
@property(nonatomic, assign) NSUInteger returnCount;
@property(nonatomic, copy) NSDictionary *order;

-(id)initWithCollection:(MECollection *)aCollection query:(NSDictionary *)params;

-(MECursor *)skip:(NSUInteger)number;
-(MECursor *)limit:(NSUInteger)number;
-(MECursor *)order:(NSDictionary *)ordering;

-(NSArray *)documents;

@end
