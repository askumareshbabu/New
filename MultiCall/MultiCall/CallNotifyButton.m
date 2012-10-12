#import "CallNotifyButton.h"

@implementation CallNotifyButton

@synthesize _highColor;
@synthesize _lowColor;
@synthesize callStatus=_callStatus;

- (id)init {
    self = [super init];
    if (self) {
        _gradientLayer=nil;
        isPlain=NO;
        
    }
    return self;
}

/**
 Some components are commented out as not needed by c3ware
 */
-(void)grayColor
{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self._highColor =[UIColor grayColor];
//    self._lowColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.8];
    self.layer.borderWidth = 1.0f;
    
}

-(void)orangeColor
{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self._highColor =[UIColor orangeColor];
//    self._lowColor = [UIColor colorWithRed:0.87 green:0.45 blue:0.00 alpha:0.8];
    self.layer.borderWidth = 1.0f;
    
}

-(void)greenColor
{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self._highColor =[UIColor greenColor];
//    self._lowColor = [UIColor colorWithRed:0.66 green:0.96 blue:0.66 alpha:1.0];
    self.layer.borderWidth = 1.0f;
    
}

-(void)redColor
{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self._highColor = [UIColor redColor ];
//    self._lowColor = [UIColor colorWithRed:0.96 green:0.49 blue:0.49 alpha:1.0];
    self.layer.borderWidth = 1.0f;
   
}

-(void)plain
{
//    self._highColor=[UIColor clearColor];
//    self._lowColor=[UIColor clearColor];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.layer.borderWidth = 0.0f; 
    self.titleLabel.font =  [UIFont fontWithName:@"Helvetica" size:11.0];
}

 /*
- (void)drawRect:(CGRect)rect
{
   
//    if(!_gradientLayer)
//    {
//        _gradientLayer = [[CAGradientLayer alloc] init];
//        _gradientLayer.bounds = self.bounds;
//        
//        _gradientLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
//        [self.layer insertSublayer:_gradientLayer atIndex:0];
//        
//        _glossyLayer = [[CAGradientLayer alloc] init];
//        _glossyLayer.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/2);
//        _glossyLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/4);
//        [self.layer addSublayer:_glossyLayer];
//        
//        self.layer.cornerRadius = 5.0f; 
//        self.clipsToBounds = NO;
//        self.layer.masksToBounds = YES;
//    }
//    
//    if (_highColor && _lowColor)
//    {
//        [_gradientLayer setColors:[NSArray arrayWithObjects:(id)[_highColor CGColor], (id)[_lowColor CGColor], nil]];
//    }
//    
//    [_glossyLayer setColors: [NSArray arrayWithObjects: 
//	  (id)[[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.99f] CGColor]
//	  , (id)[[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.2f] CGColor], nil]];
    
    [super drawRect:rect];
}
  */

- (void)reload
{
   [[self layer] setNeedsDisplay];
}

- (void)dealloc {
    [_highColor release];
    [_lowColor release];
    [_gradientLayer release];
    [_glossyLayer release];
    [super dealloc];
}

@end
