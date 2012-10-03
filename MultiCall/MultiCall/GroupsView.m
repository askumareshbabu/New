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
    [groupindex release];
    [groupNameArray release];
    
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [model sortGroups];
    groupindex=[[NSMutableArray alloc]init];
    groupNameArray=[[NSMutableArray alloc]init];

    for(int i=0; i<[model.groups count]-1;i++)
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
-(void)viewDidAppear:(BOOL)animated
{
    if(!isPickMode){
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroup)]autorelease];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editGroup)]autorelease];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)addGroup
{
    NewGroupView * newgroup=[[NewGroupView alloc]init];
    [self.navigationController pushViewController:newgroup animated:YES];
    [newgroup release];
}
-(void)editGroup
{
    
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
            // cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
        
    }
           
    
  
    
    NSString *alphabet = [groupindex objectAtIndex:[indexPath section]];
    
        //---get all states beginning with the letter---
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
    NSArray *states = [groupNameArray filteredArrayUsingPredicate:predicate];
    if([states count]>0){
        NSString *cellValue = [states objectAtIndex:indexPath.row];
   
        cell.textLabel.text=cellValue;//gModel.groupName;
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
    NSString *alphabet = [groupindex objectAtIndex:section];
   
        //---get all states beginning with the letter---
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
    NSArray *states = [groupNameArray filteredArrayUsingPredicate:predicate];
    
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

-(void)tableView :(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
       
        int row=[groupNameArray indexOfObject:[NSString stringWithFormat:@"%@", cell.textLabel.text]];
        
        GroupModel *gm=[[model groups] objectAtIndex:row];
        [self.delegate selectedGroup:gm];
        [self dismissModalViewControllerAnimated:YES];
        
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    NewGroupView *groupView = [[NewGroupView alloc]init];
    int row=[groupNameArray indexOfObject:[NSString stringWithFormat:@"%@", cell.textLabel.text]];
    groupView.model = [[model groups] objectAtIndex:row];
    [self.navigationController pushViewController:groupView animated:YES];
    [groupView release];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

-(void)editMode
{
    
}
@end
