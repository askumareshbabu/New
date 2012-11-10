//
//  CEPeoplePickerNavigationController.m
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PeoplePickerNavigationController.h"
#import "PhoneNumberFormatter.h"

#pragma mark -
#pragma mark Navigation controller private interface

@interface CEPeoplePickerNavigationController ()
@end

#pragma mark -
#pragma mark Picker controller interface

@class CEPeoplePickerCell;
@interface CEPeoplePickerController : UITableViewController<UIActionSheetDelegate,UISearchDisplayDelegate> {
    CEPeoplePickerNavigationController *ppnc;
    
    NSMutableSet *selectedPeople;
    NSArray *sectionTitles;
    NSArray *sectionPeople;
    NSArray *sectionIndexTitles;
    NSArray *sectionIndexSections;
    NSString *searchCacheString;
    NSArray *searchCachePeople;
    int indexforPersonForChoosingContact;
    // searchDisplayController, when set, doesn't seem to retain the search
    // controller, which causes issues. So we have another var here.
    UISearchDisplayController *anotherSearchDisplayController;
    //Temporary variable to save the cell. as in tableview search indexpathforSelectedrow is giving nil in actionshet clicked 
    CEPeoplePickerCell *searchIndexPath; 
}

@property (nonatomic, retain) CEPeoplePickerNavigationController *ppnc;
@property (nonatomic, retain) NSMutableDictionary *selectedValues;
@property (nonatomic, retain) NSMutableSet *selectedPeople;
@property (nonatomic, retain) NSArray *sectionTitles;     // map of section numbers to section letters
@property (nonatomic, retain) NSArray *sectionPeople;      // map of section numbers to an array of ABRecordRef objects (people only)
@property (nonatomic, retain) NSArray *sectionIndexTitles;
@property (nonatomic, retain) NSArray *sectionIndexSections;
@property (nonatomic, retain) NSString *searchCacheString; // the search string for which searchCachePeople are valid
@property (nonatomic, retain) NSArray *searchCachePeople;  // cache of the last search result
@property(nonatomic,retain)PhoneNumberFormatter *formatter;
@property (nonatomic, retain) UISearchDisplayController *anotherSearchDisplayController;

// Uses navigation controller for ABAddressBook and peoplePickerDelegate.
- (id)initWithPeoplePickerNavigationController:(CEPeoplePickerNavigationController *)aPpnc values:(NSMutableDictionary *)values;

- (NSArray *)allPeopleBySectionStarts:(NSArray *)sectionStarts lastSectionEnd:(NSString *)lastSectionEnd others:(NSArray **)othersPtr;
- (NSArray *)peopleForSearchString:(NSString *)searchString;
-(void)showActionSheet:(NSArray *)lables values:(NSArray *)values;
@end


#pragma mark -
#pragma mark Cell interface

@interface CEPeoplePickerCell : UITableViewCell
{
    CEPeoplePickerController *peoplePicker;
    ABRecordRef person;
}

@property (nonatomic, retain) CEPeoplePickerController *peoplePicker;
@property (nonatomic) ABRecordRef person;

- (id)initWithPeoplePicker:(CEPeoplePickerController *)aPeoplePicker reuseIdentifier:(NSString *)reuseIdentifier;

@end


#pragma mark -
#pragma mark Address book function declarations


// Create a ABRecordRef with type kABPersonType that can be used with
// ABPersonComparePeopleByName() to find section boundaries.
static ABRecordRef CEABPersonCreateSectionBoundary(CFStringRef sectionName);

// Using ABPersonComparePeopleByName(), it could happen that real 'c' appeared
// before boundary 'c'. This function ensures that, when otherwise equal,
// boundaries come first.

typedef struct _CEABPersonComparePeopleByNameAndIsBoundaryArgs {
    ABPersonSortOrdering ordering;
    NSArray *boundaries;
} CEABPersonComparePeopleByNameAndIsBoundaryArgs;

static CFComparisonResult CEABPersonComparePeopleByNameAndIsBoundary(ABRecordRef person1, ABRecordRef person2, CEABPersonComparePeopleByNameAndIsBoundaryArgs *args);


#pragma mark -
#pragma mark Navigation controller implementation


@implementation CEPeoplePickerNavigationController

@synthesize peoplePickerDelegate;
@synthesize addressBook;
#pragma mark Object lifecycle


