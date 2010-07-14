//
//  MEDocument.h
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-15.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MEConnection;
@class MECollection;

@interface MEDocument : NSObject {
}

@property(nonatomic, retain) NSMutableDictionary *data;
@property(nonatomic, retain) MEConnection *connection;
@property(nonatomic, retain) MECollection *collection;
@property(nonatomic, retain) NSMutableDictionary *flatView;

@property(nonatomic, readonly) NSString *oid;
@property(nonatomic, readonly) NSString *abstractDocument;

-(id)initWithCollection:(MECollection *)collection info:(NSDictionary *)info connection:(MEConnection *)connection;
-(void)flattenInto:(NSMutableDictionary *)target rootedAt:(NSDictionary *)root path:(NSArray *)path;

@end
