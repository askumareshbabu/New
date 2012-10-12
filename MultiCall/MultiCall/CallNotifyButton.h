#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/**
 UI for showing the status of the calls in CallView(Multicall).
 @see CallView
 */
@interface CallNotifyButton : UIButton {
    
    bool isPlain;
}


@property (nonatomic, assign) int callStatus;

- (void)reload;
- (void)plain;
@end