- (id)initWithValues:(NSMutableDictionary *)values
{

    if (self = [super init]) {
        addressBook = ABAddressBookCreate();
        CEPeoplePickerController *cePeoplePickerController =[[[CEPeoplePickerController alloc] initWithPeoplePickerNavigationController:self values:values] autorelease];
        self.viewControllers = [NSArray arrayWithObject:cePeoplePickerController];
    }
    return self;
}

- (void)dealloc
{
    CFRelease(addressBook);
    [super dealloc];
}

@end


#pragma mark -
#pragma mark Picker controller implementation


@implementation CEPeoplePickerController

@synthesize ppnc;

@synthesize selectedValues=_selectedValues;
@synthesize selectedPeople;
@synthesize sectionTitles;
@synthesize sectionPeople;
@synthesize sectionIndexTitles;
@synthesize sectionIndexSections;
@synthesize searchCacheString;
@synthesize searchCachePeople;

@synthesize anotherSearchDisplayController;
@synthesize formatter;
UISearchDisplayController *searchController ;
#pragma mark Object lifecycle

- (id)initWithPeoplePickerNavigationController:(CEPeoplePickerNavigationController *)aPpnc values:(NSMutableDictionary *)values
{
    if (self = [super init]) {
        self.ppnc = aPpnc;
        self.selectedPeople = [NSMutableSet set];
        self.selectedValues = values;
            // NSLog(@"selected values %@",values);
        // Determine section and section index titles
        // (hardcoded to english, Apple uses per-locale plists)
        
        NSArray *locSectionHeaders     = [NSArray arrayWithObjects:
                                          @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M",
                                          @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
        
        NSArray *locSectionIndices     = [NSArray arrayWithObjects:
                                          @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M",
                                          @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
        
        //NSString *locFirstCharacterAfterLanguage =  @"Ê’";
        NSString *locLastCharacter = @"Z";
        
        NSArray *otherPeople;
        NSArray *groupedPeople = [self allPeopleBySectionStarts:locSectionHeaders
                                                 lastSectionEnd:locLastCharacter 
                                                         others:&otherPeople];
        
        // Build final section titles and people
        
        // Filter out empty sections from groupedPeople
        NSMutableArray *theSectionTitles = [NSMutableArray array];
        NSMutableArray *theSectionPeople = [NSMutableArray array];
        
        for (NSUInteger i=0; i<[locSectionHeaders count]; i++) {
            NSString *header = [locSectionHeaders objectAtIndex:i];
            NSArray *people = [groupedPeople objectAtIndex:i];
            
            if ([people count] == 0)
                continue;
            
            [theSectionTitles addObject:header];
            [theSectionPeople addObject:people];
        }
        
        // Build section indices
        //
        // Each section index will lead to the last section <= section title, or -1 if there are no sections.
        
        NSMutableArray *theSectionIndexTitles = [NSMutableArray array];
        NSMutableArray *theSectionIndexSections = [NSMutableArray array];
        
        for (NSString *sectionIndexTitle in locSectionIndices) {
            NSInteger targetSectionNum = -1;
            
            for (NSUInteger sectionNum=0; sectionNum<[theSectionTitles count]; sectionNum++) {
                NSString *sectionTitle = [theSectionTitles objectAtIndex:sectionNum];
                
                // TODO: should be using ABPersonComparePeopleByName
                if ([sectionTitle caseInsensitiveCompare:sectionIndexTitle] == NSOrderedDescending)
                    break;
                
                targetSectionNum = sectionNum;
            }
            
            
            [theSectionIndexTitles addObject:sectionIndexTitle];
            [theSectionIndexSections addObject:[NSNumber numberWithInteger:targetSectionNum]];
        }
        
        // '#' support
        if ([otherPeople count] > 0) {
            [theSectionTitles addObject:@"#"];
            [theSectionPeople addObject:otherPeople];
        }
        [theSectionIndexTitles addObject:@"#"];
        [theSectionIndexSections addObject:[NSNumber numberWithInteger:[theSectionTitles count]-1]]; // -1 if no sections, but that's correct
        
        
        self.sectionTitles = theSectionTitles;
        self.sectionPeople = theSectionPeople;
        self.sectionIndexTitles = theSectionIndexTitles;
        self.sectionIndexSections = theSectionIndexSections;
        
        // UI
        
        self.title = @"Contacts";
        self.navigationItem.leftBarButtonItem  = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)] autorelease];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)] autorelease];
        
    }
   
    return self;
}

