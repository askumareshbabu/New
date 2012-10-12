//
//  Twilio_Stub.m
//  Multi Call
//
//  Created by saravanan on 21/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Twilio_Stub.h"
#import "JSONKit.h"
#import "ContactModel.h"
#import "Reachability.h"
#import "NSStringUtil.h"
#import "Model.h"
#import "NSURLConnectionExt.h"
#import "Message.h"

//#import "NSURLConnection+Blocks.h"

@interface Twilio_Stub()
//old code
//-(void)passMessageToDelegate:(NSString*)number status:(int)status;

//new code for show the server message
-(void)passMessageToDelegate:(NSString*)number status:(NSString*)status;

-(void)showAlert:(NSString *)str;
-(void)endCall;
-(bool)checkandProcessCallEnded;
-(void)updateStatus:(NSString *)resp;
-(void)recursivePollForStatus:(NSTimer *)object;
@end

@implementation Twilio_Stub
@synthesize timer =_timer;
@synthesize formatter=_formatter;
@synthesize isErrorOccured;

- (id)initWithDelegate:(id)delegateArg
{
    self = [super init];
    if (self) {
        calls= [[NSMutableArray alloc]init];
        delegate = delegateArg;
        isMultiCallActive= NO;
        isTimeout=NO;
        self.formatter =[[PhoneNumberFormatter alloc] init];

    }
    
    return self;
}

-(void)dealloc
{
        //  NSLog(@"dealloc Twilio_Stub" );
    if(self.timer)
    {
        [self.timer invalidate];
        self.timer=nil;
    }
    [calls release];
    delegate=nil;
      self.formatter =nil;
    
    if(isMultiCallActive)
    {
        [self cancelStatusConnection];   
    }
    if(isTimeout){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkForStatus) object: nil];
    }
    [super dealloc];
}


-(void)disconnectAll:(NSArray *)numbers
{    
    //force end call will just terinate the session as c3ware not support this feature
    if(isMultiCallActive)
    {
           
            // if(multiCall){
            
        for (int i =0;i<[numbers count]; i++) {
                //ContactModel *model = [numbers objectAtIndex:i];
            NSString * squenceNumber=[numbers objectAtIndex:i];
                NSLog(@"numberes %@",squenceNumber);
                //[self passMessageToDelegate:model.contactInfo status:@"disconnecting.."];
            [self passMessageToDelegate:squenceNumber status:@"disconnecting.."];
            
        }

               
//                [self endCall];
//                     }else
//                     {
            //multicall res close
         Model *model = [Model singleton];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:C3WARE_MULTICALL_END]];
            [request setHTTPMethod:@"POST"];
        
        // Make call and disconnect immediately,MultiCallResponseURL(pin) is NULL so i passed like this
        
        
        NSString *bodyString = [NSString stringWithFormat:@"pin=%@",model.email]; //pin Number
    
        [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
        
            //[request setHTTPBody:[multiCallResponseURL dataUsingEncoding:NSUTF8StringEncoding]];
       
            [[[NSURLConnectionExt alloc]initAsyncRequest:request
                                                 success:^(NSData *data, NSURLResponse *response) {
                                                     
                                                     for (int i =0;i<[numbers count]; i++) {
                                                         NSString * squenceNumber=[numbers objectAtIndex:i];
                                                         NSLog(@"numberes %@",squenceNumber);
                                                           
                                                         [self passMessageToDelegate:squenceNumber status:@"disconnected.."];
                                                             // [self passMessageToDelegate:model.contactInfo status:@"disconnected.."];
                                                             // NSLog(@"message %@",model.contactInfo);
                                                     }
                                                      
  
                                                     [multiCall cancel];
                                                         // self.isErrorOccured=NO;
                                                     [self endCall];
                                                         //isMultiCallActive=NO;
                                                     NSLog(@"call ended successful");
                                                
                                                 }
                                                 failure:^(NSError *error) {
                                                     NSLog(@"Error in ending call %@",error); 
                                                     if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable )
                                                     {
                                                     Message *alertMsg=[[Message alloc]init];
                                                     [alertMsg CustomMessage:@"5" MessageNo:@"6"];
                                                     [alertMsg release];
                                                     }else
                                                     {
                                                         Message *alertMsg=[[Message alloc]init];
                                                         [alertMsg CustomMessage:@"5" MessageNo:@"3"];
                                                         [alertMsg release];
                                                     }
                                                     
                                                           [self endCall];
                                                         //self.isErrorOccured=YES;
                                                         // [self checkandProcessCallEnded];
                                                     
                                                 } timeout:60] autorelease];
            //  }
       
        
            //isMultiCallActive=NO;
    }
    //c3ware does not support this feature
}

