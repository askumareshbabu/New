//
//  Message.h
//  MultiCall
//
//  Created by ipod Touch on 20/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property(nonatomic,retain) NSString *MessageContent;
-(void)CustomMessage:(NSString *)ScreenName MessageNo:(NSString *)MessageNo;
@end
