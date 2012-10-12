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
#import "Twilio_Stub.h"
#import "Recents.h"
#import "SettingsView.h"
#import "DialNumberView.h"
#import <OpenGLES/EAGLDrawable.h>

#define CONTACT_SEC_INDEX 2

#define defaultColor [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0 ];

ABAddressBookRef ab;
@interface CallView()

    - (void)cePeoplePickerNavigationControllerDidCancel:(CEPeoplePickerNavigationController *)peoplePicker;
    - (void)cePeoplePickerNavigationController:(CEPeoplePickerNavigationController *)peoplePicker didFinishPickingPeople:(NSArray*)peopleArg values:(NSDictionary *)valuesArg;

//During call actions
-(void)btnMakeMultiCall:(id)sender;
-(void)initateMultiCall;
-(void)cancelCall;
-(void)clearData;
-(void)callEnded;

@end;

@implementation CallView

@synthesize callmeonCell=_callmeonCell;

@synthesize bottomToolbar = _bottomToolbar;
@synthesize lblCallType=_lblCallType;
@synthesize contacts=_contacts;
@synthesize formatter=_formatter;
@synthesize statusButtons=_statusButtons;
@synthesize twilio_adaptor=_twilio_adaptor;
@synthesize btnAddGroup=_btnAddGroup;
@synthesize btnAddNumber=_btnAddNumber;
@synthesize btnAddContact=_btnAddContact;
@synthesize buttonviewCell=_buttonviewCelll;
@synthesize btnCallButton=_btnCallButton;
@synthesize checkMultiCallArray;

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
    self.statusButtons = [[[NSMutableDictionary alloc]init] autorelease];
    self.formatter=[[[PhoneNumberFormatter alloc]init]autorelease];
    
    if(!isViewMode){
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editMode)] autorelease];
    if(!self.checkMultiCallArray)
        self.checkMultiCallArray=[[[NSMutableArray alloc]init]autorelease];
    if(!self.contacts)
    {
        self.contacts=[[[NSMutableArray alloc]init]autorelease];
        [self disableCalling];
    }
    else
    {
        [self enableCalling];
        
    }
      
    }
    // Do any additional setup after loading the view from its nib.
}
#define CAN_ENABLE_CALL_BUTTON ([self.contacts count]==0)

