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
    case bson_null:   return [NSNull null];

    case bson_oid: {
      char* buffer = (char*)malloc(24 * 2 + 1); // 24 hex chars + 1 NUL
      if (buffer) {
        bson_oid_to_string(bson_iterator_oid(it), buffer);
        NSString *oid = [[NSString stringWithCString:buffer encoding:NSUTF8StringEncoding] autorelease];
        free(buffer);
        return oid;
      } else {
        return @"OID:Out of memory";
      }
    } 

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

    case bson_date:
    case bson_timestamp:
      return [NSDate dateWithTimeIntervalSince1970:bson_iterator_date(it) / 1000L];
      
    default:
      NSLog(@"MEUtils does not handle type %d", bson_iterator_type(it));
      return [NSNull null];
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

+(NSMutableDictionary *)dictionaryFromBson:(bson *)bson {
  bson_iterator it;
  bson_iterator_init(&it, bson->data);
  return [MEUtils dictionaryFromBsonIterator:&it];
}

+(void)fillBsonObject:(bson_buffer *)buffer fromDictionary:(NSDictionary *)dictionary {
  NSLog(@"Processing +[MEUtils fillBsonObject:fromDictionary:%@]", dictionary);
  for(NSString *key in dictionary) {
    id obj = [dictionary objectForKey:key];
    NSLog(@"Key: %@, Object: %@", key, obj);
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];

    if ([obj isKindOfClass:[NSNumber class]]) {
      /* Have to be more precise - what kind of Number? */
      bson_append_double(buffer, cKey, [obj doubleValue]);
    } else if ([obj isKindOfClass:[NSString class]]) {
      /* Maybe it's an OID? */
      bson_append_string(buffer, cKey, [obj cStringUsingEncoding:NSUTF8StringEncoding]);
    } else if ([obj isKindOfClass:[NSDate class]]) {
      bson_append_time_t(buffer, cKey, [obj timeIntervalSince1970]); /* Strange but true: time_t expects seconds, while data is returned in milliseconds */
    } else if ([obj isKindOfClass:[NSNull class]]) {
      bson_append_null(buffer, cKey);
    } else if ([obj isKindOfClass:[NSArray class]]) {
      bson_append_start_array(buffer, cKey);
      for(id entity in obj) {
        NSAssert(NO, "Arrays aren't handled just yet...");
      }
      bson_append_finish_object(buffer);
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
      bson_append_start_object(buffer, cKey);
      [MEUtils fillBsonObject:buffer fromDictionary:obj];
      bson_append_finish_object(buffer);
    } else {
      NSAssert1(NO, "Unexpected class: %@ is not handled", [obj class]);
    }
  }
}

@end
