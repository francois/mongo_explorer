//
//  MEArray.h
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-07-06.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MECollection;

#define DEFAULT_REASONABLE_VALUE 100

@interface MEArray : NSArray {
  BOOL countCached;
  NSUInteger cachedCount;

  MECollection *backingCollection;
  NSMutableArray *backingStore;
  CFMutableBitVectorRef loadedDocuments;
}

-(id)initWithCollection:(MECollection *)coll;

-(NSUInteger)count;

/** Returns MEDocument instances
 */
-(id)objectAtIndex:(NSUInteger)index;

@end
