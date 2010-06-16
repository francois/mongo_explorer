//
//  MEUtils.m
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-15.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import "MEUtils.h"

@implementation MEUtils

+(NSMutableArray *)arrayFromBsonIterator:(bson_iterator *)it {
  NSMutableArray *nested = [[[NSMutableArray alloc] init] autorelease];
  while (bson_iterator_next(it)) {
    [nested addObject:[MEUtils objectFromBsonIterator:it]];
  }

  return nested;
}

+(NSObject *)objectFromBsonIterator:(bson_iterator *)it {
  switch(bson_iterator_type(it)) {
    case bson_bool:   return [[NSNumber numberWithInt:bson_iterator_bool(it)] autorelease];
    case bson_int:    return [[NSNumber numberWithInt:bson_iterator_int(it)] autorelease];
    case bson_long:   return [[NSNumber numberWithLong:bson_iterator_long(it)] autorelease];
    case bson_double: return [[NSNumber numberWithDouble:bson_iterator_double(it)] autorelease];
    case bson_string: return [[NSString stringWithCString:bson_iterator_string(it) encoding:NSUTF8StringEncoding] autorelease];
    case bson_null:   return nil;

    case bson_array: {
      bson_iterator sub;
      bson_iterator_subiterator(it, &sub);
      return [MEUtils arrayFromBsonIterator:&sub];
    }

    case bson_object: {
      bson_iterator sub;
      bson_iterator_subiterator(it, &sub);
      return [MEUtils dictionaryFromBsonIterator:&sub];
    }
      //      case bson_oid:
      //      case bson_date:
      //      case bson_timestamp:
      
    default:
      NSLog(@"MEUtils does not handle type %d", bson_iterator_type(it));
      return nil;
  }
}
     

+(NSMutableDictionary *)dictionaryFromBsonIterator:(bson_iterator *)it {
  NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
  while(bson_iterator_next(it)) {
    const char* key = bson_iterator_key(it);
    [dict setObject:[MEUtils objectFromBsonIterator:it]
             forKey:[NSString stringWithCString:key encoding:NSUTF8StringEncoding]];
  }

  return dict;
}

@end
