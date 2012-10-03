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
    BOOL  isGroupViewMode;
}


@property (retain, nonatomic) IBOutlet UITableViewCell *groupNameCell;

@property (retain, nonatomic) IBOutlet UITableViewCell *buttonCell;



/**< Meeting model local instance @see  MeetingModel*/
@property (nonatomic, retain) GroupModel *model;

@property(nonatomic,retain) NSIndexPath *lastSelIndexPath;
@property(nonatomic,retain)NSString * groupNameExists;
@property(nonatomic,retain)NSString * isgroupNameExists;
@property(retain,nonatomic)PhoneNumberFormatter *formatter;

-(void)modifyContact:(ABRecordRef)person property:(ABPropertyID)property value:(NSString *)value ;


/**
 Save the meeting to application model.
 */
-(void)saveModel;
/**
 Load the data to local meeting instance and update the UI.
 */
-(void)loadModel;

@end
