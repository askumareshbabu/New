//
//  CallModel.h
//  MultiCall
//
//  Created by Kumaresh on 11/09/12.
//
//

#import <Foundation/Foundation.h>

@interface CallModel : NSObject<NSCoding>{
    
}
@property(nonatomic,retain)NSDate *dateTime;
@property(nonatomic,retain)NSMutableArray *contacts;


-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;

-(NSComparisonResult)compare:(CallModel *)otherObject;
@end
