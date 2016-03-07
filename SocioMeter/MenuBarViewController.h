//
//  MenuBarViewController.h
//  SocioMeter
//
//  Created by Sumit Ghosh on 26/12/15.
//  Copyright © 2015 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMenuViewController.h"
#import "EPieChart.h"
@interface MenuBarViewController : UIViewController
+(CustomMenuViewController*)showMenuBar;
@property (strong, nonatomic) EPieChart *ePieChart;
-(NSString*) languageSelectedStringForKey:(NSString*) key;

@end
