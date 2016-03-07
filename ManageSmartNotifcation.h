//
//  ManageSmartNotifcation.h
//  SocioMeter
//
//  Created by GLB-254 on 1/29/16.
//  Copyright © 2016 Sumit Ghosh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneUsageModelClass.h"

@interface ManageSmartNotifcation : NSObject
-(void)fireTheNotification:(NSDate*)date messageDictionary:(NSDictionary*)dictMessage messageOnAlertBox:(NSString*)alertMessage;
-(NSDate *)setStartingTime:(NSDate *)staringTime;
-(NSDate *)setLastTime:(NSDate *)lastTime;
-(void)fireNotificationWithAddictionScore;
-(void)lastDayPhoneuagesNoti;

@property(nonatomic,strong) NSDate* lastDateTime;
@property(nonatomic,assign)int addictionSoreWithInt;
@end
