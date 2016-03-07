//
//  EColumnChart.m
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import "EColumnChart.h"
#import "EColor.h"
#import "EColumnChartLabel.h"
#import "EFloatBox.h"
#import "Singletoneclass.h"
#define BOTTOM_LINE_HEIGHT 2
#define HORIZONTAL_LINE_HEIGHT 1
#define Y_COORDINATE_LABEL_WIDTH 30
#define DIRECTION  (_columnsIndexStartFromLeft? - 1 : 1)


@interface EColumnChart()

@property (strong, nonatomic) NSMutableDictionary *eColumns;
@property (strong, nonatomic) NSMutableDictionary *eLabels;
@property (strong, nonatomic) EColumn *fingerIsInThisEColumn;
@property (nonatomic) float fullValueOfTheGraph;
@property (strong, nonatomic)EColumnChartLabel *eColumnChartLabel;
@end

@implementation EColumnChart
@synthesize columnsIndexStartFromLeft = _columnsIndexStartFromLeft;
@synthesize showHighAndLowColumnWithColor = _showHighAndLowColumnWithColor;
@synthesize fingerIsInThisEColumn = _fingerIsInThisEColumn;
@synthesize minColumnColor = _minColumnColor;
@synthesize maxColumnColor = _maxColumnColor;
@synthesize normalColumnColor = _normalColumnColor;
@synthesize eColumns = _eColumns;
@synthesize eLabels = _eLabels;
@synthesize leftMostIndex = _leftMostIndex;
@synthesize rightMostIndex = _rightMostIndex;
@synthesize showHorizontalLabelsWithInteger = _showHorizontalLabelsWithInteger;
@synthesize fullValueOfTheGraph = _fullValueOfTheGraph;
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize totalColumnsRequired;
@synthesize totalColumns;
#pragma -mark- Setter and Getter
- (void)setDelegate:(id<EColumnChartDelegate>)delegate
{
    if (_delegate != delegate)
    {
        _delegate = delegate;
        
        if (![_delegate respondsToSelector:@selector(eColumnChart: didSelectColumn:)])
        {
            NSLog(@"@selector(eColumnChart: didSelectColumn:) Not Implemented!");
            return;
        }
        
        if (![_delegate respondsToSelector:@selector(eColumnChart:fingerDidEnterColumn:)])
        {
            NSLog(@"@selector(eColumnChart:fingerDidEnterColumn:) Not Implemented!");
            return;
        }
        
        if (![_delegate respondsToSelector:@selector(eColumnChart:fingerDidLeaveColumn:)])
        {
            NSLog(@"@selector(eColumnChart:fingerDidLeaveColumn:) Not Implemented!");
            return;
        }
        
        if (![_delegate respondsToSelector:@selector(fingerDidLeaveEColumnChart:)])
        {
            NSLog(@"@selector(fingerDidLeaveEColumnChart:) Not Implemented!");
            return;
        }
    }
}

