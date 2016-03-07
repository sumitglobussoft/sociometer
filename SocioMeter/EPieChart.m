//
//  EPieChart.m
//  EChartDemo
//
//  Created by Efergy China on 24/1/14.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//
/*
 //------------Logic used to draw graph First layer is defined=2 to 108 second Layer used 108 to 208,Third Layer= 208 to 358.ePieChartDataModel.current display to the Addiction Score and degreeToPlotOnGraph display the degree o0f endAngel.
 */
#import "EPieChart.h"
#import "EColor.h"
#import "UICountingLabel.h"
#import "SettingsViewController.h"
#import "Singletoneclass.h"

@implementation EPieChart
@synthesize frontPie = _frontPie;
@synthesize backPie = _backPie;
@synthesize isUpsideDown = _isUpsideDown;
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
@synthesize ePieChartDataModel = _ePieChartDataModel;
@synthesize motionEffectOn = _motionEffectOn;

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame ePieChartDataModel:nil];
}

- (id)initWithFrame:(CGRect)frame ePieChartDataModel:(EPieChartDataModel *)ePieChartDataModel
{
    //let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
    self = [super initWithFrame:frame];
    if (self)
    {
            //EPieChartDataModel *ePieChartDataModel = [[EPieChartDataModel alloc] initWithBudget:180 current:70 estimate:77];
      _isUpsideDown = NO;
        
            _ePieChartDataModel = ePieChartDataModel;
            _frontPie = [[EPie alloc] initWithCenter: CGPointMake(CGRectGetWidth(self.bounds) / 2.3, CGRectGetHeight(self.bounds) -80)
                                              radius: MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 1.8
                                  ePieChartDataModel: _ePieChartDataModel];
        _frontPie.layer.shadowOffset = CGSizeMake(0, 3);
        _frontPie.layer.shadowRadius = 5;
        _frontPie.layer.shadowColor = EGrey.CGColor;
        _frontPie.layer.shadowOpacity = 0.8;
        [self addSubview:_frontPie];
        

   
    }
    return self;
}


@end


@interface EPie ()
{
    CABasicAnimation *drawAnimation;
    CAGradientLayer *gradientLayer;
}

@property (nonatomic, strong) CAShapeLayer *circleBudget;
@property (nonatomic, strong) CAShapeLayer *circleCurrent;
@property (nonatomic, strong) CAShapeLayer *circleEstimate;
@property (nonatomic, strong) CAShapeLayer *firstLayer;
@property (nonatomic, strong) CAShapeLayer *secondLayer;
@property(nonatomic,strong) CAShapeLayer *thirdLayer;
@property (nonatomic) CGPoint center;
@property(nonatomic,strong)CAShapeLayer *halfCircel;

@end

@implementation EPie
@synthesize ePieChartDataModel = _ePieChartDataModel;
@synthesize circleBudget = _circleBudget;
@synthesize circleCurrent = _circleCurrent;
@synthesize circleEstimate = _circleEstimate;
@synthesize center = _center;
@synthesize radius = _radius;
@synthesize budgetColor = _budgetColor;
@synthesize currentColor = _currentColor;
@synthesize estimateColor = _estimateColor;
@synthesize lineWidth = _lineWidth;
@synthesize contentView = _contentView;
@synthesize halfCircel = halfCircel;
@synthesize firstLayer,secondLayer,thirdLayer;


- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radius
{
    self = [super initWithFrame:CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2)];
    self = [super initWithFrame:CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2)];
    if (self)
    {
        //self.clipsToBounds = YES;
        _center = center;
        _radius = radius;
        
       // self.backgroundColor =[UIColor greenColor];
        self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2.0;

    }
    return self;
}

- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radius
  ePieChartDataModel:(EPieChartDataModel *)ePieChartDataModel
{
    self = [super initWithFrame:CGRectMake(center.x - 80, center.y - radius, radius * 2, radius * 2)];
    if (self)
    {
        //self.point=100;
        
       // ePieChartDataModel.budget=3.6*self.point;
        //self.clipsToBounds = YES;
        /** Default settings*/
        _budgetColor = Eblue;
        
        _currentColor=startColorGreen;
       // _estimateColor = [EYellow colorWithAlphaComponent:0.3];;
        _lineWidth = radius / 6;
        _center = center;
        _radius = radius;
        //self.backgroundColor = EGreen;
        //self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2.0;
        _ePieChartDataModel = ePieChartDataModel;
        
        /** Default Content View*/
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
       // _contentView.clipsToBounds = YES;
        
        UILabel *title = [[UILabel alloc] initWithFrame:self.frame];
        title.text = [self languageSelectedStringForKey:@"Addiction Score"];
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont systemFontOfSize:12];
        title.textColor = [UIColor blackColor];
        title.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) );
        [self.contentView addSubview:title];

        UICountingLabel *estimateLabel = [[UICountingLabel alloc] initWithFrame:self.frame];
        estimateLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) * 1.4);
        estimateLabel.textAlignment = NSTextAlignmentCenter;
        estimateLabel.textColor = [UIColor blackColor];
        estimateLabel.format = @"%d";
        [_contentView addSubview:estimateLabel];
        [estimateLabel countFrom:0 to:ePieChartDataModel.current];
       
        [self reloadContent:ePieChartDataModel.budget];
        
    }
    return self;
}

