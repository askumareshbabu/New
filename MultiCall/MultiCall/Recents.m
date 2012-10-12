//
//  Recents.m
//  MultiCall
//
//  Created by ipod Touch on 25/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Recents.h"
#import "CallView.h"
#import "CallModel.h"
#import "GroupModel.h"
#import "ContactModel.h"
#import "DateTime.h"



#define defaultColor [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0 ];
@interface Recents() 
/**
 Return the corresponding TableViewCell with data from Model
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 Open Meeting screen when you click on row
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

-(NSString*)formatName:(CallModel *)model;

@end 
@implementation Recents
@synthesize recentview=_recentview;
@synthesize lblRecentContacts=_lblRecentContacts;
@synthesize lblParticipants=_lblParticipants;
@synthesize lblDate=_lblDate;
@synthesize starNewView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    model=[Model singleton];
           // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    [super dealloc];
    model=nil;
    
    [_recentview release];
    [_lblRecentContacts release];
    [_lblParticipants release];
    [_lblDate release];
    [starNewView release];
    
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [self.recentsarray removeAllObjects];
//    [super viewWillAppear:YES];
//    [(UITableView *)self.view reloadData];
//}
-(void)viewDidAppear:(BOOL)animated
{
        //[self.recentsarray removeAllObjects];
    self.tabBarController.tabBar.userInteractionEnabled=YES;
    
        [model sort];
    
    [(UITableView *)self.view reloadData];
         int count=[[model recentsCall]count];
   
     UIImageView *imgstartnewview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"start-new.png"]];
   
    if(count == 0){
     self.starNewView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 400)];
    
    
        starNewView.backgroundColor=[UIColor whiteColor];
        
        [imgstartnewview setFrame:CGRectMake(60, 0, 234, 128)];
        [starNewView addSubview:imgstartnewview];
        [self.view addSubview:starNewView];
        [self.starNewView release];
        [imgstartnewview release];
        
        
    }
    else
    {
        [imgstartnewview setHidden:YES];
        [imgstartnewview removeFromSuperview];
        [self.starNewView removeFromSuperview];
    }

    
   self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Start New" style:UIBarButtonItemStyleDone target:self action:@selector(StartNewMutiCall)]autorelease];
    
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(Edit)]autorelease];
    
    if(count > 0)
        self.navigationItem.leftBarButtonItem.enabled=YES;
    else
        self.navigationItem.leftBarButtonItem.enabled=NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
                                            
-(void) StartNewMutiCall
{
    CallView *cview=[[[CallView alloc]init]autorelease];
    startMulticallPicker=[[[UINavigationController alloc]initWithRootViewController:cview]autorelease];
    cview.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"MultiCalls" style:UIBarButtonItemStyleBordered target:self action:@selector(startMulticallPickerdismiss)]autorelease];
    startMulticallPicker.title=@"Add Participants";
    [self presentModalViewController:startMulticallPicker animated:YES];
   
}
-(void)startMulticallPickerdismiss
{
    [startMulticallPicker dismissModalViewControllerAnimated:YES];
}
-(void) Edit
{
    if(((UITableView *)self.view).editing)
    {
        self.navigationItem.leftBarButtonItem.title=@"Edit";
        [(UITableView *)self.view setEditing:NO animated:YES];
    }
    else
    {
        self.navigationItem.leftBarButtonItem.title=@"Done";
        [(UITableView *)self.view setEditing:YES animated:YES];
        
    }
}

#pragma TableView
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
      
    UITableViewCell *cell=nil;
    
      cell= (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Recent"];
        // if(cell == nil) {
        cell=  [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:@"Recent"]autorelease];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.backgroundColor=[[UIColor whiteColor]autorelease];
        

    self.recentview=[[[UIView alloc]init]autorelease];
    self.lblRecentContacts=[[[UILabel alloc]init]autorelease];
    self.lblParticipants=[[[UILabel alloc]init]autorelease];
    self.lblDate=[[[UILabel alloc]init]autorelease];

               
       self.recentview.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        self.recentview.frame=CGRectMake(0, 0, 320, 55);
        
        
       self.lblRecentContacts.font=[UIFont fontWithName:@"Helvetica-Bold" size:16.0];
       self.lblRecentContacts.textColor=[UIColor blackColor];
        self.lblRecentContacts.textAlignment=UITextAlignmentLeft;
        self.lblRecentContacts.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        self.lblRecentContacts.lineBreakMode=UILineBreakModeTailTruncation;
        self.lblRecentContacts.frame=CGRectMake(2, 0, 220, 25);
        
        self.lblParticipants.font=[UIFont fontWithName:@"Helvetica" size:15.0];
        self.lblParticipants.textColor=[UIColor lightGrayColor];
        self.lblParticipants.textAlignment=UITextAlignmentLeft;
        self.lblParticipants.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
        self.lblParticipants.frame=CGRectMake(2, 30, 100, 20);
        
        
        self.lblDate.font=[UIFont fontWithName:@"Helvetica" size:14.0];
        self.lblDate.textColor=[UIColor blueColor];
        self.lblDate.textAlignment=UITextAlignmentRight;
        self.lblDate.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
        self.lblDate.frame=CGRectMake(210, 25, 80, 20);
         
        [cell.contentView addSubview:self.lblRecentContacts];
        [cell.contentView addSubview:self.lblParticipants];
        [cell.contentView addSubview:self.lblDate];
        [cell.contentView addSubview:self.recentview];
       
        
        //}
    CallModel *callmo=[model.recentsCall objectAtIndex:indexPath.row];
    
   if(callmo)
   {
    
       
           self.lblRecentContacts.text=[NSString stringWithFormat:@"%@",[self formatName:callmo]];;
           //cell.textLabel.text=[self formatName:callmo];
      
       [self.lblRecentContacts setNeedsDisplay];
       if(callmo.dateTime)
       {
           self.lblParticipants.text=@"";
           NSDateFormatter *formatter = [[[NSDateFormatter alloc] init]autorelease];
       self.lblParticipants.text=[NSString stringWithFormat:@" %i Participants",[callmo.contacts count]];
          [formatter setDateFormat:@"dd/MM/YYYY"];
               // cell.detailTextLabel.text=[NSString stringWithFormat:@" %i Participants %@",[callmo.contacts count],[formatter stringFromDate:callmo.dateTime]];
           [self.lblParticipants setNeedsDisplay];
        NSDate *yesterday=[[NSDate date] dateByAddingDays:-1];
        NSDate *day2=[[NSDate date] dateByAddingDays:-2];
        NSDate *day3=[[NSDate date] dateByAddingDays:-3];      
        NSDate *day4=[[NSDate date] dateByAddingDays:-4];
        NSDate *day5=[[NSDate date] dateByAddingDays:-5];
        NSDate *day6=[[NSDate date] dateByAddingDays:-6];
        NSDate *day7=[[NSDate date] dateByAddingDays:-7];
       
            
        if([[formatter stringFromDate:callmo.dateTime] isEqualToString:[formatter stringFromDate:yesterday]])
       {
           self.lblDate.text=@"";
           self.lblDate.text=@"Yesterday";
       }
       else if([[formatter stringFromDate:callmo.dateTime] isEqualToString:[formatter stringFromDate:day2]])
       {
             self.lblDate.text=@"";
           [formatter setDateFormat:@"EEEE"]; //get Day Name
           self.lblDate.text=[formatter stringFromDate:callmo.dateTime];
           
       }
       else if([[formatter stringFromDate:callmo.dateTime] isEqualToString:[formatter stringFromDate:day3]])
       {
            self.lblDate.text=@"";
           [formatter setDateFormat:@"EEEE"]; //get Day Name
          self. lblDate.text=[formatter stringFromDate:callmo.dateTime];
           
       }
       else if([[formatter stringFromDate:callmo.dateTime] isEqualToString:[formatter stringFromDate:day4]])
       {
           self.lblDate.text=@"";
           [formatter setDateFormat:@"EEEE"]; //get Day Name
           self.lblDate.text=[formatter stringFromDate:callmo.dateTime];
           
       }
       else if([[formatter stringFromDate:callmo.dateTime] isEqualToString:[formatter stringFromDate:day5]])
       {
           self.lblDate.text=@"";
           [formatter setDateFormat:@"EEEE"]; //get Day Name
           self.lblDate.text=[formatter stringFromDate:callmo.dateTime];
           
       }
       else if([[formatter stringFromDate:callmo.dateTime] isEqualToString:[formatter stringFromDate:day6]])
       {
           self.lblDate.text=@"";
           [formatter setDateFormat:@"EEEE"]; //get Day Name
           self.lblDate.text=[formatter stringFromDate:callmo.dateTime];
           
       }
       else if([[formatter stringFromDate:callmo.dateTime] isEqualToString:[formatter stringFromDate:day7]])
       {
           self.lblDate.text=@"";
            [formatter setDateFormat:@"EEEE"]; //get Day Name
           self.lblDate.text=[formatter stringFromDate:callmo.dateTime];
           
       }
       
       else if([[NSDate date]isSameDayThanDate:callmo.dateTime])
       {
           self.lblDate.text=@"";
           [formatter setDateFormat:@"hh:mm a"];
          self. lblDate.text=[formatter stringFromDate:callmo.dateTime];
       }
       else{
           self.lblDate.text=@"";
                   self.lblDate.text=[formatter stringFromDate:callmo.dateTime];
       }
       }
       [self.lblDate setNeedsDisplay];
   }
    
   
        return cell;
}

-(NSString *)formatName:(CallModel *)modelarg
{
    NSMutableString *strName=[NSMutableString string];
    
    for(ContactModel *mo in modelarg.contacts)
    {
        if(mo.name)
        {
            [strName appendFormat:@"%@ ,",mo.name ];
        }
        else
            [strName appendFormat:@"%@ ,",mo.contactInfo];

        
    }
    [strName deleteCharactersInRange:NSMakeRange([strName length]-2, 2)];
    return strName;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
       return [model.recentsCall count];
}
-(void)tableView :(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CallView *cview=[[[CallView alloc]init]autorelease];
    CallModel * recent_call=[model.recentsCall objectAtIndex:indexPath.row];
    cview.contacts=[NSMutableArray arrayWithArray:recent_call.contacts];
    [cview addRecentsToExplode:recent_call];
    [(UITableView *)cview.view reloadData];
    callviewpicker=[[[UINavigationController alloc]initWithRootViewController:cview]autorelease];
    cview.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"MultiCalls" style:UIBarButtonItemStyleBordered target:self action:@selector(callviewpickerdismiss)]autorelease];
    callviewpicker.title=@"Add Participants";
    [self presentModalViewController:callviewpicker animated:YES];
    
       [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)callviewpickerdismiss
{
    [callviewpicker dismissModalViewControllerAnimated:YES];
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    CallView *call = [[[CallView alloc]init]autorelease];
    CallModel *recent_call =[model.recentsCall objectAtIndex:indexPath.row];
    call.contacts =[NSMutableArray arrayWithArray:recent_call.contacts];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init]autorelease];
    [formatter setDateFormat:@"dd MMM YYYY HH:mm:ss"];
    call.title =@"info"; //[formatter stringFromDate:recent_call.dateTime];
        // call.title=[recent_call.dateTime stringFromDateWithFormat:DATE_TIME];
    call->isViewMode=YES;
    call->Recentindexpath=nil;
    call->Recentindexpath=indexPath;
    call.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"MultiCalls" style:UIBarButtonItemStyleBordered target:self action:@selector(recentviewpickerdismiss)]autorelease];
    recentviewpicker=[[[UINavigationController alloc]initWithRootViewController:call]autorelease];
    [self presentModalViewController:recentviewpicker animated:YES];
    
      [tableView deselectRowAtIndexPath:indexPath animated:YES] ;
}
-(void)recentviewpickerdismiss
{
    [recentviewpicker dismissModalViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [model.recentsCall removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [(MulticallAppDelegate *)[[UIApplication sharedApplication] delegate]saveCustomeObject]; //force save

}

@end
