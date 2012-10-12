//
//  NSURLConnectionExt.h
//  MultiCall
//
//  Created by saravanan on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLConnectionExt :NSObject
{
    NSMutableData *receivedData;
    NSURLConnection *urlConnection;
    NSURLResponse *response;
    void (^failureBlock)(NSError *);
    void (^successBlock)(NSData *, NSURLResponse *);
    NSTimer *timer;
    bool isResponseRecived;
}
- (id)initAsyncRequest:(NSURLRequest *)request 
                            success:(void(^)(NSData *, NSURLResponse *))successBlock_ 
                            failure:(void(^)(NSError *))failureBlock_ 
                            timeout:(int)timeout;
-(void)cancel;
@end
