//
//  ManageSmartNotifcation.m
//  SocioMeter
//
//  Created by GLB-254 on 1/29/16.
//  Copyright © 2016 Sumit Ghosh. All rights reserved.
//

#import "ManageSmartNotifcation.h"

@implementation ManageSmartNotifcation
@synthesize lastDateTime,addictionSoreWithInt;

-(void)fireTheNotification:(NSDate*)date messageDictionary:(NSDictionary*)dictMessage messageOnAlertBox:(NSString*)alertMessage
{
    UILocalNotification * localNotification = [[UILocalNotification alloc] init];
    [localNotification setFireDate:[NSDate dateWithTimeIntervalSinceNow:60]];
    localNotification.userInfo=dictMessage;
    localNotification.alertBody =alertMessage;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
-(NSDate *)setStartingTime:(NSDate *)staringTime
{
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    [calendar setTimeZone:[NSTimeZone localTimeZone]];

    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSTimeZoneCalendarUnit fromDate:staringTime];
    
    [components setHour:00];
    [components setMinute:00];
    [components setSecond:00];
    
    NSDate* staringDateTime = [calendar dateFromComponents:components];
    NSLog(@"%@", staringTime);
    NSLog(@"%@", staringDateTime);
    
    return staringDateTime;
}
-(NSDate *)setLastTime:(NSDate *)lastTime
{
    //---
    NSCalendar* myCalendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSTimeZoneCalendarUnit
                                                 fromDate:lastTime];
    [components setHour: 23];
    [components setMinute: 59];
    [components setSecond: 59];
    lastDateTime = [myCalendar dateFromComponents:components];
    NSLog(@"%@", lastTime);
    NSLog(@"%@", lastDateTime);
    
    return [myCalendar dateFromComponents:components];
}
-(void)fireNotificationWithAddictionScore
{
    addictionSoreWithInt=[[[NSUserDefaults standardUserDefaults]objectForKey:getAddictionScore]intValue];
    
    NSDictionary *notificationDict=[[NSDictionary alloc]init];
    NSDate  *date=[NSDate date];
    //--
   int phUsagesMint= [[[NSUserDefaults standardUserDefaults]objectForKey:phUsagesTime]intValue];
    
    
    if (addictionSoreWithInt>50) {
        NSString *messageStr=[NSString stringWithFormat:@"Addiction Score %d",addictionSoreWithInt];
        [self fireTheNotification:date messageDictionary:notificationDict messageOnAlertBox:messageStr];
    }
    else if (addictionSoreWithInt>80)
    {
        NSString *eightyMessageStr=[NSString stringWithFormat:@"Addiction Score %d",addictionSoreWithInt];
        [self fireTheNotification:date messageDictionary:notificationDict messageOnAlertBox:eightyMessageStr];

    }
    else if (phUsagesMint>30)
    {
        NSString *eightyMessageStr=[NSString stringWithFormat:@"Phone usages time 30+"];
        [self fireTheNotification:date messageDictionary:notificationDict messageOnAlertBox:eightyMessageStr];
  
    }
    else if (phUsagesMint>50)
    {
        NSString *eightyMessageStr=[NSString stringWithFormat:@"Addiction Score 50"];
        [self fireTheNotification:date messageDictionary:notificationDict messageOnAlertBox:eightyMessageStr];
        
  
    }
    [self checkdifferenceOfADay];
    [self lastDayPhoneuagesNoti];
}
#pragma mark Check Difference Of A Day

-(void)checkdifferenceOfADay
{
    NSDate *dateConverted = [NSDate dateWithTimeIntervalSince1970:[[[NSUserDefaults standardUserDefaults]objectForKey:@"RunningDayTimeStamp" ]  longLongValue]];
    PhoneUsageModelClass *phUsagesClass=[[PhoneUsageModelClass alloc]init];
    int differenceInDay= [phUsagesClass compareDate:dateConverted];
    if(differenceInDay==1)
    {
        [self lastDayPhoneuagesNoti];
    }
    
}



-(void)lastDayPhoneuagesNoti
{
        NSDictionary *notificationDict=[[NSDictionary alloc]init];
        NSString *lastDateStr=[NSString stringWithFormat:@"Addiction Score %d",addictionSoreWithInt];
        [self fireTheNotification:lastDateTime messageDictionary:notificationDict messageOnAlertBox:lastDateStr];

}

@end