-(void)disconnectNumber:(NSString *)number
{
    /*
     Twilio_Call *call = [calls objectForKey:number];
     if(call)
     {
     [call disconnectCall];
     }
     */
    //c3ware does not support this feature
}



-(void)makeCalls:(NSArray *)numbers
{
    
    [calls removeAllObjects];
    isMultiCallActive=YES;

    NSMutableString *numbersToCall =[NSMutableString string];
    for (int i =0;i<[numbers count]; i++) {
        ContactModel *model = [numbers objectAtIndex:i];
        
                        if(i!=0) //the first number is the userphone. add it only to the call monitering list
            
                       [numbersToCall appendFormat:@"%@,%@,", [model.name STRIP_TO_NAME]?:@"",[self.formatter format:[[model.contactInfo prefixContactForTwilio] STRIP_TO_PHONE_NOS] withLocale:@"us"]];
        
            // NSString *PhoneNumber=[self.formatter format:[[model.contactInfo prefixContactForTwilio] STRIP_TO_PHONE_NOS] withLocale:@"us"];
        NSString * phoneNumberwithID=[NSString stringWithFormat:@"%i",i+1];
             NSLog(@"model.contactinfo %@",phoneNumberwithID);
            // [calls addObject:[self.formatter phonenumberformat:model.contactInfo withLocale:@"us"]];//do not format this, as this holds the exact phone nos as in callview to identify the call
            // [calls addObject:model.contactInfo];
            [calls addObject:phoneNumberwithID];
    }
    
    [numbersToCall deleteCharactersInRange:NSMakeRange([numbersToCall length]-1, 1)];
         NSLog(@"numbersToCall %@",numbersToCall);
    //return;
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable )
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:C3WARE_MULTICALL]];
        Model *model = [Model singleton];
        [request setHTTPMethod:@"POST"];
        NSString *bodyString = [NSString stringWithFormat:@"pin=%@&userphone=Chairperson,%@&phone=%@",
                                model.email,[self.formatter format:[[model.phoneNos prefixContactForTwilio] STRIP_TO_PHONE_NOS] withLocale:@"us"],numbersToCall]; //emailid
        NSLog(@"BodyString %@",bodyString);
            // NSLog(@"model.contactinfo %@",model.phoneNos);
        [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
            // NSLog(@"making call resquest %@",request);
        //http://pragmaticstudio.com/blog/2010/9/15/ios4-blocks-2
        
        
            // conference does not exist - 3, conference is already running - 4
        multiCall = [[[NSURLConnectionExt alloc]initAsyncRequest:request
                  success:^(NSData *data, NSURLResponse *response) {
                      NSString *resp = [[NSString alloc] initWithData:data
                                                             encoding:NSUTF8StringEncoding];
                      id jsonObject= [resp objectFromJSONString];
                      if(jsonObject==nil){
                          if([resp length]>0)
                          {
                              NSLog(@"Making Call resp %@",resp);
                                  // if([[resp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"\"conference does not exist\""])
                                if([[resp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"\"3\""])
                              {
                                  Message *alertMsg=[[Message alloc]init];
                                  [alertMsg CustomMessage:@"5" MessageNo:@"1"];
                                  [alertMsg release];
                                       [self endCall];
                                      // self.isErrorOccured=YES;
                                      // [self checkandProcessCallEnded];
                                  
                              }
                                  // else if([[resp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"\"conference is already running\""])
                                else if([[resp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"\"4\""])
                              {
                                  Message *alertMsg=[[Message alloc]init];
                                  [alertMsg CustomMessage:@"5" MessageNo:@"2"];
                                  [alertMsg release];
                                    [self endCall];
                                      // self.isErrorOccured=YES;
                                      // [self checkandProcessCallEnded];
                                  
                              }
                                  // else if([[resp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"\"Login id invalid\""]) //Login id invalid
                                else if([[resp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"\"2\""]) //Login id invalid
                              {
                                  Message *alertMsg=[[Message alloc]init];
                                  [alertMsg CustomMessage:@"5" MessageNo:@"1"];
                                  [alertMsg release];
                                  [self endCall];
                                      // self.isErrorOccured=YES;
                                      // [self checkandProcessCallEnded];
                                  
                              }
                                  // else if([[resp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"\"Speech engines are not active\""]) //Speech engines are not active
                               
                                else if([[resp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"\"5\""]) //Speech engines are not active
                              {
                                  Message *alertMsg=[[Message alloc]init];
                                  [alertMsg CustomMessage:@"5" MessageNo:@"8"];
                                  [alertMsg release];
                                  [self endCall];
                                      // self.isErrorOccured=YES;
                                      // [self checkandProcessCallEnded];
                                  
                              }
                              
                        else // code 8
                          {
                              
                                  //[self showAlert:resp];
                              Message *alertMsg=[[Message alloc]init];
                              [alertMsg CustomMessage:@"5" MessageNo:@"7"];
                              [alertMsg release];
                              [self endCall];
                          }
                          }
                      }else{
                          if(multiCallResponseURL){
                              [multiCallResponseURL release];
                              multiCallResponseURL=nil;
                          }

                          if([jsonObject isKindOfClass:[NSDictionary class]]){
                              NSDictionary *dicData =(NSDictionary*) jsonObject;
                              NSArray *keys= [jsonObject allKeys];
                              if([keys count]>0){
                                  NSString *key= [keys objectAtIndex:0];
                                  multiCallResponseURL= [[NSString stringWithFormat:@"%@=%@",key,[dicData objectForKey:key]]retain];
                              }
                          }
                          
                          NSLog(@"multiCallResponseURL %@ ",multiCallResponseURL);
                          if(multiCallResponseURL!=nil)
                              [self performSelectorOnMainThread:@selector(checkForStatus) withObject:nil waitUntilDone:NO];
                          else
                              [self showAlert:@"User details could not be retrived."];
                      }
                      [resp release];
                      multiCall=nil;
                  }
                  failure:^(NSError *error) {
                      
//                      [self showAlert:
//                       [NSString stringWithFormat:@"Could not connect. Reason: %@",[error localizedDescription]]];
//                      [self endCall];
//                      multiCall=nil;
                      NSLog(@"could not connect reason : %@",[error localizedDescription]);
                      Message *alertMsg=[[Message alloc]init];
                      [alertMsg CustomMessage:@"5" MessageNo:@"3"];
                      [alertMsg release];
                         [self endCall];
                          // self.isErrorOccured=YES;
                          //[self checkandProcessCallEnded];
                      multiCall=nil;
                      
                  } timeout:60] autorelease];
           
        //[self performSelectorInBackground:@selector(initCall:) withObject:numbersToCall];
    }else
    {
            //[self showAlert:@"Please ensure Internet connection availability"];
        Message *alertMsg=[[Message alloc]init];
        [alertMsg CustomMessage:@"5" MessageNo:@"5"];
        [alertMsg release];
            // [self endCall];
    }
    
}

-(void)checkForStatus
{
    //this reconnect is assumed in between the call, so try to reconnect
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable )
    {
        if(isMultiCallActive) //for timeout - during timeout it retries to connect with delay. 
        {
            //http://stackoverflow.com/questions/4944363/invoke-model-method-with-block-that-will-run-on-the-main-thread
            dispatch_async( dispatch_get_main_queue(), ^{
                // running synchronously on the main thread now -- call the handler
                ((UIViewController *)delegate).navigationItem.prompt= nil;
            });
            isTimeout = NO;
            [self cancelStatusConnection];
            [self recursivePollForStatus:nil];
            /*
            self.timer =[NSTimer scheduledTimerWithTimeInterval:5.0
                                                         target:self 
                                                       selector:@selector(recursivePollForStatus:) 
                                                       userInfo:nil 
                                                        repeats:YES];
            
            //http://stackoverflow.com/questions/1449035/how-do-i-use-nstimer
            NSRunLoop *runner = [NSRunLoop currentRunLoop];
            [runner addTimer:self.timer forMode: NSDefaultRunLoopMode];
             */
        }
    }else
    {
        dispatch_async( dispatch_get_main_queue(), ^{
            // running synchronously on the main thread now -- call the handler
            ((UIViewController *)delegate).navigationItem.prompt=@"No internet connection. Retrying."; 
            [((UIViewController *)delegate) performSelector:@selector(hidePrompt) withObject:delegate afterDelay:3.0];
            [self performSelector:@selector(checkForStatus) withObject:self afterDelay:15.0];           
        });
    }
}



-(void)recursivePollForStatus:(NSTimer *)object
{
    if(isMultiCallActive)
    {
            // Message *alertMsg=[[Message alloc]init];
        NSAutoreleasePool *releasepool = [[NSAutoreleasePool alloc]init];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:C3WARE_RES]];
        [request setHTTPMethod:@"POST"];
        NSString *bodyString = multiCallResponseURL;  
        
        [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
            //  NSLog(@"Response Bodystring %@",bodyString);
        multiCallRes = [[[NSURLConnectionExt alloc]initAsyncRequest:request
                        
                                                            success:^(NSData *data, NSURLResponse *response) {
                                                                    //NSLog(@"response %@",response);
                                                                NSString *resp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                [self updateStatus:resp];
                                                                self.timer=nil; //we dont want to have the last timer ref
                                                                [resp release];
                                                                    //[alertMsg release];
                                                            }
                                                            failure:^(NSError *error) {
                                                                //To retry and get the call status
                                                               
                                                                self.timer =[NSTimer scheduledTimerWithTimeInterval:5.0
                                                                                                             target:self 
                                                                                                           selector:@selector(recursivePollForStatus:) 
                                                                                                           userInfo:nil 
                                                                                                            repeats:NO];
                                                                
                                                                //http://stackoverflow.com/questions/1449035/how-do-i-use-nstimer
                                                                NSRunLoop *runner = [NSRunLoop currentRunLoop];
                                                                [runner addTimer:self.timer forMode: NSDefaultRunLoopMode];
                                                                NSLog(@"Failure in multicall response %@",error);
                                                                
                                                                    //[alertMsg CustomMessage:@"5" MessageNo:@"3"];
                                                                    //[alertMsg release];
                                                            } timeout:60] autorelease];
        [releasepool release];
        
    }
}

-(void)updateStatus:(NSString *)resp
{
    NSString *res = [resp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"resp first %@",resp);
    if([res length]>0)
    {        
        NSArray *respData =(NSArray *) [res objectFromJSONString];
        NSLog(@"updateStatus %@",respData);
        //json cannot parse plain string, it returns nil
        if(respData==nil) //c3ware sends string like 'conference ended' for error in initation 
        {
            NSLog(@"resposne %@ ",res);
            
                // if([res isEqualToString:@"\"conference ended\""])
                if([res isEqualToString:@"\"7\""])
                [self endCall];
            return; 
        }
        else
        {
            NSMutableArray *arr= [NSMutableArray arrayWithArray:respData];    
            if(arr && [arr count]>0)
            {
                [arr removeObjectAtIndex:0];//specific c3ware data structure
                NSLog(@"arr %@",arr);
                for (NSArray *array in arr) 
                {
                    NSLog(@"array %@",array);
                        // NSString *numbers = [array objectAtIndex:0];
                    NSString *numbers = [array objectAtIndex:0]; //array parts ID 0-ID,1-PhoneNumber 2- Status
                    NSString *number=numbers;
                    NSLog(@"correct number %@",number);
                        //if([number length]>10)
                        //number = [number substringFromIndex:[number length]-10];
                    NSLog(@"--%@-- ",number); 

                        
                        //  NSPredicate *query = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",number];
                    NSPredicate *query = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",[NSString stringWithFormat:@"%@",number]];
                    NSLog(@"guery %@",query);
                    NSLog(@"calls %@",calls);
                                        
                   
//                    for(NSString *number in [ calls filteredArrayUsingPredicate:query])
//                    {
                    
                    for(NSString *number in [calls filteredArrayUsingPredicate:query])
                    {
                      NSLog(@" for guery %@",query);
                            // NSString *number=[NSString stringWithFormat:@"%@",number];
                        
                        NSLog(@"--Found %@-- ",number);
                            // NSString *callstatus= [array objectAtIndex:1];
                        NSString *callstatus= [array objectAtIndex:2];
                        NSLog(@"Call Status from server : %@",callstatus);
                        callStatusFromServer=callstatus;
//                        NSString *phNumber=@"";
//                        NSMutableArray *pharray=[NSMutableArray arrayWithArray:calls];
//                        
//                        phNumber=[pharray objectAtIndex:0];
//                            
//                        NSLog(@"--Found phone number %@-- ",phNumber);
                        
                            // inprogress - 85, conference - 6, Exit - 24  Rejected -30, Conference ended- 7
                            // if([callstatus isEqualToString:@"inprogress"])
                        if([callstatus isEqualToString:@"85"])
                        {
                            callStatusFromServer=@"inprogress";
                             NSLog(@"Message passing inprogress number %@",number);
                            [self passMessageToDelegate:number status:callStatusFromServer]; 
                            
                        }
                            // else if([callstatus isEqualToString:@"exit"]) //exit
                        else if([callstatus isEqualToString:@"24"]) //exit
                        {
                            callStatusFromServer=@"exit";
                            NSLog(@"Message passing exit number %@",number);
                            [calls removeObject:number];
                            
                            [self passMessageToDelegate:number status:callStatusFromServer];
                            
                        }
                            //else if([callstatus isEqualToString:@"conference"]) //conference
                        else if([callstatus isEqualToString:@"6"]) //conference
                        {
                            callStatusFromServer=@"conference";
                                NSLog(@"Message passing conference number %@",number);
                            [self passMessageToDelegate:number status:callStatusFromServer]; 
                        }
                            // else if([callstatus isEqualToString:@"rejected"]) //Rejected
                        else if([callstatus isEqualToString:@"30"]) //Rejected
                        {
                            callStatusFromServer=@"rejected";
                                 NSLog(@"Message passing rejected number %@",number);
                            
                                  [calls removeObject:number];
                            
                            [self passMessageToDelegate:number status:callStatusFromServer]; 
                        }
                        
                        
                    }
                }
            }
            
            if(![self checkandProcessCallEnded])
            {
                [self performSelector:@selector(recursivePollForStatus:) withObject:nil];
            }
            //NSLog(@"%@ remobving number---------",calls);
        }
    }
}





-(void)endCall
{
    [calls removeAllObjects]; 
    [self checkandProcessCallEnded];
}

//old code
//-(void)statusForCall:(NSString *)number status:(int)status
//{
//    [self passMessageToDelegate:number status:status]; 
//}


//New code for show sever message
-(void)statusForCall:(NSString *)number status:(NSString*)status
{
    [self passMessageToDelegate:number status:status]; 
}


-(void)cancelStatusConnection
{
    if(self.timer)
    {
        [self.timer invalidate];
        self.timer=nil;
    }
}

-(bool)isCallActive
{
    return isMultiCallActive;
}

//old code
//-(void)passMessageToDelegate:(NSString*)number status:(int)status
//{
//    dispatch_async( dispatch_get_main_queue(), ^{
//        [delegate statusForCall:number status:status]; 
//        [self checkandProcessCallEnded];
//    });
//}

//New code for show server message
-(void)passMessageToDelegate:(NSString*)number status:(NSString*)status
{
    dispatch_async( dispatch_get_main_queue(), ^{
        [delegate statusForCall:number status:status]; 
        [self checkandProcessCallEnded];
    });
}

-(bool)checkandProcessCallEnded
{
    if([calls count]==0){
        isMultiCallActive=NO;
        dispatch_async( dispatch_get_main_queue(), ^{
            [delegate callEnded];
        });
        [self cancelStatusConnection];
        //cancel out pending reconnectors
        if(isTimeout){
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkForStatus) object: nil];
            isTimeout=NO;
        }
                
        return YES;
    }
//    else if(isErrorOccured ==YES)
//    {
//        isMultiCallActive=NO;
//        dispatch_async(dispatch_get_main_queue(), ^{
//    [delegate callEnded];
//        });
//        [self cancelStatusConnection];
//            //cancel out pending reconnectors
//        if(isTimeout){
//            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkForStatus) object: nil];
//            isTimeout=NO;
//        }
//        return  YES;
//    }
    return NO;
}

-(void)showAlert:(NSString *)str
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"MultiCall"
                                       message:str delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] ;
    [alert show];
    [alert release];    
}

/*
 1.       conference
 2.       ringing
 3.       released
 4.       exit
 5.       q&a
 6.       help
 7.       compere
 8.       agent
 9.       inquiry
 10.   wait
 11.   recording
 12.   question
 13.   connected to operator
 14.   connected to chairperson
 15.   odo room
 16.   rejected
 17.   hold by operator
 */



-(void)callEnded{} //not used

@end
