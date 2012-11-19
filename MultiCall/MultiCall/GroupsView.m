//
//  GroupsView.m
//  MultiCall
//
//  Created by ipod Touch on 25/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GroupsView.h"
#import "NewGroupView.h"
#import "GroupModel.h"
#import "Model.h"
#import "ContactModel.h"
#import "CallView.h"

#define defaultColor [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0 ];

@implementation GroupsView
@synthesize delegate=_delegate;
@synthesize deleteIndexPath;
@synthesize groupindex;
@synthesize groupNameArray;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         isPickMode=NO;
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
     model = [Model singleton];
   
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    model=nil;
    _delegate=nil;
    
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc
{
    [groupNameArray release];
    [groupindex release];
    [super dealloc];
}
-(void)loadGroupIndex
{
    if(!isPickMode){
        if([model.groups count] >0){
        if(!((UITableView *)self.view).editing){
          self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editGroup)]autorelease];
        }
        }
    else{
        
        self.navigationItem.leftBarButtonItem=nil;
        self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"New Group" style:UIBarButtonItemStyleDone target:self action:@selector(addGroup)]autorelease];
            
    }
    }
    
    [model sortGroups];
    
    groupindex=[[NSMutableArray alloc]init];
    groupNameArray=[[NSMutableArray alloc]init];
    
    for(int i=0; i<[model.groups count];i++)
    {
        groupModel=[[model groups]objectAtIndex:i];
        
        [groupNameArray addObject:groupModel.groupName];
        
        char alphabet=[[groupNameArray objectAtIndex:i]characterAtIndex:0];
        
        NSString * unichar=[NSString stringWithFormat:@"%c",alphabet];
        
        if(![groupindex containsObject:unichar])
        {
            [groupindex addObject:unichar];
        }
        
    }
    
    
    [(UITableView *)self.view reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [(UITableView *)self.view setEditing:NO animated:YES];
    if(!isPickMode){
        
        self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"New Group" style:UIBarButtonItemStyleDone target:self action:@selector(addGroup)]autorelease];
      
    }
    [self loadGroupIndex];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)addGroup
{
    if([self.navigationItem.rightBarButtonItem.title isEqualToString:@"Clear"])
    {
        UILabel *msg=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 320, 40)];
        msg.backgroundColor=[UIColor clearColor];
        msg.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
        msg.textColor=[UIColor whiteColor];
        msg.text=@"Confirm delete of all Groups listed ?";
        
        UIActionSheet *clearSheet=[[UIActionSheet alloc]initWithTitle:@"          " delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        clearSheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        
        [clearSheet addSubview:msg];
        [clearSheet showInView:self.tabBarController.view];
        [msg release];
        [clearSheet release];
    }
    else{
    NewGroupView * newgroup=[[NewGroupView alloc]init];
    [self.navigationController pushViewController:newgroup animated:YES];
    [newgroup release];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.destructiveButtonIndex == buttonIndex)
    {
        [model.groups removeAllObjects];
        [(UITableView *)self.view setEditing:NO animated:YES];
        self.navigationItem.leftBarButtonItem.style=UIBarButtonItemStyleBordered;
        self.navigationItem.leftBarButtonItem.title=@"Edit";
        self.navigationItem.rightBarButtonItem.title=@"New Group";
        self.navigationItem.rightBarButtonItem.style=UIBarButtonItemStyleDone;
        [self loadGroupIndex];
        
        [(MulticallAppDelegate *)[[UIApplication sharedApplication] delegate]saveCustomeObject]; //force save
    }
}
-(void)editGroup
{
    if([model.groups count]>0){
    if(((UITableView *)self.view).editing)
    {
        [((UITableView*)self.view) setEditing: NO animated: YES];
        self.navigationItem.leftBarButtonItem.style=UIBarButtonItemStyleBordered;
        self.navigationItem.leftBarButtonItem.title=@"Edit";
        self.navigationItem.rightBarButtonItem.title=@"New Group";
        self.navigationItem.rightBarButtonItem.style=UIBarButtonItemStyleDone;
    }
    else
    {
        [(UITableView *)self.view setEditing:YES animated:YES];

        self.navigationItem.leftBarButtonItem.style=UIBarButtonItemStyleDone;
        self.navigationItem.leftBarButtonItem.title=@"Done";
        
        self.navigationItem.rightBarButtonItem.style=UIBarButtonItemStyleBordered;
        self.navigationItem.rightBarButtonItem.title=@"Clear";
                
    }
    }

}
-(void)conformDeleteGroup{
    
    UITableViewCell *cell=[(UITableView *)self.view cellForRowAtIndexPath:self.deleteIndexPath];

    int row=[groupNameArray indexOfObject:[NSString stringWithFormat:@"%@", cell.textLabel.text]];
    GroupModel *gm=[[model groups] objectAtIndex:row];

    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Groups" message:[NSString stringWithFormat:@"%@%@%@",@"Remove ",gm.groupName,@"?"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
    [alert show];
    [alert release];
}
-(void)alertView :(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==0)
    {
        UITableViewCell *cell=[(UITableView *)self.view cellForRowAtIndexPath:self.deleteIndexPath];
        
        int row=[groupNameArray indexOfObject:[NSString stringWithFormat:@"%@", cell.textLabel.text]];
        GroupModel *gm=[[model groups] objectAtIndex:row];
        if([[model groups] count] >0)
        {
            [[model groups] removeObject:gm];
            [groupNameArray removeObject:cell.textLabel.text];
            [(UITableView *)self.view beginUpdates];
            [(UITableView *)self.view deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.deleteIndexPath.row inSection:self.deleteIndexPath.section]] withRowAnimation:UITableViewRowAnimationBottom];
            [(UITableView *)self.view endUpdates];
            [(MulticallAppDelegate *)[[UIApplication sharedApplication] delegate]saveCustomeObject];; //force save
        }
        
        

    }
    if([[model groups] count]==0)
        self.navigationItem.rightBarButtonItem.enabled = NO;
    else
        self.navigationItem.rightBarButtonItem.enabled = YES;
