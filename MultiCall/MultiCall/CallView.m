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
        isCallEnded=0;
        isCallEndCalled=0;
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
    [back release];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)enableCalling
{
    if([self.contacts count ]>0)
    {
    
    
    _bottomToolbar.hidden=NO;
        if(![self.twilio_adaptor isCallActive]){
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editMode)] autorelease];
        self.navigationItem.leftBarButtonItem.style=UIBarButtonItemStyleBordered;
        self.navigationItem.leftBarButtonItem.title=@"Cancel";
        }
    }
}
-(void)disableCalling
{
        _bottomToolbar.hidden=YES;
        //[_bottomToolbar removeFromSuperview];
    self.navigationItem.rightBarButtonItem=nil;
    self.navigationItem.leftBarButtonItem.style=UIBarButtonItemStyleBordered;
    self.navigationItem.leftBarButtonItem.title=@"Cancel";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    model=[Model singleton];
    self.statusButtons = [[[NSMutableDictionary alloc]init] autorelease];
    self.formatter=[[[PhoneNumberFormatter alloc]init]autorelease];
    
    if(!isViewMode)
    {
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

}
#define CAN_ENABLE_CALL_BUTTON ([self.contacts count]==0)

-(void)viewWillAppear:(BOOL)animated{
   
    [(UITableView *)self.view setEditing:NO animated:YES];
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
    
        if([self.twilio_adaptor isCallActive])
        self.title=@"Participants";
        else
            self.title=@"Add Participants";
        
    }
    
     [(UITableView *)self.view reloadData];
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
    self.lblCallType.text=@"";
    model.PhoneNumber=nil;
    for (NSInteger i=0; i<[model.callemeon count];i++) {
        CallmeonModel *callmeModel=[model.callemeon objectAtIndex:i];
    if(callmeModel.isSelected ==YES)
    {
        self.lblCallType=(UILabel *)[_callmeonCell viewWithTag:1];
        self.lblCallType.text=callmeModel.CallType;
        model.PhoneNumber=callmeModel.CallPhoneNumber;
    }

    }
    if([model.callemeon count] ==1)
    {

        CallmeonModel *call=[model.callemeon objectAtIndex:0];
        call.isSelected=YES;
        model.PhoneNumber=call.CallPhoneNumber;
        self.lblCallType.text=call.CallType;
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
    [callTime release];
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

    if([model.callemeon count]> 0){
        CallmeonView * callmeonview=[[CallmeonView alloc]init];
        callmeonview.title=@"Call me on";
        [self disableCalling];
        [self.navigationController pushViewController:callmeonview animated:YES];
        [callmeonview release];
    }
    else
    {
        CustomMessageClass *alertmsg=[[CustomMessageClass alloc]init];
        [alertmsg CustomMessage:@"1" MessageNo:@"4"];
        [alertmsg release];
        
        SettingsView * sv=[[SettingsView alloc]init];
        sv.title=@"Settings";
        sv->isUpdateView=YES;
        [self.navigationController pushViewController:sv animated:YES];
        [sv release];
    }
    
}

#pragma TableView

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       UITableViewCell *cell=nil;
    UIView *recentview=[[[UIView alloc]init]autorelease];
    UILabel * lblParticipants=[[[UILabel alloc]init]autorelease];
    UILabel * lblTimeMin=[[[UILabel alloc]init]autorelease];
    UILabel * lblDate=[[[UILabel alloc]init]autorelease];
        
    UILabel *lblName=[[[UILabel alloc]init]autorelease];
    UILabel *lblnumber=[[[UILabel alloc]init]autorelease];
    UILabel * lblContactType=[[[UILabel alloc]init]autorelease];
    
    switch (indexPath.section) {
          
        case 0:
        {
             cell=_buttonviewCelll;
            _buttonviewCelll.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
            
            if(isViewMode)
               {
                                      
                cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"recentView"];
                if(cell == nil) {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"recentView"]autorelease];
                    cell.backgroundView =[[[UIView alloc] initWithFrame:CGRectZero] autorelease];
                   
                    back=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shad_02.png"]];
                   back.frame=CGRectMake(cell.frame.origin.x-10, 0, 320, 65);
                  
                    [cell.contentView addSubview:back];

                   cell.selectionStyle=UITableViewCellSelectionStyleNone;                 
                    
                    recentview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                    recentview.frame=CGRectMake(0, 0, 320, 55);
                    
                    
                    lblParticipants.font=[UIFont fontWithName:@"Helvetica-Bold" size:20.0];
                    lblParticipants.textColor=[UIColor blackColor];
                    lblParticipants.textAlignment=UITextAlignmentLeft;
                    lblParticipants.autoresizingMask=UIViewAutoresizingFlexibleWidth;
                    lblParticipants.lineBreakMode=UILineBreakModeTailTruncation;
                    lblParticipants.frame=CGRectMake(2, 0, 220, 25);
                    
                    lblTimeMin.font=[UIFont fontWithName:@"Helvetica" size:16.0];
                    lblTimeMin.textColor=[UIColor lightGrayColor];
                    lblTimeMin.textAlignment=UITextAlignmentLeft;
                    lblTimeMin.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
                    lblTimeMin.frame=CGRectMake(2, 30, 200, 20);
                    
                    
                    lblDate.font=[UIFont fontWithName:@"Helvetica-Bold" size:20.0];
                    lblDate.textColor=[UIColor blackColor];
                    lblDate.textAlignment=UITextAlignmentRight;
                    lblDate.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
                    lblDate.frame=CGRectMake(180, 4, 120, 20);
                    
                    [cell.contentView addSubview:lblParticipants];
                    [cell.contentView addSubview:lblTimeMin];
                    [cell.contentView addSubview:lblDate];
                    [cell.contentView addSubview:recentview];
                    [back release];
                }
                
                CallModel *callmo=[model.recentsCall objectAtIndex:Recentindexpath];
               
                if(callmo)
                {
                    
                    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init]autorelease];
                    NSDateFormatter *formatter1 = [[[NSDateFormatter alloc] init]autorelease];
                    [formatter setDateFormat:@"dd MMM YYYY"];
                    [formatter1 setDateFormat:@"hh:mm a"];
        
                    lblParticipants.text=[NSString stringWithFormat:@"%i Participants ",[self.contacts count]];
                    lblTimeMin.text=[NSString stringWithFormat:@" %@  %@", [formatter1 stringFromDate:callmo.dateTime],callmo.Callduration];
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
                 cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
            if(cell==nil){
                 cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil]autorelease];
            }
                    cell.backgroundColor=[UIColor whiteColor];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;  
            ContactModel *contact=[self.contacts objectAtIndex:indexPath.row];
                        lblName.frame=CGRectMake(5, 3, 130, 25);
            lblName.font=[UIFont fontWithName:@"Helvetica-Bold" size:16.0];
            lblName.textColor=defaultColor;
            lblName.lineBreakMode=UILineBreakModeTailTruncation;
            
            lblnumber.frame=CGRectMake(5, 34, 180, 15);
            lblnumber.font=[UIFont fontWithName:@"Helvetica" size:15.0];
            lblnumber.textColor=[UIColor blackColor];
            lblnumber.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
            
            lblContactType.frame=CGRectMake(220,8, 70, 20);
            lblContactType.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            lblContactType.textColor=defaultColor;
            lblContactType.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
            
            [cell.contentView addSubview:lblName];
            [cell.contentView addSubview:lblnumber];
            [cell.contentView addSubview:lblContactType];
           
            if(contact)
            {
                lblName.text=contact.name ? :@"unknown";
                lblnumber.text= [self.formatter phonenumberformat:contact.contactInfo withLocale:@"us"];
                if(isCallEnded ==0){
                    
                    lblContactType.text=contact.contactType?:@"Dialed";
                }
                
            }
            
        }
        CallNotifyButton *but=[self.statusButtons objectForKey:[NSString stringWithFormat:@"%d",indexPath.row+1]];
        if([self.twilio_adaptor isCallActive])
        {
           
            CGRect cellframe = cell.frame;
            CGRect rect= CGRectMake(cellframe.size.width - 110, cellframe.origin.y - 5, 110, cellframe.size.height - 10);
            [but setFrame:rect];
            cell.accessoryView = but;
            lblName.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
            lblContactType.text=nil;
            
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
            if([self.twilio_adaptor isCallActive] )
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
            if(![self.twilio_adaptor isCallActive] && isCallEnded ==0)
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
       if(indexPath.section == 1)
       {
           return 45.0;
       }
    else
        return 55.0;
}
-(NSString *)tableView:(UITableViewCell *)tableView titleForHeaderInSection:(NSInteger)section{

    return @"";
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
        self.navigationItem.rightBarButtonItem.style=UIBarButtonItemStyleBordered;
        self.navigationItem.rightBarButtonItem.title=@"Edit";
        self.navigationItem.leftBarButtonItem.style=UIBarButtonItemStyleBordered;
        self.navigationItem.leftBarButtonItem.title=@"Cancel";
    }
    else{
        [((UITableView *)self.view) setEditing:YES animated:YES];
        self.navigationItem.leftBarButtonItem=nil;
        self.navigationItem.rightBarButtonItem.style=UIBarButtonItemStyleDone;
        self.navigationItem.rightBarButtonItem.title=@"Done";
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(MultiCalls)] autorelease];
        
    }
}
-(void)MultiCalls
{
    
    if([self.navigationItem.leftBarButtonItem.title isEqualToString:@"Clear"])
    {

        UILabel *msg=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 320, 40)];
        msg.backgroundColor=[UIColor clearColor];
        msg.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
        msg.textColor=[UIColor whiteColor];
        msg.text=@"Confirm delete of all contacts listed ?";
        
        UIActionSheet *clearSheet=[[UIActionSheet alloc]initWithTitle:@"          " delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        clearSheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        
        
        [clearSheet addSubview:msg];
        [clearSheet showInView:self.view];
        [msg release];
        [clearSheet release];
    }
    else{
    [self dismissModalViewControllerAnimated:YES];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.destructiveButtonIndex == buttonIndex)
    {
        [self.contacts removeAllObjects];
        [self disableCalling];
        [(UITableView *)self.view setEditing:NO animated:YES];
        [(UITableView *)self.view reloadData];
        
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
    self.checkMultiCallArray=nil;
    [super dealloc];
}

