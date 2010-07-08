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
    backingStore = nil;
  }

  return self;
}

-(void)dealloc {
  [backingCollection release];
  [backingStore release];
  CFRelease(loadedDocuments);
  [super dealloc];
}

-(void)initBackingStore {
  cachedCount = [backingCollection documentsCount];
  CFBitVectorSetCount(loadedDocuments, cachedCount);
  CFBitVectorSetAllBits(loadedDocuments, 0);
  countCached = YES;
  backingStore = [[NSMutableArray alloc] initWithCapacity:cachedCount];

  /* Force NSMutableArray to have the correct size / number of elements */
  for(NSUInteger i = 0; i < cachedCount; i++) {
    [backingStore insertObject:@"" atIndex:i];
  }
}

-(NSUInteger)count {
  if (!countCached) [self initBackingStore];
  return cachedCount;
}

-(id)objectAtIndex:(NSUInteger)index {
  if (!countCached) [self initBackingStore];
  if (!CFBitVectorGetBitAtIndex(loadedDocuments, index)) {
    MECursor *cursor = [backingCollection find];
    [cursor skip:index];
    [cursor limit:DEFAULT_REASONABLE_VALUE];
    NSArray *docs = [cursor documents];
    [backingStore replaceObjectsInRange:NSMakeRange(index, [docs count])
                   withObjectsFromArray:docs];

    CFBitVectorSetBits(loadedDocuments, CFRangeMake(index, [docs count]), 1);
    NSAssert(CFBitVectorGetBitAtIndex(loadedDocuments, index) == 1, "Didn't set to expected value");
  }

  return [backingStore objectAtIndex:index];
}

@end