- (void)dealloc
{
    self.ppnc = nil;
    
    self.selectedValues=nil;
    self.selectedPeople = nil;
    self.sectionTitles = nil;
    self.sectionPeople = nil;
    self.sectionIndexTitles = nil;
    self.sectionIndexSections = nil;
    self.searchCacheString = nil;
    self.searchCachePeople = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
    if (!self.view) {
        self.searchCacheString = nil;
        self.searchCachePeople = nil;
    }
}

#pragma mark Retrieving people

- (NSArray *)allPeopleBySectionStarts:(NSArray *)sectionStarts lastSectionEnd:(NSString *)lastSectionEnd others:(NSArray **)othersPtr
{
    NSArray *people = [(NSArray *)ABAddressBookCopyArrayOfAllPeople(self.ppnc.addressBook)autorelease];
    
    
    // Create an array of mock persons that represent boundaries.
    //
    // This will contain num(locSectionHeaders)+1 persons.
    // i-th section contains people: boundaries[i] <= person < boundaries[i+1]
    NSMutableArray *boundaries = [NSMutableArray array];
    
    for (NSString *sectionStart in sectionStarts) {
        ABRecordRef boundary = CEABPersonCreateSectionBoundary((CFStringRef)sectionStart);
        [boundaries addObject:(id)boundary];
        CFRelease(boundary);
    }
    
    ABRecordRef lastBoundary = CEABPersonCreateSectionBoundary((CFStringRef)lastSectionEnd);
    [boundaries addObject:(id)lastBoundary];
    CFRelease(lastBoundary);
    
    // Boundaries should already be sorted, but just to be sure
    [boundaries sortUsingFunction:(NSInteger (*)(id, id, void *))ABPersonComparePeopleByName context:(void *)ABPersonGetSortOrdering()];
    
    // Combine people and boundaries and sort them
    NSMutableArray *sortedPeopleWithBoundaries = [NSMutableArray arrayWithCapacity:[people count] + [boundaries count]];
    [sortedPeopleWithBoundaries addObjectsFromArray:people];
    [sortedPeopleWithBoundaries addObjectsFromArray:boundaries];
    
    CEABPersonComparePeopleByNameAndIsBoundaryArgs sortArgs;
    sortArgs.ordering = ABPersonGetSortOrdering();
    sortArgs.boundaries = boundaries;
    
    [sortedPeopleWithBoundaries sortUsingFunction:(NSInteger (*)(id, id, void *))CEABPersonComparePeopleByNameAndIsBoundary context:&sortArgs];
    
    // Debug
    if (NO) {
        NSLog(@"Sorted people with boundaries:");
        for (id personObj in sortedPeopleWithBoundaries) {
            ABRecordRef person = (ABRecordRef)personObj;
            
            NSString *compositeName = (NSString *)ABRecordCopyCompositeName(person);
            
            NSLog([boundaries containsObject:(id)person] ? @"[%@]" : @" - %@", compositeName);
        }
    }
    
    // Split them into sections
    // Those before first boundary or after last one are put into otherPeople.
    NSMutableArray *groupedPeople = [NSMutableArray arrayWithCapacity:[sectionStarts count]];
    for (NSUInteger i=0; i<[sectionStarts count]; i++)
        [groupedPeople addObject:[NSMutableArray array]];
    
    NSMutableArray *otherPeople = [NSMutableArray array];
    NSArray *digits = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    
    NSInteger lastSeenBoundaryIndex = -1;
    ABRecordRef nextBoundary = [boundaries count] >= 1 ? [boundaries objectAtIndex:0] : NULL;
    //NSLog(@"Starting out, next boundary: %@", nextBoundary ? [(id)ABRecordCopyCompositeName(nextBoundary) autorelease] : nil);
   
    for (id personObj in sortedPeopleWithBoundaries) {
        ABRecordRef person = (ABRecordRef)personObj;
                    
            if (person == nextBoundary) {
            lastSeenBoundaryIndex++;
            nextBoundary = [boundaries count] >= lastSeenBoundaryIndex+2 ? [boundaries objectAtIndex:lastSeenBoundaryIndex+1] : NULL;
                    //  NSLog(@"Reached %d-th boundary: %@, next boundary: %@", lastSeenBoundaryIndex, [(id)ABRecordCopyCompositeName(person) autorelease], nextBoundary ? [(id)ABRecordCopyCompositeName(nextBoundary) autorelease] : nil);
            continue;
        }
            //Remove Empty Contact number List
        ABMultiValueRef multiValue = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        int count = ABMultiValueGetCount(multiValue);
            if(multiValue)
                 CFRelease(multiValue);
        NSString *compositeName=NULL;
        if(count >  0)
           compositeName = [(NSString *)ABRecordCopyCompositeName(person)autorelease];
        
        // Filter out those without any name. Contacts displays them, and we could
        // guess what algorithm it uses, but we'd then risk falling out of sync with
        // ABPersonComparePeopleByName(), possibly causing contacts to appear at
        // unexpected places.
        if (!compositeName)
            continue;
        
        if (lastSeenBoundaryIndex == -1 || lastSeenBoundaryIndex == [boundaries count]-1) {
            //NSLog(@"Adding %@ to other", [(id)ABRecordCopyCompositeName(person) autorelease]);
            [otherPeople addObject:(id)person];
        } else if ([digits containsObject:[compositeName substringToIndex:1]]) {
            // Special case for names starting with digits: also throw them into other.
            
            //NSLog(@"Adding %@ to other (numeric)", [(id)ABRecordCopyCompositeName(person) autorelease]);
            [otherPeople addObject:(id)person];
        } else {
            //NSLog(@"Adding %@ to %d-th group: %@", [(id)ABRecordCopyCompositeName(person) autorelease], lastSeenBoundaryIndex, [locSectionHeaders objectAtIndex:lastSeenBoundaryIndex]);
            [[groupedPeople objectAtIndex:lastSeenBoundaryIndex] addObject:(id)person];
        }
        
        //check the people with selected people and add them as ABRecordref id dynamic
        ABRecordID iden = ABRecordGetRecordID(person);
        if([self.selectedValues objectForKey:KEY_FOR_SELECTION(iden)])
            [self.selectedPeople addObject:(id)person];
        
    }
    
    *othersPtr = otherPeople;
   
    return groupedPeople;
}

