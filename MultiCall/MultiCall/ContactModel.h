//
//  ContactModel.h
//  MultiCall
//
//  Created by Kumaresh on 11/09/12.
//
//

#import <Foundation/Foundation.h>
#import "PhoneNumberFormatter.h"

@interface ContactModel : NSObject<NSCoding>
{
    
}

@property(nonatomic) NSInteger personId;
@property(retain,nonatomic)NSString *contactInfo;
@property(retain,nonatomic)NSString * name;
@property(retain,nonatomic)NSString *contactType;
@property(retain,nonatomic)PhoneNumberFormatter *formatter;

-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;

@end
