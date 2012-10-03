//
//  CallView.m
//  MultiCall
//
//  Created by ipod Touch on 25/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CallView.h"
#import "CallmeonView.h"
#import "CallmeonModel.h"
#import "ContactModel.h"
#import "CallModel.h"
#import "GroupModel.h"
#import "PhoneViewController.h"
#import "GroupsView.h"
#import "DialNumberModel.h"
#import "PhoneNumberFormatter.h"

#define CONTACT_SEC_INDEX 1
#define GROUP_SEC_INDEX 2
#define defaultColor [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0 ];
@interface CallView()

    - (void)cePeoplePickerNavigationControllerDidCancel:(CEPeoplePickerNavigationController *)peoplePicker;
    - (void)cePeoplePickerNavigationController:(CEPeoplePickerNavigationController *)peoplePicker didFinishPickingPeople:(NSArray*)peopleArg values:(NSDictionary *)valuesArg;


    @end;

@implementation CallView

@synthesize callmeonCell=_callmeonCell;

@synthesize bottomToolbar = _bottomToolbar;
@synthesize lblCallType=_lblCallType;
@synthesize contacts=_contacts;
@synthesize groups;
@synthesize formatter=_formatter;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    isViewMode=NO;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)enableCalling
{
    _bottomToolbar.hidden=NO;
}
-(void)disableCalling
{
    _bottomToolbar.hidden=YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    model=[Model singleton];
    self.formatter=[[PhoneNumberFormatter alloc]init];
         
    
    if(!self.contacts)
    {
        self.contacts=[[NSMutableArray alloc]init];
    [self disableCalling];
    }
    else
    {
        [self enableCalling];
        
    }
    
     
    // Do any additional setup after loading the view from its nib.
}
#define CAN_ENABLE_CALL_BUTTON ([self.contacts count]==0)

-(void)viewWillAppear:(BOOL)animated{
     self.title=@"Add Participants";
    [self loadCallmeon];
    if([self.contacts count])
    {
        
    int y= self.navigationController.view.frame.size.height - 55.0;
    [_bottomToolbar setFrame:CGRectMake(0, y, _bottomToolbar.frame.size.width,  55.0)];
    [self.navigationController.view addSubview:_bottomToolbar];
        [self enableCalling];
    }
    else
        [self disableCalling];

}
-(void)viewWillDisappear:(BOOL)animated
{
    
  if(CAN_ENABLE_CALL_BUTTON)
        [self enableCalling];
      else
          [self disableCalling];
  
}
-(void)loadCallmeon
{
    for (NSInteger i=0; i<[model.callemeon count];i++) {
        CallmeonModel *callmeModel=[model.callemeon objectAtIndex:i];
            // NSLog(@"ca %@",callmeModel);
    if(callmeModel.isSelected ==YES)
    {
        self.lblCallType=(UILabel *)[_callmeonCell viewWithTag:1];
        if(self.lblCallType.tag ==1)
        {
            self.lblCallType.text=callmeModel.CallType;
        }
        break;
    }
    else{
        self.lblCallType.text=@"";
    }
    }
}
- (void)viewDidUnload
{
   
    [self setCallmeonCell:nil];
    [self setBottomToolbar:nil];
    self.formatter =nil;
    [super viewDidUnload];
    [_bottomToolbar removeFromSuperview];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)pushToCallMeOn
{
    CallmeonView *callmeon=[[CallmeonView alloc]init];
    self.title=@"Participants";
    
    [self.navigationController pushViewController:callmeon animated:YES];
   
    callmeon.title=@"Call me on";
    [callmeon release];
}

#pragma TableView

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                    case 0:
                    cell =_callmeonCell;
                    break;

                default:
                    break;
            }
            
            break;
        }
        case CONTACT_SEC_INDEX:{
            cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"contact"];
            if(cell == nil) {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"contact"]autorelease];
                cell.textLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
                cell.detailTextLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
                cell.backgroundColor=[UIColor whiteColor];
                cell.detailTextLabel.textColor = defaultColor;
                cell.textLabel.textAlignment=UITextAlignmentLeft;
                cell.detailTextLabel.textAlignment=UITextAlignmentRight;
            }
            ContactModel *contact=[self.contacts objectAtIndex:indexPath.row];
            
            NSLog(@"self.contacts %@",self.contacts);
            if(contact)
            {
               
                cell.textLabel.text=contact.name ?:[self.formatter phonenumberformat:contact.contactInfo withLocale:@"us"];                 
                cell.detailTextLabel.text=contact.contactType ?:@"unknown";
                
                
            }
        }
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return 1;
            
        case CONTACT_SEC_INDEX:
            return [self.contacts count];
        default:
            return 1;
    }
    
}
-(void)tableView :(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isViewMode)
    {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    if(indexPath.section ==0)
    {
        if(indexPath.row==0)
        {
            [self pushToCallMeOn];
        }
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}
-(NSInteger)numberOfSectionsInTableView :(UITableView *)tableView
{
    return 2;
}
-(NSString *)tableView:(UITableViewCell *)tableView titleForHeaderInSection:(NSInteger)section{

    return @"";
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
     
}
//-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 55.0;
//}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}
- (void)dealloc {
    
    [_callmeonCell release];
   
    [_bottomToolbar release];
    model=nil;
    self.lblCallType=nil;
    self.contacts=nil;
    [super dealloc];
}
- (IBAction)addContact {
    
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    ABAddressBookRef  ab=ABAddressBookCreate();
    
    
    for(ContactModel *conmodel in self.contacts)
    {
        if(conmodel.name)
        {
            ABRecordRef person=ABAddressBookGetPersonWithRecordID(ab, (ABRecordID)conmodel.personId);
            if(person)
            {
                    ABRecordID iden=ABRecordGetRecordID(person);
                NSMutableArray *arr=[NSMutableArray arrayWithObjects:conmodel.contactInfo,conmodel.contactType, nil];
                [dict setObject:arr forKey:KEY_FOR_SELECTION(iden)];
                
                    CFRelease(person);
            }
        }
        else{
                //add Dial Number
        }
    }
   
    CEPeoplePickerNavigationController *picker=[[CEPeoplePickerNavigationController alloc]initWithValues:dict];
    picker.peoplePickerDelegate=self;
    [self presentModalViewController:picker animated:YES];
    [picker release];
    
    
}
-(void)cancelGroupPicker
{
    [groupContactPicker dismissModalViewControllerAnimated:YES];
}
-(void)canceldialerPicker
{
    [dialNUmberpicker dismissModalViewControllerAnimated:YES];
}
- (IBAction)addGroup {
    
    GroupsView *gview=[[GroupsView alloc]init];
    gview ->isPickMode=YES;
    gview.delegate=self;
    groupContactPicker=[[UINavigationController alloc]initWithRootViewController:gview];
    gview.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelGroupPicker)]autorelease];
    groupContactPicker.title=@"Groups";
    [self presentModalViewController:groupContactPicker animated:YES];
    [gview release];
    [groupContactPicker release];
}

