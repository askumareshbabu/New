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


#define defaultColor [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0 ];
@interface NewGroupView()
-(void)dialNumber:(id)sender;
-(void)addContact:(id)sender;

    //- (void)didEnterNumber:(NSString*)number;
- (void)cePeoplePickerNavigationControllerDidCancel:(CEPeoplePickerNavigationController *)peoplePicker;
- (void)cePeoplePickerNavigationController:(CEPeoplePickerNavigationController *)peoplePicker didFinishPickingPeople:(NSArray *)people values:(NSDictionary *)valuesArg;

-(void)modifyContact:(ABRecordRef)person property:(ABPropertyID)property value:(NSString *)value ;
-(void)addContactToModel:(NSString *)name contactInfo:(NSString *)contactInfo personId:(int)personId ;

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
    self.formatter=[[PhoneNumberFormatter alloc]init];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editmode)]autorelease];
    
    // Do any additional setup after loading the view from its nib.
    if(!self.model)
    {
        isGroupViewMode=NO;
        GroupModel *mod = [[GroupModel alloc]init];
        self.model = mod;
        contactsTemp= [[NSMutableArray alloc]init];
        [self loadGroupName];
        
        [mod release];
        
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
        self.title=self.model.groupName;
        
    }
    else
        self.title=@"New Group";
}

