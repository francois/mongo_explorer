//
//  MECollection.m
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-08.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import "MECollection.h"
#import "MEDatabase.h"
#import "MEConnection.h"
#import "MEConnection-Private.h"
#import "MEDocument.h"
#import "MECursor.h"
#import "MEUtils.h"
#import "MEArray.h"

@implementation MECollection

@synthesize connection, database, fullName, name, array;

-(id)initWithDatabase:(MEDatabase *)aDatabase info:(NSDictionary *)info connection:(MEConnection *)aConnection {
  if (![super init]) return nil;

  self.connection = aConnection;
  self.database = aDatabase;
  self.fullName = [info objectForKey:@"name"];
  self.name = [[info objectForKey:@"name"] stringByReplacingOccurrencesOfString:[self.database.name stringByAppendingString:@"."] withString:@""];
  self.array = [[MEArray alloc] initWithCollection:self];

  return self;
}

-(void)dealloc {
  self.connection = nil;
  self.database = nil;
  self.name = nil;
  self.array = nil;

  [super dealloc];
}

-(NSArray *)reload {
  if ([self.connection connect]) return [NSArray array];

  NSMutableArray *results = [[NSMutableArray alloc] init];

  /* TODO: Reimplement in terms of MECursor and MEDocument */
  bson query, fields;
  const char* ns = [self.fullName cStringUsingEncoding:NSUTF8StringEncoding];
  mongo_cursor *cursor = mongo_find([self.connection mongo_connection], ns, bson_empty(&query), bson_empty(&fields), 0, 0, 0);
  while(mongo_cursor_next(cursor)) {
    bson_iterator it;
    bson_iterator_init(&it, cursor->current.data);
    NSDictionary *info = [MEUtils dictionaryFromBsonIterator:&it];
    [results addObject:[[[MEDocument alloc] initWithCollection:self info:info connection:self.connection] autorelease]];
  }
  
  mongo_cursor_destroy(cursor);

  return results;
}

-(NSString *)description {
  return self.name;
}

-(NSUInteger)documentsCount {
  return [self.connection documentsCountFromCollection:self.name database:[self.database name]];
}

-(MECursor *)find {
  return [self find:[NSDictionary dictionary]];
}

-(MECursor *)find:(NSDictionary *)query {
  return [[MECursor alloc] initWithCollection:self query:query];
}

-(NSString *)namespace {
  return [NSString stringWithFormat:@"%@.%@", self.database.name, self.name];
}

@end
