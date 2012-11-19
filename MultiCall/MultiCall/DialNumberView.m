//
//  DialNumberView.m
//  MultiCall
//
//  Created by ipod Touch on 18/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DialNumberView.h"
#import "CallView.h"
#import "ContactModel.h"

@implementation DialNumberView
@synthesize delegate;
@synthesize arrayRowCount;
@synthesize saveDialArray;
@synthesize txtDialNumber;
@synthesize editingRowIndex;
@synthesize textFieldTagList;


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
    

    if(!rowCount)
        rowCount=1;
    if(!self.arrayRowCount)
        self.arrayRowCount=[[[NSMutableArray alloc]init]autorelease];
    if(!self.saveDialArray)
        self.saveDialArray=[[[NSMutableArray alloc]init]autorelease];
    if(!self.textFieldTagList)
        self.textFieldTagList=[[[NSMutableArray alloc]init]autorelease];
     if(!self.txtDialNumber)
         self.txtDialNumber =[[[UITextField alloc]init]autorelease];
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
    delegate=nil;
    [arrayRowCount release];
    [saveDialArray release];
    [textFieldTagList release];
    [txtDialNumber release];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardAppear) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDisAppear) name:UIKeyboardDidHideNotification object:nil];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];

}
-(void)keyboardAppear
{
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)]autorelease];
    self.navigationItem.rightBarButtonItem.style=UIBarButtonItemStyleDone;
}
-(void)keyboardDisAppear
{
        self.navigationItem.rightBarButtonItem =nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(NSInteger)tableView:(UITableView *)tableView numberofSectionsInTableView:(NSInteger)section
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        // NSLog(@"rowcount %i",rowCount);
    
    return rowCount;
    
}
-(UITableViewCell *)tableView :(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell=nil;//(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.txtDialNumber=[[[UITextField alloc]initWithFrame:CGRectMake(10, 10, 250, 30)]autorelease];
        if(cell == nil) {
            cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DialNumber"];
         cell=  [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"DialNumber"]autorelease];
             cell.backgroundColor=[UIColor whiteColor];
             tableView.backgroundColor=[UIColor whiteColor];
             cell.selectionStyle=UITableViewCellSelectionStyleNone;
            self.txtDialNumber.keyboardType=UIKeyboardTypePhonePad;
            self.txtDialNumber.textAlignment=UITextAlignmentLeft;
            self.txtDialNumber.clearButtonMode=UITextFieldViewModeWhileEditing;
            self.txtDialNumber.placeholder=@"Add a Number";
    self.txtDialNumber.text=@"";
            self.txtDialNumber.delegate=self;
            [cell.contentView addSubview:self.txtDialNumber];
            
        }
        self.txtDialNumber.tag=indexPath.row+1;
        
        if(![self.textFieldTagList containsObject:[NSString stringWithFormat:@"%i",self.txtDialNumber.tag]])
        {
        [self.textFieldTagList addObject:[NSString stringWithFormat:@"%i",self.txtDialNumber.tag]];
        
        }
    
       
  
    if(self.saveDialArray){
       if([self.saveDialArray containsObject:@"@"])
       {
           [self.saveDialArray removeObject:@"@"];
       }
        for(int i=0; i <[self.saveDialArray count]; i++){
                if(i == indexPath.row)
                 {
                     NSString *number=[self.saveDialArray objectAtIndex:indexPath.row];
                     self.txtDialNumber.text=number;
                     
                 }
        }
    }
     
    if(indexPath.row ==0 &&[saveDialArray count] ==0)
    {
        [self.txtDialNumber becomeFirstResponder];
    }

    return cell;
}
-(BOOL)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex]-1;
    if(editingRowIndex== indexPath.row)
        return UITableViewCellEditingStyleNone;
    else
    if(indexPath.row==lastRowIndex)
        return UITableViewCellEditingStyleNone;
    else
        return UITableViewCellEditingStyleDelete;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{

        return YES;
}
-(void)tableView :(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
       

        [self.saveDialArray removeObjectAtIndex:indexPath.row];
        rowCount--;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath  indexPathForRow:indexPath.row inSection:0], nil]withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
        
            
    }
}

