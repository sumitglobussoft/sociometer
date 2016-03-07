//
//  HelperDataBase.h
//  Around Dubuque
//
//  Created by GLB-254 on 10/15/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface HelperDataBase : NSObject
{
    sqlite3 *_databaseHandle;
    NSMutableDictionary * saveDataDictionary;
}
-(void)createDailyUsageTable:(NSString *)tableName;
-(void)saveUserDetailInSqlite:(NSDictionary *)userData;
-(NSArray *)retrivePhoneUsage:(double)lowerValueOfTimeStamp higherTimeStamp:(double)higherTimeStamp;
+(NSString*)currentDayTimeStamp:(NSDate*)currentDate;
-(NSString *)updateAddictionScore:(double)currentTimestamp updateAddictionScore:(float)UpdateAddictionScore;
-(NSString *)updateAddictionScore:(double)currentTimestamp updateDatabse:(NSDictionary *)dataBaseDict;
-(NSString *)updateAfterEachTimeInterval:(double)currentTimestamp updateDatabse:(NSDictionary *)dataBaseDict;
-(void)retriveandCheck:(NSDictionary *)dataBaseDict;
-(NSArray *)retriveAndCheck:(int)valueOfTimeStamp;
@end
