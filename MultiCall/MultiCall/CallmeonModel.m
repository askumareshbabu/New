//
//  CallmeonModel.m
//  MultiCall
//
//  Created by Kumaresh on 01/09/12.
//
//

#import "CallmeonModel.h"

@implementation CallmeonModel

@synthesize CallType=_CallType;
@synthesize CallPhoneNumber=_CallPhoneNumber;
@synthesize isSelected=_isSelected;

- (BOOL)isEqual:(id)anObject
{
        if([self.CallType isEqual:((CallmeonModel *)anObject).CallType])
        {
            return YES;
        }else
        {
            return NO;
        }
    
    return NO;
}
-(id)init
{
    if(self=[super init])
    {
        
    }
    return  self;
}
-(void)dealloc
{
    self.CallType=nil;
    self.CallPhoneNumber=nil;
    [super dealloc];
}

-(id)initWithCoder:(NSCoder *)coder
{
    if(self=[super init])
    {
        self.CallType=[coder decodeObjectForKey:@"callType"];
        self.CallPhoneNumber=[coder decodeObjectForKey:@"callPhoneNumber"];
        self.isSelected=[coder decodeBoolForKey:@"selected"];
    }
    return self;
    
}
-(void)encodeWithCoder:(NSCoder *)coder
{
  
        [coder encodeObject:_CallType forKey:@"callType"];
        [coder encodeObject:_CallPhoneNumber forKey:@"callPhoneNumber"];
        [coder encodeBool:_isSelected forKey:@"selected"];
    
}
-(NSString*)description
{
    return [NSString stringWithFormat:@"callType: %@ callPhoneNumber :%@ checked: %u",self.CallType,self.CallPhoneNumber,self.isSelected];
}

@end
