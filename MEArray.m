//
//  MEArray.m
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-07-06.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import "MEArray.h"
#import "MECollection.h"
#import "MECursor.h"

@implementation MEArray

-(id)initWithCollection:(MECollection *)coll {
  if ((self = [super init])) {
    backingCollection = [coll retain];
    countCached = NO;
    loadedDocuments = CFBitVectorCreateMutable(kCFAllocatorDefault, 0);
  }

  return self;
}

-(void)dealloc {
  [backingCollection release];
  [backingStore release];
  // TODO: release loadedDocuments
  [super dealloc];
}

-(void)initBackingStore {
  NSLog(@"-[MEArray initBackingStore]");
  cachedCount = [backingCollection documentsCount];
  CFBitVectorSetCount(loadedDocuments, cachedCount);
  countCached = YES;
  NSLog(@"backingStore initialized with capacity %d", cachedCount);
  backingStore = [[NSMutableArray alloc] initWithCapacity:cachedCount];
}

-(NSUInteger)count {
  NSLog(@"-[MEArray count]");
  if (!countCached) [self initBackingStore];
  return cachedCount;
}

-(id)objectAtIndex:(NSUInteger)index {
  NSLog(@"-[MEArray objectAtIndex:%d]", index);
  if (!countCached) [self initBackingStore];
  if (!CFBitVectorGetBitAtIndex(loadedDocuments, index)) {
    MECursor *cursor = [backingCollection find];
    [cursor skip:index];
    [cursor limit:DEFAULT_REASONABLE_VALUE];
    NSArray *docs = [cursor documents];
    NSRange range = NSMakeRange(index, index + [docs count] - 1);
    NSLog(@"replacing (%d..%d) with %d objects, with capacity: %d", range.location, range.length, [docs count], cachedCount);
    [backingStore replaceObjectsInRange:range
                   withObjectsFromArray:docs];
    
    CFBitVectorSetBits(loadedDocuments, CFRangeMake(index, index + [docs count] - 1), 1);
  }

  return [backingStore objectAtIndex:index];
}

@end
