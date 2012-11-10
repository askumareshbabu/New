//
//  NewGroupView.m
//  MultiCall
//
//  Created by ipod Touch on 25/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewGroupView.h"
#import "GroupModel.h"
#import "Model.h"
#import "GroupsView.h"
#import "ContactModel.h"
#import "CallView.h"


#define defaultColor [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0 ];
@interface NewGroupView()




    //- (void)didEnterNumber:(NSString*)number;
- (void)cePeoplePickerNavigationControllerDidCancel:(CEPeoplePickerNavigationController *)peoplePicker;
- (void)cePeoplePickerNavigationController:(CEPeoplePickerNavigationController *)peoplePicker didFinishPickingPeople:(NSArray *)people values:(NSDictionary *)valuesArg;


-(void)editmode;
-(void)saveModel;


@end

@implementation NewGroupView

@synthesize groupNameCell=_groupNameCell;
@synthesize buttonCell = _buttonCell;
@synthesize model=_model;
@synthesize lastSelIndexPath;
@synthesize groupNameExists;
@synthesize isgroupNameExists;
@synthesize formatter=_formatter;
@synthesize placeMulitCall;
@synthesize addMember;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isEditingContact = NO;
        isEditMode= NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.formatter=[[[PhoneNumberFormatter alloc]init]autorelease];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editmode)]autorelease];
    self.navigationItem.rightBarButtonItem.style=UIBarButtonItemStyleBordered;
    // Do any additional setup after loading the view from its nib.
    if(!self.model)
    {
            isGroupViewMode=NO;
        GroupModel *mod = [[[GroupModel alloc]init]autorelease];
        self.model = mod;
        contactsTemp= [[NSMutableArray alloc]init];
        [self loadGroupName];
        
    }
    
    else
    {
        isEditMode=YES;
       
        contactsTemp = [[NSMutableArray alloc]initWithArray:self.model.contacts];
        [self loadGroupName];
        NSLog(@"ContactsTemp %@",contactsTemp);
    }
    if(isEditMode)
    {
            // self.title=self.model.groupName;
        
    }
    else
        self.title=@"New Group";
}

