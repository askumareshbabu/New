//
//  GroupModel.m
//  MultiCall
//
//  Created by Kumaresh on 11/09/12.
//
//

#import "GroupModel.h"

@implementation GroupModel
@synthesize groupName=_groupName;
@synthesize contacts=_contacts;
@synthesize isGroupViewMode=_isGroupViewMode;

- (id)init
{
    self = [super init];
    if (self) {
            // Initialization code here.
        self.contacts=[[[NSMutableArray alloc]init]autorelease];
    }
    
    return self;
}


- (id) initWithCoder: (NSCoder *)coder
{
   
    if ((self = [super init]))
    {
        self.groupName = [coder decodeObjectForKey:@"_groupName"];
        self.contacts = [coder decodeObjectForKey:@"contacts"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_groupName forKey:@"_groupName"];
    [coder encodeObject:_contacts forKey:@"contacts"];
}

-(NSString *) description {
    return [NSString stringWithFormat:@"GroupName: %@, Contacts; %@",self.groupName,self.contacts];
}
- (NSComparisonResult)compare:(GroupModel *)otherObject {
    
    
    return [self.groupName compare:otherObject.groupName];
    
    
}

- (BOOL)isEqual:(id)anObject
{
    return [self.groupName isEqualToString:((GroupModel *)anObject).groupName];
}


@end
