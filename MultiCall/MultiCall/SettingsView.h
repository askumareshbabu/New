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
    bool isEditMode;
    bool isPhoneChecked;
    bool isMobileCheckd;
    bool isHomeChecked;
    bool isWorkChecked;
}
@property (retain, nonatomic) IBOutlet UITableViewCell *addPinNo;
@property (retain, nonatomic) IBOutlet UITableViewCell *addPhoneNumber;

@property (retain, nonatomic) IBOutlet UITableViewCell *addiPhoneNumber;
@property (retain, nonatomic) IBOutlet UITableViewCell *addMobileNumber;

@property (retain, nonatomic) IBOutlet UITableViewCell *addHomeNumber;
@property (retain, nonatomic) IBOutlet UITableViewCell *addWork;

@property(retain,nonatomic)NSIndexPath * checkedIndexPath;


-(void)loadTextField;
-(void)done;
-(void)save;
-(void)savecallmeon;
-(void)keyboardAppear;

@end
