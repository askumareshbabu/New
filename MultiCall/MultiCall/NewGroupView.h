//
//  NewGroupView.h
//  MultiCall
//
//  Created by ipod Touch on 25/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "PeoplePickerNavigationController.h"
#import "PhoneNumberFormatter.h"

@class GroupModel;
@class Model;
@class GroupsView;

@interface NewGroupView : UIViewController<CEPeoplePickerNavigationControllerDelegate>
{
    /**< Flag to indicate action - contact being modified.*/
    bool isEditingContact;
	/**< Flag to indicate edit mode i.e Updating a meeting.*/
    bool isEditMode;
    
	/**< Last Row selected  */
        // NSIndexPath *lastSelIndexPath;
	/**<  Store contacts temporarily. For saving purposes  */
    NSMutableArray *contactsTemp; //store the editing contact temporarily. for saving purposes
    GroupModel *groupModel;
    @public
    BOOL  isGroupViewMode;
    
    UINavigationController *groupscallpicker;
}


@property (retain, nonatomic) IBOutlet UITableViewCell *groupNameCell;

@property (retain, nonatomic) IBOutlet UITableViewCell *buttonCell;




/**< Meeting model local instance @see  MeetingModel*/
@property (nonatomic, retain) GroupModel *model;

@property(nonatomic,retain) NSIndexPath *lastSelIndexPath;
@property(nonatomic,retain)NSString * groupNameExists;
@property(nonatomic,retain)NSString * isgroupNameExists;
@property(retain,nonatomic)PhoneNumberFormatter *formatter;
@property(retain,nonatomic)UIButton *placeMulitCall;
@property(retain,nonatomic)UIButton* addMember;

-(void)modifyContact:(ABRecordRef)person property:(ABPropertyID)property value:(NSString *)value phoneType:(NSString *)phoneType;

-(void)addContactToModel:(NSString *)name contactInfo:(NSString *)contactInfo contactType:(NSString *)contactType personId:(int)personId;
/**
 Save the meeting to application model.
 */

/**
 Load the data to local meeting instance and update the UI.
 */

-(void)loadGroupName;
-(void)save;


@end
