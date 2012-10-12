
//  Created by Ahmed Abdelkader on 1/22/10.
//  This work is licensed under a Creative Commons Attribution 3.0 License.

//http://the-lost-beauty.blogspot.com/2010/01/locale-sensitive-phone-number.html
//http://code.google.com/p/iphone-patch/source/browse/trunk/bgfix/UIKit.framework/PhoneFormats/UIPhoneFormats.plist?r=7
#import "PhoneNumberFormatter.h"

@implementation PhoneNumberFormatter

- (id)init {
    self = [super init];
    if (self){
    //matching top to bottom
    NSArray *usPhoneFormats = [NSArray arrayWithObjects:
                               @"9$",//for all indian mobile standards
                               @"##########",
                               nil];
    
    predefinedFormats = [[NSDictionary alloc] initWithObjectsAndKeys:
                         usPhoneFormats, @"us",nil];
    }
    return self;
}

- (NSString *)phonenumberformat:(NSString *)phoneNumber withLocale:(NSString *)locale {    
    
    Phoneformatmethod=@"1";
    if([phoneNumber length]<6) return phoneNumber;
    
    NSArray *localeFormats = [predefinedFormats objectForKey:locale];
    if(localeFormats == nil) return phoneNumber;
    NSString *input =[self strip:phoneNumber];
        // NSLog(@"phonenumberformat input %@",input);
    return input;
}

- (NSString *)format:(NSString *)phoneNumber withLocale:(NSString *)locale {    
    
    Phoneformatmethod=@"2";
    if([phoneNumber length]<6) return phoneNumber;
    
    NSArray *localeFormats = [predefinedFormats objectForKey:locale];
    if(localeFormats == nil) return phoneNumber;
    NSString *input = [self strip:phoneNumber];
    
    for(NSString *phoneFormat in localeFormats) {
        int i = 0;
        NSMutableString *temp = [[[NSMutableString alloc] init] autorelease];
        for(int p = 0; temp != nil && i < [input length] && p < [phoneFormat length]; p++) {
            char c = [phoneFormat characterAtIndex:p];
            BOOL required = [self canBeInputByPhonePad:c];
            char next = [input characterAtIndex:i];
            switch(c) {
                case '$':
                    p--;
                    [temp appendFormat:@"%c", next]; i++;
                    break;
                    
                case '#':
                    if(next < '0' || next > '9') {
                        temp = nil;
                        break;
                    }
                    [temp appendFormat:@"%c", next]; i++;
                    break;
                    
                default:
                    if(required) {
                        if(next != c) {
                            temp = nil;
                            break;
                        }
                        [temp appendFormat:@"%c", next]; i++;
                    } else {
                        [temp appendFormat:@"%c", c];
                        if(next == c) i++;
                    }
                    break;       
            }   
        }
        if(i == [input length]) {
            return temp;   
        }   
    }
    return input;
    
}



- (NSString *)strip:(NSString *)phoneNumber {
    
    NSMutableString *res = [[[NSMutableString alloc] init] autorelease];
    
    for(int i = 0; i < [phoneNumber length]; i++) {
        
        char next = [phoneNumber characterAtIndex:i];
        
        if([self canBeInputByPhonePad:next])
            
            [res appendFormat:@"%c", next];
        
    }
    
    return res;
    
}


- (BOOL)canBeInputByPhonePad:(char)c {
    
    if([Phoneformatmethod isEqualToString:@"2"])
    {
        //  if(c == '+' || c == '*' || c == '#') return YES;
    if(c == '*' || c == '#') return YES;
    
    if(c >= '0' && c <= '9') return YES;
    }
    else
    {
        if(c == '+' || c == '*' || c == '#') return YES;
       
        
        if(c >= '0' && c <= '9') return YES;
    }
    
    return NO;
    
}



- (void)dealloc {
    
    [predefinedFormats release];
    
    [super dealloc];
    
}



@end
