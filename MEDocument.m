//
//  MEDocument.m
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-15.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import "MEDocument.h"
#import "MEConnection.h"
#import "MECollection.h"

@implementation MEDocument

@synthesize data, collection, connection, flatView;

-(id)initWithCollection:(MECollection *)aCollection info:(NSDictionary *)info connection:(MEConnection *)aConnection {
  if (![super init]) return nil;

  self.collection = aCollection;
  self.connection = aConnection;
  self.data = [info mutableCopy];

  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  [self flattenInto:dict rootedAt:self.data path:[NSArray array]];
  self.flatView = dict;
  [dict release];
  
  return self;
}

-(void)dealloc {
  self.collection = nil;
  self.connection = nil;
  self.flatView = nil;
  self.data = nil;
  [super dealloc];
}

-(NSString *)description {
  return [self.data description];
}

-(NSString *)oid {
  return [self.data objectForKey:@"_id"];
}

-(NSString *)abstractDocument {
  NSCharacterSet *spaces = [NSCharacterSet characterSetWithCharactersInString:@" \t"];
  NSArray *components = [[data description] componentsSeparatedByString:@"\n"];
  [components makeObjectsPerformSelector:@selector(stringByTrimmingCharactersInSet:)
                              withObject:spaces];
  return [components componentsJoinedByString:@" "];
}

-(void)flattenInto:(NSMutableDictionary *)target rootedAt:(NSDictionary *)root path:(NSArray *)path {
  for(id key in root) {
    id object = [root objectForKey:key];
    NSMutableArray *newPath = [[NSMutableArray alloc] initWithArray:path copyItems:NO];
    [newPath addObject:key];

    if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSMutableDictionary class]]) {
      [self flattenInto:target rootedAt:object path:newPath];
    } else {
      [target setObject:object forKey:[newPath componentsJoinedByString:@"."]];
    }

    [newPath release];
  }
}

@end
