//
//  MEUtils.h
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-15.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "bson.h"

@interface MEUtils : NSObject {

}

+(NSMutableDictionary *)dictionaryFromBsonIterator:(bson_iterator *)it;
+(NSObject *)objectFromBsonIterator:(bson_iterator *)it;
+(NSMutableDictionary *)dictionaryFromBson:(bson *)bson;

@end
