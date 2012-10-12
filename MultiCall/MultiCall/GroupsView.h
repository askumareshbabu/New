//
//  GroupsView.h
//  MultiCall
//
//  Created by ipod Touch on 25/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GroupModel;
@class Model;

@interface GroupsView : UIViewController
{
    Model * model;
    GroupModel * groupModel;
    NSMutableArray *groupindex;
    NSMutableArray *groupNameArray;
    @public
    bool isPickMode;
    UINavigationController *callViewPicker;
    
}
@property(nonatomic,retain) id delegate;
@property(retain,nonatomic)NSMutableArray *groupindex;
@property(retain,nonatomic)NSMutableArray *groupNameArray;
@property(nonatomic,retain)NSIndexPath *deleteIndexPath;

@end
