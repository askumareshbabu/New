//
//  PhoneViewController.m
//  MultiCall
//
//  Created by Kumaresh on 14/09/12.
//
//

#import "PhoneViewController.h"
#import "CallView.h"
#import "Model.h"
#import "CallModel.h"
#import "ContactModel.h"

@interface PhoneViewController ()

@end

@implementation PhoneViewController


@synthesize txtDialNumber;
@synthesize insertArray;
@synthesize insertingIndexPath;
@synthesize dialNumberModel=_dialNumberModel;
@synthesize numberarray;
@synthesize phoneTableView;
@synthesize row;
@synthesize editingIndexPath;
@synthesize delegate=_delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    model=[Model singleton];
    if(!self.dialNumberModel)
    {
        DialNumberModel * dialModel=[[DialNumberModel alloc]init];
        self.dialNumberModel=dialModel;
        [dialModel release];
        
    }
    if(!txtDialNumber)
        txtDialNumber=[[UITextField alloc ]init];
    
    if(!self.numberarray)
        self.numberarray=[[NSMutableArray alloc]init];
    
    if(!self.insertArray)
    {
        self.insertArray=[[NSMutableArray alloc]init];
        
         NSLog(@"inserarray %@",insertArray);
        for(NSUInteger i=0; i<[model.dialNumbers count]; i++)
        {
            ContactModel *cm=[model.dialNumbers objectAtIndex:i];
            NSLog(@"Contactinfo %@",cm.contactType);
            [insertArray addObject:cm.contactInfo];
            [numberarray addObject:[NSString stringWithFormat:@"cell%i",i]];
        }
         NSLog(@"inserarray %@",insertArray);
    }
    
    
    
      self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)]autorelease];
}

- (void)viewDidUnload
{
    
    [self setTxtDialNumber:nil];
    [self setPhoneTableView:nil];
    [super viewDidUnload];
    insertArray=nil;
    insertingIndexPath=nil;
    lastIndexPathrow=0;
    _delegate=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewWillAppear:(BOOL)animated
{
        
    [phoneTableView setEditing:YES animated:YES];
        
    [super viewWillAppear:YES];
    
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardAppear) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDisAppear) name:UIKeyboardDidHideNotification object:nil];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    

    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}
