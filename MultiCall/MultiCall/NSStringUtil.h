//
//  NSStringUtil.h
//  Multi Call
//
//  Created by saravanan on 14/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringUtil)
- (NSString*)stringByTruncatingToWidth:(CGFloat)width withFont:(UIFont *)font;
-(NSString *)STRIP_TO_PHONE_NOS;
-(NSString*)prefixContactForTwilio;
-(NSString *)STRIP_TO_NAME;
-(NSString*)prefixrevertContactForTwilio;

@end