-(void)viewWillAppear:(BOOL)animated{
        // [self hideButtons];
    if(!isViewMode){
     
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
    
        if([self.twilio_adaptor isCallActive]){
        self.title=@"Participants";
            self.navigationItem.rightBarButtonItem.enabled=NO;}
        else{
            self.title=@"Add Participants";
        }
    }
    
        
}
-(void)viewWillDisappear:(BOOL)animated
{
    if(!isViewMode){
  if(CAN_ENABLE_CALL_BUTTON)
        [self enableCalling];
      else
          [self disableCalling];
    }
}
-(void)loadCallmeon
{
    for (NSInteger i=0; i<[model.callemeon count];i++) {
        CallmeonModel *callmeModel=[model.callemeon objectAtIndex:i];
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
    [self setBtnAddContact:nil];
    [self setBtnAddGroup:nil];
    [self setBtnAddContact:nil];
    [self setBtnAddNumber:nil];
    [self setBtnCallButton:nil];
    [self setButtonviewCell:nil];
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
    UIView *recentview=[[[UIView alloc]init]autorelease];
    UILabel * lblRecentContacts=[[[UILabel alloc]init]autorelease];
    UILabel * lblParticipants=[[[UILabel alloc]init]autorelease];
    UILabel * lblDate=[[[UILabel alloc]init]autorelease];

      UITableViewCell *cell=nil;
    switch (indexPath.section) {
          
        case 0:
        {
             cell=_buttonviewCelll;
            _buttonviewCelll.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
            
            if(isViewMode)
               {
                                      
                cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"recentView"];
                       //if(cell == nil) {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"recentView"]autorelease];
                    cell.backgroundView =[[[UIView alloc] initWithFrame:CGRectZero] autorelease];
                   
                    UIImageView *back=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shad_02.png"]];
                   back.frame=CGRectMake(0, 0, 320, 70);
                  
                    [cell.contentView addSubview:back];
//                    cell.textLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
//                    cell.detailTextLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
//                    cell.backgroundColor=[UIColor whiteColor];
//                    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
//                    cell.textLabel.textColor = [UIColor blackColor];
//                    cell.textLabel.textAlignment=UITextAlignmentLeft;
//                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//                    cell.detailTextLabel.textAlignment=UITextAlignmentRight;
//                    cell.textLabel.numberOfLines=2;
                   cell.selectionStyle=UITableViewCellSelectionStyleNone;                 
                    
                    recentview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                    recentview.frame=CGRectMake(0, 0, 320, 55);
                    
                    
                    lblRecentContacts.font=[UIFont fontWithName:@"Helvetica-Bold" size:20.0];
                    lblRecentContacts.textColor=[UIColor blackColor];
                    lblRecentContacts.textAlignment=UITextAlignmentLeft;
                    lblRecentContacts.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                    lblRecentContacts.lineBreakMode=UILineBreakModeTailTruncation;
                    lblRecentContacts.frame=CGRectMake(2, 0, 220, 25);
                    
                    lblParticipants.font=[UIFont fontWithName:@"Helvetica" size:15.0];
                    lblParticipants.textColor=[UIColor blackColor];
                    lblParticipants.textAlignment=UITextAlignmentLeft;
                    lblParticipants.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
                    lblParticipants.frame=CGRectMake(2, 30, 200, 20);
                    
                    
                    lblDate.font=[UIFont fontWithName:@"Helvetica" size:18.0];
                    lblDate.textColor=[UIColor blackColor];
                    lblDate.textAlignment=UITextAlignmentRight;
                    lblDate.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
                    lblDate.frame=CGRectMake(180, 0, 120, 20);
                    
                    [cell.contentView addSubview:lblRecentContacts];
                    [cell.contentView addSubview:lblParticipants];
                    [cell.contentView addSubview:lblDate];
                    [cell.contentView addSubview:recentview];
                    [back release];
                       //}
                
                CallModel *callmo=[model.recentsCall objectAtIndex:Recentindexpath.row];
               
                if(callmo)
                {
                    
                    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init]autorelease];
                    NSDateFormatter *formatter1 = [[[NSDateFormatter alloc] init]autorelease];
                    [formatter setDateFormat:@"dd MMM YYYY"];
                    [formatter1 setDateFormat:@"hh:mm a"];
                        //  cell.textLabel.text=[NSString stringWithFormat:@"%i Participants \n %@  %@",[self.contacts count],[formatter1 stringFromDate:callmo.dateTime],callmo.Callduration?:@""];
                        //  cell.detailTextLabel.text=[formatter stringFromDate:callmo.dateTime];
                    lblRecentContacts.text=[NSString stringWithFormat:@"%i Participants ",[self.contacts count]];
                    lblParticipants.text=[NSString stringWithFormat:@" %@  %@", [formatter1 stringFromDate:callmo.dateTime],callmo.Callduration];
                    lblDate.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:callmo.dateTime]];
                    
                }
            }
                 
                    break;
            
        }
        case 1:{
            cell =_callmeonCell;
            self.tabBarController.tabBar.userInteractionEnabled=YES;
            break;
        }
        case CONTACT_SEC_INDEX:{
            cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"callView"];
            if(cell == nil) {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"callView"]autorelease];
                cell.textLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
                cell.detailTextLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
                cell.backgroundColor=[UIColor whiteColor];
                cell.detailTextLabel.textColor = defaultColor;
                cell.textLabel.textAlignment=UITextAlignmentLeft;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.detailTextLabel.textAlignment=UITextAlignmentRight;
            }
            ContactModel *contact=[self.contacts objectAtIndex:indexPath.row];
            
                //NSLog(@"self.contacts %@",self.contacts);
            if(contact)
            {
               
                cell.textLabel.text=contact.name ?:[self.formatter phonenumberformat:contact.contactInfo withLocale:@"us"];                 
                cell.detailTextLabel.text=contact.contactType ?:@"unknown";
                
                
                
            }
        }
        CallNotifyButton *but=[self.statusButtons objectForKey:[NSString stringWithFormat:@"%d",indexPath.row+1]];
        if([self.twilio_adaptor isCallActive])
        {
                CGRect cellframe = cell.frame;
                CGRect rect= CGRectMake(cellframe.size.width - 130, cellframe.origin.y - 10, 130, cellframe.size.height - 10);
                [but setFrame:rect];
                cell.accessoryView = but;
                cell.detailTextLabel.text=nil;
            
            
        }
        else{
            if(!isViewMode){
                if(!but)
                    cell.accessoryView=nil;
            }
        }

    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:{
            if([self.twilio_adaptor isCallActive])
                return 0;
            else
                return 1;
        }
        case 1:{
            if([self.twilio_adaptor isCallActive] || isViewMode)
                return 0;
            else
                return 1;
        }
        case CONTACT_SEC_INDEX:
            NSLog(@"self.contacts count %@",self.contacts);
            return [self.contacts count];
        default:
            return 0;
    }
    
}
-(void)tableView :(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isViewMode)
    {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    if(indexPath.section ==1)
    {
       
            [self pushToCallMeOn];
        
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}
/* disable Tableview cell remove button on Recents View List */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(!isViewMode)
    {
        if(indexPath.section ==2){
            if(![self.twilio_adaptor isCallActive])
                return UITableViewCellEditingStyleDelete;
                else
            return UITableViewCellEditingStyleNone;
        }
        else
            return UITableViewCellEditingStyleNone;
    }
    else {
        return UITableViewCellEditingStyleNone;
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==2)
        return YES;
    else
        return NO;
}
-(NSInteger)numberOfSectionsInTableView :(UITableView *)tableView
{
    
        return 3;
}
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
       if(indexPath.section == 0)
       {
           return 65.0;
       }
    else
        return 45.0;
}
-(NSString *)tableView:(UITableViewCell *)tableView titleForHeaderInSection:(NSInteger)section{

    return @"";
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
     
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == CONTACT_SEC_INDEX){
    [self.contacts removeObjectAtIndex:indexPath.row];
    
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:CONTACT_SEC_INDEX]] withRowAnimation:UITableViewRowAnimationFade];
        if(!self.contacts)
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:CONTACT_SEC_INDEX] withRowAnimation:UITableViewRowAnimationFade];
    
    }
    if(CAN_ENABLE_CALL_BUTTON)
    {
        [self editMode];
        [self disableCalling];
    }
}
-(void)editMode
{
    if(((UITableView *)self.view).editing)
    {
        [((UITableView *)self.view) setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItem.title=@"Edit";
    }
    else{
        [((UITableView *)self.view) setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItem.title=@"Done";
    }
}
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
    self.twilio_adaptor=nil;
    [_btnAddGroup release];
    [_btnAddContact release];
    [_btnAddNumber release];
    [_btnCallButton release];
    [_buttonviewCelll release];
    Recentindexpath=nil;
    self.checkMultiCallArray=nil;
    [super dealloc];
}
- (IBAction)addContact {
    
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
     ab=ABAddressBookCreate();
    
    for(NSUInteger i=0 ; i<[self.contacts count]; i++)
    {
        ContactModel *conmodel=[self.contacts objectAtIndex:i];
        if(conmodel.name)
        {
            ABRecordRef person=ABAddressBookGetPersonWithRecordID(ab, (ABRecordID)conmodel.personId);
            if(person)
            {
                ABRecordID iden=ABRecordGetRecordID(person);
                NSMutableArray *arr=[NSMutableArray arrayWithObjects:conmodel.name,conmodel.contactInfo,conmodel.contactType, nil];
                [dict setObject:arr forKey:KEY_FOR_SELECTION(iden)];
                person=nil;
            }

        }
        else
        {
            NSMutableArray *arr=[NSMutableArray arrayWithObjects:conmodel.contactInfo,nil, nil];
            [dict setObject:arr forKey:KEY_FOR_SELECTION(conmodel.personId)];
        }
    }
    NSLog(@"add contact clicked dfd sdfasdf%@",self.contacts);
       
    CEPeoplePickerNavigationController *picker=[[CEPeoplePickerNavigationController alloc]initWithValues:dict];
    picker.peoplePickerDelegate=self;
    [self presentModalViewController:picker animated:YES];
    [picker release];
    [dict release];
    
    
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
    gview.title=@"Groups";
    [self presentModalViewController:groupContactPicker animated:YES];
    [gview release];
    [groupContactPicker release];
}

- (IBAction)addDialNumber {

        //PhoneViewController *dialNumber=[[PhoneViewController alloc]init];
    DialNumberView *dialNumber=[[DialNumberView alloc]init];
    dialNumber.delegate=self;
    dialNUmberpicker=[[UINavigationController alloc]initWithRootViewController:dialNumber];
    dialNumber.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(canceldialerPicker)]autorelease];
    
    dialNumber.title=@"Add Number";
    [self presentModalViewController:dialNUmberpicker animated:YES];
    [dialNumber release];
    [dialNUmberpicker release];
    
}