- (void)viewDidUnload
{
    [self setGroupNameCell:nil];
    
    [self setButtonCell:nil];
    [super viewDidUnload];
    self.formatter=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_groupNameCell release];
    [contactsTemp release];
    [_formatter release];
    [_buttonCell release];
    [super dealloc];
}
-(void)buttonEnable
{
    if(isGroupViewMode ==YES)
    {
        [self.addMember setEnabled:NO];
    }
    else
    {
        [self.addMember setEnabled:YES];
    }
    
    if([contactsTemp count])
    {
        [self.placeMulitCall setEnabled:YES];
    }
    else
    {
        self.navigationItem.rightBarButtonItem=nil;
        [self.placeMulitCall setEnabled:NO];
        
    }
}
-(void)enableSave
{
    if(!isGroupViewMode){
         self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)]autorelease];
        self.navigationItem.rightBarButtonItem.style=UIBarButtonItemStyleDone;
        
    }
}
-(void)disableSave
{
    if([contactsTemp count]>0){
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editmode)]autorelease];
        self.navigationItem.rightBarButtonItem.style=UIBarButtonItemStyleBordered;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    if([contactsTemp count])
            [self enableSave];
       else
           [self disableSave];
    
         [self buttonEnable];
}
-(void)viewDidDisappear:(BOOL)animated
{
   
}
-(void)loadGroupName
{
    UITextField *txtGroupName=(UITextField *)[_groupNameCell viewWithTag:1];
    txtGroupName.text=self.model.groupName ?:@"";
    if(isGroupViewMode==YES)
    {
        self.groupNameExists=self.model.groupName;
        txtGroupName.enabled=NO;
    }
    else{
        txtGroupName.enabled=YES;
    
        [txtGroupName becomeFirstResponder];}
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([[textField text]length])
        self.navigationItem.rightBarButtonItem.enabled=YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
-(void)editmode
{
        isGroupViewMode=NO;
    if(((UITableView*)self.view).editing){
        
        [((UITableView*)self.view) setEditing: NO animated: YES];
        self.navigationItem.rightBarButtonItem.title=@"Edit";
        self.navigationItem.rightBarButtonItem.style=UIBarButtonItemStyleBordered;
    }
    else{
       
        
        [((UITableView*)self.view) setEditing: YES animated: YES];
        self.navigationItem.rightBarButtonItem.title=@"Done";
        self.navigationItem.rightBarButtonItem.style=UIBarButtonItemStyleDone;
        [self enableSave];
        [self loadGroupName];
            //[(UITableView *)self.view reloadData];
    }
    [self buttonEnable];
}
-(void)done
{
    [self.view endEditing:YES];
    [self save];
}
-(BOOL)isABAddressBookCreateWithOptionsAvailable {
    return &ABAddressBookCreateWithOptions != NULL;
}
-(IBAction)addMemberClicked 
{
        // http://stackoverflow.com/questions/12517394/ios-6-address-book-not-working;
    
    CFErrorRef error = nil;

    
    ABAddressBookRef addressBook;
    if ([self isABAddressBookCreateWithOptionsAvailable]) {
        
        addressBook = ABAddressBookCreateWithOptions(NULL,&error);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                // callback can occur in background, address book must be accessed on thread it was created on
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    CustomMessageClass *alermsg=[[CustomMessageClass alloc]init];
                    [alermsg CustomMessage:@"1" MessageNo:@"5"];
                    [alermsg release];
                   
                    
                } else if (!granted) {
                    CustomMessageClass *alermsg=[[CustomMessageClass alloc]init];
                    [alermsg CustomMessage:@"1" MessageNo:@"5"];
                    [alermsg release];
                   
                    
                } else {
                    
                    
                   
                    [self LoadContacts:addressBook];
                    CFRelease(addressBook);
                }
            });
        });
        
    } else {
            // iOS 4/5
        addressBook = ABAddressBookCreate();
        [self LoadContacts:addressBook];
        CFRelease(addressBook);
    }
    
   
}
-(void)LoadContacts:(ABAddressBookRef)addressBook
{
    NSMutableDictionary *values =[NSMutableDictionary dictionary];
    for(ContactModel *Cmodel in contactsTemp)
    {
        if(Cmodel.name){
            ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook,(ABRecordID) Cmodel.personId);
            if(person){ //crashing sometimes so defensive
                ABRecordID iden = ABRecordGetRecordID(person);
                NSMutableArray *arr=[NSMutableArray arrayWithObjects:Cmodel.name,Cmodel.contactInfo,Cmodel.contactType, nil];
                [values setObject:arr forKey:KEY_FOR_SELECTION(iden)];
                person=nil;
                
            }
        }
        
    }
    
    CEPeoplePickerNavigationController *picker = [[CEPeoplePickerNavigationController alloc] initWithValues:values];
    picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release];

}
-(IBAction)placeMultiCallClicked
{
    NSLog(@"place multicall clicked");
    
    CallView *cview=[[CallView alloc]init];
    [cview selectedPlaceGroup:contactsTemp];
    groupscallpicker=[[UINavigationController alloc]initWithRootViewController:cview];
    cview.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(groupscallpickerpickerdismiss)]autorelease];
    groupscallpicker.title=@"Add Participants";
    [self presentModalViewController:groupscallpicker animated:YES];
    [groupscallpicker release];
    [cview release];
    
}


