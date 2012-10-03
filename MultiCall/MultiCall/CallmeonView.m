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
@synthesize txtiPhone;
@synthesize txtHome;
@synthesize txtWork;
@synthesize txtMobile;
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
    // Do any additional setup after loading the view from its nib.
    //self.navigationItem.rightBarButtonItem=self.editButtonItem;
    if(!self.callmeonModel)
    {
        CallmeonModel * callme=[[CallmeonModel alloc]init];
        self.callmeonModel=callme;
        [callme release];
        
    }
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editMode)]autorelease];
    
}
-(void)LoadTextField
{
    self.txtiPhone=(UITextField *)[_addiPhoneNumber viewWithTag:1];
     self.txtMobile=(UITextField *)[_addMobileNumber viewWithTag:2];
     self.txtHome=(UITextField *)[_addHomeNumber viewWithTag:3];
    self.txtWork=(UITextField *)[_addWorkNumber viewWithTag:4];
    
    if([model.callemeon count]>0)
    {
        for (NSInteger i=0; i <[model.callemeon count]; i++) {
            
    
        self.callmeonModel=[model.callemeon objectAtIndex:i];
   
        if([self.callmeonModel.CallType isEqualToString:@"iPhone"])
        {
            self.txtiPhone.text=self.callmeonModel.CallPhoneNumber?:@"";
            if(self.callmeonModel.isSelected ==YES)
            {
                _addiPhoneNumber.accessoryType=UITableViewCellAccessoryCheckmark;
               
            }
            else{
                _addiPhoneNumber.accessoryType=UITableViewCellAccessoryNone;
            }
        }
           
    
            
    
        if([self.callmeonModel.CallType isEqualToString:@"mobile"])
        {
            self.txtMobile.text=self.callmeonModel.CallPhoneNumber?:@"";
            if(self.callmeonModel.isSelected ==YES)
            {
                _addMobileNumber.accessoryType=UITableViewCellAccessoryCheckmark;
                
            }
            else{
                _addMobileNumber.accessoryType=UITableViewCellAccessoryNone;
            }
           
        }
        
        if([self.callmeonModel.CallType isEqualToString:@"home"])
        {
            self.txtHome.text=self.callmeonModel.CallPhoneNumber?:@"";
            if(self.callmeonModel.isSelected ==YES)
            {
                _addHomeNumber.accessoryType=UITableViewCellAccessoryCheckmark;
                
            }
            else{
                _addHomeNumber.accessoryType=UITableViewCellAccessoryNone;
            }
           
        }
      
        if([self.callmeonModel.CallType isEqualToString:@"work"])
        {
            self.txtWork.text=self.callmeonModel.CallPhoneNumber?:@"";
            if(self.callmeonModel.isSelected ==YES)
            {
                _addWorkNumber.accessoryType=UITableViewCellAccessoryCheckmark;
                
            }
            else{
                _addWorkNumber.accessoryType=UITableViewCellAccessoryNone;
            }
             
        }
        
        }
    }
    
    else{
        self.txtMobile.text=@"";
        self.txtiPhone.text=@"";
        self.txtHome.text=@"";
        self.txtWork.text=@"";
    }

           
    //disable the text editing.only selection option
    if(isEditMode==NO)
    {
        self.txtiPhone.enabled=NO;
        self.txtMobile.enabled=NO;
        self.txtHome.enabled=NO;
        self.txtWork.enabled=NO;
        
    }
    else
    {
        self.txtiPhone.enabled=YES;
        self.txtMobile.enabled=YES;
        self.txtHome.enabled=YES;
        self.txtWork.enabled=YES;
    }
    if([cellArray count] ==0 || cellArray ==NULL || isEditMode)
    cellArray=[[NSMutableArray alloc]initWithObjects:@"iPhone",@"mobile",@"home",@"work",nil];
    else
        NSLog(@"cellarray %@",cellArray);
       
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardAppear) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDisAppear) name:UIKeyboardDidHideNotification object:nil];
    isEditMode=NO;
    [self LoadTextField];
    [self removeEmptyTableCell];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];
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
-(void)removeEmptyTableCell
{
    NSLog(@"recmoving cellarray %@",cellArray);
    if(!isEditMode)
    {
            //[(UITableView *)self.view beginUpdates];
      if(![self.txtMobile.text isEqualToString:@""] || ![self.txtHome.text isEqualToString:@""] || ![self.txtWork.text isEqualToString:@""] )
      {
           
          if([cellArray containsObject:@"iPhone"])
          {
            if([self.txtiPhone.text isEqualToString:@""])
            {
                [(UITableView *)self.view beginUpdates];
               int index=[cellArray indexOfObject:@"iPhone"];
                [cellArray removeObject:@"iPhone"];
              [(UITableView *)self.view deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                  NSLog(@"recmoving cellarray %@",cellArray);
                 [(UITableView *)self.view endUpdates];
                   
                
            }
          }
      }
            
        if([cellArray containsObject:@"mobile"])
        {
        if([self.txtMobile.text isEqualToString:@""])
        {
           [(UITableView *)self.view beginUpdates];
            int index=[cellArray indexOfObject:@"mobile"];
            [cellArray removeObject:@"mobile"];
            [(UITableView *)self.view deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
              NSLog(@"recmoving cellarray %@",cellArray);
            [(UITableView *)self.view endUpdates];
        }
        }
            
        if([cellArray containsObject:@"home"])
        {
        if([self.txtHome.text isEqualToString:@""])
        {
             [(UITableView *)self.view beginUpdates];
            int index=[cellArray indexOfObject:@"home"];
            [cellArray removeObject:@"home"];
            NSLog(@"recmoving cellarray %@",cellArray);
            [(UITableView *)self.view deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            
            [(UITableView *)self.view endUpdates];
        }
        }
            
        if([cellArray containsObject:@"work"])
        {
        if([self.txtWork.text isEqualToString:@""])
        {
             [(UITableView *)self.view beginUpdates];
                int index=[cellArray indexOfObject:@"work"];
                [cellArray removeObject:@"work"];
                [(UITableView *)self.view deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [(UITableView *)self.view endUpdates];
                NSLog(@"recmoving cellarray %@",cellArray);
        }
        }
        NSLog(@"--Delete Cell-- %@",cellArray);
           
        
        
    }
   
}

- (void)dealloc {
    [_addiPhoneNumber release];
    [_addMobileNumber release];
    [_addHomeNumber release];
    [_addWorkNumber release];
    cellArray=nil;
    self.callmeonModel=nil;
    [super dealloc];
}
#pragma TableView
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        UITableViewCell *cell=nil;
    
        if([cellArray containsObject:@"iPhone"])
        {
            cell=_addiPhoneNumber;
            [cellArray removeObject:@"iPhone"];
           
            return cell;
           
        }
    
        if([cellArray containsObject:@"mobile"])
        {
            cell=_addMobileNumber;
            [cellArray removeObject:@"mobile"];
            return cell;
        }

        if([cellArray containsObject:@"home"])
        {
            cell=_addHomeNumber;
            [cellArray removeObject:@"home"];
            return cell;
        }
             
        if([cellArray containsObject:@"work"])
        {
            cell=_addWorkNumber;
            [cellArray removeObject:@"work"];
           
            return  cell;
        }
            return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"coung %i",[cellArray count]);
    if(isEditMode)
    return   4;
    
    else
    {
        
       return  [cellArray count];
        
    }
    
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
        isPhoneChecked=NO;
        isMobileCheckd=NO;
        isHomeChecked=NO;
        isWorkChecked=NO;
        [self savecheckedNumber];
    }
    if([self.checkedIndexPath isEqual:indexPath])
    {
        self.checkedIndexPath=nil;
        isPhoneChecked=NO;
        isMobileCheckd=NO;
        isHomeChecked=NO;
        isWorkChecked=NO;
        [self savecheckedNumber];
    }
    else
    {
        thisCell=[tableView cellForRowAtIndexPath:indexPath];
       
        
            // self.checked=YES;
        
        self.checkedIndexPath=indexPath;
        for(UIView * view in thisCell.contentView.subviews)
        {
            UITextField *txtField=(UITextField *)view;
            if(txtField.tag ==1)
            {
                if(![txtField.text isEqualToString:@""])
                {
                    CallmeonModel *callmodel=[[CallmeonModel alloc]init];
                    isPhoneChecked=YES;
                    isMobileCheckd=NO;
                    isHomeChecked=NO;
                    isWorkChecked=NO;
                    thisCell.accessoryType=UITableViewCellAccessoryCheckmark;
                    [self savecheckedNumber];
                    [callmodel release];

                   
                }
                else{
                    thisCell.accessoryType=UITableViewCellAccessoryNone;
                    Message * alertMsg=[[Message alloc]init];
                    [alertMsg CustomMessage:@"6" MessageNo:@"1"];
                    [alertMsg release];
                    return;
                }

            }
          
           if(txtField.tag ==2)
           {
               if(![txtField.text isEqualToString:@""])
               {
                   CallmeonModel *callmodel=[[CallmeonModel alloc]init];
                   isPhoneChecked=NO;
                   isMobileCheckd=YES;
                   isHomeChecked=NO;
                   isWorkChecked=NO;
                   thisCell.accessoryType=UITableViewCellAccessoryCheckmark;
                   [self savecheckedNumber];
                   [callmodel release];
                 
               }
               else
               {
                thisCell.accessoryType=UITableViewCellAccessoryNone;
               }
           }
           
            if(txtField.tag ==3)
            {
            
                if(![txtField.text isEqualToString:@""])
                {
                    CallmeonModel *callmodel=[[CallmeonModel alloc]init];
                    isPhoneChecked=NO;
                    isMobileCheckd=NO;
                    isHomeChecked=YES;
                    isWorkChecked=NO;
                    thisCell.accessoryType=UITableViewCellAccessoryCheckmark;
                    [self savecheckedNumber];
                    [callmodel release];
                  
                }
                else
                {
                    thisCell.accessoryType=UITableViewCellAccessoryNone;
                }
            }
            
            if(txtField.tag ==4)
            {
                if(![txtField.text isEqualToString:@""])
                {
                    CallmeonModel *callmodel=[[CallmeonModel alloc]init];
                    isPhoneChecked=NO;
                    isMobileCheckd=NO;
                    isHomeChecked=NO;
                    isWorkChecked=YES;
                    thisCell.accessoryType=UITableViewCellAccessoryCheckmark;
                    [self savecheckedNumber];
                    [callmodel release];
                 
                }
                else
                {
                    thisCell.accessoryType=UITableViewCellAccessoryNone;
                }
            }
        
        } //for
    }//else
          
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
    return 45.0;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return @"Remove";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(!isdeleted)
    {
            cellArray=[[NSMutableArray alloc]initWithObjects:@"iPhone",@"mobile",@"home",@"work",nil];
    }
    
    NSLog(@"cell array %@",cellArray);
    isEditMode=NO;
    isdeleted=YES;
    if(editingStyle ==UITableViewCellEditingStyleDelete)
    {
        [tableView setEditing:YES animated:YES];
    }
    else
        [tableView setEditing:NO animated:NO];
    if([cellArray count]!=1)
    {
        switch (indexPath.row)
        {
        
    case 0:
    {
        if([cellArray containsObject:@"iPhone"])
        {
            
            [tableView beginUpdates];
            [cellArray removeObject:@"iPhone"];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
            [ self.txtiPhone setText:@""];
            isPhoneChecked=NO;
            [self saveModel];
        break;
        }
    }
        case 1:
            {
            if([cellArray containsObject:@"mobile"])
            {
                [tableView beginUpdates];
                [cellArray removeObject:@"mobile"];
                [(UITableView *)self.view deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView endUpdates];
                self.txtMobile.text=@"";
                isMobileCheckd=NO;
                [self saveModel];
                break;
            }
        }
        case 2:
        {
            if([cellArray containsObject:@"home"])
            {
                [tableView beginUpdates];
                [cellArray removeObject:@"home"];
                [(UITableView *)self.view deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]]withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView endUpdates];
                self.txtHome.text=@"";
                isHomeChecked=NO;
                [self saveModel];
                break;
            }
        }
        case 3:
        {
            if([cellArray containsObject:@"work"])
            {
                [tableView beginUpdates];
                [cellArray removeObject:@"work"];
                [(UITableView *)self.view deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView endUpdates];
                self.txtWork.text=@"";
                isWorkChecked=NO;
                [self saveModel];
                break;
            }
     
        }
        } //indexpath
    }//if
}
-(BOOL)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{

   
    if(isEditMode){

        switch (indexPath.row) {

            case 0:
            {
                if(![self.txtiPhone.text isEqualToString:@""])
                {
                    
                    return UITableViewCellEditingStyleDelete;
               
                }
                else
                {
                    return UITableViewCellEditingStyleNone;
                
                }
                
            }

            case 1:
            {
                if(![self.txtMobile.text isEqualToString:@""])
                
                    return UITableViewCellEditingStyleDelete;
                
                else
                {
                    return UITableViewCellEditingStyleNone;
                   
                }
                
            }

            case 2:
            {
                if(![self.txtHome.text isEqualToString:@""])
            
                    return UITableViewCellEditingStyleDelete;
                else
                {
                    return UITableViewCellEditingStyleNone;
                    
                }
                 
            }

            case 3:
            {
                if(![self.txtWork.text isEqualToString:@""])
                    
                    return UITableViewCellEditingStyleDelete;
                    
                else
                {
                    return UITableViewCellEditingStyleNone;
                    
                }
                   
            }

        }
        
    }
    else
    {
        return UITableViewCellEditingStyleNone;
    }
  
    return UITableViewCellEditingStyleDelete;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;

}

