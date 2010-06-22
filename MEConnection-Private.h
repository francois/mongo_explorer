/*
 *  MEConnection-Private.h
 *  Mongo Explorer
 *
 *  Created by François Beausoleil on 10-06-20.
 *  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
 *
 *
 * This file exists only to provide me with the equivalent of package protected methods in Java.
 * DO NOT #import this file.
 */

#import "MEConnection.h"

@interface MEConnection ()

-(mongo_connection *)mongo_connection;
-(mongo_cursor *)cursorForNamespace:(NSString *)namespace query:(NSDictionary *)aQuery fields:(NSDictionary *)aFields skipCount:(int)skipCount returnCount:(int)returnCount;

@end
