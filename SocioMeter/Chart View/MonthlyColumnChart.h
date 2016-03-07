//
//  MonthlyColumnChart.h
//  SocioMeter
//
//  Created by Sumit Ghosh on 02/01/16.
//  Copyright © 2016 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthlyColumn.h"
#import "EColumnDataModel.h"

@class MonthlyColumnChart;

@protocol MonthlyColumnChartDataSource <NSObject>

/** How many Columns are there in total.*/
- (NSInteger) numberOfColumnsInEColumnChart:(MonthlyColumnChart *) eColumnChart;

/** How many Columns should be presented on the screen each time*/
- (NSInteger) numberOfColumnsPresentedEveryTime:(MonthlyColumnChart *) eColumnChart;

/** The hightest vaule among the whole chart*/
- (EColumnDataModel *)     highestValueEColumnChart:(MonthlyColumnChart *) eColumnChart;

/** Value for each column*/
- (EColumnDataModel *)     eColumnChart:(MonthlyColumnChart *) eColumnChart
                          valueForIndex:(NSInteger)index;

@optional
/** Allow you to customize the color of every coloum as you wish.*/
- (UIColor *) colorForEColumn:(MonthlyColumn *)eColumn;

/** New protocals coming soon, will allow you to customize column*/



@end


@protocol MonthlyColumnChartDelegate <NSObject>

/** When finger single taped the column*/
- (void)        eColumnChart:(MonthlyColumnChart *) eColumnChart
             didSelectColumn:(MonthlyColumn *) eColumn;

/** When finger enter specific column, this is dif from tap*/
- (void)        eColumnChart:(MonthlyColumnChart *) eColumnChart
        fingerDidEnterColumn:(MonthlyColumn *) eColumn;

/** When finger leaves certain column, will
 tell you which column you are leaving*/
- (void)        eColumnChart:(MonthlyColumnChart *) eColumnChart
        fingerDidLeaveColumn:(MonthlyColumn *) eColumn;

/** When finger leaves wherever in the chart,
 will trigger both if finger is leaving from a column */
- (void) fingerDidLeaveEColumnChart:(MonthlyColumnChart *)eColumnChart;

@end



@interface MonthlyColumnChart : UIView <MonthlyColumnChartDelegate>
@property (nonatomic, readonly) NSInteger leftMostIndex;
@property (nonatomic, readonly) NSInteger rightMostIndex;

@property (nonatomic, strong) UIColor *minColumnColor;
@property (nonatomic, strong) UIColor *maxColumnColor;
@property (nonatomic, strong) UIColor *normalColumnColor;

@property (nonatomic) BOOL showHighAndLowColumnWithColor;

/** If this switch in on, all horizontal labels will show in Integer. */
@property (nonatomic) BOOL showHorizontalLabelsWithInteger;

/** IMPORTANT:
 This should be setted before datasoucre has been set.*/
@property (nonatomic) BOOL columnsIndexStartFromLeft;

/** Pull out the columns hidden in the left*/
- (void)moveLeft;

/** Pull out the columns hidden in the right*/
- (void)moveRight;

- (void)initData;

/** Call to redraw the whole chart*/
- (void)reloadData;

@property (strong, nonatomic) NSMutableDictionary *eColumns;
@property (strong, nonatomic) NSMutableDictionary *eLabels;
@property (strong, nonatomic) MonthlyColumn *fingerIsInThisEColumn;
@property (nonatomic) float fullValueOfTheGraph;

@property (weak, nonatomic) id <MonthlyColumnChartDataSource> dataSource;
@property (weak, nonatomic) id <MonthlyColumnChartDelegate> delegate;
//@end

//@interface MonthlyColumnChart : UIView

@end