-(void)keyboardAppear
{
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)]autorelease];
}
-(void)keyboardDisAppear
{
    self.navigationItem.rightBarButtonItem.enabled=NO;
}
-(void)dealloc
{
    
    [txtDialNumber release];
    self.insertArray=nil;
    insertingIndexPath=nil;
    lastIndexPathrow=0;
    [phoneTableView release];
    [_dialNumberModel release];
    self.numberarray=nil;
    _delegate=nil;
    [super dealloc];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     
       
          NSLog(@"dialnumber  count  %i,%i",[insertArray count],lastIndexPathrow);
    // Return the number of rows in the section.
   
    if(!lastIndexPathrow)
        return [insertArray count]+1;
    else if([insertArray count]== lastIndexPathrow){

        return lastIndexPathrow;}
          else
       return  lastIndexPathrow;
    
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
    NSString *CellIdentifier=[NSString stringWithFormat: @"cell%i", indexPath.row];
    UITableViewCell *cell=nil;
    if(![numberarray containsObject:[NSString stringWithFormat: @"cell%i", indexPath.row]])
      cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        else
         CellIdentifier=[NSString stringWithFormat:@"cell%i",lastRowIndex +1];
    
        NSLog(@"number array %@,%i",numberarray,indexPath.row);
    
   
    
        
            //CellIdentifier= [NSString stringWithFormat: @"cell%i", indexPath.row];
    NSLog(@"CellIdentifier %@",CellIdentifier);
    
     
    if (cell == nil) {
         
       cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        txtDialNumber = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 250, 30)];
        txtDialNumber.adjustsFontSizeToFitWidth = YES;
        txtDialNumber.delegate=self;
        
        txtDialNumber.keyboardType=UIKeyboardTypePhonePad;
        txtDialNumber.returnKeyType=UIReturnKeyDone;
        txtDialNumber.textAlignment=UITextAlignmentLeft;
        txtDialNumber.clearButtonMode=UITextFieldViewModeWhileEditing;
        [cell.contentView addSubview:txtDialNumber];
        txtDialNumber.placeholder=@"Add a Number";
        
        if(insertArray)
        {
        for(int i=0; i <[insertArray count]; i++){
            if(i == indexPath.row)
                {
                        //NSLog(@"i %i,row %i",i,indexPath.row);
                                        
                        [txtDialNumber setText:[insertArray objectAtIndex:indexPath.row]];
                        // txtDialNumber.text=cm.name;
                   
                }
            }
        }
        txtDialNumber.tag=indexPath.row;
        
        [txtDialNumber release];
   
    
        lastIndexPathrow=indexPath.row+1;
    }
    NSLog(@"insert array %@",insertArray);
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{

    return YES;


}
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;

}
-(BOOL)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
         
        //  NSLog(@" edit indexpatrow %i",indexPath.row);
        // First figure out how many sections there are
    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    
        // Then grab the number of rows in the last section
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
        //NSLog(@"last edit indexpatrow %i",lastRowIndex);
        // int count = [numberarray count];
    
        if (indexPath.row == lastRowIndex)
        
         return    UITableViewCellEditingStyleNone;

        return UITableViewCellEditingStyleDelete;

}
    

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITextField *cellText = (UITextField *)[phoneTableView cellForRowAtIndexPath:indexPath];
    NSLog(@"deleing index path row %i",indexPath.row);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSLog(@"cell.text %@",cellText.text);
        
        [insertArray removeObjectAtIndex:indexPath.row];
        lastIndexPathrow=lastIndexPathrow-1;
        [tableView beginUpdates];
    
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        
    }
    NSLog(@"after delete array %@",insertArray);
   
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
   
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
        [phoneTableView setEditing:YES animated:YES];
    [textField becomeFirstResponder];
        // NSIndexPath *  indexpath=[phoneTableView indexPathForCell:(UITableViewCell*)[[textField superview] superview]];
        // [phoneTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexpath.row inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
  
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
     NSLog(@"insert array %@",insertArray);
        //NSIndexPath *  indexpath=[phoneTableView indexPathForCell:(UITableViewCell*)[[textField superview] superview]];
    NSLog(@"clear clicked %@",textField.text);
    [insertArray removeObject:textField.text];
        //  [numberarray removeObjectAtIndex:indexpath.row];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    NSIndexPath *  indexpath=[phoneTableView indexPathForCell:(UITableViewCell*)[[textField superview] superview]];
   UITableViewCell * thisCell=[phoneTableView cellForRowAtIndexPath:indexpath];
    
    for(UIView *view in thisCell.contentView.subviews){
        textField =(UITextField *)view;
        NSInteger lastSectionIndex = [phoneTableView numberOfSections] - 1;
        NSInteger lastRowIndex = [phoneTableView numberOfRowsInSection:lastSectionIndex] - 1;
            if(lastIndexPathrow >1 && [textField.text isEqualToString:@""])
            {
                    //  NSLog(@"before remove text array %@",insertArray);
                for(int i=0; i <[insertArray count]; i++)
                {
                    if(i == indexpath.row)
                        [insertArray removeObject:textField.text];
                }

                 
            NSLog(@"after remove number array %@",insertArray);
                 
               
                NSLog(@"delete array count %i,lastindexpath %i,%i",[insertArray count],lastIndexPathrow,lastRowIndex);
               if([insertArray count] != lastRowIndex || [insertArray count] <=lastRowIndex)
               {
                  lastIndexPathrow=lastIndexPathrow-1;
                [phoneTableView beginUpdates];
                
                [phoneTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexpath.row
                                                                                                          inSection:0], nil] withRowAnimation:UITableViewRowAnimationBottom];
                [phoneTableView endUpdates];
               }
            }
        
        if(![textField.text isEqualToString:@""])
        {
            if(![insertArray containsObject:textField.text])
                [insertArray addObject:textField.text];
            else
            {
                NSLog(@"already contacts exists");
                    //textField.text=@"";
            }
            
        }
    }
    
       if([[textField text]length])
        self.navigationItem.rightBarButtonItem.enabled=YES;
    
    NSLog(@"insert array %@",insertArray);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   
    insertingIndexPath=[phoneTableView indexPathForCell:(UITableViewCell*)[[textField superview] superview]];
        //  NSLog(@"range length %i",insertingIndexPath.row);
    NSInteger lastSectionIndex = [phoneTableView numberOfSections] - 1;
    NSInteger lastRowIndex = [phoneTableView numberOfRowsInSection:lastSectionIndex]-1;
    if (textField.text.length==1 && range.length==0)
    {
        if (![self.numberarray containsObject:[NSString stringWithFormat:@"cell%i",insertingIndexPath.row]]) {
            [self.numberarray addObject:[NSString stringWithFormat:@"cell%i",insertingIndexPath.row]];
            editingIndexPath=insertingIndexPath;
        }
       
        NSLog(@"insert array count %i,lastindexpath %i",[insertArray count],lastRowIndex);
        if([insertArray count]==lastRowIndex)
        {
             lastIndexPathrow=lastIndexPathrow +1;
        [phoneTableView beginUpdates];
        
        [phoneTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:lastIndexPathrow-1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationBottom];
         
        [phoneTableView endUpdates];
                //[phoneTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:insertingIndexPath.row-1 inSection:0],nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
    return YES;


  
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
	NSLog(@"Self edititng");
   
}

-(void)done
{
    [model.dialNumbers removeAllObjects];
         int personid;
         NSString * number;
        //[model.dialNumbers setArray:insertArray];
    NSLog(@"done insertArray %@",insertArray);
    for(NSInteger i=0; i<[insertArray count]; i++)
    {
        number=[insertArray objectAtIndex: i];
        if(![model.dialNumbers containsObject:insertArray]){
        if([number length] > 4)
         personid = [[number substringWithRange:NSMakeRange(number.length-5, 4)] intValue];
        else
            personid=[number intValue];
       
           [self addContactToModel:nil contactInfo:number contactType:nil personId:-personid];
                //  [model.dialNumbers addObject:[NSString stringWithFormat:@"%i %@ %@ %@",personid,@"name",number,@"unKnown"]];
        }
    }
    
    NSLog(@"dailnumbers %@",model.dialNumbers);
    [(MulticallAppDelegate*)[[UIApplication sharedApplication] delegate]saveCustomeObject];
   
    [self.delegate dialnumberarray:model.dialNumbers];
    
    
    
    [self dismissModalViewControllerAnimated:YES];
     
}
-(void)addContactToModel:(NSString *)name contactInfo:(NSString *)contactInfo contactType:(NSString *)contactType personId:(int)personId
{
    ContactModel *contact = [[ContactModel alloc]init];
    contact.name = name;
    contact.personId=personId;
    contact.contactInfo = contactInfo;
    contact.contactType=contactType;
    
        //    //check for nulls and also say user if somthing is invalid
    if(![model.dialNumbers containsObject:contact])
    {
        [model.dialNumbers addObject:contact];
        [contact release];
    }
    
}




@end
