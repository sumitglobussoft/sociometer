//
//  DashBarViewController.h
//  SocioMeter
//
//  Created by Sumit Ghosh on 26/12/15.
//  Copyright © 2015 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPieChart.h"
#import "EColumnChart.h"
#import "CalenderHelper.h"
@interface DashBarViewController : UIViewController<EPieChartDelegate, EPieChartDataSource,EColumnChartDelegate, EColumnChartDataSource>
@property (strong, nonatomic) EPieChart *ePieChart;
@property(nonatomic, assign) int lockCount,totalScore,dateCount;
@property (strong, nonatomic) UILabel *screenlockLbl;
@property (strong, nonatomic) EColumnChart *eColumnChart,*_eColumnChartForPhUsages,*_eColumnChartForWeeklyAddiction,*ecolumnChartMonthly,*_ecolumnChartMonthlyPhUsages;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic)UIImageView *dateImg;
@property(nonatomic,strong)NSString *changeStrValue;
@property(nonatomic,strong)UILabel *phusageTimeLbl,*graphDescriptionLabel;
@property(nonatomic,strong) UIView *weeklyView;
@property(nonatomic,strong) UIView *todayView;
@property(nonatomic,strong)UIView *monthlyView;
@property(nonatomic,strong) NSArray * weeklyScoreValues,*monthlyScoreValues,*weeklyPhUsgesScoreValue;
@property(atomic,strong) NSArray * presentFetchedDataFromDb;
- (void)segmentedControlChangedValue;
-(void)randomImage;
-(void)setColumnDataValuesWeekly:(NSArray*)savedValuesInDb valueType:(NSString*)valueTypeKey;

@end
