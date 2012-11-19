//
//  CallModel.m
//  MultiCall
//
//  Created by Kumaresh on 11/09/12.
//
//

#import "CallModel.h"

@implementation CallModel

@synthesize dateTime=_dateTime;
@synthesize contacts=_contacts;
@synthesize Callduration=_Callduration;

-(id)init
{
    if(self=[super init]){
        self.contacts=[[[NSMutableArray alloc]init]autorelease];
    }
    return self;
}
-(void)dealloc{
    self.dateTime=nil;
    self.contacts=nil;
    self.Callduration=nil;
    [super dealloc];
}
-(BOOL)isEqual:(id)object
{
    if([self.contacts isEqual:((CallModel *)object).contacts])
        return YES;
    else
        return NO;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self=[super init])
    {
        self.dateTime=[aDecoder decodeObjectForKey:@"dateTime"];
        self.contacts=[aDecoder decodeObjectForKey:@"contacts"];
        self.Callduration=[aDecoder decodeObjectForKey:@"duration"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_dateTime forKey:@"dateTime"];
    [aCoder encodeObject:_contacts forKey:@"contacts"];
    [aCoder encodeObject:_Callduration forKey:@"duration"];
}
-(NSComparisonResult)compare:(CallModel *)otherObject
{
    return [self.dateTime compare:otherObject.dateTime];
}
-(NSString *)description
{
    return [NSString stringWithFormat:@" %@",self.contacts];
}
@end
