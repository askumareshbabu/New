//
//  SettingsView.h
//  MultiCall
//
//  Created by ipod Touch on 25/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "CallmeonModel.h"

@class Model;
@interface SettingsView : UIViewController
{
    Model *model;
    @public
    bool isUpdateView;
}
@property (retain, nonatomic) IBOutlet UITableViewCell *addPinNo;
@property (retain, nonatomic) IBOutlet UITableViewCell *addPhoneNumber;
-(void)loadTextField;
-(void)done;
-(void)save;

@end
