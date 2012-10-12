#import "CallNotifyButton.h"

@implementation CallNotifyButton


@synthesize callStatus=_callStatus;

- (id)init {
    self = [super init];
    if (self) {
    
        isPlain=NO;
        
    }
    return self;
}



-(void)plain
{

    [self setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.layer.borderWidth = 0.0f;

    self.titleLabel.font =  [UIFont fontWithName:@"Helvetica" size:15.0];
}

 - (void)reload
{
   [[self layer] setNeedsDisplay];
}

- (void)dealloc {
    
    [super dealloc];
}

@end