-(void)groupscallpickerpickerdismiss
{
    [self dismissModalViewControllerAnimated:YES];
}
#pragma TableView
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=nil;
    UIView * viewcontact=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    UILabel *lblName=[[[UILabel alloc]init]autorelease];
    UILabel *lblnumber=[[[UILabel alloc]init]autorelease];
    UILabel * lblContactType=[[[UILabel alloc]init]autorelease];
    
    switch (indexPath.section) {
        case 0:
        {
            cell =_groupNameCell;
            break;
        
            
        }
        case 1:
        {
            cell=_buttonCell;
           
                //Removing the border so i used this
         _buttonCell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            
            self.addMember = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.addMember setFrame:CGRectMake(0, 0, 140, 45)];
            
            self.placeMulitCall =[UIButton buttonWithType:UIButtonTypeCustom];
            [self.placeMulitCall setFrame:CGRectMake(160, 0, 140, 45)];
            
                // [addMember setBackgroundImage:[[UIImage imageNamed:@"Add-Member-Butt.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [self.addMember setBackgroundImage:[[UIImage imageNamed:@"Add-Member-Butt.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal ];
            
            [self.placeMulitCall setBackgroundImage:[[UIImage imageNamed:@"Place_Multicall.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [_buttonCell.contentView addSubview:self.addMember];
            [_buttonCell.contentView addSubview:self.placeMulitCall];
            [self.addMember addTarget:self action:@selector(addMemberClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.placeMulitCall addTarget:self action:@selector(placeMultiCallClicked) forControlEvents:UIControlEventTouchUpInside];
            [self buttonEnable];
            break;
        }
        
        case 2:
            {
                cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"newGroup"];
                    // if(cell == nil)
            
                    cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"newGroup"]autorelease];
                cell.backgroundColor=[UIColor whiteColor];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                   
            
                
                lblName.font=[UIFont fontWithName:@"Helvetica-Bold" size:16.0];
                lblnumber.font=[UIFont fontWithName:@"Helvetica" size:15.0];
                lblContactType.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                lblName.textColor=defaultColor;
                lblnumber.textColor=[UIColor blackColor];
                lblContactType.textColor=defaultColor;
                
                lblName.frame= CGRectMake(5, 3, 130, 25);
                lblnumber.frame=CGRectMake(5, 34, 180, 15);
                lblContactType.frame=CGRectMake(220,8, 70, 20);
                
                [viewcontact addSubview:lblName];
                [viewcontact addSubview:lblnumber];
                [viewcontact addSubview:lblContactType];
                [cell.contentView addSubview:viewcontact];
                lblName.lineBreakMode=UILineBreakModeTailTruncation;
                viewcontact.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                    //lblName.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
                lblnumber.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                lblContactType.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
                ContactModel *contact = [contactsTemp objectAtIndex:indexPath.row];
               
                if(contact)
                {
                    lblName.text=contact.name ? :@"unknown";
                    lblnumber.text=[self.formatter phonenumberformat:contact.contactInfo withLocale:@"us"]; 
                    lblContactType.text=contact.contactType ?:@"Dialed";
                }
                
                break;
            }
        }
     
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
                //  if(isGroupViewMode ==YES)
                // return 0;
                // else
                return 1;
           
        case 1:
                // if(isGroupViewMode ==YES)
                //   return 0;
                //   else
                
                return 1;
        case 2:
            
            NSLog(@"count %i",[contactsTemp count]);
                return [contactsTemp count];
       
        default:
           
            return 1;
    }
    
}
-(NSInteger)numberOfSectionsInTableView :(UITableView *)tableView
{
    return 3;
}
-(BOOL)tableView :(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return NO;
            break;
        case 1:
            return NO;
        case 2:
            return YES;
        default:
            return YES;
            break;
    }
}
-(BOOL)tableView :(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return UITableViewCellEditingStyleNone;
            break;
        case 1:
            return UITableViewCellEditingStyleNone;
            case 2:
                if(!isGroupViewMode ==YES)
            return UITableViewCellEditingStyleDelete;
                 else
                   return UITableViewCellEditingStyleNone;
        default:
            return UITableViewCellEditingStyleDelete;
            break;
    }
}
-(void)tableView :(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
        [contactsTemp removeObjectAtIndex:indexPath.row];
   
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:2]] withRowAnimation:UITableViewRowAnimationBottom];
   
    NSLog(@"Removed contat temp %@",contactsTemp);
    [self buttonEnable];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==2)
    return 55.0;
    else
        return 44.0;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

- (void)cePeoplePickerNavigationControllerDidCancel:(CEPeoplePickerNavigationController *)peoplePicker
//- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
}

/**
 When a contact is picked , get the contact details and save it to model
 */
-(void)cePeoplePickerNavigationController:(CEPeoplePickerNavigationController *)peoplePicker didFinishPickingPeople:(NSArray *)peopleArg values:(NSDictionary *)valuesArg
{
    
    [contactsTemp removeAllObjects];
    [(UITableView *)self.view reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationLeft];
    
        // NSArray *people=peopleArg;
    
    NSLog(@"grpoups people %@",peopleArg);
//    if([people count])
//    {
//        NSMutableDictionary * values=[[NSMutableDictionary alloc]initWithDictionary:valuesArg];
//        NSLog(@"groups value arg %@",values);
//        for(int i=0; i<[people count]; i++)
//        {
//            ABRecordRef person=[people objectAtIndex:i];
//            ABRecordID iden=ABRecordGetRecordID(person);
//            
//                //NSString * key=KEY_FOR_SELECTION(iden);
//            NSString * key=KEY_FOR_SELECTION(iden);
//            
//            NSMutableArray * dictkeys=[values objectForKey:key];
//            NSString *name=[dictkeys objectAtIndex:0];
//            NSString *value=[dictkeys objectAtIndex:1];
//            NSString * phoneType=[dictkeys objectAtIndex:2];
//            
//                //add Contact;
//                // [self modifyContact:person property:kABPersonPhoneProperty value:value phoneType:phoneType];
//            [self addContactToModel:name contactInfo:[self.formatter phonenumberformat:value withLocale:@"us"] contactType:phoneType personId:[key intValue]];
//            [values removeObjectForKey:key];
//        }
//            // [values release];
//    }
    if([valuesArg count])
    {
        NSMutableDictionary * values=[[NSMutableDictionary alloc]initWithDictionary:valuesArg];
        NSLog(@"value arg %@",values);
        NSString *value;NSString * phoneType;NSString *name;
        for(id key in [values allKeys])
        {
                //NSLog(@"key %@",key);
            NSMutableArray * dictkeys=[values objectForKey:key];
                // NSLog(@"dicts %@",dictkeys);
        
                name=[dictkeys objectAtIndex:0];
                value=[dictkeys objectAtIndex:1];
                phoneType=[dictkeys objectAtIndex:2];
                
            
            [self addContactToModel:name contactInfo:[self.formatter phonenumberformat:value withLocale:@"us"] contactType:phoneType personId:[key intValue]];  
        }
        [values release];
    }
    [peoplePicker dismissModalViewControllerAnimated:YES];
    [(UITableView *)self.view reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationLeft];
        //[(UITableView *)self.view setEditing:YES animated:YES];
        //[self.view performSelector:@selector(editmode)];
}
/**
 Save contact details to model
 */
