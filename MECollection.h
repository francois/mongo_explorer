//
//  MECollection.h
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-08.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MEConnection;
@class MEDatabase;

@interface MECollection : NSObject {
}

@property(nonatomic, retain) MEConnection *connection;
@property(nonatomic, retain) MEDatabase *database;
@property(nonatomic, copy) NSString *fullName;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, retain) NSArray *documents;
@property(nonatomic, readonly) NSString *description;

-(id)initWithDatabase:(MEDatabase *)database info:(NSDictionary *)info connection:(MEConnection *)connection;
-(NSArray *)reload;

@end