- (void)btnMakeMultiCall:(id)sender {
    self.title =@"Participants";
    if([self.twilio_adaptor isCallActive])
    {
        NSMutableArray *numbers=[NSMutableArray array];
        int squenceNumber=0;
        for(ContactModel *cm in self.contacts)
        {
            squenceNumber ++;
            [numbers addObject:[NSString stringWithFormat:@"%i",squenceNumber]];
        }
        [self.twilio_adaptor disconnectAll:numbers];
    }
    else
    {
        
        if(![[Model singleton] isCallemeonpresent])
        {
            CustomMessageClass *alertMsg=[[CustomMessageClass alloc]init];
            [alertMsg CustomMessage:@"1" MessageNo:@"4"];
            [alertMsg release];
            
            
            CallmeonView * callmeonview=[[CallmeonView alloc]init];
            callmeonview ->isEditMode=YES;
            callmeonViewpicker=[[UINavigationController alloc]initWithRootViewController:callmeonview];
            callmeonview.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Participants" style:UIBarButtonItemStyleBordered target:self action:@selector(CallmeonViewpickerdismiss)]autorelease];
            callmeonview.title=@"Call me on";
            [self presentModalViewController:callmeonViewpicker animated:YES];
            
            [callmeonview release];
            [callmeonViewpicker release];     
        }
        
        
        
        else if(![[Model singleton] isSettingsPresent])
        {
            CustomMessageClass *alertMsg=[[CustomMessageClass alloc]init];
            [alertMsg CustomMessage:@"1" MessageNo:@"1"];
            [alertMsg release];
                                 
            SettingsView * sview=[[SettingsView alloc]init];
            settingsViewpicker=[[UINavigationController alloc]initWithRootViewController:sview];
            sview ->isUpdateView=YES;
            sview.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"MultiCalls" style:UIBarButtonItemStyleBordered target:self action:@selector(callviewpickerdismiss)]autorelease];
            sview.title=@"Settings";
            [self presentModalViewController:settingsViewpicker animated:YES];
       
            [sview release];
            [settingsViewpicker release];     
        }
        else
        {
            if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable )
            {
                
                CustomMessageClass *alertMsg=[[CustomMessageClass alloc]init];
                [alertMsg CustomMessage:@"1" MessageNo:@"3"];
                [alertMsg release];
            }
            else
            {
            timersecondDate =[[NSDate date] retain];
            
                // durationTimer=[NSTimer scheduledTimerWithTimeInterval:1.0/10.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
                [self initateMultiCall];
            }
        }
    }
}
-(void)callviewpickerdismiss
{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)CallmeonViewpickerdismiss
{
    [callmeonViewpicker dismissModalViewControllerAnimated:YES];
}
  
    
-(void)initateMultiCall
{
    
    if(callbuttonstatus ==NO){
    self.navigationItem.rightBarButtonItem=nil;
    self.navigationItem.leftBarButtonItem=nil;
    
    
    self.tabBarController.tabBar.userInteractionEnabled=NO;
    
   
    [self changeButton:@"red.png" selector:@selector(btnMakeMultiCall:)];
    
    
    NSMutableArray *numbers=[NSMutableArray array];
    ContactModel *myPhone=[[ContactModel alloc]init];
    myPhone.name=@"Me";
    myPhone.contactType=self.lblCallType.text;
    myPhone.contactInfo=[[Model singleton]PhoneNumber];

    
    
    
    [self.contacts insertObject:myPhone atIndex:0];
            //[self saveModel];
    [myPhone release];
    NSLog(@"self.contacts insert %@",self.contacts);
    int i=1;
    for(ContactModel *contact in self.contacts)
    {        
        CallNotifyButton *but=[[CallNotifyButton alloc]init];
        but.tag=10;
        [but plain];
        [but setTitle:@"connecting.." forState:UIControlStateNormal];
        [self.statusButtons setObject:but forKey:[NSString stringWithFormat:@"%i",i++]];
        [numbers addObject:contact];
        [but release];
    }
    
    self.twilio_adaptor=nil; //ensure release of the object
    self.twilio_adaptor = [[[Twilio_Stub alloc]initWithDelegate:self] autorelease];
    [self.twilio_adaptor makeCalls:numbers];
    
        //change the cells to reflect to connecting
    [((UITableView *)self.view) reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] withRowAnimation:UITableViewRowAnimationFade];
    }
}
    // Updates the OpenGL view when the timer fires