-(BOOL)isABAddressBookCreateWithOptionsAvailable {

    return &ABAddressBookCreateWithOptions != NULL;
}
- (IBAction)addContact {
    
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
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    for(NSUInteger i=0 ; i<[self.contacts count]; i++)
    {
        ContactModel *conmodel=[self.contacts objectAtIndex:i];
        if(conmodel.name)
        {
            ABRecordRef person=ABAddressBookGetPersonWithRecordID(addressBook, (ABRecordID)conmodel.personId);
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
    
    callTime = [NSDate date];
    [callTime retain];
    [(UITableView *)self.view setEditing:NO animated:YES];
    [self enableCalling];
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
        if(![[Model singleton] isSettingsPresent])
        {
            CustomMessageClass *alertMsg=[[CustomMessageClass alloc]init];
            [alertMsg CustomMessage:@"1" MessageNo:@"1"];
            [alertMsg release];
                                 
            SettingsView * sview=[[SettingsView alloc]init];
            settingsViewpicker=[[UINavigationController alloc]initWithRootViewController:sview];
            sview ->isUpdateView=YES;
            sview.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(settingsViewPickerDismiss)]autorelease];
            sview.title=@"Settings";
            [self presentModalViewController:settingsViewpicker animated:YES];
       
            [sview release];
            [settingsViewpicker release];     
        }
        else if(![[Model singleton] isPhonenumberPresent])
        {
            
            CustomMessageClass *alertMsg=[[CustomMessageClass alloc]init];
            [alertMsg CustomMessage:@"4" MessageNo:@"6"];
            [alertMsg release];
            
            CallmeonView * sview=[[CallmeonView alloc]init];
            callmeonViewpicker=[[UINavigationController alloc]initWithRootViewController:sview];
            sview.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(CallmeonViewpickerdismiss)]autorelease];
            sview.title=@"Call me on";
            [self presentModalViewController:callmeonViewpicker animated:YES];
            
            [sview release];
            [callmeonViewpicker release];  
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
            
                [self initateMultiCall];
            }
        }
    }
}

