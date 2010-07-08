//
//  MECursor.m
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-19.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import "MECursor.h"
#import "MECollection.h"
#import "MEConnection-Private.h"
#import "MEUtils.h"
#import "MEDocument.h"

@implementation MECursor

@synthesize collection, params, skipCount, returnCount, order;

-(id)initWithCollection:(MECollection *)aCollection query:(NSDictionary *)aDict {
  if (![super init]) return nil;

  self.collection = aCollection;
  self.params = aDict;
  self.skipCount = 0;
  self.returnCount = UINT32_MAX;

  return self;
}

-(void)dealloc {
  if (cursor) {
    mongo_cursor_destroy(cursor);
    cursor = NULL;
  }

  self.collection = nil;
  self.params = nil;

  [super dealloc];
}

-(MECursor *)skip:(NSUInteger)number {
  self.skipCount = number;
  return self;
}

-(MECursor *)limit:(NSUInteger)number {
  self.returnCount = number;
  return self;
}

-(MECursor *)order:(NSDictionary *)ordering {
  self.order = ordering;
  return self;
}

-(NSArray *)documents {
  NSArray *results = [self allObjects];
  return results;
}

-(void)ensureCursor {
  if (cursor) return;
  
  int nToReturn = self.returnCount < 0 ? self.returnCount : -1 * self.returnCount;
  NSLog(@"-[MECursor ensureCursor] (namespace=%@ query=%@ skipCount=%d returnCount=%d)", self.collection.namespace, self.params, self.skipCount, nToReturn);
  cursor = [self.collection.connection cursorForNamespace:self.collection.namespace
                                                    query:self.params
                                                   fields:nil
                                                skipCount:self.skipCount
                                              returnCount:nToReturn];
}

-(id)nextObject {
  [self ensureCursor];
  if (mongo_cursor_next(cursor)) {
    return [[[MEDocument alloc] initWithCollection:self.collection
                                              info:[MEUtils dictionaryFromBson:&cursor->current]
                                        connection:self.collection.connection] autorelease];
  } else {
    mongo_cursor_destroy(cursor);
    cursor = NULL;
    return nil;
  }
}

@end
