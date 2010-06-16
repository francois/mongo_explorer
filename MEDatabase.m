//
//  MEDatabase.m
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-08.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import "MEDatabase.h"
#import "MEConnection.h"
#import "MECollection.h"
#import "MEUtils.h"

@implementation MEDatabase

@synthesize connection, name, collections;

-(id)initWithInfo:(NSDictionary *)info connection:(MEConnection *)aConnection {
  if (![super init]) return nil;
  self.name = [info objectForKey:@"name"];
  self.connection = aConnection;
  self.collections = [self reload];

  return self;
}

-(void)dealloc {
  self.name = nil;
  self.connection = nil;
  [super dealloc];
}

-(NSArray *)reload {
  if ([self.connection connect]) return [NSArray array];
  
  NSMutableArray *results = [[NSMutableArray alloc] init];
  
  bson query, fields;
  const char* ns = [[self.name stringByAppendingString:@".system.namespaces"] cStringUsingEncoding:NSUTF8StringEncoding];
  mongo_cursor *cursor = mongo_find([self.connection mongo_connection], ns, bson_empty(&query), bson_empty(&fields), 0, 0, 0);
  while(mongo_cursor_next(cursor)) {
    bson_iterator it;
    bson_iterator_init(&it, cursor->current.data);
    NSDictionary *info = [MEUtils dictionaryFromBsonIterator:&it];
    if ([[info objectForKey:@"name"] rangeOfString:@"$"].location == NSNotFound) {
      [results addObject:[[[MECollection alloc] initWithDatabase:self info:info connection:self.connection] autorelease]];
    }
  }
  
  mongo_cursor_destroy(cursor);

  NSLog(@"MEDatabase#reload:\n%@", results);
  return results;
}

-(NSString *)description {
  return self.name;
}

@end
