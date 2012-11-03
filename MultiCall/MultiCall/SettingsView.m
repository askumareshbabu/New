//
//  SettingsView.m
//  MultiCall
//
//  Created by ipod Touch on 25/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsView.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation SettingsView
@synthesize addPinNo=_addPinNo;
@synthesize addPhoneNumber=_addPhoneNumber;
@synthesize addiPhoneNumber;
@synthesize addMobileNumber;
@synthesize addHomeNumber;
@synthesize addWork;
@synthesize checkedIndexPath;
@synthesize isexists;
#define defaultColor [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0 ];
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
    if(!isUpdateView)
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"About" style:UIBarButtonItemStyleBordered target:self action:@selector(infoView)]autorelease];
     self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)]autorelease];
   
    // Do any additional setup after loading the view from its nib.
}
-(void)infoView
{
   
      
    UIAlertView * aboutalert=[[UIAlertView alloc]initWithTitle:@"" message:@"MultiCall ™ \n Version 1.1.0 \n ©Telekonnectors" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    [aboutalert show];
    
    [aboutalert release];
}
- (void)viewDidUnload
{
    [self setAddPinNo:nil];
    [self setAddPhoneNumber:nil];
    
    [self setAddiPhoneNumber:nil];
    [self setAddMobileNumber:nil];
    [self setAddHomeNumber:nil];
    [self setAddWork:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)loadTextField
{
    
    Model *mo=[Model singleton];
    UITextField * txtPinNo=(UITextField *)[_addPinNo viewWithTag:1];
    txtPinNo.text=mo.Pinno ?:@"";
   
    UITextField * txtiPhoneNumber=(UITextField *)[addiPhoneNumber viewWithTag:3];
    UITextField * txtMobileNumber=(UITextField *)[addMobileNumber viewWithTag:4];
    UITextField * txtHomeNumber=(UITextField *)[addHomeNumber viewWithTag:5];
    UITextField * txtWorkNumber=(UITextField *)[addWork viewWithTag:6];
        //disable the text editing.only selection option
    
    

        //UITextField *txtPhoneNumber=(UITextField *)[_addPhoneNumber viewWithTag:2];
    
    if([model.callemeon count]>0)
    {
        for (NSInteger i=0; i <[model.callemeon count]; i++) {
            
            
            CallmeonModel *Callmeonmodel=[model.callemeon objectAtIndex:i];
            
            if([Callmeonmodel.CallType isEqualToString:@"iPhone"])
            {
                txtiPhoneNumber.text=Callmeonmodel.CallPhoneNumber?:@"";
                if(Callmeonmodel.isSelected ==YES)
                {
                    addiPhoneNumber.accessoryType=UITableViewCellAccessoryCheckmark;
                    
                    model.PhoneNumber=txtiPhoneNumber.text;
                }
                else{
                    addiPhoneNumber.accessoryType=UITableViewCellAccessoryNone;
                    
                }
            }
            
            
            
            
            if([Callmeonmodel.CallType isEqualToString:@"Mobile"])
            {
                txtMobileNumber.text=Callmeonmodel.CallPhoneNumber?:@"";
                if(Callmeonmodel.isSelected ==YES)
                {
                    addMobileNumber.accessoryType=UITableViewCellAccessoryCheckmark;
                    model.PhoneNumber=txtMobileNumber.text;
                    
                }
                else{
                    addMobileNumber.accessoryType=UITableViewCellAccessoryNone;
                    
                }
                
            }
            
            if([Callmeonmodel.CallType isEqualToString:@"Home"])
            {
                txtHomeNumber.text=Callmeonmodel.CallPhoneNumber?:@"";
                if(Callmeonmodel.isSelected ==YES)
                {
                    addHomeNumber.accessoryType=UITableViewCellAccessoryCheckmark;
                    model.PhoneNumber=txtHomeNumber.text;                    
                }
                else{
                    addHomeNumber.accessoryType=UITableViewCellAccessoryNone;
                }
                
            }
            
            if([Callmeonmodel.CallType isEqualToString:@"Work"])
            {
                txtWorkNumber.text=Callmeonmodel.CallPhoneNumber?:@"";
                if(Callmeonmodel.isSelected ==YES)
                {
                    addWork.accessoryType=UITableViewCellAccessoryCheckmark;
                    model.PhoneNumber=txtWorkNumber.text;
                }
                else{
                    addWork.accessoryType=UITableViewCellAccessoryNone;
                }
                
            }
            
        }
    }   
    else
    {
        txtiPhoneNumber.text=@"";
        txtMobileNumber.text=@"";
        txtHomeNumber.text=@"";
        txtWorkNumber.text=@"";
        model.PhoneNumber=nil;
    }

       
    [(UITableView *)self.view reloadData];
    
   }
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardAppear) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDisAppear) name:UIKeyboardDidHideNotification object:nil];
    [self loadTextField];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
        // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_addPinNo release];
    [_addPhoneNumber release];
    model=nil;
        //checkedIndexPath=nil;
    [addiPhoneNumber release];
    [addMobileNumber release];
    [addHomeNumber release];
    [addWork release];
    [super dealloc];
}
#pragma TableView
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=nil;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
       switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
               
                case 0:
                    cell=_addPinNo;
                    
                    break;
