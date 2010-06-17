//
//  HumanSizedNumber.m
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-16.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import "HumanSizedNumber.h"


@implementation HumanSizedNumber

+(Class)transformedValueClass {
  return [NSString class];
}

+(BOOL)allowsReverseTransformation {
  return NO;
}

-(id)transformedValue:(id)value {
  if (value == nil) return nil;
  long val = [value longValue];

  if (val < 1024) {
    return [NSString stringWithFormat:@"%ld", val];
  } else if (val < 1000L) {
    return [NSString stringWithFormat:@"%ldK", val / 1000];
  } else if (val < 1000L * 1000) {
    return [NSString stringWithFormat:@"%ldM", val / 1000 / 1000];
  } else if (val < 1000L * 1000 * 1000) {
    return [NSString stringWithFormat:@"%ldG", val / 1000 / 1000 / 1000];
  } else if (val < 1000L * 1000 * 1000 * 1000) {
    return [NSString stringWithFormat:@"%ldT", val / 1000 / 1000 / 1000 / 1000];
  } else if (val < 1000L * 1000 * 1000 * 1000 * 1000) {
    return [NSString stringWithFormat:@"%ldT", val / 1000 / 1000 / 1000 / 1000 / 1000];
  } else if (val < 1000L * 1000 * 1000 * 1000 * 1000 * 1000) {
    return [NSString stringWithFormat:@"%ldT", val / 1000 / 1000 / 1000 / 1000 / 1000 / 1000];
  } else {
    return [NSString stringWithFormat:@"%ldP", val / 1000 / 1000 / 1000 / 1000 / 1000 / 1000 / 1000];
  }
}

@end