-(void)CallmeonViewpickerdismiss
{
    [callmeonViewpicker dismissModalViewControllerAnimated:YES];
}
-(void)settingsViewPickerDismiss
{
    [settingsViewpicker dismissModalViewControllerAnimated:YES];
}
  
-(void)initateMultiCall
{
    
    isCallEnded=1;

    if(callbuttonstatus ==NO){
        
        self.navigationItem.rightBarButtonItem=nil;
        self.navigationItem.leftBarButtonItem=nil;
    self.tabBarController.tabBar.userInteractionEnabled=NO;
    
   
    [self changeButton:@"EndCallButton.png" selector:@selector(btnMakeMultiCall:)];
    
    
    NSMutableArray *numbers=[NSMutableArray array];
    ContactModel *myPhone=[[ContactModel alloc]init];
    myPhone.name=@"Me";
    myPhone.contactType=self.lblCallType.text;
    myPhone.contactInfo=[[Model singleton]PhoneNumber];

        
    [self.contacts insertObject:myPhone atIndex:0];
     
    [myPhone release];
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
    else if(seconds >0)
    {
        
        result = [NSString stringWithFormat:@"%2d seconds", seconds];        
    }
    else{
        result=@"canceled";
    }
    
    
    return result;        
	
    
}
-(void)callEnded

{
    if(isCallEndCalled ==0){
   [self saveModel];
    [self changeButton:@"EndCallButton.png" selector:nil];
    [self performSelector:@selector(cancelCall) withObject:self afterDelay:3.0];
        self.navigationItem.leftBarButtonItem.title=@"Cancel";
    [self performSelector:@selector(endModelviewcontroller) withObject:self afterDelay:2.0];
    }
   
}
-(void)endModelviewcontroller
{
    [self dismissModalViewControllerAnimated:NO];
    
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
        
        [self performSelector:@selector(clearData) withObject:self];
        [self performSelector:@selector(enableCalling) withObject:self afterDelay:2.0];
        
    }
}
-(void)clearData{
    
    [self.statusButtons removeAllObjects];
    
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
isCallEndCalled=1;
        //[((UITableView *)self.view)reloadData];
    
}
-(void)changeButton:(NSString *)imagePath selector:(SEL)selector
{
    if([imagePath isEqualToString:@"EndCallButton.png"])
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

    CallNotifyButton *but = [self.statusButtons objectForKey:number];
    if(but){
        but.callStatus =(int)status;
        
        [but plain];
        [but setTitle:status forState:UIControlStateNormal];
        [but setNeedsDisplay];
       
    }
if([status isEqualToString:@"conference"])
{
     timersecondDate =[[NSDate date] retain];
}
}
/**
 Save data to model
 */