[self loadGroupIndex];
}

#pragma TableView
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"groupView"];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"groupView"]autorelease];
        cell.textLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
        cell.detailTextLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        cell.backgroundColor=[UIColor whiteColor];
        cell.detailTextLabel.textColor = defaultColor;
        cell.textLabel.textAlignment=UITextAlignmentLeft;
        cell.detailTextLabel.textAlignment=UITextAlignmentRight;
        if(!isPickMode)
        cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
        
    }
           
    NSString *alphabet=nil;
    alphabet = [groupindex objectAtIndex:[indexPath section]];
    
        //---get all states beginning with the letter---
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
    NSArray *states = [groupNameArray filteredArrayUsingPredicate:predicate];
    if([states count]>0){
        NSString *cellValue = [states objectAtIndex:indexPath.row];
   
        cell.textLabel.text=cellValue;
     int row=[groupNameArray indexOfObject:[NSString stringWithFormat:@"%@", cell.textLabel.text]];
       GroupModel *gModel=[[model groups]objectAtIndex:row];
        
        if(gModel)
        {
        cell.detailTextLabel.text=[NSString stringWithFormat:@"(%i)",[gModel.contacts count]];
        }
    }
    

    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        //---get the letter in each section; e.g., A, B, C, etc.---
    NSString *alphabet; alphabet= [groupindex objectAtIndex:section];
   
        //---get all states beginning with the letter---
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
    NSArray *states;
    states= [groupNameArray filteredArrayUsingPredicate:predicate];
    
        //---return the number of states beginning with the letter---
    
    return [states count];

}
    //---set the number of sections in the table---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [groupindex count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   
    return [groupindex objectAtIndex:section];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.deleteIndexPath=indexPath;
    [self conformDeleteGroup];
}

-(void)tableView :(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
       
        
    int row=[groupNameArray indexOfObject:[NSString stringWithFormat:@"%@", cell.textLabel.text]];
    GroupModel *gm=[[model groups] objectAtIndex:row];
    if(isPickMode)
    {
      
        [self.delegate selectedGroup:gm];
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {

        
        CallView *cview=[[CallView alloc]init];
        [cview selectedGroup:gm];
        callViewPicker=[[UINavigationController alloc]initWithRootViewController:cview];
        cview.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(callviewpickerdismiss)]autorelease];
        callViewPicker.title=@"Add Participants";
        [self presentModalViewController:callViewPicker animated:YES];
        [callViewPicker release];
        [cview release];

    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)callviewpickerdismiss
{
    
    [callViewPicker dismissModalViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    NewGroupView *groupView = [[NewGroupView alloc]init];
    groupView->isGroupViewMode=YES;
    int row=[groupNameArray indexOfObject:[NSString stringWithFormat:@"%@", cell.textLabel.text]];
    groupView.model = [[model groups] objectAtIndex:row];
    [self.navigationController pushViewController:groupView animated:YES];
    [groupView release];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}


@end
