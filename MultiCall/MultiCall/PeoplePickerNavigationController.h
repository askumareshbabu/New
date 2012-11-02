//
//  CEPeoplePickerNavigationController.h
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "PhoneNumberFormatter.h"

#define KEY_FOR_SELECTION(x) [NSString stringWithFormat:@"%d",x]

@protocol CEPeoplePickerNavigationControllerDelegate;

//
// This is a replacement for ABPeoplePickerNavigationController, which
// supports picking of multiple people.

@interface CEPeoplePickerNavigationController : UINavigationController {
    id<CEPeoplePickerNavigationControllerDelegate> peoplePickerDelegate;
    ABAddressBookRef addressBook;
}

@property (nonatomic, readonly) ABAddressBookRef addressBook;
@property (nonatomic, assign) id<CEPeoplePickerNavigationControllerDelegate> peoplePickerDelegate;

- (id)initWithValues:(NSMutableDictionary *)values;
@end


@protocol CEPeoplePickerNavigationControllerDelegate <NSObject>

// Return YES to add the person to the current selection, NO to do nothing.
//- (BOOL)cePeoplePickerNavigationController:(CEPeoplePickerNavigationController *)peoplePicker shouldSelectPerson:(ABRecordRef)person;
//- (BOOL)cePeoplePickerNavigationController:(CEPeoplePickerNavigationController *)peoplePicker shouldDeselectPerson:(ABRecordRef)person;

// People is a CFArrayRef containing ABRecordRef of type kABPersonType. It follows the Get rule.
// The receiver is responsible for dismissing peoplePicker.
- (void)cePeoplePickerNavigationController:(CEPeoplePickerNavigationController *)peoplePicker didFinishPickingPeople:(NSArray*)people values:(NSDictionary *)values;

// The receiver is responsible for dismissing peoplePicker.
- (void)cePeoplePickerNavigationControllerDidCancel:(CEPeoplePickerNavigationController *)peoplePicker;

@end