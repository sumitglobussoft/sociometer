//
//  NSObject+CalenderHelperMethods.m
//  SocioMeter
//
//  Created by GLB-254 on 2/12/16.
//  Copyright © 2016 Sumit Ghosh. All rights reserved.
//

#import "NSObject+CalenderHelperMethods.h"

@implementation NSObject (CalenderHelperMethods)
-(NSInteger)numberOfDaysInMonthCount:(NSDate *)date
{
    NSRange dayRange = [[self calendar] rangeOfUnit:NSDayCalendarUnit
                                             inUnit:NSMonthCalendarUnit
                                            forDate:date];
    
    return dayRange.length;
}
-(NSCalendar*)calendar
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone: [NSTimeZone localTimeZone]];
    return calendar;
}
-(NSDate*)firstDayOfMonth:(NSDate *)date
{
    NSInteger dayCount = 1;
    
    NSDateComponents *comp = [[self calendar] components:
                              NSYearCalendarUnit |
                              NSMonthCalendarUnit |
                              NSDayCalendarUnit fromDate:date];
    
    [comp setDay:dayCount];
    
    return [[self calendar] dateFromComponents:comp];
}
-(NSDate*)lastDayOfMonth:(NSDate *)date
{
    NSInteger dayCount = [self numberOfDaysInMonthCount:date];
    
    NSDateComponents *comp = [[self calendar] components:
                              NSYearCalendarUnit |
                              NSMonthCalendarUnit |
                              NSDayCalendarUnit fromDate:date];
    
    [comp setDay:dayCount];
    
    return [[self calendar] dateFromComponents:comp];
}

#pragma mark Week Days
-(NSDate*)findFirstDayOfWeek
{
    NSDate *currentDate =[self currentDayFromTwelveAm];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:currentDate];
    [components setDay:([components day]-([components weekday]-1))];
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    return beginningOfWeek;
}
-(NSDate*)findLastDayOfWeek
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [self currentDayFromTwelveAm];
    NSDate *startOfTheWeek;
    NSDate *endOfWeek;
    NSTimeInterval interval;
    [cal rangeOfUnit:NSWeekCalendarUnit
           startDate:&startOfTheWeek
            interval:&interval
             forDate:now];
    //startOfWeek holds now the first day of the week, according to locale (monday vs. sunday)
    
    endOfWeek = [startOfTheWeek dateByAddingTimeInterval:interval-1];
    // holds 23:59:59 of last day in week.
    return endOfWeek;
}
-(NSDate*)currentDayFromTwelveAm
{
    NSDate * currentDate=[NSDate date];
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    [calendar setTimeZone: [NSTimeZone localTimeZone]];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSTimeZoneCalendarUnit fromDate:currentDate];
    [components setHour:00];
    [components setMinute:00];
    [components setSecond:00];
    NSDate* staringDateTime = [calendar dateFromComponents:components];
    return staringDateTime;
}

-(int)getDayFromnTimeStamp:(NSInteger)timeStamp
{
    NSDate * currentDate=[NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"dd"];
    NSString *  myDayString = [df stringFromDate:currentDate];
    
    return [myDayString intValue];
}
-(NSDate*)getDateWithAdditionOfWeek:(NSDate*)endDayOfWeek
{
    NSDate * firstDayOfWeek;
    NSDate * newEndDateOfWeek;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd, MMM"];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:+ 6];
    firstDayOfWeek=[endDayOfWeek dateByAddingTimeInterval:24*60*60];
    newEndDateOfWeek = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:firstDayOfWeek options:0];
    return newEndDateOfWeek;
}
-(NSDate*)getDateWithSubtractionOfWeek:(NSDate*)endDayOfWeek
{
    NSDate * firstDayOfWeek;
    NSDate * newEndDateOfWeek;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd, MMM"];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-7];
    firstDayOfWeek=[endDayOfWeek dateByAddingTimeInterval:-7*24*60*60];
    newEndDateOfWeek = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:firstDayOfWeek options:0];
    return newEndDateOfWeek;
}

@end
