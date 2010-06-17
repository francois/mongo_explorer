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

-(id)transformedValue:(id)value {
  if (value == nil) return nil;
  long val = [value longValue];
  NSString *result;
  
  if (val < 1024L) {
    result = [NSString stringWithFormat:@"%ldB", val];
  } else if (val < 1048576L) {
    result = [NSString stringWithFormat:@"%ldKiB", val >> 10];
  } else if (val < 1024L * 1048576) {
    result = [NSString stringWithFormat:@"%ldMiB", val >> 20];
  } else if (val < 1024L * 1024 * 1048576L) {
    result = [NSString stringWithFormat:@"%ldGiB", val >> 30];
  } else if (val < 1024L * 1024 * 1024 * 1048576L) {
    result = [NSString stringWithFormat:@"%ldTiB", val >> 40];
  } else if (val < 1024L * 1024 * 1024 * 1024 * 1048576L) {
    result = [NSString stringWithFormat:@"%ldPiB", val >> 50];
  } else {
    result = [NSString stringWithFormat:@"%ldEiB", val >> 60];
  }

  NSLog(@"val: %ld, result: %@", val, result);
  return result;
}

@end
