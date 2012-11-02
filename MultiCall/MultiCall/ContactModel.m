//
//  ContactModel.m
//  MultiCall
//
//  Created by Kumaresh on 11/09/12.
//
//

#import "ContactModel.h"

@implementation ContactModel


@synthesize personId=_personId;
@synthesize name=_name;
@synthesize contactInfo=_contactInfo;
@synthesize contactType=_contactType;
@synthesize formatter=_formatter;

-(id)init
{
    if(self=[super init])
    {
       
    }
    return self;
}

-(void)dealloc
{
    
    self.name=nil;
    self.contactInfo=nil;
    self.contactType=nil;
    [_formatter release];
    [super dealloc];
    
}
-(BOOL)isEqual:(id)object
{
        //NSLog(@"contact info %@,%@",self.contactInfo,((ContactModel *)object).contactInfo);
        // if([[self.formatter phonenumberformat:self.contactInfo withLocale:@"us"] isEqual:[self.formatter phonenumberformat:((ContactModel *)object).contactInfo withLocale:@"us"]]){
       
         if([self.contactInfo isEqual:((ContactModel *)object).contactInfo]){
            return YES;
        }
       
               
    else{
              return NO;
    }
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self=[super init])
    {
        self.personId=[aDecoder decodeIntegerForKey:@"personId"];
        self.name=[aDecoder decodeObjectForKey:@"name"];
        self.contactInfo=[aDecoder decodeObjectForKey:@"contactInfo"];
        self.contactType=[aDecoder decodeObjectForKey:@"contactType"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_personId forKey:@"personId"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_contactInfo forKey:@"contactInfo"];
    [aCoder encodeObject:_contactType forKey:@"contactType"];
}
-(NSString *)description
{
    self.formatter=[[[PhoneNumberFormatter alloc]init]autorelease];;
        //  NSLog(@"contact model description %@",[NSString stringWithFormat:@"%i %@ %@ %@",self.personId?:0,self.name?:@"",self.contactInfo,self.contactType?:@"unknown"]);
    return [NSString stringWithFormat:@"%i %@ %@ %@",self.personId?:0,self.name?:@"",[self.formatter phonenumberformat:self.contactInfo withLocale:@"us"],self.contactType?:@"unknown"];
}
@end