- (void)setDataSource:(id<EColumnChartDataSource>)dataSource
{
    if (_dataSource != dataSource)
    {
        _dataSource = dataSource;
        
        if (![_dataSource respondsToSelector:@selector(numberOfColumnsInEColumnChart:)])
        {
            NSLog(@"@selector(numberOfColumnsInEColumnChart:) Not Implemented!");
            return;
        }
        
        if (![_dataSource respondsToSelector:@selector(numberOfColumnsPresentedEveryTime:)])
        {
            NSLog(@"@selector(numberOfColumnsPresentedEveryTime:) Not Implemented!");
            return;
        }
        
        if (![_dataSource respondsToSelector:@selector(highestValueEColumnChart:)])
        {
            NSLog(@"@selector(highestValueEColumnChart:) Not Implemented!");
            return;
        }
        
        if (![_dataSource respondsToSelector:@selector(eColumnChart:valueForIndex:)])
        {
            NSLog(@"@selector(eColumnChart:valueForIndex:) Not Implemented!");
            return;
        }
        int numberOfVerticalLabel;
        if(self.showHorizontalLabelsWithInteger)
        {
            numberOfVerticalLabel=8;
        }
        else
        {
            numberOfVerticalLabel=10;
        }
       
            EColumnDataModel * dataModelForMaxValue=[_dataSource highestValueEColumnChart:self];
            
            totalColumnsRequired = [_dataSource numberOfColumnsPresentedEveryTime:self];
            totalColumns = [_dataSource numberOfColumnsInEColumnChart:self];
            /** Currently only support columns layout from right to left, WILL ADD OPTIONS LATER*/
            if (_columnsIndexStartFromLeft)
            {
                _leftMostIndex = 0;
                _rightMostIndex = _rightMostIndex + totalColumnsRequired - 1;
            }
            else
            {
                _rightMostIndex = 0;
                _leftMostIndex = _rightMostIndex + totalColumnsRequired - 1;
            }
            
            /** Start construct horizontal lines*/
            /** Start construct value labels for horizontal lines*/
        _fullValueOfTheGraph = [self calculateMaximumValue:dataModelForMaxValue.value];

                // NSLog(@"highestValueEColumnChart %f",_fullValueOfTheGraph);
                float heightGap = self.frame.size.height / numberOfVerticalLabel;
           //     float valueGap = _fullValueOfTheGraph / 10.0;
                NSMutableArray *tempArr=[NSMutableArray array];
                ///---left side horizantal Line
             EColumnChartLabel *  eColumnChartLabel = [[EColumnChartLabel alloc] initWithFrame:CGRectMake(0, 0, 1.5, heightGap*numberOfVerticalLabel)];
                [eColumnChartLabel setTextAlignment:NSTextAlignmentCenter];
                eColumnChartLabel.backgroundColor=[UIColor colorWithRed:(CGFloat)210/255 green:(CGFloat)210/255 blue:(CGFloat)210/255 alpha:1];
                [self addSubview:eColumnChartLabel];
                
                ///---right side horizantal Line
                
                eColumnChartLabel = [[EColumnChartLabel alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, 1.5, heightGap*numberOfVerticalLabel)];
                [eColumnChartLabel setTextAlignment:NSTextAlignmentCenter];
                eColumnChartLabel.backgroundColor=[UIColor colorWithRed:(CGFloat)210/255 green:(CGFloat)210/255 blue:(CGFloat)210/255 alpha:1];
                [self addSubview:eColumnChartLabel];
                
                for (int i =0; i <=numberOfVerticalLabel; i++)
                {
                    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, heightGap * i, self.frame.size.width, HORIZONTAL_LINE_HEIGHT)];
                   // int hig=heightGap * i;
                    horizontalLine.backgroundColor = EGrey;
                    [self addSubview:horizontalLine];
                    int maxValue=[self calculateMaximumValue:dataModelForMaxValue.value];
                    
                    eColumnChartLabel = [[EColumnChartLabel alloc] initWithFrame:CGRectMake(-1 * Y_COORDINATE_LABEL_WIDTH, -heightGap / 2.0 + heightGap * i, Y_COORDINATE_LABEL_WIDTH, heightGap)];
                    [eColumnChartLabel setTextAlignment:NSTextAlignmentCenter];
                    NSString *str1=[NSString stringWithFormat:@"%.1d ", (maxValue-i*maxValue/numberOfVerticalLabel)] ;
                    //eColumnChartLabel.text =str1;
                      [tempArr addObject:str1];
                    eColumnChartLabel.text =str1 ;
                    //eColumnChartLabel.backgroundColor = ELightBlue;
                    [self addSubview:eColumnChartLabel];
                    //Creating Mirror of Y axis Label
                   EColumnChartLabel * eColumnChartMirrorLabel = [[EColumnChartLabel alloc] initWithFrame:CGRectMake(Screen_width-Y_COORDINATE_LABEL_WIDTH*3+10, -heightGap / 2.0 + heightGap * i, Y_COORDINATE_LABEL_WIDTH, heightGap)];
                    [eColumnChartMirrorLabel setTextAlignment:NSTextAlignmentCenter];
                    NSString * textToDisplay=[NSString stringWithFormat:@"%.1d ", (maxValue-i*maxValue/numberOfVerticalLabel)] ;
                    eColumnChartMirrorLabel.text =textToDisplay ;
                    [self addSubview:eColumnChartMirrorLabel];
                    //Conditions for diplaying Hours
                    if(_showHorizontalLabelsWithInteger)
                    {
                        NSString * textToDisplay=[NSString stringWithFormat:@"%.1d ", (24-(i*3))] ;
                        eColumnChartMirrorLabel.text =textToDisplay ;
                        eColumnChartLabel.text =textToDisplay ;

                    }

            }
                   [self reloadData];

        //}
    }
    
}

