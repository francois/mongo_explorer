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

#define KILO  (10L*10*10)
#define MEGA  (KILO*KILO)
#define GIGA  (MEGA*KILO)
#define TERA  (GIGA*KILO)
#define PETA  (TERA*KILO)
#define EXA   (PETA*KILO)
#define ZETTA (EXA*KILO)

-(id)transformedValue:(id)value {
  if (value == nil) return nil;
  long val = [value longValue];

  if (val < KILO) {
    return [NSString stringWithFormat:@"%ld", val];
  } else if (val < MEGA) {
    return [NSString stringWithFormat:@"%.1fK", val / (float)KILO];
  } else if (val < GIGA) {
    return [NSString stringWithFormat:@"%.1fM", val / (float)MEGA];
  } else if (val < TERA) {
    return [NSString stringWithFormat:@"%.1fG", val / (float)GIGA];
  } else if (val < PETA) {
    return [NSString stringWithFormat:@"%.1fT", val / (float)TERA];
  } else if (val < EXA) {
    return [NSString stringWithFormat:@"%.1fT", val / (float)PETA];
  } else {
    return [NSString stringWithFormat:@"%.1fP", val / (float)EXA];
  }
}

@end
