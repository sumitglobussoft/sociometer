//
//  EPieChart.h
//  EChartDemo
//
//  Created by Efergy China on 24/1/14.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TB_SLIDER_SIZE 320                          //The width and the heigth of the slider
#define TB_BACKGROUND_WIDTH 60                      //The width of the dark background
#define TB_LINE_WIDTH 40                            //The width of the active area (the gradient) and the width of the handle
#define TB_FONTSIZE 65                              //The size of the textfield font
#define TB_FONTFAMILY @"Futura-CondensedExtraBold"  //The font family of the textfield font

@class EPie;
@class EPieChartDataModel;
@class EPieChart;

@protocol EPieChartDataSource <NSObject>

@optional
/** You can customize the front view by implimenting
    this dataSoure, If it's not implimented, it will use
    default view*/
- (UIView *) frontViewForEPieChart:(EPieChart *) ePieChart;

/** You can customize the back view by implimenting
 this dataSoure, If it's not implimented, it will use
 default view*/
- (UIView *) backViewForEPieChart:(EPieChart *) ePieChart;

@end

@protocol EPieChartDelegate <NSObject>

@optional
- (void)                ePieChart:(EPieChart *)ePieChart
  didTurnToFrontViewWithFrontView:(UIView *)frontView;

- (void)                ePieChart:(EPieChart *)ePieChart
    didTurnToBackViewWithBackView:(UIView *)backView;

@end


@interface EPieChart : UIView

@property (strong, nonatomic) EPie *frontPie;

@property (strong, nonatomic) EPie *backPie;

@property (strong, nonatomic) EPieChartDataModel *ePieChartDataModel;

@property (nonatomic) BOOL isUpsideDown;

/** motionEffect supports only iOS7 or higher, So don't turn it on if you are not using it in iOS7.*/
@property (nonatomic) BOOL motionEffectOn;

@property (weak, nonatomic) id <EPieChartDelegate> delegate;

@property (weak ,nonatomic) id <EPieChartDataSource> dataSource;

- (id)initWithFrame:(CGRect)frame ePieChartDataModel:(EPieChartDataModel *)ePieChartDataModel;

- (void) turnPie;

@end

@interface EPie : UIView

@property (nonatomic,assign) int angle;

@property (strong, nonatomic) UIView *contentView;
@property(assign,nonatomic)int point;

@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat radius;

@property (strong, nonatomic) UIColor *budgetColor;
@property (strong, nonatomic) UIColor *currentColor;
@property (strong, nonatomic) UIColor *estimateColor;

@property (strong, nonatomic) EPieChartDataModel *ePieChartDataModel;

- (void) reloadContent;

- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radius;

- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radius
  ePieChartDataModel:(EPieChartDataModel *)ePieChartDataModel;
@end


@interface EPieChartDataModel : NSObject
@property (nonatomic) CGFloat budget;
@property (nonatomic) CGFloat current;
@property (nonatomic) CGFloat estimate;

- (id)initWithBudget:(CGFloat) budget
             current:(CGFloat) current
            estimate:(CGFloat) estimate;
@end