- (void)viewDidUnload
{
    [self setGroupNameCell:nil];
    [contactsTemp release];
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
-(void)enableSave
{
         self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)]autorelease];
    self.navigationItem.rightBarButtonItem.enabled=YES;
}
-(void)disableSave
{
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editmode)]autorelease];
    self.navigationItem.rightBarButtonItem.enabled=NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    if([contactsTemp count]){
       if(!isGroupViewMode ==YES)
       [self enableSave];
    }
       else
           [self disableSave];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
   
}
-(void)loadGroupName
{
    UITextField *txtGroupName=(UITextField *)[_groupNameCell viewWithTag:1];
    txtGroupName.text=self.model.groupName ?:@"";
    if(![txtGroupName.text isEqualToString:@""]){
        isGroupViewMode=YES;
        self.groupNameExists=self.model.groupName;}
    else
        [txtGroupName becomeFirstResponder];
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
    }
    else{
       
        
        [((UITableView*)self.view) setEditing: YES animated: YES];
        self.navigationItem.rightBarButtonItem.title=@"Done";
        [self enableSave];
        [(UITableView *)self.view reloadData];
    }

}
-(void)done
{
    [self.view endEditing:YES];
    [self save];
}
-(IBAction)addMemberClicked 
{
    NSMutableDictionary *values =[NSMutableDictionary dictionary];
    ABAddressBookRef ab = ABAddressBookCreate();
    for(ContactModel *Cmodel in contactsTemp)
    {
        if(Cmodel.name){
            ABRecordRef person = ABAddressBookGetPersonWithRecordID(ab,(ABRecordID) Cmodel.personId);
            if(person){ //crashing sometimes so defensive
                ABRecordID iden = ABRecordGetRecordID(person);
                NSMutableArray *arr=[NSMutableArray arrayWithObjects:Cmodel.contactInfo,Cmodel.contactType, nil];
                [values setObject:arr forKey:KEY_FOR_SELECTION(iden)];
                CFRelease(person);
            }
        }else //dailed nos
        {
                // [values setObject:Cmodel.contactInfo forKey:KEY_FOR_SELECTION(Cmodel.personId)];
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
}
#pragma TableView
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
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
         _buttonCell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
            UIButton* addMember = [UIButton buttonWithType:UIButtonTypeCustom];
            [addMember setFrame:CGRectMake(0, 0, 140, 45)];
            
            UIButton* placeMulitCall = [UIButton buttonWithType:UIButtonTypeCustom];
            [placeMulitCall setFrame:CGRectMake(160, 0, 140, 45)];
            
                // [addMember setBackgroundImage:[[UIImage imageNamed:@"Add-Member-Butt.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [addMember setBackgroundImage:[[UIImage imageNamed:@"Add-Member-Butt.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal ];
            
            [placeMulitCall setBackgroundImage:[[UIImage imageNamed:@"Place_Multicall.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [_buttonCell.contentView addSubview:addMember];
            [_buttonCell.contentView addSubview:placeMulitCall];
            [addMember addTarget:self action:@selector(addMemberClicked) forControlEvents:UIControlEventTouchUpInside];
            [placeMulitCall addTarget:self action:@selector(placeMultiCallClicked) forControlEvents:UIControlEventTouchUpInside];
                //   [addMember release];
                //  [placeMulitCall release];
            break;
        }
        
        case 2:
            {
                cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"newGroup"];
                if(cell == nil)
                {
                    cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"newGroup"]autorelease];
                    cell.textLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
                    cell.detailTextLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
                    cell.backgroundColor=[UIColor whiteColor];
                    cell.detailTextLabel.textColor = defaultColor;
                    cell.textLabel.textAlignment=UITextAlignmentLeft;
                    cell.detailTextLabel.textAlignment=UITextAlignmentRight;
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                   
                }
                
                ContactModel *contact = [contactsTemp objectAtIndex:indexPath.row];
                if(contact)
                {
                    cell.textLabel.text=contact.name ?:[self.formatter phonenumberformat:contact.contactInfo withLocale:@"us"];// contact.contactInfo;
                    cell.detailTextLabel.text=contact.contactType ?:@"unknown";
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
            if(isGroupViewMode ==YES)
                return 0;
            else
                return 1;
           
        case 1:
            if(isGroupViewMode ==YES)
                return 0;
            else
                
                return 1;
        case 2:
            
            
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
        
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    
    if([contactsTemp count])
    {
        [self enableSave];
    }
    else
        [self disableSave];
    
}
-(void)tableView :(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

-(void)addContact:(id)sender
{
    NSMutableDictionary *values =[NSMutableDictionary dictionary];
    ABAddressBookRef ab = ABAddressBookCreate();
    for(ContactModel *Cmodel in contactsTemp)
    {
        if(Cmodel.name){
            ABRecordRef person = ABAddressBookGetPersonWithRecordID(ab,(ABRecordID) Cmodel.personId);
            if(person){ //crashing sometimes so defensive
                ABRecordID iden = ABRecordGetRecordID(person);
                NSMutableArray *arr=[NSMutableArray arrayWithObjects:Cmodel.contactInfo,Cmodel.contactType, nil];
                [values setObject:arr forKey:KEY_FOR_SELECTION(iden)];
                CFRelease(person);
            }
        }else //dailed nos
        {
                // [values setObject:Cmodel.contactInfo forKey:KEY_FOR_SELECTION(Cmodel.personId)];
        }
    }
    
    CEPeoplePickerNavigationController *picker = [[CEPeoplePickerNavigationController alloc] initWithValues:values];
    picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release];
    
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
    
    NSArray *people=peopleArg;
    
   
    if([people count])
    {
        NSMutableDictionary * values=[[NSMutableDictionary alloc]initWithDictionary:valuesArg];
        for(int i=0; i<[people count]; i++)
        {
            ABRecordRef person=[people objectAtIndex:i];
            ABRecordID iden=ABRecordGetRecordID(person);
            
                //NSString * key=KEY_FOR_SELECTION(iden);
            NSString * key=KEY_FOR_SELECTION(iden);
            
            NSMutableArray * dictkeys=[values objectForKey:key];
            NSString *value=[dictkeys objectAtIndex:0];
            NSString * phoneType=[dictkeys objectAtIndex:1];
            
                //add Contact;
            [self modifyContact:person property:kABPersonPhoneProperty value:value phoneType:phoneType];
            [values removeObjectForKey:key];
        }
            //add Dial Number here
    }
    [peoplePicker dismissModalViewControllerAnimated:YES];
    [(UITableView *)self.view reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationLeft];
    [(UITableView *)self.view setEditing:YES animated:YES];
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
    [self addContactToModel:trimmedName contactInfo:[self.formatter phonenumberformat:value withLocale:@"us"] contactType:phoneType personId:iden];
    
}
-(void)addContactToModel:(NSString *)name contactInfo:(NSString *)contactInfo contactType:(NSString *)contactType personId:(int)personId
{
    ContactModel *contact = [[ContactModel alloc]init];
    contact.name = name;
    contact.personId=personId;
    contact.contactInfo = contactInfo;
    contact.contactType=contactType;
    
        //check for nulls and also say user if somthing is invalid
    if(![contactsTemp containsObject:contact])
    {
        [contactsTemp addObject:contact];
        [contact release];
         
    }
    
    
}


/**
 Save data to model
 */
-(void)save
{
    UITextField *name = (UITextField*)[_groupNameCell viewWithTag:1];
    NSString *trimmedName =[name.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableArray *groupName=[[ NSMutableArray alloc]init];
    
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
      
        Message *alertMsg=[[Message alloc]init];
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
                Message *alertMsg=[[Message alloc]init];
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
        Message *alertMsg=[[Message alloc]init];
        [alertMsg CustomMessage:@"3" MessageNo:@"3"];
        [alertMsg release];
        
        
    }
    else{
        [[[Model singleton]groups] addObject:self.model];
            //message= @"Group created successfully";
        Message *alertMsg=[[Message alloc]init];
        [alertMsg CustomMessage:@"3" MessageNo:@"2"];
        [alertMsg release];
        
    }
     
    [(MulticallAppDelegate *)[[UIApplication sharedApplication] delegate]saveCustomeObject]; //force save
    NSLog(@"self.groups %@",self.model.contacts);
      [self.navigationController popViewControllerAnimated:YES ];
}

@end
