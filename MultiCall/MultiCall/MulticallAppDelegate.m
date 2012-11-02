//
//  MulticallAppDelegate.m
//  MultiCall
//
//  Created by ipod Touch on 18/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MulticallAppDelegate.h"
#import "Model.h"

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
    [self updateChecker];
    // Override point for customization after application launch.
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
    [self updateChecker];
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
    NSLog(@"checking for update");
    NSData *plistData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://mindssoft.net/MultiCall_Test/iPhone/MultiCallUpdateChecker.plist"]];
    if (plistData) {
        NSLog(@"finished checking for update");
        NSError *error;
        NSPropertyListFormat format;
        NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:&format error:&error];
        if (plist) {
            NSArray *items = [plist valueForKey:@"items"];
            NSDictionary *dictionary;
            if ([items count] > 0) {
                dictionary = [items objectAtIndex:0];
            }
            NSDictionary *metaData = [dictionary objectForKey:@"metadata"];
            
            NSString * buildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]; //get Build Version
            NSString * currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]; //get Version 
            
            NSString * newVersion = [metaData objectForKey:@"bundle-version"];
            NSString *newBuildVersion=[metaData objectForKey:@"Build-version"];
            
            NSString *title = [NSString stringWithFormat:@"MultiCall new version %@ Now Available", newVersion];
            NSString *releaseNotes=[metaData objectForKey:@"releasenotes"];
            NSString *message = [NSString stringWithFormat:@"New in this version:\n%@", releaseNotes];
            NSString *URL=[metaData objectForKey:@"filepath"];
            
            filepath=[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",URL];
             NSLog(@"filepath %@",filepath);
            [filepath retain];
            NSLog(@"newVersion: %@, currentVersion: %@ ,%@ ", newVersion, currentVersion,buildVersion);
            if (![newVersion isEqualToString:currentVersion] || ![buildVersion isEqualToString:newBuildVersion]) {
                
                NSLog(@"A new update is available");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Not now" otherButtonTitles:@"UPDATE", nil];
                
                [alert show];
            }
        }
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
       
            
            NSLog(@"downloading full update URL %@",filepath);
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=http://www.mindssoft.net/MultiCall_Test/iPhone/MultiCall_Inhouse.plist"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:filepath]];
        
    }
    [filepath release];
}


@end
