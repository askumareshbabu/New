//
//  NSURLConnection+Blocks.h


#import <Foundation/Foundation.h>

@interface NSURLConnection (Blocks)

#pragma mark Class API Extensions
+ (void)asyncRequest:(NSURLRequest *)request 
						 success:(void(^)(NSData *, NSURLResponse *))successBlock_ 
						 failure:(void(^)(NSData *, NSError *))failureBlock_;

@end
