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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)loadTextField
{
    
    Model *mo=[Model singleton];
    UITextField * txtPinNo=(UITextField *)[_addPinNo viewWithTag:1];
    txtPinNo.text=mo.Pinno ?:@"";
   
    
    UITextField *txtPhoneNumber=(UITextField *)[_addPhoneNumber viewWithTag:2];
    for (NSInteger i=0; i<[model.callemeon count];i++) {
        CallmeonModel *callmeModel=[model.callemeon objectAtIndex:i];
        if(callmeModel.isSelected ==YES)
        {
            txtPhoneNumber.text=callmeModel.CallPhoneNumber ?:mo.PhoneNumber ? :@"";
            
        }
        
    }
        
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
    [super dealloc];
}
#pragma TableView
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=nil;
    switch (indexPath.row) {
        case 0:
            cell=_addPinNo;
            break;
        case 1:
            cell=_addPhoneNumber;
            break;
    }
   
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
-(void)done
{
    [self.view endEditing:YES];
    [self save];
}

-(void)keyboardAppear
{
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)]autorelease];
}
-(void)keyboardDisAppear
{
    self.navigationItem.rightBarButtonItem.enabled=NO;
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
        limit=11;}
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
    UITextField *phonenumber = (UITextField*)[_addPhoneNumber viewWithTag:2];
    model.PhoneNumber=[phonenumber.text length] >0? phonenumber.text :nil ;
    
    
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
    else if(model.PhoneNumber ==NULL)
    {
            //Enter Phone Number
        CustomMessageClass *alertMsg=[[CustomMessageClass alloc]init];
        [alertMsg CustomMessage:@"4" MessageNo:@"2"];
        [alertMsg release];
        [phonenumber becomeFirstResponder];
    
    }
    else if([model.PhoneNumber length] < 10)
    {
            //Enter valid Phone Number;
        CustomMessageClass *alertMsg=[[CustomMessageClass alloc]init];
        [alertMsg CustomMessage:@"4" MessageNo:@"3"];
        [alertMsg release];
        [phonenumber becomeFirstResponder];
        
    }
    else
    {
            //Saved successfully
        
        CustomMessageClass *alertMsg=[[CustomMessageClass alloc]init];
        [alertMsg CustomMessage:@"4" MessageNo:@"4"];
        [alertMsg release];
        self.navigationItem.rightBarButtonItem =nil;
        [(MulticallAppDelegate *)[[UIApplication sharedApplication] delegate]saveCustomeObject]; //force save
        
    }
    
}

@end
