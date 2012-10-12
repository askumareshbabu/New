//
//  NSDateConvertor.m
//  Multi Call
//
//  Created by saravanan on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDateConvertor.h"

@implementation NSDate (NSDateConvertor)
- (NSString *)stringFromDateWithFormat:(NSString *)dateFormat 
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat]; //EdMMM - Tue 2 Aug
    NSString *formatted = [formatter stringFromDate:self];//[self convertDatetoText:meeting.datetime];
    [formatter release];
    return formatted;
}
@end