-(void)saveModel
{
    
    if([self.contacts count]>0){
    CallModel *cmodel = [[CallModel alloc] init];
        cmodel.dateTime =callTime;//[NSDate date];
    cmodel.Callduration=[self updateTime];
          
    /* Remove Chairperson to avoid showing in recents list */
    NSMutableArray *array=[NSMutableArray arrayWithArray:self.contacts];
    [array removeObjectAtIndex:0];
    
    
    [cmodel.contacts setArray:array];
   if(!isViewMode)
    [[Model singleton]addRecentscallLog:cmodel];
    
    [(MulticallAppDelegate *)[[UIApplication sharedApplication] delegate]saveCustomeObject];
        [cmodel release];
    }
}
-(void)cePeoplePickerNavigationController:(CEPeoplePickerNavigationController *)peoplePicker didFinishPickingPeople:(NSArray *)peopleArg values:(NSDictionary *)valuesArg
{

    [self.contacts removeAllObjects];
    
    [(UITableView *)self.view reloadSections:[NSIndexSet indexSetWithIndex:CONTACT_SEC_INDEX] withRowAnimation:UITableViewRowAnimationLeft];
    NSMutableDictionary * values=[[NSMutableDictionary alloc]initWithDictionary:valuesArg];
    NSString *value;NSString * phoneType;NSString *name;
    if([valuesArg count])
    {
            for (int i=0; i<[peopleArg count]; i++) {
                ABRecordRef person  =[peopleArg objectAtIndex:i];
                ABRecordID iden = ABRecordGetRecordID(person);
               NSString * key = KEY_FOR_SELECTION(iden);
                 NSMutableArray * dictkeys=[values objectForKey:key];
                name=[dictkeys objectAtIndex:0];
                value = [dictkeys objectAtIndex:1];
                phoneType=[dictkeys objectAtIndex:2];
                
                [self addContactToModel:name contactInfo:[self.formatter phonenumberformat:value withLocale:@"us"] contactType:phoneType personId:[key intValue]];  
                [values removeObjectForKey:key];
            }
        for(id key in [values allKeys])
        {
            NSMutableArray * dictkeys=[values objectForKey:key];
            if([key hasPrefix:@"-"]) // dial number
            {
                value=[NSString stringWithFormat:@"%@",dictkeys];
                name=nil;
                phoneType=nil;
                [self addContactToModel:name contactInfo:[self.formatter phonenumberformat:value withLocale:@"us"] contactType:phoneType personId:[key intValue]];  
                [values removeObjectForKey:key];
            }
        }
    }
    [values release];
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

-(void)addContactToModel:(NSString *)name contactInfo:(NSString *)contactInfo contactType:(NSString *)contactType personId:(int)personId
{
    ContactModel *contact = [[[ContactModel alloc]init]autorelease];
    contact.name = name;
    contact.personId=personId;
    contact.contactInfo = contactInfo;
    contact.contactType=contactType;
               
        if(![self.contacts containsObject:contact])
        {
            [self.contacts addObject:contact];
            
        }
}


-(void)selectedGroup :(GroupModel *)groupmodel //pick group group Screen
{
    if(!self.contacts){
        self.contacts=[[[NSMutableArray alloc]init]autorelease];}
    
    
    GroupsView *gv=[[GroupsView alloc]init];
    if(gv ->isPickMode == YES)
    {
        
       [self.contacts removeAllObjects];
        
    }

   [gv release];
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
-(void)selectedPlaceGroup :(NSMutableArray *)groups //Pick groups from MultiCall Screen.
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
     
    
    if(!self.contacts){
        self.contacts = [[[NSMutableArray alloc]init] autorelease];
    }
    [self.contacts removeAllObjects];
    for(ContactModel * contact in cmodel.contacts)
    {
        if(![self.contacts containsObject:contact])
        {
            [self.contacts addObject:contact];
        }
    }
     [(UITableView *)self.view reloadData];   
}

@end
