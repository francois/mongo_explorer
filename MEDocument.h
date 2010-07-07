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

@property(nonatomic, readonly) NSArray *keys;
@property(nonatomic, readonly) NSArray *deepKeys;
@property(nonatomic, retain) NSMutableDictionary *data;
@property(nonatomic, retain) MEConnection *connection;
@property(nonatomic, retain) MECollection *collection;

@property(nonatomic, readonly) NSString *oid;
@property(nonatomic, readonly) NSString *abstractDocument;

-(id)initWithCollection:(MECollection *)collection info:(NSDictionary *)info connection:(MEConnection *)connection;

@end
