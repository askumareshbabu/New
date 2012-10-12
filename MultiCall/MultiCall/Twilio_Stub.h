//
//  Twilio_Stub.h
//  Multi Call
//
//  Created by saravanan on 21/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CallStatus.h"
#import "PhoneNumberFormatter.h"
enum status { CONNECTING, CONNECTED , NOANSWER, COMPLETED, BUSY, FAILED ,CANCELLED, INVALID };
NSString * callStatusFromServer;
//http://www.twilio.com/docs/api/twiml/dial#attributes-timeout

@class ContactModel;
@class NSURLConnectionExt;
/**
 Handles the network interface stub for c3ware. Connects using a long lived async HTTP connection to pool and retrive the status of the call
 @see CallStatus
 */
@interface Twilio_Stub : NSObject <CallStatus>
{
    NSMutableArray *calls;
    @private 
    bool isMultiCallActive;
    bool isErrorOccured;
    id delegate;
   // NSMutableData *responseData; 
    //NSURLConnection *connection;
    bool isTimeout;
    NSMutableString *responseData;
    NSURLConnectionExt *multiCall; 
    NSURLConnectionExt *multiCallRes;
   
    //bool isTimerRunning;
@private
    id multiCallResponseURL;
}
@property (nonatomic,retain)NSTimer *timer; 
@property (nonatomic,retain) PhoneNumberFormatter *formatter;
@property(nonatomic,assign)bool isErrorOccured;

- (id)initWithDelegate:(id)delegateArg;
-(void)makeCalls:(NSArray *)numbers;
-(void)disconnectAll:(NSArray*)numbers;
-(void)disconnectNumber:(NSString *)model;
-(void)checkForStatus;

-(void)cancelStatusConnection;
-(bool)isCallActive;



    //Local IP 192.168.8.59:90/
    //#define C3WARE_MULTICALL_END @"http://192.168.8.59:90/DsnlWebInterface/MultiCallEnd"

     #define C3WARE_MULTICALL_END @"http://122.165.33.168/DsnlWebInterface/MultiCallEnd"
    //  #define C3WARE_MULTICALL_END @"http://webconsole.dsnl.in/DsnlWebInterface/MultiCallEnd"

    //#define C3WARE_MULTICALL @"http://192.168.8.59:90/DsnlWebInterface/MultiCall"
      #define C3WARE_MULTICALL @"http://122.165.33.168/DsnlWebInterface/MultiCall"
    // #define C3WARE_MULTICALL @"http://webconsole.dsnl.in/DsnlWebInterface/MultiCall"

    //#define C3WARE_RES  @"http://192.168.8.59:90/DsnlWebInterface/MultiCallResponse"
     #define C3WARE_RES  @"http://122.165.33.168/DsnlWebInterface/MultiCallResponse"
    // #define C3WARE_RES   @"http://webconsole.dsnl.in/DsnlWebInterface/MultiCallResponse"

/*
 http://122.165.33.168:90/DsnlWebInterface/MultiCall?emailid=test@c3ware.in&userphone=9884086692&phone=9500015192
 
 http://122.165.33.168:90/DsnlWebInterface/MultiCallResponse?emailid=test@c3ware.in
 */
@end
