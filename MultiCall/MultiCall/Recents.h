//
//  Recents.h
//  MultiCall
//
//  Created by ipod Touch on 25/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallView.h"

@class Model;
@class CallView;


@interface Recents : UIViewController

{
    Model *model;
    UINavigationController *callviewpicker;
    UINavigationController *recentviewpicker;
    UINavigationController *startMulticallPicker;

}

-(NSString *)formatName:(CallModel *)modelarg;
@property(retain,nonatomic) UIView * recentview;
@property(retain,nonatomic)UILabel *lblRecentContacts; 
@property(retain,nonatomic)UILabel *lblParticipants; 
@property(retain,nonatomic)UILabel *lblDate; 
@property(retain,nonatomic)UIView *starNewView;



@end
