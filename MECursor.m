//
//  MECursor.m
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-19.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import "MECursor.h"

@implementation MECursor

-(id)initWithCursor:(mongo_cursor *)cursor {
  if ([super init]) return nil;
  return self;
}

-(MECursor *)skip:(int)number {
  return self;
}

-(MECursor *)limit:(int)number {
  return self;
}

-(MECursor *)order:(NSDictionary *)ordering {
  return self;
}

-(NSArray *)documents {
  return nil;
}

@end
