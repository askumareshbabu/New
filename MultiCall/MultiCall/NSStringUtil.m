//
//  NSStringUtil.m
//  Multi Call
//
//  Created by saravanan on 14/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSStringUtil.h"

#define ellipsis @"…"
@implementation NSString (NSStringUtil)

- (NSString*)stringByTruncatingToWidth:(CGFloat)width withFont:(UIFont *)font
{
    // Create copy that will be the returned result
    NSMutableString *truncatedString = [[self mutableCopy] autorelease];
        //NSLog(@"%i ",[self length]);
    // Make sure string is longer than requested width
    if ([self sizeWithFont:font].width > width)
    {
        // Accommodate for ellipsis we'll tack on the end
        width -= [ellipsis sizeWithFont:font].width;
        
        // Get range for last character in string
        NSRange range = NSMakeRange([self length] - 1, 1);
        
        // Loop, deleting characters until string fits within width
        while ([truncatedString sizeWithFont:font].width > width) 
        {
            // Delete character at end
            [truncatedString deleteCharactersInRange:range];
            
            // Move back another character
            range.location--;
        }
        
        // Append ellipsis
        [truncatedString replaceCharactersInRange:range withString:ellipsis];
    }
    
    return truncatedString;
}

-(NSString*)prefixContactForTwilio
{
    NSString *contact = self;
    
   
    if([contact hasPrefix:@"+"]) 
    {
        contact=[contact stringByReplacingOccurrencesOfString:@"+" withString:@"00"];//for c3ware
    }
    /*else if([contact length] == 8) //Assume phone number
    {  
        if(![contact hasPrefix:@"44"])
        {
            contact = [NSString stringWithFormat:@"9144%@",contact]; 
        }
        //4280 5232 -> 91 44 4280 5232 
    }else if ([contact length] > 9 && [contact length] < 11)
    {
        //44 4280 5232 ->91 44 4280 5232
        //9884086692   ->91 9884086692
        if(![contact hasPrefix:@"91"])
        {
            contact = [NSString stringWithFormat:@"91%@",contact]; 
        }
    }*/
    
        // NSLog(@"dialed nos: %@",contact);
    return contact;
}
-(NSString*)prefixrevertContactForTwilio
{
    NSString *contact = self;
    
    
    if([contact hasPrefix:@"00"]) 
    {
        contact=[contact stringByReplacingOccurrencesOfString:@"00" withString:@"+"];//for c3ware
    }
    return contact;
}
-(NSString *)STRIP_TO_PHONE_NOS
{
    NSMutableCharacterSet *ss = [NSMutableCharacterSet decimalDigitCharacterSet];
    [ss addCharactersInString:@"+"];
    return [[self componentsSeparatedByCharactersInSet:[ss invertedSet]] componentsJoinedByString:@""];
}




- (BOOL)canBeInputByContactName:(char) C{
    
    if(C == '.' || C == '(' || C == ')'  || C == '-' || C == ' ') return YES;
    
        //  if(C >= '0' && C <= '9') return YES;
    
    if(C =='A' || C =='B'|| C=='C'  || C =='D'  || C =='E'  || C =='F'  || C =='G'  || C =='H'  || C =='I'  || C =='J'  || C =='K'  || C =='L'  || C =='M'  || C =='N'  || C =='O'  || C =='P'  || C =='Q'  || C =='R'  || C =='S'  || C =='T'  || C =='U'  || C =='V'  || C =='W'  || C =='X' || C == 'Y'  || C =='Z'  )return YES;
    
    return NO;
    
}
-(NSString *)STRIP_TO_NAME
{
    NSString *result=self;
    
    NSMutableString *result1=[[[NSMutableString alloc]init]autorelease];
   result=[result uppercaseString];
    
    for(int i =0; i <[result length]; i++)
    {
        char next=[result characterAtIndex:i];
        if([self canBeInputByContactName:next])
            [result1 appendFormat:@"%c",next];
    }
    
    
    return  result1;
    
}

@end
