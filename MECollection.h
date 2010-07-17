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
@class MECursor;
@class MEArray;

@interface MECollection : NSObject {
}

@property(nonatomic, retain) MEConnection *connection;
@property(nonatomic, retain) MEDatabase *database;
@property(nonatomic, copy) NSString *fullName;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, readonly) NSUInteger documentsCount;
@property(nonatomic, readonly) NSString *description;
@property(nonatomic, readonly) NSString *namespace;
@property(nonatomic, retain) MEArray *array;
@property(nonatomic, retain) NSArray *documentKeys;

-(id)initWithDatabase:(MEDatabase *)database info:(NSDictionary *)info connection:(MEConnection *)connection;

/**
 * Returns an NSArray (autoreleased) that contains the keys of the first few documents.
 * Useful to provide builders for queries and such.
 */
-(NSArray *)buildDocumentKeys;

/**
 * Returns an MECursor that will return all documents when iterated over.
 */
-(MECursor *)find;

/**
 * Returns an MECursor that will find a subset of all documents, when iterated over.
 */
-(MECursor *)find:(NSDictionary *)query;

@end