- (NSString *) updateTime {
    
    NSInteger secondsSinceStart = (NSInteger)[[NSDate date] timeIntervalSinceDate:timersecondDate]; 
    
    int seconds = secondsSinceStart % 60;
    int  minutes = (secondsSinceStart / 60) % 60;
    int  hours = secondsSinceStart / (60 * 60);
    NSString *result = nil;
    
    if (hours > 0) 
    {
        result = [NSString stringWithFormat:@"%2d hours", hours];
    }
    else if(minutes > 0)
    {
        result = [NSString stringWithFormat:@"%2d minutes", minutes];  
    }
    else 
    {
        result = [NSString stringWithFormat:@"%2d seconds", seconds];        
    }
    
    
    return result;        
	
    
}
-(void)callEnded

{

        [self saveModel];
   
    [self changeButton:@"red.png" selector:nil];
    [self performSelector:@selector(cancelCall) withObject:self afterDelay:3.0];
    
//    Recents *rec=[[[Recents alloc]init]autorelease];
//    rec->isStarNewView=YES;
//    [(UITableView *)rec.view reloadData];
   
    self.navigationItem.leftBarButtonItem.title=@"MultiCalls";
    [self.tabBarController setSelectedIndex:1];
    [self performSelector:@selector(endModelviewcontroller) withObject:self afterDelay:3.0];
    
    

}
-(void)endModelviewcontroller
{
    
    [self dismissModalViewControllerAnimated:YES];
    
        
}
-(void)cancelCall
{
    if(self.twilio_adaptor.isErrorOccured==NO)
    {
        [self performSelector:@selector(clearData) withObject:self afterDelay:2.0];
        
        [self performSelector:@selector(disableCalling) withObject:self afterDelay:2.0];
    }
    else
    {
            //[self changeButton:@"Green_but_w_txt.png" selector:@selector(btnMakeMultiCall:)];
        [self performSelector:@selector(clearData) withObject:self];
        [self performSelector:@selector(enableCalling) withObject:self afterDelay:2.0];
        
    }
}
-(void)clearData{
    
    [self.statusButtons removeAllObjects];
//    if([self.contacts count]> 0)
//        [self.contacts removeAllObjects];
    
    if(self.twilio_adaptor.isErrorOccured ==NO)
    {
        if([self.contacts count]>0)
            [self.contacts removeAllObjects];
    
    }
    else
    {
            //remove chairperson only.
        
        if([self.contacts count] >0)
        {
            ContactModel *cmodel = [self.contacts objectAtIndex:0];
            if(cmodel.personId ==0)
            {
                [self.contacts removeObjectAtIndex:0];
            }
        }
        
    }
        //  [((UITableView *)self.view)reloadData];
    
}
-(void)changeButton:(NSString *)imagePath selector:(SEL)selector
{
    if([imagePath isEqualToString:@"red.png"])
        callbuttonstatus=YES;
    else
        callbuttonstatus=NO;
    
    [self.btnCallButton setImage:[UIImage imageNamed:imagePath] forState:UIControlStateNormal];
   
}
-(BOOL)isMultiCallActive
{
    return [self.twilio_adaptor isCallActive];
}
-(void)statusForCall:(NSString *)number status:(NSString *)status
{
    
    NSLog(@"status number %@",number);

    CallNotifyButton *but = [self.statusButtons objectForKey:number];
        // NSIndexPath *  indexpath=[(UITableView *)self.view indexPathForCell:(UITableViewCell *)number];
        // UITableViewCell * thisCell=[(UITableView *)self.view cellForRowAtIndexPath:indexpath];
    if(but){
        but.callStatus =(int)status;
        
        [but plain];
        [but setTitle:status forState:UIControlStateNormal];
        [but setNeedsDisplay];
        NSLog(@" CallNotifyButton Call Status %@",status);
       
    }

}
/**
 Save data to model
 */
