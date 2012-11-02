//
//  Model.h
//  MultiCall
//
//  Created by Kumaresh on 01/09/12.
//
//

#import <Foundation/Foundation.h>

@class CallModel;

@interface Model : NSObject
{
    
}
    // @return the singleton of model class
+(id)singleton;
@property(nonatomic,retain)NSMutableArray *callemeon;
@property(nonatomic,retain)NSMutableArray *recentsCall;
@property(nonatomic,retain)NSMutableArray *groups;
@property(nonatomic,retain)NSString *Pinno;
@property(nonatomic,retain)NSString *PhoneNumber;
@property(nonatomic,retain)NSMutableArray *dialNumbers;

-(id)initWithCoder:(NSCoder *)coder;
-(void)encodeWithCoder:(NSCoder *)coder;
-(void)addRecentscallLog:(CallModel *)cmodel;
 
-(void)sort;
-(void)sortGroups;
-(bool)isSettingsPresent;

 
@end



