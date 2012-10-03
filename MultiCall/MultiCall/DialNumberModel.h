//
//  DialNumberModel.h
//  MultiCall
//
//  Created by Kumaresh on 20/09/12.
//
//

#import <Foundation/Foundation.h>

@interface DialNumberModel : NSObject


@property(nonatomic,retain)NSString *DialNumber;


-(id)initWithCoder :(NSCoder *)coder;
-(void)encodeWithCoder :(NSCoder *)coder;
@end