// Caches the last result, so calling this with the same search string multiple
// times doesn't hurt much.
- (NSArray *)peopleForSearchString:(NSString *)searchString
{
   
    if([searchString isEqualToString:@""])
        searchString=@"A";
  
        NSArray *results;//=[[NSArray alloc]init];
    if (![searchString isEqual:self.searchCacheString]) {
        // Reload needed
        
        results = [(NSArray *)ABAddressBookCopyPeopleWithName(self.ppnc.addressBook, (CFStringRef)searchString)autorelease];
        results = [results sortedArrayUsingFunction:(NSInteger (*)(id, id, void *))ABPersonComparePeopleByName context:(void *)ABPersonGetSortOrdering()];
            //Remove Empty Contact number List form search result
        NSMutableArray *compositeName=[[[NSMutableArray alloc]init]autorelease];
            //NSLog(@"search result %@",results);
        
        for(id elements in results)
        {
                //NSLog(@"ABRecordRef search %@",elements);
            ABMultiValueRef multiValueempty = ABRecordCopyValue(elements, kABPersonPhoneProperty);
            
            int count = ABMultiValueGetCount(multiValueempty);
            if(count >  0)
            {
                [compositeName addObject:elements];
            }
           if(multiValueempty)
               CFRelease(multiValueempty);
        
        }
        self.searchCacheString = searchString;
            if(results !=NULL)
        self.searchCachePeople = compositeName;
        else
        
            self.searchCachePeople=results;
            //}
        }
    return self.searchCachePeople;
}

#pragma mark Actions

- (void)cancelAction:(id)sender
{
    if ([self.ppnc.peoplePickerDelegate respondsToSelector:@selector(cePeoplePickerNavigationControllerDidCancel:)])
        [self.ppnc.peoplePickerDelegate cePeoplePickerNavigationControllerDidCancel:self.ppnc];
}

- (void)doneAction:(id)sender

