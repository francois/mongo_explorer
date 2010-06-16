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

@implementation MECollection

@synthesize connection, database, name, documents;

-(id)initWithDatabase:(MEDatabase *)aDatabase info:(NSDictionary *)info connection:(MEConnection *)aConnection {
  if (![super init]) return nil;

  self.connection = aConnection;
  self.database = aDatabase;
  self.name = [[info objectForKey:@"name"] stringByReplacingOccurrencesOfString:[self.database.name stringByAppendingString:@"."] withString:@""];
  self.documents = [NSArray array];
  
  return self;
}

-(void)dealloc {
  self.connection = nil;
  self.database = nil;
  self.name = nil;
  self.documents = nil;
  [super dealloc];
}

-(long)numberOfDocuments {
  return [self.documents count];
}

-(NSString *)description {
  return self.name;
}

@end