-(void)saveModel
{
    CallModel *cmodel = [[CallModel alloc] init];
    cmodel.dateTime = [NSDate date];
    cmodel.Callduration=[self updateTime];
        // NSLog(@"timer result %@",cmodel.Callduration);
    
    NSLog(@"self.contact save n%@",self.contacts);
    /* Remove Chairperson to avoid showing in recents list */
    NSMutableArray *array=[NSMutableArray arrayWithArray:self.contacts];
    [array removeObjectAtIndex:0];
    
    
    [cmodel.contacts setArray:array];
   if(!isViewMode)
    [[Model singleton]addRecentscallLog:cmodel];
    
    [(MulticallAppDelegate *)[[UIApplication sharedApplication] delegate]saveCustomeObject];
        [cmodel release];
}
-(void)cePeoplePickerNavigationController:(CEPeoplePickerNavigationController *)peoplePicker didFinishPickingPeople:(NSArray *)peopleArg values:(NSDictionary *)valuesArg
{

    [self.contacts removeAllObjects];
    
    [(UITableView *)self.view reloadSections:[NSIndexSet indexSetWithIndex:CONTACT_SEC_INDEX] withRowAnimation:UITableViewRowAnimationLeft];

    if([valuesArg count])
    {
        NSMutableDictionary * values=[[NSMutableDictionary alloc]initWithDictionary:valuesArg];
        
        NSString *value;NSString * phoneType;NSString *name;
        for(id key in [values allKeys])
        {
       
        NSMutableArray * dictkeys=[values objectForKey:key];
        
        if([key hasPrefix:@"-"]) // dial number
        {
            value=[NSString stringWithFormat:@"%@",dictkeys];
            name=nil;
             phoneType=nil;
                // [values removeObjectForKey:key];
           
        }
        else{
        name=[dictkeys objectAtIndex:0];
        value=[dictkeys objectAtIndex:1];
        phoneType=[dictkeys objectAtIndex:2];
                //[values removeObjectForKey:key];
        }
            
           [self addContactToModel:name contactInfo:[self.formatter phonenumberformat:value withLocale:@"us"] contactType:phoneType personId:[key intValue]];  
    }
        [values release];
    }
    [peoplePicker dismissModalViewControllerAnimated:YES];
    [(UITableView *)self.view reloadSections:[NSIndexSet indexSetWithIndex:CONTACT_SEC_INDEX] withRowAnimation:
     UITableViewRowAnimationLeft];
    
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
    CFStringRef firstName=NULL, lastName=NULL;
    NSString *trimmedName=nil;
    firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    lastName  = ABRecordCopyValue(person, kABPersonLastNameProperty)   ;
    ABRecordID iden = ABRecordGetRecordID(person);
    trimmedName=[NSString stringWithFormat:@"%@ %@",firstName?:(CFStringRef)@"",lastName?:(CFStringRef)@""];
    trimmedName = [trimmedName stringByTrimmingCharactersInSet:
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
        //if(![self.checkMultiCallArray containsObject:[NSString stringWithFormat:@"%@",contact.contactInfo]])
    NSLog(@"contactinfo %@",contactInfo);
       

        //NSLog(@"lll lkjdslkfasdjfl %@",self.checkMultiCallArray);
    //    //check for nulls and also say user if somthing is invalid
   
//    if([self.contacts containsObject:contact])
//    {
//        NSLog(@"before remove contact %@",self.contacts);
//        [self.contacts removeObject:contact];
//        NSLog(@"after remove contact %@",self.contacts);
//    }
    if(![self.contacts containsObject:contact])
    {
          NSLog(@"before add contact %@",self.contacts);
        [self.contacts addObject:contact];
         NSLog(@"after add contactsdfsdf %@",self.contacts);
    }
        //[self.checkMultiCallArray addObject:contactInfo];
}
-(void)selectedGroup :(GroupModel *)groupmodel
{
    if(!self.contacts){
        self.contacts=[[[NSMutableArray alloc]init]autorelease];}
    
    
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
    
    [gv release];
    [(UITableView *)self.view reloadData];
}
-(void)selectedPlaceGroup :(NSMutableArray *)groups
{
    if(!self.contacts){
        self.contacts=[[[NSMutableArray alloc]init]autorelease];}

    for(ContactModel *cMode in groups)
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
    NSLog(@"dianumber adding %@",dialnumbers);
    if(!self.contacts){
        self.contacts=[[[NSMutableArray alloc]init]autorelease];}

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
-(void)addRecentsToExplode:(CallModel*)cmodel
{
     
    [self.contacts removeAllObjects];
    if(!self.contacts){
        self.contacts = [[[NSMutableArray alloc]init] autorelease];
    }
    
    for(ContactModel * contact in cmodel.contacts)
    {
        if(![self.contacts containsObject:contact])
        {
            [self.contacts addObject:contact];
        }
    }
       
}

@end
