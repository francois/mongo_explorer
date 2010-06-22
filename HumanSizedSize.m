//
//  HumanSizedSize.m
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-16.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import "HumanSizedSize.h"


@implementation HumanSizedSize

+(Class)transformedValueClass {
  return [NSString class];
}

+(BOOL)allowsReverseTransformation {
  return NO;
}

#define KIBIBYTE (1L<<10)
#define MEBIBYTE (1L<<20)
#define GIBIBYTE (1L<<30)
#define TEBIBYTE (1L<<40)
#define PEBIBYTE (1L<<50)
#define EXBIBYTE (1L<<60)
#define ZEBIBYTE (1L<<70)
#define YOBIBYTE (1L<<80)

-(id)transformedValue:(id)value {
  if (value == nil) return nil;
  long val = [value longValue];
  NSString *result;
  
  if (val < KIBIBYTE) {
    result = [NSString stringWithFormat:@"%ldB", val];
  } else if (val < MEBIBYTE) {
    result = [NSString stringWithFormat:@"%.1fKiB", val / (float)KIBIBYTE];
  } else if (val < GIBIBYTE) {
    result = [NSString stringWithFormat:@"%.1fMiB", val / (float)MEBIBYTE];
  } else if (val < TEBIBYTE) {
    result = [NSString stringWithFormat:@"%.1fGiB", val / (float)GIBIBYTE];
  } else if (val < PEBIBYTE) {
    result = [NSString stringWithFormat:@"%.1fTiB", val / (float)TEBIBYTE];
  } else if (val < EXBIBYTE) {
    result = [NSString stringWithFormat:@"%.1fPiB", val / (float)PEBIBYTE];
  } else {
    result = [NSString stringWithFormat:@"%.1fEiB", val / (float)EXBIBYTE];
  }

  NSLog(@"val: %ld, result: %@", val, result);
  return result;
}

@end
