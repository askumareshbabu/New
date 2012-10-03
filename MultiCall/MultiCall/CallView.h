//
//  CallView.h
//  MultiCall
//
//  Created by ipod Touch on 25/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import <AddressBook/AddressBook.h>
#import "PeoplePickerNavigationController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "GroupsView.h"
#import "PhoneNumberFormatter.h"



@class  Model;
@class CallModel;
@class GroupModel;
@class DialNumberModel;
@class PhoneNumberFormatter;


@interface CallView : UIViewController<CEPeoplePickerNavigationControllerDelegate>
{
    BOOL isViewMode;
    Model *model;
    UINavigationController *groupContactPicker;
    UINavigationController *dialNUmberpicker;
}

@property (retain, nonatomic) IBOutlet UITableViewCell *callmeonCell;


@property (retain, nonatomic) IBOutlet UIToolbar *bottomToolbar;
@property(retain,nonatomic)UILabel * lblCallType;
@property(retain,nonatomic)NSMutableArray *contacts;
@property(retain,nonatomic)NSMutableArray *groups;
@property(retain,nonatomic)PhoneNumberFormatter *formatter;


- (IBAction)addContact;
- (IBAction)addGroup;

- (IBAction)addDialNumber;

-(void)selectedGroup :(GroupModel *)groupmodel;
-(void)dialnumberarray:(NSMutableArray *)dialnumbers;
-(void)addContactToModel:(NSString *)name contactInfo:(NSString *)contactInfo contactType:(NSString *)contactType personId:(int)personId;
@end
