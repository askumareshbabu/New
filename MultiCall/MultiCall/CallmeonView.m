//
//  CallmeonView.m
//  MultiCall
//
//  Created by ipod Touch on 29/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CallmeonView.h"
#import "CallmeonModel.h"
#import "Model.h"




@implementation CallmeonView
@synthesize addiPhoneNumber=_addiPhoneNumber;
@synthesize addMobileNumber=_addMobileNumber;
@synthesize addHomeNumber=_addHomeNumber;
@synthesize addWorkNumber=_addWorkNumber;

@synthesize cellArray;
@synthesize checkedIndexPath;
@synthesize checked;
@synthesize selectdIndexPath;

@synthesize callmeonModel=_callmeonModel;

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
-(void)awakeFromNib
{
    isdeleted=NO;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    model=[Model singleton];
}

- (void)viewDidUnload
{
    [self setAddiPhoneNumber:nil];
    [self setAddMobileNumber:nil];
    [self setAddHomeNumber:nil];
    [self setAddWorkNumber:nil];
    [super viewDidUnload];
    model=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [model.callemeon count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"callmeon"];
    if(cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"callmeon"]autorelease];
        cell.textLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        cell.detailTextLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
        cell.backgroundColor=[UIColor whiteColor];
        cell.textLabel.textAlignment=UITextAlignmentLeft;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.textAlignment=UITextAlignmentRight;
        UIView* vertLineView = [[[UIView alloc] initWithFrame:CGRectMake(70, 0, 1, 44)]autorelease];
        vertLineView.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:vertLineView];
    }
    CallmeonModel *callme=[model.callemeon objectAtIndex:indexPath.row];
    if(callme)
    {
        cell.textLabel.text=callme.CallType;
        cell.detailTextLabel.text=callme.CallPhoneNumber;
        if(callme.isSelected==YES){
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
            self.checkedIndexPath=indexPath;
        }
        else
            cell.accessoryType=UITableViewCellAccessoryNone;
        
    }
    return cell;
}
-(void)tableView :(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        //http://stackoverflow.com/questions/10192908/uitableview-checkmark-only-one-row-at-a-time
  
    UITableViewCell * thisCell=[tableView cellForRowAtIndexPath:indexPath];
    
        //if user uncheck the and already cheecked cell on first time loading 
    if(self.checkedIndexPath ==NULL)
    {
        if(thisCell.accessoryType==UITableViewCellAccessoryCheckmark)
        {
            thisCell.accessoryType=UITableViewCellAccessoryNone;
            self.checkedIndexPath=indexPath;
        }
    }
    
    
    if(self.checkedIndexPath)
    {
        UITableViewCell * oldCell=[tableView cellForRowAtIndexPath:self.checkedIndexPath];
        oldCell.accessoryType=UITableViewCellAccessoryNone;
        [self savecheckedNumber];
    }
    if([self.checkedIndexPath isEqual:indexPath])
    {
        self.checkedIndexPath=nil;
        [self savecheckedNumber];
    }
    else
    {
        thisCell=[tableView cellForRowAtIndexPath:indexPath];
        self.checkedIndexPath=indexPath;
        thisCell.accessoryType=UITableViewCellAccessoryCheckmark;
        model.PhoneNumber=thisCell.detailTextLabel.text;
       
                
        }//else
       [self saveModel];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 45.0;
}

-(void)saveModel
{
    [model.callemeon removeAllObjects];
    [(MulticallAppDelegate*)[[UIApplication sharedApplication] delegate]saveCustomeObject];
    [(UITableView *)self.view scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];

    for(int i=0; i<[[(UITableView *)self.view visibleCells]count]; i++)
    {
        CallmeonModel *callme=[[CallmeonModel alloc]init];

        callme.CallType=[(UITableView *)self.view cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].textLabel.text;
        callme.CallPhoneNumber=[(UITableView *)self.view cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].detailTextLabel.text;
        
        callme.isSelected=[(UITableView *)self.view cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].accessoryType;
        if(callme.isSelected ==3)
        {
            callme.isSelected=YES;
        }
        else
            callme.isSelected=NO;
        if(![model.callemeon containsObject:callme]){
        [[[Model singleton]callemeon]addObject:callme];
        [(MulticallAppDelegate*)[[UIApplication sharedApplication] delegate]saveCustomeObject];
        }
        
        [callme release];
    }
    
   

}

-(void)savecheckedNumber
{
    [self saveModel];      
    
}


@end