{
         NSArray *people = [self.selectedPeople allObjects];
    NSLog(@"done action %@",self.selectedPeople);
    NSLog(@"seleced Values %@",self.selectedValues);
    NSArray *sortedPeople = [people sortedArrayUsingFunction:(NSInteger (*)(id, id, void *))ABPersonComparePeopleByName context:(void *)ABPersonGetSortOrdering()];
   
    
    if ([self.ppnc.peoplePickerDelegate respondsToSelector:@selector(cePeoplePickerNavigationController:didFinishPickingPeople:values:)])
            [self.ppnc.peoplePickerDelegate cePeoplePickerNavigationController:self.ppnc didFinishPickingPeople:sortedPeople values:[NSDictionary dictionaryWithDictionary:self.selectedValues]];
        
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formatter=[[[PhoneNumberFormatter alloc]init]autorelease];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Set up the gray background when scrolling past the top
    
    CGRect grayViewFrame = self.tableView.bounds;
    grayViewFrame.origin.y = -grayViewFrame.size.height;
    
    UIView *grayView = [[[UIView alloc] initWithFrame:grayViewFrame] autorelease];
    grayView.backgroundColor = [UIColor colorWithRed:0.886f green:0.906f blue:0.929f alpha:1.0f];
    [self.tableView addSubview:grayView];
    
    // Set up search
    
    UISearchBar *searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 44.0f)] autorelease];
    self.tableView.tableHeaderView = searchBar;
    
       
        UISearchDisplayController *searchController = [[[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self] autorelease];
   
    
    searchController.delegate = self;
    
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
    
    // Apparently, searchDisplayController property doesn't retain it, even though it's declared with `retain`:
    // http://stackoverflow.com/questions/2395272/uisearchdisplaycontroller-not-working-when-created-in-code
    // So we have another var.
    self.anotherSearchDisplayController = searchController;
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //searchBar.showsCancelButton=YES;
}
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    controller.searchBar.text = @"";
    [(UITableView *)self.view reloadData];
    
    
}


 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
     NSLog(@"page appear");
 }
 

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
    
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
     // Return YES for supported orientations
     return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }


- (void)viewDidUnload
{
    self.anotherSearchDisplayController = nil;
    [super viewDidUnload];
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    if (![self.searchDisplayController isActive]) {
        if ([self.sectionTitles count] == 0)
            return 1;
        
        return [self.sectionTitles count];
    } else {
        // Search has only 1 section
        return 1;
    } 
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
    if (![self.searchDisplayController isActive]) {
        if ([self.sectionTitles count] == 0)
            return nil; // no header for the only and empty section
        
        return [self.sectionTitles objectAtIndex:section];
    } else {
        return nil;
    } 
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView
{
    if (![self.searchDisplayController isActive]) {
        if ([self.sectionIndexTitles count] == 0)
            return nil; // no index titles at all
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:self.sectionIndexTitles];
    } else {
        return nil;
    } 
}

- (NSInteger)tableView:(UITableView *)aTableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (![self.searchDisplayController isActive]) {
        if ([self.sectionIndexTitles count] == 0)
            return 1; // shouldn't get to here (since we have no index)
        
        if (index == 0) {
            // Magnifying glass clicked, scroll manually
            [aTableView scrollRectToVisible:self.tableView.tableHeaderView.bounds animated:NO];
            return -1;
        } else {
            NSInteger section = [[self.sectionIndexSections objectAtIndex:index-1] integerValue];
            
            if (section == -1)
                return 0; // no sections, but we magically added at least one
            
            return section;
        }
    } else{
        NSLog(@"Search results table does not have section index titles, can't get section indexes for them (returning 1)!");
        return 1;
    } 
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if (![self.searchDisplayController isActive]) {
        if ([self.sectionTitles count] == 0)
            return 0; // only one and empty section
        
        return [[self.sectionPeople objectAtIndex:section] count];
    } else  {
        int count =[[self peopleForSearchString:self.searchDisplayController.searchBar.text] count];
        return count;
    } 
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CEPeoplePickerCell";
    
    CEPeoplePickerCell *cell = (CEPeoplePickerCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CEPeoplePickerCell alloc] initWithPeoplePicker:self reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Get person
    ABRecordRef person = NULL;
    if ([self.searchDisplayController isActive]) {
            // NSLog(@"search active");
        person = (ABRecordRef)[[self peopleForSearchString:self.searchDisplayController.searchBar.text] objectAtIndex:[indexPath row]];
                
    }
    else {
            // NSLog(@"search not active");
        person = (ABRecordRef)[[self.sectionPeople objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];   
        
    } 
    
    if(person){
    cell.person = person;
        
            //mark the selections
    if([self.selectedValues count])
    {
        
        ABRecordID iden = ABRecordGetRecordID(person);
        if([self.selectedValues objectForKey:KEY_FOR_SELECTION(iden)])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }

        
        cell.textLabel.text=(NSString *)ABRecordCopyCompositeName(person);
       
                         
    }
    
    return cell;
    
}



