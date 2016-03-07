//
//  ViewController.h
//  SocioMeter
//
//  Created by Sumit Ghosh on 24/12/15.
//  Copyright © 2015 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMenuViewController.h"
#import "EPieChart.h"
@interface ViewController : UIViewController

//+(CustomMenuViewController*)showMenuBar;
@property (strong, nonatomic) EPieChart *ePieChart;

@end

