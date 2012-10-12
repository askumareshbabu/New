#import <Foundation/Foundation.h>

@class  ContactModel;
/**
Simple protocol class for the target delegates to implement it and recive notifications
 @see CallStatus
 */
@protocol CallStatus <NSObject>

//old code
//-(void)statusForCall:(NSString *)model status:(int)status;

//new code for show server message
-(void)statusForCall:(NSString *)number status:(NSString*)status;
-(void)callEnded;

@end