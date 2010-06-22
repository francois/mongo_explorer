//
//  MEConnection.h
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-06.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "mongo.h"
@class MEDatabase;

/* The key under which you'll find the database's name in the returned NSDictionary
 * from -databases.
 */
extern NSString * const MEDBName;

/* The key under which you'll find the database's size in the returned NSDictionary
 * from -databases.
 */
extern NSString * const MEDBSize;

/* The key under which MEConnection will find it's host name in -initWithConnectionInfo: */
extern NSString * const MEHost;

/* The key under which MEConnection will find the port to connect to in -initWithConnectionInfo: */
extern NSString * const MEPort;

/* The key under which MEConnection will find it's user name in -initWithConnectionInfo: */
extern NSString * const MEUsername;

/* The key under which MEConnection will find it's password in -initWithConnectionInfo: */
extern NSString * const MEPassword;

/* Represents a connection to a Mongo instance. You may instantiate multiple such objects.
 * On release, this object will clean up and disconnect from Mongo, if still connected.
 */
@interface MEConnection : NSObject {
  mongo_connection *connection;
}

@property(nonatomic, copy) NSString *host;
@property(nonatomic, assign) NSUInteger port;
@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *password;
@property(readonly) BOOL connected;
@property(readonly) NSString *connectionString;

-(id)initWithConnectionInfo:(NSDictionary *)connectionInfo;
 
/* Opens the connection to Mongo, or does nothing.
 *
 * If the connection is already open (connected is YES), nothing happens.
 * Else, the connection to Mongo will be open, and kept alive.
 *
 * @return 0 if connected, else a Mongo error code.
 */
-(int)connect;

/* Disconnects from Mongo.
 *
 * If MEConnection was disconnected, nothing happens. If we were connected,
 * the connection will be dropped. Calling any methods will reconnect.
 */
-(void)disconnect;

/* Returns the databases available to this instance.
 *
 * The return value is an NSSet of MEDatabase objects.
 */
-(NSSet *)databases;

/* Returns the named database, or nil if it doesn't exist. */
-(MEDatabase *)databaseNamed:(NSString *)name;

-(NSUInteger)documentsCountFromCollection:(NSString *)collectionName database:(NSString *)databaseName;

@end
