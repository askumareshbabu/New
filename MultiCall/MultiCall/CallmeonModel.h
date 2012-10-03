//
//  CallmeonModel.h
//  MultiCall
//
//  Created by Kumaresh on 01/09/12.
//
//

#import <Foundation/Foundation.h>

@interface CallmeonModel : NSObject<NSCoding>
{
    BOOL * isSelected;
}
@property(nonatomic,retain)NSString *CallType;
@property(nonatomic,retain)NSString *CallPhoneNumber;
@property(nonatomic)BOOL isSelected;

-(id)initWithCoder :(NSCoder *)coder;
-(void)encodeWithCoder :(NSCoder *)coder;

@end
