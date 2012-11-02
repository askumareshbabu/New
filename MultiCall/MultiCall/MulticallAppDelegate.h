//
//  MulticallAppDelegate.h
//  MultiCall
//
//  Created by ipod Touch on 18/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MulticallAppDelegate : NSObject <UIApplicationDelegate>

@property (retain, nonatomic) IBOutlet UIWindow *window;

@property (retain, nonatomic) IBOutlet UITabBarController *tabBarController;
@property(retain,nonatomic)NSString *filepath;

-(void)loadCustomObject;
-(void)saveCustomeObject;
-(void)updateChecker;
@end
