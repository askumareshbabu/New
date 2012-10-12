#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/**
 UI for showing the status of the calls in CallView(Multicall).
 @see CallView
 */
@interface CallNotifyButton : UIButton {
    UIColor *_highColor;
    UIColor *_lowColor;
    CAGradientLayer* _gradientLayer;
	CAGradientLayer* _glossyLayer;
    bool isPlain;
}

@property (nonatomic, retain) UIColor *_highColor;
@property (nonatomic, retain) UIColor *_lowColor;
@property (nonatomic, assign) int callStatus;

-(void)grayColor;
-(void)orangeColor;
-(void)greenColor;
-(void)redColor;
- (void)reload;
- (void)plain;
@end
