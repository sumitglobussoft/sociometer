//
//  PhoneUsageModelClass.h
//  CalculateBackGroundExecution
//
//  Created by GLB-254 on 2/1/16.
//  Copyright © 2016 globussoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface PhoneUsageModelClass : NSObject <CLLocationManagerDelegate>
-(id)init:(BOOL)registerForPhoneUsage;
@property (strong,nonatomic) NSNumber * foregroundTimerCount;
@property(strong,nonatomic) NSTimer * foregroundTimer;
@property(strong,nonatomic) CLLocationManager * locationManager;
-(void)checkdifferenceOfADay;
-(int)compareDate:(NSDate*)oldDate;
-(void)saveUserData;

@end
