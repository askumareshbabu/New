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
     if(!self.txtDialNumber)
         self.txtDialNumber =[[UITextField alloc]init];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)]autorelease];
    
    [(UITableView *)self.view setEditing:YES animated:YES];
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
//    NSLog(@"row cont %i,%i",[arrayRowCount count],[self.saveDialArray count]);
//    if([self.arrayRowCount count] == 0)
//        return 1;
//    else
//    return [self.arrayRowCount count];
    return rowCount;
}
-(UITableViewCell *)tableView :(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    self.txtDialNumber=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, 250, 30)];
         if(cell == nil) {
            cell=  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:nil];
            
            self.txtDialNumber.keyboardType=UIKeyboardTypePhonePad;
            self.txtDialNumber.textAlignment=UITextAlignmentLeft;
            self.txtDialNumber.clearButtonMode=UITextFieldViewModeWhileEditing;
            
            self.txtDialNumber.delegate=self;
             txtDialNumber.text=@"";
            [cell.contentView addSubview:self.txtDialNumber];
         }
    self.txtDialNumber.tag=499+indexPath.row;
    NSLog(@"Saving array %@,%i",self.saveDialArray,rowCount);
    if(self.saveDialArray)
        for(int i=0; i <[saveDialArray count]; i++){
            if(i == indexPath.row)
            {
                    //NSLog(@"i %i,row %i",i,indexPath.row);
                
                [self.txtDialNumber setText:[saveDialArray objectAtIndex:indexPath.row]];
               
                
            }
        }
    
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    BOOL returnvalue;
//    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
//    for (UIView *view in  cell.contentView.subviews){                
//        
//        if ([view isKindOfClass:[UITextField class]]){
//            
//            UITextField* txtField = (UITextField *)view;
//             NSLog(@"textFileld %@",txtField.text);
//            if(![txtField.text isEqualToString:@""]){
//                returnvalue=YES;
//                break;
//            }
//            
//        }
//    }
//if(rowstyle !=indexPath.row)
       return  UITableViewCellEditingStyleDelete;
        //else
        //return UITableViewCellEditingStyleNone;
}
-(BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)tableView :(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        rowCount--;
        [self.saveDialArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath  indexPathForRow:indexPath.row inSection:0], nil]withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
     NSIndexPath *  indexpath=[(UITableView *)self.view indexPathForCell:(UITableViewCell*)[[textField superview] superview]];
   
    if(![textField.text length])
    {
        
        rowCount ++;
        [(UITableView *)self.view beginUpdates];
         rowstyle=indexpath.row;
            
        [(UITableView *)self.view insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:rowCount-1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationBottom];
            //[(UITableView *)self.view reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexpath.row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        [(UITableView *)self.view endUpdates];
            
    }
    [textField becomeFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSIndexPath *  indexpath=[(UITableView *)self.view indexPathForCell:(UITableViewCell*)[[textField superview] superview]];
    if([textField.text length] == 0)
    {
        rowCount--;
        [(UITableView *)self.view beginUpdates];
        
        [(UITableView *)self.view deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexpath.row inSection:0], nil] withRowAnimation:UITableViewRowAnimationBottom];
        [(UITableView *)self.view endUpdates];

    }
    if(![textField.text isEqualToString:@""]){
    if(![self.saveDialArray containsObject:[NSString stringWithFormat:@"%@",textField.text]])
    {
        [self.saveDialArray addObject:[NSString stringWithFormat:@"%@",textField.text]];

    }
    }
    

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
-(void)done
{
    int personid;
    NSString * number;
   
    for(int i=0; i < rowCount; i++)
    {
    
        NSString *dialNumberValue = [((UITextField*)[self.view viewWithTag:499+i]) text];
        NSLog(@"done textFiled %@",dialNumberValue);
        
            if(![dialNumberValue isEqualToString:@""])
            {
                number=dialNumberValue;
                if([number length] > 4)
                    personid = [[number substringWithRange:NSMakeRange(number.length-5, 4)] intValue];
                else
                    personid=[number intValue];
                
                [self addContactToModel:nil contactInfo:number contactType:nil personId:-personid];
//                if(![self.arrayRowCount containsObject:[NSString stringWithFormat:@"%i %@",-personid,number]])
//                    [self.arrayRowCount addObject:[NSString stringWithFormat:@"%i %@",-personid,number]];
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
    if(![self.arrayRowCount containsObject:contact])
    {
        [self.arrayRowCount addObject:contact];
        
    }
    NSLog(@"after save array %@",self.arrayRowCount);
}


@end
