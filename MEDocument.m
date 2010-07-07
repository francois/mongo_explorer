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

@synthesize data, collection, connection;

-(id)initWithCollection:(MECollection *)aCollection info:(NSDictionary *)info connection:(MEConnection *)aConnection {
  if (![super init]) return nil;

  self.collection = aCollection;
  self.connection = aConnection;
  self.data = [info mutableCopy];
  return self;
}

-(void)dealloc {
  self.collection = nil;
  self.connection = nil;
  self.data = nil;
  [super dealloc];
}

-(NSArray *)keys {
  return [NSArray array];
}

-(NSArray *)deepKeys {
  return [NSArray array];
}

-(NSString *)description {
  return [self.data description];
}

-(NSString *)oid {
  return [self.data objectForKey:@"_id"];
}

-(NSString *)abstractDocument {
  return [NSString stringWithFormat:@"abstract for %@", self.oid];
}

@end
