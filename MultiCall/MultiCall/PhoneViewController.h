//
//  PhoneViewController.h
//  MultiCall
//
//  Created by Kumaresh on 14/09/12.
//
//

#import <UIKit/UIKit.h>
#import "DialNumberModel.h"

@class DialNumberModel;
@class  Model;
@interface PhoneViewController : UIViewController<UITextFieldDelegate>
{
    UITextField * txtDialNumber;
    int  lastIndexPathrow;
    Model *model;
    NSString * edit;
}


@property(retain,nonatomic)NSMutableArray *insertArray;
@property(retain,nonatomic)NSMutableArray *numberarray;
@property(retain,nonatomic)NSIndexPath * insertingIndexPath;
@property(retain,nonatomic)NSIndexPath * editingIndexPath;
@property(retain,nonatomic)UITextField * txtDialNumber;

@property(retain,nonatomic)DialNumberModel * dialNumberModel;

@property (retain, nonatomic) IBOutlet UITableView *phoneTableView;
@property(nonatomic,assign)int row;
@property(retain,nonatomic)id delegate;


-(void)addContactToModel:(NSString *)name contactInfo:(NSString *)contactInfo contactType:(NSString *)contactType personId:(int)personId
;

@end
