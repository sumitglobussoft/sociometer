//
//  PhoneUsageModelClass.m
//  CalculateBackGroundExecution
//
//  Created by GLB-254 on 2/1/16.
//  Copyright © 2016 globussoft. All rights reserved.
//

#import "PhoneUsageModelClass.h"
#import "HelperDataBase.h"
#import "notify.h"
#import "Singletoneclass.h"
#import "ManageSmartNotifcation.h"
@implementation PhoneUsageModelClass
-(id)init:(BOOL)registerForPhoneUsage
{
    self=[super init];
    if(self)
    {
        self.foregroundTimer = [NSTimer scheduledTimerWithTimeInterval:60
                                                                target:self
                                                              selector:@selector(timerToCalculateAppForegroundTime)
                                                              userInfo:nil
                                                               repeats:YES];
        int notify_token;
        notify_register_dispatch("com.apple.springboard.lockstate",     &notify_token,dispatch_get_main_queue(), ^(int token) {
            uint64_t state = UINT64_MAX;
            notify_get_state(token, &state);
            if(state == 0)
            {
                self.foregroundTimer = [NSTimer scheduledTimerWithTimeInterval:60
                                                                        target:self
                                                                      selector:@selector(timerToCalculateAppForegroundTime)
                                                                      userInfo:nil
                                                                       repeats:YES];
                [Singletoneclass sharedSingleton].phoneLockCount=[NSNumber numberWithInt: [Singletoneclass sharedSingleton].phoneLockCount.intValue+1];
                //-----Updating Phone Lock Count In Main Screen
                [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdatePhoneUsageAndLock" object:nil];
            }
            else
            {
                [self.foregroundTimer invalidate];
                self.foregroundTimer=nil;
            }
            
            NSLog(@"com.apple.springboard.lockstate = %llu", state);
        });
        
        [self locationUpdateCode];
    }
    return self;
}
#pragma mark Location Update and Delegate
-(void)locationUpdateCode
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.locationManager requestAlwaysAuthorization];
    }    // Start getting location updates
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    [self.locationManager startUpdatingLocation];
}
// Location updates
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // Do what ever you want with the location
    
}
#pragma mark Timer Method
-(void)timerToCalculateAppForegroundTime
{
    self.foregroundTimerCount=[NSNumber  numberWithInt:[[[NSUserDefaults standardUserDefaults] objectForKey:phUsagesTime] intValue]] ;
    self.foregroundTimerCount=[NSNumber  numberWithInt:[self.foregroundTimerCount intValue] + 1];
    NSLog(@"ForeGround Time %@",self.foregroundTimerCount);
    [Singletoneclass sharedSingleton].phoneUsageTime=self.foregroundTimerCount;
    //-----Updating Phone Time In Main Screen
    [[NSUserDefaults standardUserDefaults]setObject:self.foregroundTimerCount forKey:phUsagesTime];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdatePhoneUsageAndLock" object:nil];
    ManageSmartNotifcation * manageObj=[[ManageSmartNotifcation alloc]init];
    [manageObj fireNotificationWithAddictionScore];

    [self checkdifferenceOfADay];
}
#pragma mark Check Difference Of A Day

-(void)checkdifferenceOfADay
{
    NSDate *dateConverted = [NSDate dateWithTimeIntervalSince1970:[[[NSUserDefaults standardUserDefaults]objectForKey:@"RunningDayTimeStamp" ]  longLongValue]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *strCurrentDate = [formatter stringFromDate:dateConverted];
    
    NSDate *currentDate=[formatter dateFromString:strCurrentDate];
    
   int differenceInDay= [self compareDate:currentDate];
    [self updateUserData];
    if(differenceInDay>=1)
    {
        [self saveUserData];
        
    }
 
}
-(void)updateUserData
{
    int valueOfTimeStamp=[[HelperDataBase currentDayTimeStamp:[NSDate date]] intValue];
    NSMutableDictionary * tempDict=[[NSMutableDictionary alloc]init];
    [tempDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:lockValue] forKey:TotalScreenLockDBDictionaryKey];
    [tempDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:phUsagesTime] forKey:PhoneUageDBDictionaryKey];
    [tempDict setObject:[NSString stringWithFormat:@"%d",valueOfTimeStamp] forKey:@"CurrentTimeStamp"];
    NSString * dailyAdditoinalScore=[NSString stringWithFormat:@"%d",[self calculatePhoneUsageTime]];
    [tempDict setObject:dailyAdditoinalScore forKey:AddictionScoreDBDictionaryKey];
    HelperDataBase * helperDBObj=[[HelperDataBase alloc]init];
    [helperDBObj updateAfterEachTimeInterval:valueOfTimeStamp updateDatabse:tempDict];


}
-(void)saveUserData
{
    //Save the user data and reset its variables.
    NSDictionary * userDetail=[[NSMutableDictionary alloc]init];
//    NSString * dailyAdditoinalScore=[NSString stringWithFormat:@"%d",[self calculatePhoneUsageTime]];
    //---------------------------Setting the Daily Data------------
    [userDetail setValue:@"0" forKey:TotalScreenLockDBDictionaryKey];
    [userDetail setValue:@"0" forKey:PhoneUageDBDictionaryKey];
    [userDetail setValue:[HelperDataBase currentDayTimeStamp:[NSDate date]] forKey:@"CurrentTimeStamp"];
    [userDetail setValue:@"0" forKey:AddictionScoreDBDictionaryKey];
    //---------------
    HelperDataBase * helperDBObj=[[HelperDataBase alloc]init];
    [helperDBObj saveUserDetailInSqlite:userDetail];
   }
-(int)calculatePhoneUsageTime
{
    int screenLck=[[[NSUserDefaults standardUserDefaults]objectForKey:lockValue]intValue];
    int minuteTime=[[[NSUserDefaults standardUserDefaults]objectForKey:phUsagesTime]intValue];
    return  screenLck/2+minuteTime/4;
}
-(int)compareDate:(NSDate*)oldDate
{
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
        NSString *strCurrentDate = [formatter stringFromDate:currentDate];
        currentDate=[formatter dateFromString:strCurrentDate];
        NSDateFormatter *formatterSecond = [[NSDateFormatter alloc]init];
        [formatterSecond setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
       [formatterSecond setTimeZone:[NSTimeZone localTimeZone]];
        unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitSecond;
        NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *conversionInfo = [gregorianCal components:unitFlags fromDate:oldDate  toDate:currentDate  options:0];
        //int months = (int)[conversionInfo month];
        int days = (int)[conversionInfo day];
        int hours = (int)[conversionInfo hour];
        int minutes = (int)[conversionInfo minute];
        int seconds = (int)[conversionInfo second];
        int months = (int)[conversionInfo month];
        //NSLog(@"%d months , %d days, %d hours, %d min %d sec", months, days, hours, minutes, seconds);
    return days;
}


@end
