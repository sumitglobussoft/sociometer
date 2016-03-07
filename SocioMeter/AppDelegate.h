//
//  AppDelegate.h
//  SocioMeter
//
//  Created by Sumit Ghosh on 24/12/15.
//  Copyright © 2015 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    int lockCount;
    int minutes;
    int lastphoneusageTime;
    NSDictionary *dict;
}
@property (strong, nonatomic) UIWindow *window;
@property (assign,nonatomic) NSInteger *count;
@property(assign,nonatomic)NSDate *startDate;
@property(assign,nonatomic)NSDate *endDate;
@property(assign,nonatomic)NSString *phoneUsagesTime,*minuteStr;
@property(assign,nonatomic)NSDate *backgroundStartTime;
@property(nonatomic,strong) UIImageView *noticeImageView;
@end