#pragma mark Table view delegate

- (NSIndexPath *)tableView:(UITableView *)aTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CEPeoplePickerCell *cell = (CEPeoplePickerCell *)[aTableView cellForRowAtIndexPath:indexPath];
   
    ABRecordID iden = ABRecordGetRecordID(cell.person);
    ABMultiValueRef multiValues = ABRecordCopyValue(cell.person, kABPersonPhoneProperty);
    
   
    
    int count = ABMultiValueGetCount(multiValues);
    
    searchIndexPath=nil;
    
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {    
        [self.selectedValues removeObjectForKey:KEY_FOR_SELECTION(iden)];
        cell.accessoryType= UITableViewCellAccessoryNone;
        [self.selectedPeople removeObject:(id)cell.person];
        [cell setNeedsDisplay];        
    }else
    {
        if(self.navigationItem.prompt) //ensure prompt is clearing when user is selecting another contact
            self.navigationItem.prompt =nil;
        
        if(count>0)
        {
            if(count==1)
            {                
                CFStringRef  value=ABMultiValueCopyValueAtIndex(multiValues, 0);
              CFStringRef compositeName =ABRecordCopyCompositeName(cell.person);
                CFStringRef phoneType = ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(multiValues, 0));
               
                    // if([[value STRIP_TO_PHONE_NOS] length]>7)
                    //{
                    [self.selectedPeople addObject:(id)cell.person];
                NSMutableArray *arr=[NSMutableArray arrayWithObjects:(NSString *)compositeName,[self.formatter phonenumberformat:(NSString *)value withLocale:@"us"],(NSString *)phoneType, nil];
                if(value) CFRelease(value);
                if(compositeName)CFRelease(compositeName);
                if(phoneType)CFRelease(phoneType);
                
                    [self.selectedValues setObject:arr  forKey:KEY_FOR_SELECTION(iden)];
                    cell.accessoryType= UITableViewCellAccessoryCheckmark;
//                }else
//                {
//                    self.navigationItem.prompt=@"Invalid phone number";
//                    [self performSelector:@selector(hidePrompt) withObject:self afterDelay:3.0];                    
//                }
            }
            else //more than one
            {
                NSMutableArray *values = [NSMutableArray array];
                 NSMutableArray *labels = [NSMutableArray array];
                for(CFIndex i=0;i<count;i++)
                {
                    [values addObject:(NSString*)ABMultiValueCopyValueAtIndex(multiValues,i)];
                    [labels addObject:(NSString*)ABMultiValueCopyLabelAtIndex(multiValues,i)];
                }
                
                [self showActionSheet:labels values:values];
                
                searchIndexPath=cell;
            }
        }
//        else
//        {
//            self.navigationItem.prompt =@"No Contacts found.";
//        }
if(multiValues)
    CFRelease(multiValues);
    }
    return indexPath;
}

