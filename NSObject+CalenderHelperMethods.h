//
//  NSObject+CalenderHelperMethods.h
//  SocioMeter
//
//  Created by GLB-254 on 2/12/16.
//  Copyright © 2016 Sumit Ghosh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CalenderHelperMethods)
-(NSInteger)numberOfDaysInMonthCount:(NSDate *)date;
-(NSDate*)firstDayOfMonth:(NSDate *)date;
-(NSDate*)lastDayOfMonth:(NSDate *)date;
-(NSDate*)findFirstDayOfWeek;
-(NSDate*)findLastDayOfWeek;
-(NSDate*)currentDayFromTwelveAm;
-(int)getDayFromnTimeStamp:(NSInteger)timeStamp;
-(NSDate*)getDateWithAdditionOfWeek:(NSDate*)endDayOfWeek;
-(NSDate*)getDateWithSubtractionOfWeek:(NSDate*)endDayOfWeek;
@end