-(void)modifyContact:(ABRecordRef)person property:(ABPropertyID)property value:(NSString *)value phoneType:(NSString *)phoneType
{
    CFStringRef firstName, lastName;
    
    firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    lastName  = ABRecordCopyValue(person, kABPersonLastNameProperty)   ;
    ABRecordID iden = ABRecordGetRecordID(person);
    NSString *name=[NSString stringWithFormat:@"%@ %@",firstName?:(CFStringRef)@"",lastName?:(CFStringRef)@""];
    NSString *trimmedName = [name stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self addContactToModel:trimmedName contactInfo:value contactType:phoneType personId:iden];
    if(firstName)
        CFRelease(firstName);
    if(lastName)
        CFRelease(lastName);
}
-(void)addContactToModel:(NSString *)name contactInfo:(NSString *)contactInfo contactType:(NSString *)contactType personId:(int)personId
{
    ContactModel *contact = [[[ContactModel alloc]init]autorelease];
    contact.name = name;
    contact.personId=personId;
    contact.contactInfo = contactInfo;
    contact.contactType=contactType;
    
        //check for nulls and also say user if somthing is invalid
    if(![contactsTemp containsObject:contact])
    {
        [contactsTemp addObject:contact];
        
         
    }
}


/**
 Save data to model
 */
-(void)save
{
    UITextField *name = (UITextField*)[_groupNameCell viewWithTag:1];
    NSString *trimmedName =[name.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableArray *groupName=[[[ NSMutableArray alloc]init]autorelease];
    
    for (NSInteger i=0;i<[[[Model singleton]groups]count];i++) {
        
        groupModel= [[[Model singleton]groups] objectAtIndex:i];
        
        [groupName addObject:groupModel.groupName];
        
    }
    if(self.groupNameExists)
        [groupName removeObject:self.groupNameExists];
     NSLog(@"group array %@",groupName);
    
    
    if([trimmedName length] > 0)
    {
        self.model.groupName=trimmedName;
        
    }
    else
    {
      
        CustomMessageClass *alertMsg=[[CustomMessageClass alloc]init];
        [alertMsg CustomMessage:@"3" MessageNo:@"1"];
        [alertMsg release];
        [name becomeFirstResponder];
        return;
    }
    if(![contactsTemp count])
    {
        
        return;
    }
    
   
    else if([[[Model singleton]groups] containsObject:self.model])
    {
        
        
        for(NSString *Gname in groupName)
        {
            
            if([Gname isEqualToString:self.model.groupName])
            {
                
                self.model.groupName=groupNameExists;
                CustomMessageClass *alertMsg=[[CustomMessageClass alloc]init];
                [alertMsg CustomMessage:@"3" MessageNo:@"4"];
                [alertMsg release];
                [name becomeFirstResponder];
                return;
                
            }
            
        }
        
        [self.model.contacts setArray:contactsTemp];
        
        [self saveModel];
        
            //self.navigationItem.prompt =@"Group already exists.";
            // [self performSelector:@selector(hidePrompt) withObject:self afterDelay:3.0];
        
    }
    else
    {
        [self.model.contacts setArray:contactsTemp];
        
        [self saveModel];
    }
    
}

-(void)saveModel
{
        //NSString *message;
    if(isEditMode){
            //  message= @"Group modified successfully";
        CustomMessageClass *alertMsg=[[CustomMessageClass alloc]init];
        [alertMsg CustomMessage:@"3" MessageNo:@"3"];
        [alertMsg release];
        
        
    }
    else{
        [[[Model singleton]groups] addObject:self.model];
            //message= @"Group created successfully";
        CustomMessageClass *alertMsg=[[CustomMessageClass alloc]init];
        [alertMsg CustomMessage:@"3" MessageNo:@"2"];
        [alertMsg release];
        
    }
     
    [(MulticallAppDelegate *)[[UIApplication sharedApplication] delegate]saveCustomeObject]; //force save
    NSLog(@"self.groups %@",self.model.contacts);
    [self.navigationController popViewControllerAnimated:YES ];
}

@end