-(void)saveModel
{
    [model.callemeon removeAllObjects];
   
    
    [(MulticallAppDelegate*)[[UIApplication sharedApplication] delegate]saveCustomeObject];

    if(![self.txtiPhone.text isEqualToString:@""])
    {
        CallmeonModel *callmeonModel=[[CallmeonModel alloc]init];
        [callmeonModel setCallType:@"iPhone"];
        [callmeonModel setCallPhoneNumber:txtiPhone.text?:@""];
        callmeonModel.isSelected=isPhoneChecked;
        [[[Model singleton]callemeon]addObject:callmeonModel];
        [(MulticallAppDelegate*)[[UIApplication sharedApplication] delegate]saveCustomeObject];
        [callmeonModel release];
        
    }
    if(![self.txtMobile.text isEqualToString:@""])
    {
        CallmeonModel *callmeonModel=[[CallmeonModel alloc]init];
        [callmeonModel setCallType:@"mobile"];
        [callmeonModel setCallPhoneNumber:txtMobile.text ?:@""];
        callmeonModel.isSelected=isMobileCheckd;
              [[[Model singleton]callemeon]addObject:callmeonModel];
        
          [(MulticallAppDelegate*)[[UIApplication sharedApplication] delegate]saveCustomeObject];
        [callmeonModel release];
         
    }
    if(![self.txtHome.text isEqualToString:@""])
    {
        CallmeonModel *callmeonModel=[[CallmeonModel alloc]init];
        [callmeonModel setCallType:@"home"];
        [callmeonModel setCallPhoneNumber:txtHome.text? :@""];
        callmeonModel.isSelected=isHomeChecked;
        [[[Model singleton]callemeon]addObject:callmeonModel];
        [(MulticallAppDelegate*)[[UIApplication sharedApplication] delegate]saveCustomeObject];
        
        [callmeonModel release];
         
    }
    if(![self.txtWork.text isEqualToString:@""])
    {
        CallmeonModel *callmeonModel=[[CallmeonModel alloc]init];
        [callmeonModel setCallType:@"work"];
        [callmeonModel setCallPhoneNumber:txtWork.text ?: @""];
        callmeonModel.isSelected=isWorkChecked;
        [[[Model singleton]callemeon]addObject:callmeonModel];
       [(MulticallAppDelegate*)[[UIApplication sharedApplication] delegate]saveCustomeObject];
        [callmeonModel release];
    }
    NSLog(@"after save %@",model.callemeon);

}
-(void)saveNumber
{
    [self.view endEditing:YES];
    [self saveModel];
    [self editMode];
}
-(void)savecheckedNumber
{
    [self saveModel];
    [self LoadTextField];
}
-(void)keyboardAppear
{
       
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(saveNumber)]autorelease];
}
-(void)keyboardDisAppear
{
    [[[Model singleton]callemeon] addObject:self.callmeonModel];
    self.navigationItem.rightBarButtonItem.enabled=YES;
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
-(void)editMode
{
    
    if(((UITableView*)self.view).editing){
        isEditMode=NO;
        [((UITableView*)self.view) setEditing: NO animated: YES];
        self.navigationItem.rightBarButtonItem.title=@"Edit";
        
     
        isdeleted=NO;
    }
    else{
        isEditMode=YES;
        [(UITableView *)self.view reloadData];
        [((UITableView*)self.view) setEditing: YES animated: YES];
        self.navigationItem.rightBarButtonItem.title=@"Done";    
        
    }
     
    [self LoadTextField];
    [self removeEmptyTableCell];
    [(UITableView *)self.view reloadData];
     
    
}
@end
