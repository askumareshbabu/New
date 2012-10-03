//
//  DialNumberModel.m
//  MultiCall
//
//  Created by Kumaresh on 20/09/12.
//
//

#import "DialNumberModel.h"

@implementation DialNumberModel

@synthesize DialNumber=_DialNumber;


- (BOOL)isEqual:(id)anObject
{
    if([self.DialNumber isEqual:((DialNumberModel *)anObject).DialNumber])
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
    self.DialNumber=nil;
   
    [super dealloc];
}

-(id)initWithCoder:(NSCoder *)coder
{
    if(self=[super init])
    {
        self.DialNumber=[coder decodeObjectForKey:@"dialNumber"];
        
        
    }
    return self;
    
}
-(void)encodeWithCoder:(NSCoder *)coder
{
    
    [coder encodeObject:_DialNumber forKey:@"dialNumber"];
  
    
    
}
-(NSString*)description
{
    return [NSString stringWithFormat:@"dialNumber: %@",self.DialNumber];
}



@end