- (IBAction)addDialNumber {

    PhoneViewController *dialNumber=[[PhoneViewController alloc]init];
   
    dialNumber.delegate=self;
    dialNUmberpicker=[[UINavigationController alloc]initWithRootViewController:dialNumber];
    dialNumber.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(canceldialerPicker)]autorelease];
    dialNUmberpicker.title=@"Add Number";
    [self presentModalViewController:dialNUmberpicker animated:YES];
    [dialNumber release];
    [dialNUmberpicker release];
}
-(void)cePeoplePickerNavigationController:(CEPeoplePickerNavigationController *)peoplePicker didFinishPickingPeople:(NSArray *)peopleArg values:(NSDictionary *)valuesArg
{

    [self.contacts removeAllObjects];
    [(UITableView *)self.view reloadSections:[NSIndexSet indexSetWithIndex:CONTACT_SEC_INDEX] withRowAnimation:UITableViewRowAnimationLeft];
   
    NSArray *people=peopleArg;
    
    NSLog(@"people array %@",people);
     
    if([people count])
    {
        NSMutableDictionary * values=[[NSMutableDictionary alloc]initWithDictionary:valuesArg];
        NSLog(@"value array %@",values);
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
            [self modifyContact:person property:kABPersonPhoneProperty value:[self.formatter phonenumberformat:value withLocale:@"us"] phoneType:phoneType];
            [values removeObjectForKey:key];
        }
    //add Dial Number here
    }
    [peoplePicker dismissModalViewControllerAnimated:YES];
    [(UITableView *)self.view reloadSections:[NSIndexSet indexSetWithIndex:CONTACT_SEC_INDEX] withRowAnimation:UITableViewRowAnimationLeft];
}
-(void)cePeoplePickerNavigationControllerDidCancel:(CEPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
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
    
}
-(void)addContactToModel:(NSString *)name contactInfo:(NSString *)contactInfo contactType:(NSString *)contactType personId:(int)personId
{
    ContactModel *contact = [[ContactModel alloc]init];
    contact.name = name;
    contact.personId=personId;
    contact.contactInfo = contactInfo;
    contact.contactType=contactType;
   
    //    //check for nulls and also say user if somthing is invalid
    if([self.contacts containsObject:contact])
    {
        [self.contacts removeObject:contact];
        
    }
    if(![self.contacts containsObject:contact])
    {
        [self.contacts addObject:contact];
       
    }
     [contact release];
}
-(void)selectedGroup :(GroupModel *)groupmodel
{
    if(!self.contacts){
        self.contacts=[[NSMutableArray alloc]init];}
    GroupsView *gv=[[GroupsView alloc]init];
    if(gv ->isPickMode == YES)
    {
        [self.contacts removeAllObjects];
    }
    for(ContactModel *cMode in groupmodel.contacts)
    {
        if([self.contacts containsObject:cMode])
        {
            [self.contacts removeObject:cMode];
        }
        
        if(![self.contacts containsObject:cMode])
        {
            
            [self.contacts addObject:cMode];
            
        }
    }
    [(UITableView *)self.view reloadData];
}
-(void)dialnumberarray:(NSMutableArray *)dialnumbers
{
    NSLog(@"dialnumbers %@",dialnumbers);
    if(!self.contacts){
        self.contacts=[[NSMutableArray alloc]init];}
    
    for (int i=0; i<[self.contacts count]; i++) {
        ContactModel *cmo=[self.contacts objectAtIndex:i];
        NSString *sid=[NSString stringWithFormat:@"%i",cmo.personId];
        NSLog(@"sid %@",sid);
        if([sid hasPrefix:@"-"])
            [self.contacts removeObjectAtIndex:i];
    }
       for(ContactModel *cMode in dialnumbers)
    {
        if([self.contacts containsObject:cMode])
        {
            [self.contacts removeObject:cMode];
        }
        
        if(![self.contacts containsObject:cMode])
        {
            
            [self.contacts addObject:cMode];
            
    }
    
    }
            
    
    [(UITableView *)self.view reloadData];
}

@end
