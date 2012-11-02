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
        self.arrayRowCount=[[NSMutableArray alloc]init];
    if(!self.saveDialArray)
        self.saveDialArray=[[NSMutableArray alloc]init];
    if(!self.textFieldTagList)
        self.textFieldTagList=[[NSMutableArray alloc]init];
     if(!self.txtDialNumber)
         self.txtDialNumber =[[UITextField alloc]init];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)]autorelease];
    
        // [(UITableView *)self.view setEditing:YES animated:YES];
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
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    if([self.saveDialArray count] > 0)
//        self.navigationItem.rightBarButtonItem.enabled=YES;
//    else
//        self.navigationItem.rightBarButtonItem.enabled=NO;

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

    
    return rowCount;
    
}
-(UITableViewCell *)tableView :(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
       UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    self.txtDialNumber=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, 250, 30)];
         if(cell == nil) {
            cell=  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:nil];
             cell.backgroundColor=[UIColor whiteColor];
             tableView.backgroundColor=[UIColor whiteColor];
             cell.selectionStyle=UITableViewCellSelectionStyleNone;
            self.txtDialNumber.keyboardType=UIKeyboardTypePhonePad;
            self.txtDialNumber.textAlignment=UITextAlignmentLeft;
            self.txtDialNumber.clearButtonMode=UITextFieldViewModeWhileEditing;
            self.txtDialNumber.placeholder=@"Add Phone Number";
            self.txtDialNumber.delegate=self;
             txtDialNumber.text=@"";
             
            [cell.contentView addSubview:self.txtDialNumber];
         }
        self.txtDialNumber.tag=indexPath.row+1;
        
        if(![self.textFieldTagList containsObject:[NSString stringWithFormat:@"%i",self.txtDialNumber.tag]])
        {
        [self.textFieldTagList addObject:[NSString stringWithFormat:@"%i",self.txtDialNumber.tag]];
        }
    
    if(self.saveDialArray)
        for(int i=0; i <[saveDialArray count]; i++){
            if(i == indexPath.row)
            {
                    //NSLog(@"i %i,row %i",i,indexPath.row);
                NSString *number=[self.saveDialArray objectAtIndex:indexPath.row];
                
                if(![number isEqualToString:@""]){
                    
                    [self.txtDialNumber setText:number];
                }
                
                
            }
        }
    
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex]-1;
    NSLog(@"%i,%i,%i,%i",lastRowIndex,editingRowIndex,indexPath.row,self.txtDialNumber.tag);
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
        NSLog(@"before deleting save array %@,%i",self.saveDialArray,rowCount);

        [self.saveDialArray removeObjectAtIndex:indexPath.row];
        rowCount--;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath  indexPathForRow:indexPath.row inSection:0], nil]withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
        
              NSLog(@"deleting save array %@,%i",self.saveDialArray,rowCount);
        
            
    }
}

- (void)textFieldDidChange:(UITextField *)source
{
    NSString *str= source.text;
    NSLog(@"txt %@",str);
     NSIndexPath *  indexpath=[(UITableView *)self.view indexPathForCell:(UITableViewCell*)[[source superview] superview]];
    if(![str isEqualToString:@""]){
       
    [self.saveDialArray replaceObjectAtIndex:indexpath.row withObject:str];
    NSLog(@"replacing at %i = %@",indexpath.row,[self.saveDialArray objectAtIndex:indexpath.row]);
    }
    
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
     NSIndexPath *  indexpath=[(UITableView *)self.view indexPathForCell:(UITableViewCell*)[[textField superview] superview]];
    editingRowIndex=indexpath.row;
  
    if(![textField.text length])
    {
    
        rowCount ++;
        [(UITableView *)self.view beginUpdates];
                    
        [(UITableView *)self.view insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:rowCount-1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationBottom];
        [(UITableView *)self.view endUpdates];
            
    }
    else
    {
        
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    }
    
    [textField becomeFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSIndexPath *  indexpath=[(UITableView *)self.view indexPathForCell:(UITableViewCell*)[[textField superview] superview]];
    NSInteger lastSectionIndex = [(UITableView *)self.view numberOfSections] - 1;
    NSInteger lastRowIndex = [(UITableView *)self.view numberOfRowsInSection:lastSectionIndex] - 1;
    if([textField.text length] == 0)
    {
        NSLog(@"rowcount lastrow %i,%i",rowCount,lastRowIndex);
        if(lastRowIndex != rowCount +1 ){
            NSLog(@"delte text %@ , %i",textField.text,indexpath.row);
            
       
          rowCount--;
        [(UITableView *)self.view beginUpdates];
        
        [(UITableView *)self.view deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexpath.row inSection:0], nil] withRowAnimation:UITableViewRowAnimationBottom];
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
        NSLog(@"this number already exists %@",textField.text);
    }
        
    }
    NSLog(@"savedial %@",self.saveDialArray);
    self.txtDialNumber=nil;
}


-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    
    [self.saveDialArray removeObject:[NSString stringWithFormat:@"%@",textField.text]];

    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([[textField text] length] + [string length] - range.length >= 16) {
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

    for(NSUInteger i=0; i < rowCount; i++)
    {
        UITableViewCell* cell = [(UITableView *)self.view cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        
        for(UIView * view in cell.contentView.subviews)
        {
             UITextField *txtField=(UITextField *)view;
            NSLog(@"view textvalue %@, %i",txtField.text,txtField.tag);
            
        //  NSLog(@"taglist %@",self.textFieldTagList);
//        NSString * tagnum=[self.textFieldTagList objectAtIndex:i];
//        NSLog(@"tag %@,%i,%i",tagnum,self.txtDialNumber.tag,indexpath.row);
//        NSString *dialNumberValue = [((UITextField*)[self.view  viewWithTag:[tagnum intValue]]) text];
//        NSLog(@"dailnumbervalue %@",dialNumberValue);
            if(![txtField.text isEqualToString:@""])
            {
                number=txtField.text;
                    NSLog(@"number %@",number);
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
    NSLog(@"after save array %@",self.arrayRowCount);
}


@end
