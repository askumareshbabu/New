//
//  GroupModel.h
//  MultiCall
//
//  Created by Kumaresh on 11/09/12.
//
//

#import <Foundation/Foundation.h>

@interface GroupModel : NSObject

@property (nonatomic, retain) NSString *groupName;
@property (nonatomic, retain) NSMutableArray *contacts;
@property(nonatomic,retain) NSString * isGroupViewMode;


- (id) initWithCoder: (NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;
- (NSComparisonResult)compare:(GroupModel *)otherObject;
@end