- (void)textFieldDidChange:(UITextField *)source
{
    NSIndexPath *  indexpath=[(UITableView *)self.view indexPathForCell:(UITableViewCell*)[[source superview] superview]];
   
    NSString *str= source.text;
    
    if(![str isEqualToString:@""]  &&  textControlEvent==1){
            [self.saveDialArray replaceObjectAtIndex:indexpath.row withObject:str];
    }

    
}
-(void)textFieldEditing:(UITextField *)textField
{
    NSIndexPath *  indexpath=[(UITableView *)self.view indexPathForCell:(UITableViewCell*)[[textField superview] superview]];
    NSInteger lastSectionIndex = [(UITableView *)self.view numberOfSections] - 1;
    NSInteger lastRowIndex = [(UITableView *)self.view numberOfRowsInSection:lastSectionIndex]-1;

    
    if([textField.text length] == 2 && textControlEvent==0 && indexpath.row ==lastRowIndex){
            rowCount ++;
            [(UITableView *)self.view beginUpdates];
        
            [(UITableView *)self.view insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:rowCount-1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        
            [(UITableView *)self.view endUpdates];
        
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
     NSIndexPath *  indexpath=[(UITableView *)self.view indexPathForCell:(UITableViewCell*)[[textField superview] superview]];
       editingRowIndex=indexpath.row;
    
    if(![textField.text length])
    {
       
            textControlEvent=0;
            //[textField addTarget:self action:@selector(textFieldEditing:) forControlEvents:UIControlEventEditingChanged];
        
        
    }
    else
    {
       
        textControlEvent=1;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSIndexPath *  indexpath=[(UITableView *)self.view indexPathForCell:(UITableViewCell*)[[textField superview] superview]];
    NSInteger lastSectionIndex = [(UITableView *)self.view numberOfSections] - 1;
    NSInteger lastRowIndex = [(UITableView *)self.view numberOfRowsInSection:lastSectionIndex]-1;
    
    if([textField.text length] == 0)
    {
        if(indexpath.row !=lastRowIndex){
        rowCount--;
        [(UITableView *)self.view beginUpdates];
        
        [(UITableView *)self.view deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexpath.row inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        [(UITableView *)self.view endUpdates];
        
            }

    }
    
    if(![textField.text isEqualToString:@""]){
                   
    if(![self.saveDialArray containsObject:[NSString stringWithFormat:@"%@",textField.text]])
    { 
             
        [self.saveDialArray addObject:[NSString stringWithFormat:@"%@",textField.text]];
       
    }
    else
    {
            //  NSLog(@"this number already exists %@",textField.text);
         
    }
        
    }
    
}


-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    NSIndexPath *  indexpath=[(UITableView *)self.view indexPathForCell:(UITableViewCell*)[[textField superview] superview]];
    
    if([self.saveDialArray count] > 0){
    [self.saveDialArray removeObject:textField.text];
        [self.saveDialArray insertObject:@"@" atIndex:indexpath.row];
    }
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSIndexPath *  indexpath=[(UITableView *)self.view indexPathForCell:(UITableViewCell*)[[textField superview] superview]];
    NSInteger lastSectionIndex = [(UITableView *)self.view numberOfSections] - 1;
    NSInteger lastRowIndex = [(UITableView *)self.view numberOfRowsInSection:lastSectionIndex]-1;
    
        //  NSLog(@"%i,%i",indexpath.row,lastRowIndex);
    if([textField.text length] == 1 && indexpath.row==lastRowIndex){
        rowCount ++;
        [(UITableView *)self.view beginUpdates];
        
        [(UITableView *)self.view insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:rowCount-1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [(UITableView *)self.view endUpdates];
        
    }
    if ([[textField text] length] + [string length] - range.length >= 20) {
        return NO;
    } 
    else {
        return YES; 
    }
}
-(void)done
{
    int personid;
    NSString * number;
    [(UITableView *)self.view scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    for(NSUInteger i=0; i < rowCount; i++)
    {
        UITableViewCell* cell = [(UITableView *)self.view cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        for(UIView * view in cell.contentView.subviews)
        {
             UITextField *txtField=(UITextField *)view;
        
            if(![txtField.text isEqualToString:@""])
            {
                number=txtField.text;
                if([number length] > 4)
                    personid = [[number substringWithRange:NSMakeRange(number.length-5, 4)] intValue];
                else
                    personid=[number intValue];
                
                [self addContactToModel:nil contactInfo:number contactType:nil personId:-personid];
                }
            
        }
        
    }
    
    
    [self.delegate dialnumberarray:self.arrayRowCount];
    [self dismissModalViewControllerAnimated:YES];
    
}
-(void)addContactToModel:(NSString *)name contactInfo:(NSString *)contactInfo contactType:(NSString *)contactType personId:(int)personId
{
    ContactModel *contact = [[[ContactModel alloc]init]autorelease];
    contact.name = name;
    contact.personId=personId;
    contact.contactInfo = contactInfo;
    contact.contactType=contactType;
//    
        //    //check for nulls and also say user if somthing is invalid
    if(contact.contactInfo !=NULL){
    if(![self.arrayRowCount containsObject:contact])
    {
        [self.arrayRowCount addObject:contact];
        
    }
    }
}


@end
