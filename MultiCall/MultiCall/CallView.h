//
//  CallView.h
//  MultiCall
//
//  Created by ipod Touch on 25/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AddressBook/AddressBook.h>
#import "Model.h"
#import "PeoplePickerNavigationController.h"
#import "GroupsView.h"
#import "PhoneNumberFormatter.h"
#import "CallStatus.h"
#import "Twilio_Stub.h"
#import "CallNotifyButton.h"
#import "Reachability.h"
#import "Recents.h"
#import "DialNumberView.h"


@class  Model;
@class CallModel;
@class GroupModel;
@class DialNumberModel;
@class PhoneNumberFormatter;
@class Twilio_Stub;


@interface CallView : UIViewController<CEPeoplePickerNavigationControllerDelegate,CallStatus,UIAlertViewDelegate,UIActionSheetDelegate>
{
    @public
    BOOL isViewMode;
    NSIndexPath *Recentindexpath;
   
    
    Model *model;
    UINavigationController *groupContactPicker;
    UINavigationController *dialNUmberpicker;
    UINavigationController *settingsViewpicker;
    UINavigationController *callmeonViewpicker;
    
    BOOL iscontactclicked;
    BOOL callbuttonstatus;
    BOOL isCallEnded;
    UILabel * detailstext;
    NSDate *timersecondDate;
    
   


}

@property (retain, nonatomic) IBOutlet UITableViewCell *callmeonCell;



@property (retain, nonatomic) IBOutlet UIToolbar *bottomToolbar;
@property(retain,nonatomic)UILabel * lblCallType;
@property(retain,nonatomic)NSMutableArray *contacts;
@property(retain,nonatomic)PhoneNumberFormatter *formatter;
@property(retain,nonatomic)Twilio_Stub *twilio_adaptor;
@property (nonatomic, retain) NSMutableDictionary *statusButtons; 
@property (retain, nonatomic) IBOutlet UIButton *btnAddContact;
@property(retain,nonatomic)NSMutableArray *checkMultiCallArray;



@property (retain, nonatomic) IBOutlet UITableViewCell *buttonviewCell;

@property (retain, nonatomic) IBOutlet UIButton *btnAddGroup;
@property (retain, nonatomic) IBOutlet UIButton *btnAddNumber;
@property (retain, nonatomic) IBOutlet UIButton *btnCallButton;



- (IBAction)addContact;
- (IBAction)addGroup;

- (IBAction)addDialNumber;

- (IBAction)btnMakeMultiCall:(id)sender;


-(void)selectedGroup :(GroupModel *)groupmodel;
-(void)selectedPlaceGroup :(NSMutableArray *)groups;
-(void)dialnumberarray:(NSMutableArray *)dialnumbers;
-(void)addRecentsToExplode:(CallModel*)cmodel;

-(BOOL)isMultiCallActive;


-(void)changeButton:(NSString *)imagePath selector:(SEL)selector;
-(void)loadCallmeon;
-(void)editMode;
-(void)saveModel;
-(void)addContactToModel:(NSString *)name contactInfo:(NSString *)contactInfo contactType:(NSString *)contactType personId:(int)personId;
-(void)modifyContact:(ABRecordRef)person property:(ABPropertyID)property value:(NSString *)value phoneType:(NSString *)phoneType;

-(void)callEnded;


@end