-(float)calculateMaximumValue:(float)maxValue
{
    if([[Singletoneclass sharedSingleton].graphSelected isEqualToString:PhoneUageDBDictionaryKey])
    {
        return 24;
    }
    
    maxValue=(int)maxValue/100;
    maxValue++;
    return maxValue*100;
}


- (void)setMaxColumnColor:(UIColor *)maxColumnColor
{
    _maxColumnColor = maxColumnColor;
    [self reloadData];

}

- (void)setMinColumnColor:(UIColor *)minColumnColor
{
    _minColumnColor = minColumnColor;
    [self reloadData];

}

- (void)setShowHighAndLowColumnWithColor:(BOOL)showHighAndLowColumnWithColor
{
    _showHighAndLowColumnWithColor = showHighAndLowColumnWithColor;
    [self reloadData];

}

- (void)setColumnsIndexStartFromLeft:(BOOL)columnsIndexStartFromLeft
{
    if (_dataSource)
    {
        NSLog(@"setColumnsIndexStartFromLeft Should Be Called Before Setting Datasource!");
        return;
    }
    _columnsIndexStartFromLeft = columnsIndexStartFromLeft;
}


#pragma -mark- Custom Methed
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        /** Should i release these two objects before self have been destroyed*/
        _eLabels = [NSMutableDictionary dictionary];
        _eColumns = [NSMutableDictionary dictionary];
        
        [self initData];
    }
    return self;
}



- (void)initData
{
    /** Initialize colors for max and min column*/
    

    _showHighAndLowColumnWithColor = YES;
}

