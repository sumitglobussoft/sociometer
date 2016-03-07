//
//  AchievementViewController.h
//  SocioMeter
//
//  Created by Sumit Ghosh on 26/12/15.
//  Copyright © 2015 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMenuViewController.h"
@interface AchievementViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
+(CustomMenuViewController*)showMenuBar;
@property(nonatomic,strong)UITableView *achievementTableview;
@property(nonatomic,strong)NSString *cahngeStrValue;
@end