#pragma mark Action sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(!searchIndexPath)return;
    CEPeoplePickerCell *cell = searchIndexPath; //(CEPeoplePickerCell *)[self.tableView cellForRowAtIndexPath:searchIndexPath];    
    
    if(actionSheet.cancelButtonIndex == buttonIndex)
    {
        cell.accessoryType= UITableViewCellAccessoryNone;
        [cell setNeedsDisplay];
       //[self.selectedPeople removeObject:(id)cell.person];kABPersonPhoneProperty
    }else
    {
        if(cell.person){
            ABMultiValueRef multiValue = ABRecordCopyValue(cell.person, kABPersonPhoneProperty);
            CFStringRef value=ABMultiValueCopyValueAtIndex(multiValue, buttonIndex);
            CFStringRef compositeName =ABRecordCopyCompositeName(cell.person);
            CFStringRef phoneType = ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(multiValue, buttonIndex));
            
            //NSString *value =[actionSheet buttonTitleAtIndex:buttonIndex];
            //dictonary does not allow int to be keys - ??
            //if([[value STRIP_TO_PHONE_NOS] length]>7)
            //{
                cell.accessoryType= UITableViewCellAccessoryCheckmark;
                [cell setNeedsDisplay];
                [self.selectedPeople addObject:(id)cell.person];
                ABRecordID iden = ABRecordGetRecordID(cell.person);
            NSMutableArray *arr=[NSMutableArray arrayWithObjects:(NSString *)compositeName,[self.formatter phonenumberformat:(NSString *)value withLocale:@"us"],(NSString *)phoneType, nil];
           
            if(value)CFRelease(value);
            if(compositeName)CFRelease(compositeName);
            if(phoneType)CFRelease(phoneType);
            
            if(multiValue)CFRelease(multiValue);
            
                [self.selectedValues setObject:arr  forKey:KEY_FOR_SELECTION(iden)];
          }
    }

    searchIndexPath=nil;
}

-(void) hidePrompt
{
    self.navigationItem.prompt=nil;
}

-(void)showActionSheet:(NSArray *)lables values:(NSArray *)values
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:self.title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];

    for (int i=0; i<[values count];i++) {
        NSString *it = [lables objectAtIndex:i];
        if([it hasPrefix:@"_$!"])
        {
            NSString *label = [it substringFromIndex:4];
            label = [label substringToIndex:[label length]-4];
            NSString *text= [NSString stringWithFormat:@" %@ %@ ",label,[values objectAtIndex:i]];
            [actionSheet addButtonWithTitle:text];   
        }else
        {
            NSString *text= [NSString stringWithFormat:@" %@ %@ ",it,[values objectAtIndex:i]];
            [actionSheet addButtonWithTitle:text];   
        }
    }
        
    [actionSheet addButtonWithTitle:@"Cancel"];
     actionSheet.cancelButtonIndex = [values count];
    [actionSheet showInView:self.view];
    [actionSheet release];
}


@end


#pragma mark -
#pragma mark Cell implementation


@implementation CEPeoplePickerCell

@synthesize peoplePicker;
@dynamic person;

- (id)initWithPeoplePicker:(CEPeoplePickerController *)aPeoplePicker reuseIdentifier:(NSString *)reuseIdentifier
{
    
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.peoplePicker = aPeoplePicker;
	}
	return self;
}

- (void)dealloc
{
    self.peoplePicker = nil;
	self.person = NULL;
    [super dealloc];
}

#pragma mark Accessors

- (void)setPerson:(ABRecordRef)aPerson
{
    if (aPerson != person) {
        if (person)
            CFRelease(person);
        if (aPerson)
            CFRetain(aPerson);
        person = aPerson;
    }
}

- (ABRecordRef)person
{
    return person;
}
@end


#pragma mark -
#pragma mark Address book function implementations


static ABRecordRef CEABPersonCreateSectionBoundary(CFStringRef sectionName)
{
    // Lowercase are ordered before sorted uppercase. Ensure this is lowercase, so nothing sneaks before us.
    sectionName = (CFStringRef)[(NSString *)sectionName lowercaseString];
    
    ABRecordRef ret = ABPersonCreate();
    if (!ABRecordSetValue(ret, kABPersonOrganizationProperty, sectionName, NULL))
        [NSException raise:@"error" format:@"Cannot create section boundary for name %@", (NSString *)sectionName];
    return ret;
}

static CFComparisonResult CEABPersonComparePeopleByNameAndIsBoundary(ABRecordRef person1, ABRecordRef person2, CEABPersonComparePeopleByNameAndIsBoundaryArgs *args)
{
    CFComparisonResult ret = ABPersonComparePeopleByName(person1, person2, args->ordering);
    if (ret == NSOrderedSame) {
        BOOL person1IsBoundary = [args->boundaries containsObject:(id)person1];
        BOOL person2IsBoundary = [args->boundaries containsObject:(id)person2];
        
        if (person1IsBoundary == person2IsBoundary)
            return NSOrderedSame;
        else
            return person1IsBoundary ? NSOrderedAscending : NSOrderedDescending;
    } else {
        return ret;
    }
}