- (void)reloadData
{
    if (nil == _dataSource)
    {
        NSLog(@"Important!! DataSource Not Set!");
        return;
    }
    
    totalColumnsRequired = [_dataSource numberOfColumnsPresentedEveryTime:self];
    
    float widthOfTheColumnShouldBe = self.frame.size.width / (float)(totalColumnsRequired + (totalColumnsRequired + 1) * 0.5);
    float minValue = 1000000.0;
    float maxValue = 0.0;
    NSInteger minIndex = 0;
    NSInteger maxIndex = 0;
    
    for (int i = 0; i < totalColumnsRequired; i++)
    {
        NSInteger currentIndex = _leftMostIndex - i * DIRECTION;
        EColumnDataModel *eColumnDataModel = [_dataSource eColumnChart:self valueForIndex:currentIndex];
        if (eColumnDataModel == nil)
            eColumnDataModel = [[EColumnDataModel alloc] init];
        /** Judge which is the max value and which is min, then set color correspondingly */
        if (eColumnDataModel.value > maxValue) {
            maxIndex =  currentIndex;
            maxValue = eColumnDataModel.value;
        }
        if (eColumnDataModel.value < minValue) {
            minIndex = currentIndex;
            minValue = eColumnDataModel.value;
        }
        
        /** Construct Columns*/
        EColumn *eColumn = [_eColumns objectForKey: [NSNumber numberWithInteger:currentIndex]];
        if (nil == eColumn)
        {
            eColumn = [[EColumn alloc] initWithFrame:CGRectMake(widthOfTheColumnShouldBe * 0.5 + (i * widthOfTheColumnShouldBe * 1.5), 0, widthOfTheColumnShouldBe,self.frame.size.height)];
          //  NSLog(@"frame parameteres %f",self.frame.size.height);
            
            eColumn.backgroundColor = EGrey;
            eColumn.grade = (eColumnDataModel.value *self.frame.size.height)/_fullValueOfTheGraph;
            eColumn.eColumnDataModel = eColumnDataModel;
            [eColumn setDelegate:self];
            [self addSubview:eColumn];
            [_eColumns setObject:eColumn forKey:[NSNumber numberWithInteger:currentIndex ]];
        }
        if ([_dataSource respondsToSelector:@selector(colorForEColumn:)])
        {
            eColumn.barColor = [_dataSource colorForEColumn:eColumn];
        }
        else
        {
            eColumn.barColor = _normalColumnColor;
        }
        
        /** Construct labels for corresponding columns */
        EColumnChartLabel *eColumnChartLabel = [_eLabels objectForKey:[NSNumber numberWithInteger:(currentIndex)]];
        if (nil == eColumnChartLabel)
        {
          //
            CGRect frameChartLabel;
            if([self.typeOfGraph isEqualToString:@"Weekly"])
            {
                frameChartLabel=CGRectMake(widthOfTheColumnShouldBe * 0.5 + (i * widthOfTheColumnShouldBe * 1.5), self.frame.size.height, widthOfTheColumnShouldBe, 20);
            }
            else
            {
                   frameChartLabel=CGRectMake(widthOfTheColumnShouldBe * 0.5 + (i * widthOfTheColumnShouldBe * 1.5), self.frame.size.height,  widthOfTheColumnShouldBe*2, 25);
//                frameChartLabel=CGRectMake(widthOfTheColumnShouldBe * 0.5  + (i * widthOfTheColumnShouldBe *4.5), self.frame.size.height, widthOfTheColumnShouldBe*2, 25);
            }
            
            eColumnChartLabel = [[EColumnChartLabel alloc] initWithFrame:frameChartLabel];
            [eColumnChartLabel setTextAlignment:NSTextAlignmentCenter];
            eColumnChartLabel.text = eColumnDataModel.label;
            //eColumnChartLabel.backgroundColor = ELightBlue;
            [self addSubview:eColumnChartLabel];
            [_eLabels setObject:eColumnChartLabel forKey:[NSNumber numberWithInteger:(currentIndex)]];
        }
    }
//    
//    if (_showHighAndLowColumnWithColor)
//    {
//        EColumn *eColumn = [_eColumns objectForKey: [NSNumber numberWithInteger: maxIndex]];
//        //eColumn.barColor = [UIColor redColor];
//        eColumn = [_eColumns objectForKey: [NSNumber numberWithInteger: minIndex]];
//        eColumn.barColor =  [UIColor redColor];
//    }
    
    
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^
     {
         UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, 0, BOTTOM_LINE_HEIGHT)];
         bottomLine.backgroundColor = [UIColor blackColor];
         bottomLine.layer.cornerRadius = 2.0;
         [self addSubview:bottomLine];
         [bottomLine setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, BOTTOM_LINE_HEIGHT)];
         
     } completion:nil];
    
}



#pragma -mark- EColumnDelegate
- (void)eColumnTaped:(EColumn *)eColumn
{
    [_delegate eColumnChart:self didSelectColumn:eColumn];
    [_delegate fingerDidLeaveEColumnChart:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma -mark- detect Gesture

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nil == _delegate) return;
    [_delegate fingerDidLeaveEColumnChart:self];
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    for (EColumn *view in _eColumns.objectEnumerator)
    {
        if(CGRectContainsPoint(view.frame, touchLocation))
        {
            [_delegate eColumnChart:self fingerDidLeaveColumn:view];
            _fingerIsInThisEColumn = nil;
            return;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nil == _delegate) return;
    UITouch *touch = [[event allTouches] anyObject];
    /** We do not want the coordinate system of the columns here, 
     we need coordinate system of the Echart instead, so we use self*/
    //CGPoint touchLocation = [touch locationInView:touch.view];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (nil == _fingerIsInThisEColumn)
    {
        for (EColumn *view in _eColumns.objectEnumerator)
        {
            if(CGRectContainsPoint(view.frame, touchLocation) )
            {
                [_delegate eColumnChart:self fingerDidEnterColumn:view];
                _fingerIsInThisEColumn = view;
                return ;
            }
        }
    }
    if (_fingerIsInThisEColumn && !CGRectContainsPoint(_fingerIsInThisEColumn.frame, touchLocation))
    {
        [_delegate eColumnChart:self fingerDidLeaveColumn:_fingerIsInThisEColumn];
        _fingerIsInThisEColumn = nil;
    }
    
    return ;
}



@end