//                case 1:
//                    cell=_addPhoneNumber;
//                    break;
            }
            break;
        }
         
        case 1:{
            switch (indexPath.row) {
                       
        case 0:
            cell=addiPhoneNumber;
        if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            self.checkedIndexPath=indexPath;
        }
        break;
            
        case 1:
            cell=addMobileNumber;
                    if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
                    {
                        self.checkedIndexPath=indexPath;
                    }
            break;
        case 2:
            cell=addHomeNumber;
                    if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
                    {
                        self.checkedIndexPath=indexPath;
                    }
            break;
        case  3:
            cell=addWork;
                    if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
                    {
                        self.checkedIndexPath=indexPath;
                    }
            break;
            }
            break;
        }
    }
     cell.backgroundColor=[UIColor whiteColor];
       return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
        return 4;
            default:
            return 1;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        //http://iphonedevsdk.com/forum/iphone-sdk-development/5172-font-sizecolor-of-tableview-header.html
    
        // create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
	
        // create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = defaultColor;
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:20];
	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
    headerLabel.text = @"Call me on"; // i.e. array element
	[customView addSubview:headerLabel];
    switch (section) {
        case 0:
            return nil;
        case 1:
            return customView;
        default:
            return nil;
    }
	
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0;
        case 1:
            return 44.0;
        default:
            return 0;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
        // Return the number of sections.
    return 2;
}
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
    return 45.0;
}
-(BOOL)tableView :(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  NO;
}
-(BOOL)tableView :(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{        
    return NO;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==1)
        return YES;
    else
        return NO;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
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
            model.PhoneNumber=nil;
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
        model.PhoneNumber=nil;
        
    }
    if([self.checkedIndexPath isEqual:indexPath])
    {
        self.checkedIndexPath=nil;
        isPhoneChecked=NO;
        isMobileCheckd=NO;
        isHomeChecked=NO;
        isWorkChecked=NO;
        model.PhoneNumber=nil;
        
    }
    else
    {
        thisCell=[tableView cellForRowAtIndexPath:indexPath];
        
        
            // self.checked=YES;
        
        self.checkedIndexPath=indexPath;
        for(UIView * view in thisCell.contentView.subviews)
        {
            UITextField *txtField=(UITextField *)view;
            if(txtField.tag ==3)
            {
                if(![txtField.text isEqualToString:@""])
                {
                    CallmeonModel *callmodel=[[CallmeonModel alloc]init];
                    isPhoneChecked=YES;
                    isMobileCheckd=NO;
                    isHomeChecked=NO;
                    isWorkChecked=NO;
                    thisCell.accessoryType=UITableViewCellAccessoryCheckmark;
                    model.PhoneNumber=txtField.text;
                    [callmodel release];
                    
                    
                }
                
                
            }
            
            if(txtField.tag ==4)
            {
                if(![txtField.text isEqualToString:@""])
                {
                    CallmeonModel *callmodel=[[CallmeonModel alloc]init];
                    isPhoneChecked=NO;
                    isMobileCheckd=YES;
                    isHomeChecked=NO;
                    isWorkChecked=NO;
                    thisCell.accessoryType=UITableViewCellAccessoryCheckmark;
                    model.PhoneNumber=txtField.text;
                    
                    [callmodel release];
                    
                }
                else
                {
                    thisCell.accessoryType=UITableViewCellAccessoryNone;
                }
            }
            
            if(txtField.tag ==5)
            {
                
                if(![txtField.text isEqualToString:@""])
                {
                    CallmeonModel *callmodel=[[CallmeonModel alloc]init];
                    isPhoneChecked=NO;
                    isMobileCheckd=NO;
                    isHomeChecked=YES;
                    isWorkChecked=NO;
                    thisCell.accessoryType=UITableViewCellAccessoryCheckmark;
                     model.PhoneNumber=txtField.text;
                    [callmodel release];
                    
                }
                else
                {
                    thisCell.accessoryType=UITableViewCellAccessoryNone;
                }
            }
            
            if(txtField.tag ==6)
            {
                if(![txtField.text isEqualToString:@""])
                {
                    CallmeonModel *callmodel=[[CallmeonModel alloc]init];
                    isPhoneChecked=NO;
                    isMobileCheckd=NO;
                    isHomeChecked=NO;
                    isWorkChecked=YES;
                    thisCell.accessoryType=UITableViewCellAccessoryCheckmark;
                     model.PhoneNumber=txtField.text;
                    [callmodel release];
                    
                }
                else
                {
                    thisCell.accessoryType=UITableViewCellAccessoryNone;
                }
            }
            
        } //for
    }//else
    [self savecallmeon];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)done
{
    [self.view endEditing:YES];
    [self save];
}
-(void)editMode
{
   
    if(((UITableView *)self.view).isEditing)
    {
       
         isEditMode=NO;
        [(UITableView *)self.view setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItem.title=@"Edit";
       
         [self done];
    }
    else
    {
        if([self.navigationItem.rightBarButtonItem.title isEqualToString:@"Done"]){
            [self done];
            isEditMode=NO;
        }
        else{
         isEditMode=YES;
        [(UITableView *)self.view setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItem.title=@"Done";
         }
    }
     [self loadTextField];
    [(UITableView *)self.view reloadData];
   
}
-(void)keyboardAppear
{
        //self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)]autorelease];
}
-(void)keyboardDisAppear
{
        // self.navigationItem.rightBarButtonItem.enabled=NO;
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
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
      int limit=0;
    if(textField.tag ==1){
        limit=16;}
    else
    {  limit=21;}
    
    if([[textField text ]length]  +[string length] - range.length >= limit)
        
    {
        return NO;
    }
    
    return YES;
}
/**
 Save data to Model
 */
-(void)save
{
        //Model *model =[Model singleton];
    UITextField *pinno = (UITextField*)[_addPinNo viewWithTag:1];
    model.Pinno=[pinno.text length] >0 ? pinno.text :nil;
    NSLog(@"ping no %@",pinno.text);
//    UITextField *phonenumber = (UITextField*)[_addPhoneNumber viewWithTag:2];
//    model.PhoneNumber=[phonenumber.text length] >0? phonenumber.text :nil ;
       
        //Empty Validation and length validation
    NSLog(@"pin length %i", [model.Pinno length]);
    if(model.Pinno ==NULL)
    {
            //Enter PIN No.
        CustomMessageClass *alertMsg=[[CustomMessageClass alloc]init];
        [alertMsg CustomMessage:@"4" MessageNo:@"1"];
        [alertMsg release];
        [pinno becomeFirstResponder];
    }
    else if([model.PhoneNumber length] == 1)
    {
        CustomMessageClass *alertMsg=[[CustomMessageClass alloc]init];
        [alertMsg CustomMessage:@"4" MessageNo:@"5"];
        [alertMsg release];
        [pinno becomeFirstResponder];
    }
  

        
    
else{
            //Saved successfully
        [self savecallmeon];
        
        
         
        [(MulticallAppDelegate *)[[UIApplication sharedApplication] delegate]saveCustomeObject]; //force save
    if([model.callemeon count]> 0){
        CustomMessageClass *alertMsg=[[CustomMessageClass alloc]init];
        [alertMsg CustomMessage:@"4" MessageNo:@"4"];
        [alertMsg release];
    }
    }
    
}
-(void)savecallmeon
{
    [model.callemeon removeAllObjects];
    
    
    [(MulticallAppDelegate*)[[UIApplication sharedApplication] delegate]saveCustomeObject];
    UITextField * txtiPhoneNumber=(UITextField *)[addiPhoneNumber viewWithTag:3];
    UITextField * txtMobileNumber=(UITextField *)[addMobileNumber viewWithTag:4];
    UITextField * txtHomeNumber=(UITextField *)[addHomeNumber viewWithTag:5];
    UITextField * txtWorkNumber=(UITextField *)[addWork viewWithTag:6];
    
    NSMutableArray * phones=[[[NSMutableArray alloc]init]autorelease];
    [phones removeAllObjects];
    if(![txtiPhoneNumber.text isEqualToString:@""] || ![txtMobileNumber.text isEqualToString:@""] || ![txtHomeNumber.text isEqualToString:@""] ||![txtWorkNumber.text isEqualToString:@""]){
     
    [phones addObject:[NSString stringWithFormat:@"%@", [txtiPhoneNumber.text length] > 1 ?  txtiPhoneNumber.text:nil]];
    [phones addObject:[NSString stringWithFormat:@"%@", [txtMobileNumber.text length] > 1 ? txtMobileNumber.text:nil]];
    [phones addObject:[NSString stringWithFormat:@"%@", [txtHomeNumber.text length] > 1 ? txtHomeNumber.text:nil]];
    [phones addObject:[NSString stringWithFormat:@"%@",[txtWorkNumber.text length] > 1 ? txtWorkNumber.text:nil]];
    }
    NSLog(@"phones %@",phones);
    
    if([phones count]==0){
        //Enter Phone Number
        CustomMessageClass *alertMsg=[[CustomMessageClass alloc]init];
        [alertMsg CustomMessage:@"4" MessageNo:@"2"];
        [alertMsg release];
       
    }
    

    else
    {
        [phones removeAllObjects];
    if(![txtiPhoneNumber.text isEqualToString:@""])
    {
        CallmeonModel *callmeonModel=[[CallmeonModel alloc]init];
        [callmeonModel setCallType:@"iPhone"];
        [callmeonModel setCallPhoneNumber:txtiPhoneNumber.text?:@""];
        callmeonModel.isSelected=isPhoneChecked;
        [[[Model singleton]callemeon]addObject:callmeonModel];
        [(MulticallAppDelegate*)[[UIApplication sharedApplication] delegate]saveCustomeObject];
        [callmeonModel release];
        
    }
    if(![txtMobileNumber.text isEqualToString:@""])
    {
        CallmeonModel *callmeonModel=[[CallmeonModel alloc]init];
        [callmeonModel setCallType:@"Mobile"];
        [callmeonModel setCallPhoneNumber:txtMobileNumber.text ?:@""];
        callmeonModel.isSelected=isMobileCheckd;
        [[[Model singleton]callemeon]addObject:callmeonModel];
        
        [(MulticallAppDelegate*)[[UIApplication sharedApplication] delegate]saveCustomeObject];
        [callmeonModel release];
        
    }
    if(![txtHomeNumber.text isEqualToString:@""])
    {
        CallmeonModel *callmeonModel=[[CallmeonModel alloc]init];
        [callmeonModel setCallType:@"Home"];
        [callmeonModel setCallPhoneNumber:txtHomeNumber.text? :@""];
        callmeonModel.isSelected=isHomeChecked;
        [[[Model singleton]callemeon]addObject:callmeonModel];
        [(MulticallAppDelegate*)[[UIApplication sharedApplication] delegate]saveCustomeObject];
        
        [callmeonModel release];
        
    }
    if(![txtWorkNumber.text isEqualToString:@""])
    {
        CallmeonModel *callmeonModel=[[CallmeonModel alloc]init];
        [callmeonModel setCallType:@"Work"];
        [callmeonModel setCallPhoneNumber:txtWorkNumber.text ?: @""];
        callmeonModel.isSelected=isWorkChecked;
        [[[Model singleton]callemeon]addObject:callmeonModel];
        [(MulticallAppDelegate*)[[UIApplication sharedApplication] delegate]saveCustomeObject];
        [callmeonModel release];
    }
        

    }
    NSLog(@"after save %@",model.callemeon);
    
}

@end
