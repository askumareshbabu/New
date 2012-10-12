//
//  Message.m
//  MultiCall
//
//  Created by ipod Touch on 20/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomMessageClass.h"

@implementation CustomMessageClass
@synthesize MessageContent;


    //Project Message List information ,error,warning Message List

-(void)CustomMessage:(NSString *)ScreenName MessageNo:(NSString *)MessageNo
{
        // Screen Name 1 = MultiCall 2=Recents 3= Groups 4=Settings 5=Network 6=Callmeon
    NSString * titleName=@"";
   
    if([ScreenName isEqualToString:@"1"])
    {
        if([MessageNo isEqualToString:@"1"])
        {
            titleName=@"Settings";
            MessageContent=@"Please update 'Settings' before making a MultiCall.";
        }
        
        else if([MessageNo isEqualToString:@"2"])
        {
            titleName=@"Settings";
            MessageContent =@"Pin number is invalid. Please check your settings";
        }
        
        else if([MessageNo isEqualToString:@"3"])
        {
            titleName=@"MultiCall";
            MessageContent =@"Unable to make MultiCall. Please connect to a WiFi or use a 3G connection.";
        }
        else if([MessageNo isEqualToString:@"4"])
        {
            titleName=@"MultiCall";
            MessageContent =@"Please Add numbers in 'Callmeon' before making a MultiCall.";
        }
        
        
    }
    if([ScreenName isEqualToString:@"3"])
    {
        if([MessageNo isEqualToString:@"1"])
        {
            titleName=@"Groups";
            MessageContent =@"Please enter Group Name.";
        }
        else if([MessageNo isEqualToString:@"2"])
        {
            titleName=@"Groups";
            MessageContent =@"Group created successfully.";
        }
        else if([MessageNo isEqualToString:@"3"])
        {
            titleName=@"Groups";
            MessageContent =@"Group updated successfully.";
        }
        else if([MessageNo isEqualToString:@"4"])
        {
            titleName=@"Groups";
            MessageContent =@"Group name already exists.";
        }
       
        
        
    }
    if([ScreenName isEqualToString:@"4"])
    {
        if([MessageNo isEqualToString:@"1"])
        {
            titleName=@"Settings";
            MessageContent =@"Please enter Pin number.";
        }
        else if([MessageNo isEqualToString:@"2"])
        {
            titleName=@"Settings";
            MessageContent =@"Please enter phone number.";
        }
        else if([MessageNo isEqualToString:@"3"])
        {
            titleName=@"Settings";
            MessageContent =@"Invalid phone number.";
        }
        else if([MessageNo isEqualToString:@"4"])
        {
            titleName=@"Settings";
            MessageContent =@"Settings saved successfully.";
        }
        else if([MessageNo isEqualToString:@"5"])
        {
            titleName=@"Settings";
            MessageContent =@"Invalid Pin Number";
        }

        
        
    }
    if([ScreenName isEqualToString:@"5"])
    {
         if([MessageNo isEqualToString:@"1"])
        {
            titleName=@"Settings";
            MessageContent =@"Pin number is invalid. Please check your settings.";
        }
         else if([MessageNo isEqualToString:@"2"])
         {
             titleName=@"MultiCall";
             MessageContent =@"Conference is already running";
         }
         else if([MessageNo isEqualToString:@"3"])
         {
             titleName=@"MultiCall";
             MessageContent =@"MultiCall server unreachable. Please try again later.";
         }
         else if([MessageNo isEqualToString:@"4"])
         {
             titleName=@"MultiCall";
             MessageContent =@"Unable to end MultiCall.Please connect to a WiFi or use a 3G connection";
         }
         else if([MessageNo isEqualToString:@"5"])
         {
             titleName=@"MultiCall";
             MessageContent =@"Unable to make MultiCall. Please connect to a WiFi or use a 3G connection.";
         }
         else if([MessageNo isEqualToString:@"6"])
         {
             titleName=@"MultiCall";
             MessageContent =@"Please hang up the phone call";
         }
         else if([MessageNo isEqualToString:@"7"])
         {
             titleName=@"MultiCall";
             MessageContent =@"Invalid request";
         }
       
    }
    if([ScreenName isEqualToString:@"6"])
    {
        if([MessageNo isEqualToString:@"1"])
        {
            titleName=@"Call me on";
            MessageContent =@"Click Edit to add Phone Numbers";
        }
    }
    
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:titleName
                                       message:MessageContent delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] ;
    [alert show];
    [alert release];  
    
}

-(NSString *)currentTime
{    
        //Get current time
    NSString * strCurrentTime;
    NSDate* now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    NSInteger hour = [dateComponents hour];
    NSString *am_OR_pm=@"AM";
    
    if (hour>12)
    {
        hour=hour%12;
        
        am_OR_pm = @"PM";
    }
    
    NSInteger minute = [dateComponents minute];
    NSInteger second = [dateComponents second];
    [gregorian release];
    strCurrentTime=[NSString stringWithFormat:@"%02d:%02d:%02d %@", hour, minute, second,am_OR_pm];
    NSLog(@"Current Time  %@",[NSString stringWithFormat:@"%02d:%02d:%02d %@", hour, minute, second,am_OR_pm]);
    return strCurrentTime;
}

@end
