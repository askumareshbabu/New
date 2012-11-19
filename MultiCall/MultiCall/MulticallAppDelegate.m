//
//  MulticallAppDelegate.m
//  MultiCall
//
//  Created by ipod Touch on 18/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MulticallAppDelegate.h"
#import "Model.h"
#import "Reachability.h"
#import <BugSense-iOS/BugSenseController.h>
@implementation MulticallAppDelegate

@synthesize window = _window;
@synthesize filepath;
@synthesize tabBarController = _tabBarController;


- (void)dealloc
{
    
    [_tabBarController release];
    [_window release];
    filepath=nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self loadCustomObject];
        self.window.rootViewController=self.tabBarController;
       
    [self.tabBarController setSelectedIndex:1];
    
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
   // [BugSenseController sharedControllerWithBugSenseAPIKey:@"2877294f"];
    [BugSenseController sharedControllerWithBugSenseAPIKey:@"2877294f"
                                            userDictionary:nil
                                           sendImmediately:YES];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [self saveCustomeObject];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    [self loadCustomObject];
    if(![[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
    [self performSelectorInBackground:@selector(updateChecker) withObject:self];
        
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [self saveCustomeObject];
}
-(void)loadCustomObject
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData *myEncodedData=[defaults objectForKey:@"multicallmodel"];
    [NSKeyedUnarchiver unarchiveObjectWithData:myEncodedData];
}
-(void)saveCustomeObject
{
    
    NSUserDefaults *defaluts=[NSUserDefaults standardUserDefaults];
    NSData *myEncodingData=[NSKeyedArchiver archivedDataWithRootObject:[Model singleton]];
    [defaluts setObject:myEncodingData forKey:@"multicallmodel"];
    [defaluts synchronize];
}
-(void)updateChecker
{
       NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"checking for update");
        //  NSData *plistData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://mindssoft.net/MultiCall_Test/iPhone/MultiCallUpdateChecker.plist"]];
     NSData *plistData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://122.165.33.168/iphoneMC/MultiCallUpdateChecker.plist"]];
    
    if (plistData) {
        NSLog(@"finished checking for update");
        NSError *error;
        NSPropertyListFormat format;
        NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:&format error:&error];
        if (plist) {
            NSArray *items = [plist valueForKey:@"items"];
            NSDictionary *dictionary=[[[NSDictionary alloc]init]autorelease];
            if ([items count] > 0) {
                dictionary = [items objectAtIndex:0];
            }
            NSDictionary *metaData = [dictionary objectForKey:@"metadata"];
            
            NSString * buildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]; //get Build Version
            NSString * currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]; //get Version 
            
            NSString * newVersion = [metaData objectForKey:@"bundle-version"];
            NSString *newBuildVersion=[metaData objectForKey:@"Build-version"];
            
                //  NSString *title = [NSString stringWithFormat:@"MultiCall new version %@ now available", newVersion];
            NSString *title = [NSString stringWithFormat:@"New version of MultiCall is available"];
            NSString *releaseNotes=[metaData objectForKey:@"releasenotes"];
            NSString *message = [NSString stringWithFormat:@"What's New:\n%@", releaseNotes];
            NSString *URL=[metaData objectForKey:@"filepath"];
            
            filepath=[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",URL];
                //  NSLog(@"filepath %@",filepath);
            
            NSLog(@"newVersion: %@, currentVersion: %@ ,%@ ", newVersion, currentVersion,buildVersion);
            if (![newVersion isEqualToString:currentVersion] || ![buildVersion isEqualToString:newBuildVersion]) {
                [filepath retain];
                    //NSLog(@"A new update is available");
                   
                    // http://stackoverflow.com/questions/945082/uiwebview-in-multithread-viewcontroller
                dispatch_async(dispatch_get_main_queue(), ^{
                        // do work here
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                                message:@"\n\n\n\n\n\n\n\n Do you want to update ? "
                                                               delegate:self
                                                      cancelButtonTitle:@"Not Now"
                                                      otherButtonTitles:@"Update", nil];
                UIView *vi=[[[UIView alloc]initWithFrame:CGRectMake(10, 60, 270, 160)]autorelease];
                UITextView *txt=[[[UITextView alloc]initWithFrame:CGRectMake(0, 0, 264,160)]autorelease];
                txt.editable=NO;
                txt.font=[UIFont fontWithName:@"Helveitcal" size:16.0];
                txt.textAlignment=UITextAlignmentLeft;
                txt.text=message;
                [vi addSubview:txt];
                [alert addSubview:vi];
                [alert show];
                    [alert release];
                    });
                
            }
                //else
                    // NSLog(@"app uptodate");
        }
    }
    [pool release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
       
            
            //NSLog(@"downloading full update URL %@",filepath);
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=http://www.mindssoft.net/MultiCall_Test/iPhone/MultiCall_Inhouse.plist"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:filepath]];
            [filepath release];
        
    }

}


@end
