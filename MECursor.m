//
//  MECursor.m
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-19.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import "MECursor.h"
#import "MECollection.h"

@implementation MECursor

@synthesize collection, params, skipCount, returnCount, order;

-(id)initWithCollection:(MECollection *)aCollection query:(NSDictionary *)aDict {
  if (![super init]) return nil;

  self.collection = aCollection;
  self.params = aDict;
  self.skipCount = 0;
  self.returnCount = INT_MAX;

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

-(MECursor *)skip:(int)number {
  self.skipCount = number;
  return self;
}

-(MECursor *)limit:(int)number {
  self.returnCount = number;
  return self;
}

-(MECursor *)order:(NSDictionary *)ordering {
  self.order = ordering;
  return self;
}

-(NSArray *)documents {
  NSArray *results = [self allObjects];
  mongo_cursor_destroy(cursor);
  cursor = NULL;

  return results;
}

-(void)ensureCursor {
  if (cursor) return;

  const char* ns = [self.collection.namespace cStringUsingEncoding:NSUTF8StringEncoding];

  bson query;
  bson fields;
  bson_empty(&query);
  bson_empty(&fields);

  cursor = mongo_find([self.collection.connection mongo_connection], ns, &query, &fields, self.returnCount, self.skipCount, 0);
}

@end
