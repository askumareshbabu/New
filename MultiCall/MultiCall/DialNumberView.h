//
//  DialNumberView.h
//  MultiCall
//
//  Created by ipod Touch on 18/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialNumberView : UIViewController<UITextFieldDelegate>
{
    int rowCount;
    int rowstyle;
    int textControlEvent;
}
@property(nonatomic,retain)id delegate;
@property(nonatomic,retain)NSMutableArray *arrayRowCount;
@property(nonatomic,retain)NSMutableArray *saveDialArray;
@property(nonatomic,retain)NSMutableArray *textFieldTagList;
@property(retain,nonatomic)UITextField *txtDialNumber;
@property(readwrite,nonatomic)NSUInteger editingRowIndex;
-(void)addContactToModel:(NSString *)name contactInfo:(NSString *)contactInfo contactType:(NSString *)contactType personId:(int)personId;
- (void)textFieldDidChange:(UITextField *)source;
@end