-(NSString*) languageSelectedStringForKey:(NSString*) key
{
    
    NSString *path;
    
    if([[Singletoneclass sharedSingleton].languageChanged isEqualToString:@"English"])
        path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    
    else if([[Singletoneclass sharedSingleton].languageChanged isEqualToString:@"Arabic"])
        path = [[NSBundle mainBundle] pathForResource:@"ar" ofType:@"lproj"];
    else{
        path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    }
    NSBundle* languageBundle = [NSBundle bundleWithPath:path];
    NSString* str=[languageBundle localizedStringForKey:key value:@"" table:nil];
    return str;
    
}

- (void)reloadContent:(CGFloat)degreeToPlotOnGraph
{
 
    self.point=degreeToPlotOnGraph*100/360;
   
    //---------
    UIBezierPath* circleBudgetPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                                    radius: _radius * 0.8
                                                                startAngle: 0
                                                                  endAngle: 2 * M_PI
                                                                 clockwise:NO];
    
    if (!_circleBudget)
    _circleBudget = [CAShapeLayer layer];
    _circleBudget.path = circleBudgetPath.CGPath;
    _circleBudget.fillColor = [UIColor clearColor].CGColor;
    _circleBudget.strokeColor = _budgetColor.CGColor;
    _circleBudget.lineCap = kCALineCapRound;
    _circleBudget.lineWidth = _lineWidth;
    _circleBudget.zPosition = -1;


    if (degreeToPlotOnGraph <108 && degreeToPlotOnGraph!=0)
    {
        
        [self firstLayerAction:degreeToPlotOnGraph];

        //[firstLayer addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    }
    else if (degreeToPlotOnGraph>108 && degreeToPlotOnGraph <208)
    {
        
        [firstLayer addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
        [self firstLayerAction:108];

        [self performSelector:@selector(secondLayerAction:) withObject:[NSNumber numberWithFloat:degreeToPlotOnGraph] afterDelay:2.50];
    }
    else if (degreeToPlotOnGraph>208)
    {
        [self firstLayerAction:108];

        [firstLayer addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
        [self performSelector:@selector(secondLayerAction:) withObject:[NSNumber numberWithFloat:208] afterDelay:2.50];
        [self performSelector:@selector(thirdLayerAction:) withObject:[NSNumber numberWithFloat:360] afterDelay:2.50*2];
    }

    [self.layer addSublayer:_circleBudget];

//    [firstLayer addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
//    [self performSelector:@selector(secondLayerAction) withObject:nil afterDelay:2.50];
//    [self performSelector:@selector(thirdLayerAction) withObject:nil afterDelay:2.50*2];
    
    if (_contentView)
    {
        [self addSubview:_contentView];
    }
    
}



-(void)firstLayerAction:(CGFloat)endDegree
{
    
    
    //int endPoint=M_PI*budget/180;
    
    firstLayer = [CAShapeLayer layer];
    firstLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                     radius: _radius * 0.8
                                                 startAngle:2*M_PI/180
                                                   endAngle:endDegree*M_PI/180
                                                  clockwise:YES].CGPath;
    //self.point*M_PI/180
    
    firstLayer.fillColor = [UIColor clearColor].CGColor;
    firstLayer.strokeColor = [UIColor greenColor].CGColor;
    firstLayer.lineWidth = 15;
    //-----
    drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = 10.0; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 0.0;  // Animate only once..
    drawAnimation.removedOnCompletion = NO;   // Remain stroked after the animation..
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:10.0f];
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [firstLayer addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    //-----
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    CGColorRef green=[UIColor colorWithRed:(CGFloat)8/255 green:(CGFloat)138/255 blue:(CGFloat)41/255 alpha:1].CGColor;
    CGColorRef yellow=[UIColor colorWithRed:(CGFloat)255/255 green:(CGFloat)194/255 blue:(CGFloat)0/255 alpha:1].CGColor;
    CGColorRef redColor=[UIColor redColor].CGColor;
    gradientLayer.colors = @[(__bridge id)redColor,(__bridge id)yellow,(__bridge id)green,(__bridge id)yellow,(__bridge id)green];
    gradientLayer.startPoint = CGPointMake(0,0.6);
    gradientLayer.endPoint = CGPointMake(1,0.9);
    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0],
                               [NSNumber numberWithFloat:0.5],
                               [NSNumber numberWithFloat:0.8],
                               nil];
    [_circleBudget addSublayer:gradientLayer];
     [_circleBudget addSublayer:firstLayer];
    gradientLayer.mask = firstLayer;
   
}
-(void)secondLayerAction:(NSNumber*)endDegree{
    secondLayer = [CAShapeLayer layer];
    secondLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                      radius: _radius * 0.8
                                                  startAngle:108*M_PI/180
                                                    endAngle:endDegree.floatValue*M_PI/180
                                                   clockwise:YES].CGPath;
    
    secondLayer.fillColor = [UIColor clearColor].CGColor;
    secondLayer.strokeColor = [UIColor greenColor].CGColor;
    secondLayer.lineWidth = 15;
    //-----
    CABasicAnimation *secondAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    secondAnimation.duration            = 10.0; // "animate over 10 seconds or so.."
    secondAnimation.repeatCount         = 1.0;  // Animate only once..
    secondAnimation.removedOnCompletion = NO;   // Remain stroked after the animation..
    secondAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    secondAnimation.toValue   = [NSNumber numberWithFloat:10.0f];
    secondAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [secondLayer addAnimation:secondAnimation forKey:@"drawCircleAnimation"];
    //-----
    CAGradientLayer *secondgradientLayer = [CAGradientLayer layer];
    secondgradientLayer.frame = self.bounds;
    CGColorRef green=[UIColor colorWithRed:(CGFloat)8/255 green:(CGFloat)138/255 blue:(CGFloat)41/255 alpha:1].CGColor;
    CGColorRef yellow=[UIColor colorWithRed:(CGFloat)255/255 green:(CGFloat)194/255 blue:(CGFloat)0/255 alpha:1].CGColor;
    secondgradientLayer.colors = @[(__bridge id)green,(__bridge id)yellow,];
    secondgradientLayer.startPoint = CGPointMake(0.5,1);
    secondgradientLayer.endPoint = CGPointMake(0,0);
    secondgradientLayer.locations = [NSArray arrayWithObjects:
                                     [NSNumber numberWithFloat:0],
                                     [NSNumber numberWithFloat:0.0],
                                     [NSNumber numberWithFloat:0.6],
                                     nil];
    [_circleBudget addSublayer:secondgradientLayer];
    [_circleBudget addSublayer:secondLayer];
    secondgradientLayer.mask = secondLayer;

    
}
-(void)thirdLayerAction:(NSNumber*)endDegree{
    thirdLayer = [CAShapeLayer layer];
    thirdLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                     radius: _radius * 0.8
                                                 startAngle:208*M_PI/180
                                                   endAngle:endDegree.floatValue*M_PI/180
                                                  clockwise:YES].CGPath;
    
    thirdLayer.fillColor = [UIColor clearColor].CGColor;
    thirdLayer.strokeColor = [UIColor greenColor].CGColor;
    thirdLayer.lineWidth = 15;
    //-----
    CABasicAnimation *thirdDrawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    thirdDrawAnimation.duration            = 10.0; // "animate over 10 seconds or so.."
    thirdDrawAnimation.repeatCount         = 1.0;  // Animate only once..
    thirdDrawAnimation.removedOnCompletion = NO;   // Remain stroked after the animation..
    thirdDrawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    thirdDrawAnimation.toValue   = [NSNumber numberWithFloat:10.0f];
    thirdDrawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [thirdLayer addAnimation:thirdDrawAnimation forKey:@"drawCircleAnimation"];
    //-----
    CAGradientLayer *thirdGradientLayer = [CAGradientLayer layer];
    thirdGradientLayer.frame = self.bounds;
    CGColorRef yellow=[UIColor colorWithRed:(CGFloat)255/255 green:(CGFloat)194/255 blue:(CGFloat)0/255 alpha:1].CGColor;
    CGColorRef redColor=[UIColor redColor].CGColor;
    thirdGradientLayer.colors =@[(__bridge id)yellow,(__bridge id)redColor];
    thirdGradientLayer.startPoint = CGPointMake(0.15,1);
    thirdGradientLayer.endPoint = CGPointMake(1,1);
    thirdGradientLayer.locations = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0],
                                    [NSNumber numberWithFloat:1.0],
                                    [NSNumber numberWithFloat:0.9],
                                    nil];
    [_circleBudget addSublayer:thirdLayer];
    thirdGradientLayer.mask = thirdLayer;
    [_circleBudget addSublayer:thirdGradientLayer];
    
}




- (void) reloadContentWithEPieChartDataModel:(EPieChartDataModel *)ePieChartDataModel
{
    
    _ePieChartDataModel = ePieChartDataModel;
    [self reloadContent];
}

@end


@implementation EPieChartDataModel
@synthesize current = _current;
@synthesize budget = _budget;
@synthesize estimate = _estimate;


- (id)init
{
    self = [super init];
    if (self)
    {
        _budget = 100;
        _current = 40;
        _estimate = 80;
    }
    return self;
}

- (id)initWithBudget:(CGFloat) budget
             current:(CGFloat) current
            estimate:(CGFloat) estimate
{
    self = [self init];
    if (self)
    {
        _budget = budget;
        _current = current;
        _estimate = estimate;
    }
    return self;
}



@end
