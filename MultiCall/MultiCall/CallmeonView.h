//
//  CallmeonView.h
//  MultiCall
//
//  Created by ipod Touch on 29/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallmeonModel.h"
#import "Message.h"


@class Model;
@class CallmeonModel;

@interface CallmeonView : UIViewController
{
bool isEditMode;
    bool isPhoneChecked;
    bool isMobileCheckd;
    bool isHomeChecked;
    bool isWorkChecked;
    bool isdeleted;
    Model *model;
    NSString * iphone,*mobile,*home,*work;
    
    NSMutableArray *cellArray;
   
}
@property (retain, nonatomic) IBOutlet UITableViewCell *addiPhoneNumber;
@property (retain, nonatomic) IBOutlet UITableViewCell *addMobileNumber;
@property (retain, nonatomic) IBOutlet UITableViewCell *addHomeNumber;
@property (retain, nonatomic) IBOutlet UITableViewCell *addWorkNumber;

@property(retain,nonatomic)UITextField * txtiPhone;
@property(retain,nonatomic)UITextField * txtMobile;
@property(retain,nonatomic)UITextField * txtHome;
@property(retain,nonatomic)UITextField * txtWork;


@property(retain,nonatomic)NSMutableArray * cellArray;

@property(retain,nonatomic)NSIndexPath * checkedIndexPath;
@property(retain,nonatomic)NSIndexPath *selectdIndexPath;

@property(nonatomic)BOOL checked;
@property(retain,nonatomic) CallmeonModel *callmeonModel;



-(void)LoadTextField;
-(void)removeEmptyTableCell;
-(void)saveModel;


@end
