//
//  NSURLConnectionExt.m
//  MultiCall
//
//  Created by saravanan on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSURLConnectionExt.h"

@interface NSURLConnectionExt()
-(void)timer;
@end

@implementation NSURLConnectionExt

- (id)initAsyncRequest:(NSURLRequest *)request 
               success:(void(^)(NSData *, NSURLResponse *))successBlock_ 
               failure:(void(^)(NSError *))failureBlock_ 
               timeout:(int)timeout{
    if (self = [super init]) {
        urlConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (urlConnection) {
            receivedData = [[NSMutableData alloc] init];
        } else {
            
        }
        failureBlock=[failureBlock_ copy] ;
        successBlock=[successBlock_ copy];
        
        //    if (error) {
        //        failureBlock_(data,error);
        //    } else {
        //successBlock(receivedData,response);
        //    }
        
        timer=[[NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(timer) userInfo:nil repeats:NO] retain];  
    }
    return self;
}

-(void)timer
{
    [self cancel];
    NSError *error = [[NSError alloc]initWithDomain:@"Request timed out" code:10001 userInfo:nil];
    failureBlock(error);
    
         [timer release];
        timer=nil;
}

-(void)cancel
{
    if(urlConnection)
    {
        [urlConnection cancel];
        [urlConnection release];
        urlConnection=nil;
    }
    
    if([timer isValid])
        [timer invalidate];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)responseArg
{
    [timer invalidate];    
    response = responseArg;
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [timer invalidate];
    [connection release];
    failureBlock(error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    [connection release];
    successBlock(receivedData,response);
}

-(void)dealloc
{
        //NSLog(@"--------Connection ext release---------");
    [receivedData release];
    [successBlock release];
    [failureBlock release];
    response=nil;
    [super dealloc];
}
@end
