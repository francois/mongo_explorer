//
//  NewConnectionController.h
//  Mongo Explorer
//
//  Created by François Beausoleil on 10-06-05.
//  Copyright 2010 Solutions Technologiques Internationales. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *MEHost;
extern NSString *MEPort;
extern NSString *MEUsername;
extern NSString *MEPassword;
extern NSString *MEConnectionRequest;

@interface NewConnectionController : NSWindowController {
}

@property(nonatomic, retain) IBOutlet NSTextField *host;
@property(nonatomic, retain) IBOutlet NSTextField *port;
@property(nonatomic, retain) IBOutlet NSTextField *username;
@property(nonatomic, retain) IBOutlet NSTextField *password;

-(IBAction)connect:(id)sender;
-(IBAction)cancel:(id)sender;

@end
