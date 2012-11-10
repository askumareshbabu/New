//
//  main.m
//  MultiCall
//
//  Created by ipod Touch on 18/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MulticallAppDelegate.h"

int main(int argc, char *argv[])
{
//    @autoreleasepool {
//        
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([MulticallAppDelegate class]));
//    }
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    
    return retVal;
}
