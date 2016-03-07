//
//  MonthlyColumn.h
//  SocioMeter
//
//  Created by Sumit Ghosh on 02/01/16.
//  Copyright © 2016 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EColumnDataModel.h"

@class EColumn;

@protocol monthlyColumnDelegate <NSObject>

//- (void)eColumnTaped:(EColumn *)eColumn;


@end
@interface MonthlyColumn : UIView
@property (nonatomic) float grade;

@property (nonatomic,strong) CAShapeLayer * chartLine;

@property (nonatomic, strong) UIColor * barColor;

@property (nonatomic, strong) EColumnDataModel *eColumnDataModel;

-(void)rollBack;

@property (weak, nonatomic) id <monthlyColumnDelegate> delegate;

@end
