//
//  Model.m
//  MultiCall
//
//  Created by Kumaresh on 01/09/12.
//
//

#import "Model.h"

@implementation Model

@synthesize callemeon=_callemeon;
@synthesize recentsCall=_recentsCall;
@synthesize groups=_groups;
@synthesize Pinno=_Pinno;
@synthesize PhoneNumber=_PhoneNumber;
@synthesize dialNumbers=_dialNumbers;



static Model *sharedSingleton=nil;

+(id)singleton
{
    if(!sharedSingleton)
    {
        sharedSingleton=[[Model alloc]init];
    }
    return sharedSingleton;
}
-(id)init
{
    if(self =[super init])
    {
        self.callemeon=[NSMutableArray array];
        self.recentsCall=[NSMutableArray array];
        self.groups=[NSMutableArray array];
        self.Pinno=[NSString string];
        self.PhoneNumber=[NSString string];
        self.dialNumbers=[NSMutableArray array];
    }
    return self;
}
-(void)dealloc
{
    self.callemeon=nil;
    self.recentsCall=nil;
    self.groups=nil;
    self.dialNumbers=nil;
    [super dealloc];
}
-(id)initWithCoder:(NSCoder *)coder
{
    if(self=[super init])
    {
        self.callemeon=[coder decodeObjectForKey:@"callmeon"]?:[NSMutableArray array];
            //[self.callemeon removeAllObjects];
            // NSLog(@"callmeon %@",self.callemeon);
        self.recentsCall=[coder decodeObjectForKey:@"recentsCalls"]?:[NSMutableArray array];
        self.groups=[coder decodeObjectForKey:@"contactsGroups"]?:[NSMutableArray array];
        self.Pinno=[coder decodeObjectForKey:@"pinNo"]?:[NSString string];
        self.PhoneNumber=[coder decodeObjectForKey:@"PhoneNumber"]?:[NSString string];
        self.dialNumbers=[coder decodeObjectForKey:@"dialNumbers"]?:[NSMutableArray array];
    }
    if(!sharedSingleton)
    {
        sharedSingleton=self;
    }
    sharedSingleton=[sharedSingleton retain];
    return sharedSingleton;
}
-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_callemeon forKey:@"callmeon"];
    [coder encodeObject:_recentsCall forKey:@"recentsCalls"];
    [coder encodeObject:_groups forKey:@"contactsGroups"];
    [coder encodeObject:_Pinno forKey:@"pinNo"];
    [coder encodeObject:_PhoneNumber forKey:@"PhoneNumber"];
    [coder encodeObject:_dialNumbers forKey:@"dialNumbers"];
}
-(void)sort
{
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(compare:)];
    [self.recentsCall sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}
-(void)sortGroups
{
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(compare:)];
    [self.groups sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

-(bool)isSettingsPresent
{
        //return ([self.Pinno length] >0 && [self.PhoneNumber length] > 0);
         return ([self.Pinno length] >0 &&[self.callemeon count] >0);
  
}
-(bool)isPhonenumberPresent
{
    return ([self.PhoneNumber length] > 0);
    
    
}
-(void)addRecentscallLog:(CallModel *)cmodel
{
        //NSLog(@"Recents callmodel %@",cmodel);
   
    for(NSInteger i=0; i< [self.recentsCall count]; i++)
    {
            //NSLog(@"Recents call %@",self.recentsCall);
        if([[self.recentsCall objectAtIndex:i] isEqual:cmodel])
        {
            [self.recentsCall removeObjectAtIndex:i];
            
        }
    }
   [self.recentsCall insertObject:cmodel atIndex:0];

}
@end
