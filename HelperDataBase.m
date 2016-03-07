//
//  HelperDataBase.m
//  Around Dubuque
//
//  Created by GLB-254 on 10/15/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import "HelperDataBase.h"
#import "Singletoneclass.h"
#import <sqlite3.h>
@implementation HelperDataBase
/* 
 Save Data of Each Day taking Time Stamp of 12:00 A.M to save in D.B
 */
-(void)createDailyUsageTable:(NSString *)tableName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"SocioMeterDB.sqlite"];
    
    // Open the database and store the handle as a data member
    if (sqlite3_open([databasePath UTF8String], &_databaseHandle) == SQLITE_OK)
    {
        // Create the database if it doesn't yet exists in the file system
        
        
        // Create the Table
        NSString * tableCreateQuery=[NSString  stringWithFormat:@"CREATE TABLE  IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,TotalScreenLock TEXT,TotalPhUsagesTime TEXT,DailyAddictionScore TEXT, CURRENTDAYTIMESTAMP INTEGER)",tableName];
        const char *sqlStatement =[tableCreateQuery UTF8String];
        
        char *error;
        if (sqlite3_exec(_databaseHandle, sqlStatement, NULL, NULL, &error) == SQLITE_OK)
        {
            NSLog(@"table created");
            // Create the ADDRESS table with foreign key to the PERSON table
            
            NSLog(@"Database and tables created.");
        }
        else
        {
            NSLog(@"````Error: %s", error);
        }
    }
    
    
}
-(void)saveUserDetailInSqlite:(NSDictionary *)dataBaseDict
{
    NSString * lockScreen=[dataBaseDict objectForKey:TotalScreenLockDBDictionaryKey];
    NSString *phoneUsagesStr=[dataBaseDict objectForKey:PhoneUageDBDictionaryKey];
    NSString *currentDateStr=[dataBaseDict objectForKey:@"CurrentTimeStamp"];
    NSString *AddictionScoreStr=[dataBaseDict objectForKey:AddictionScoreDBDictionaryKey];
    //--
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"SocioMeterDB.sqlite"];
    
    NSString *insertSQL=[NSString stringWithFormat:@"insert into SocioMeterDB(TotalScreenLock,TotalPhUsagesTime,DailyAddictionScore,CURRENTDAYTIMESTAMP) values (\"%@\",\"%@\",\"%@\",\"%@\")",lockScreen,phoneUsagesStr,AddictionScoreStr,currentDateStr];
    
    
    const char *query=[insertSQL UTF8String];

    sqlite3_stmt *inset_statement;
    
    if (sqlite3_open([databasePath UTF8String], &_databaseHandle)!=SQLITE_OK) {
        NSLog(@"Error to Open");
        return;
    }
    
    if (sqlite3_prepare_v2(_databaseHandle, query , -1,&inset_statement, NULL) != SQLITE_OK ) {
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(_databaseHandle), sqlite3_errcode(_databaseHandle));
        NSLog(@"Error to Prepare");
        
    }
    if(sqlite3_step(inset_statement) == SQLITE_DONE)
    {
        
        NSLog(@"Success");
        [self  resetAllPhoneUsage];
    }
    sqlite3_finalize(inset_statement);
    sqlite3_close(_databaseHandle);

}
-(NSArray *)retrivePhoneUsage:(double)lowerValueOfTimeStamp higherTimeStamp:(double)higherTimeStamp
{
    
            NSMutableArray * dataInSqlite=[[NSMutableArray alloc]init];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSLog(@"%@",paths);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"SocioMeterDB.sqlite"];
            // Check to see if the database file already exists
            //Converting Date into String
            NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@  WHERE CURRENTDAYTIMESTAMP >= %f AND CURRENTDAYTIMESTAMP <= %f",SocioMeterDB,lowerValueOfTimeStamp,higherTimeStamp];
            sqlite3_stmt *stmt=nil;
            if(sqlite3_open([databasePath UTF8String], &_databaseHandle)!=SQLITE_OK)
                NSLog(@"error to open");
            
            if (sqlite3_prepare_v2(_databaseHandle, [query UTF8String], -1, &stmt, NULL)== SQLITE_OK)
            {
                NSLog(@"prepared");
            }
            else
                NSLog(@"error");
            // sqlite3_step(stmt);
            @try
            {
                while(sqlite3_step(stmt)==SQLITE_ROW)
                {
                    NSMutableDictionary * tempDictionary=[[NSMutableDictionary alloc]init];
                    char * totalScreenLock = (char *) sqlite3_column_text(stmt,1);
                    char * totalPhoneUsage = (char *) sqlite3_column_text(stmt,2);
                    char *datailyAdditionScore = (char *) sqlite3_column_text(stmt,3);
                   NSInteger timeStamp = sqlite3_column_int(stmt, 4);
                    [tempDictionary setObject:[NSString stringWithUTF8String:totalScreenLock] forKey:@"TotalScreenLock"];
                    [tempDictionary setObject:[NSString stringWithUTF8String:totalPhoneUsage] forKey:@"TotalPhoneUsage"];
                    [tempDictionary setObject:[NSString stringWithUTF8String:datailyAdditionScore] forKey:AddictionScoreDBDictionaryKey];
                    [tempDictionary setObject:[NSNumber numberWithInteger:timeStamp] forKey:@"TodayTimeStamp"];
                    [dataInSqlite addObject:tempDictionary];
                }
            }
            @catch(NSException *e)
            {
                NSLog(@"%@",e);
            }
    return dataInSqlite;

}
-(NSArray *)retriveAndCheck:(int)valueOfTimeStamp
{
    BOOL checkData;
    checkData=false;
    NSMutableArray * dataInSqlite=[[NSMutableArray alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"path of DB%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"SocioMeterDB.sqlite"];
    // Check to see if the database file already exists
    //Converting Date into String
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM SocioMeterDB  WHERE CURRENTDAYTIMESTAMP == %d",valueOfTimeStamp];
    sqlite3_stmt *stmt=nil;
    if(sqlite3_open([databasePath UTF8String], &_databaseHandle)!=SQLITE_OK)
        NSLog(@"error to open");
    
    if (sqlite3_prepare_v2(_databaseHandle, [query UTF8String], -1, &stmt, NULL)== SQLITE_OK)
    {
        NSLog(@"prepared");
    }
    else
        NSLog(@"error");
    // sqlite3_step(stmt);
    @try
    {
        while(sqlite3_step(stmt)==SQLITE_ROW)
        {
            checkData=true;
           
        }
                sqlite3_finalize(stmt);
                sqlite3_close(_databaseHandle);
    }
    @catch(NSException *e)
    {
        NSLog(@"%@",e);
    }
    if(checkData)
    {
        NSMutableDictionary * tempDict=[[NSMutableDictionary alloc]init];
        [tempDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:lockValue] forKey:@"TotalScreenLock"];
        [tempDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:phUsagesTime] forKey:@"TotalPhoneUsage"];
        [tempDict setObject:[NSString stringWithFormat:@"%d",valueOfTimeStamp] forKey:@"CurrentTimeStamp"];
        NSString * dailyAdditoinalScore=[NSString stringWithFormat:@"%f",[self calculateAndReturnScore]];
        [tempDict setObject:dailyAdditoinalScore forKey:AddictionScoreDBDictionaryKey];

    [self updateAddictionScore:valueOfTimeStamp updateDatabse:saveDataDictionary];
    }
    else
    {
        NSString * timeStampToSave=[NSString stringWithFormat:@"%d",valueOfTimeStamp];
        NSMutableDictionary * tempDict=[[NSMutableDictionary alloc]init];
        [tempDict setObject:@"0" forKey:TotalScreenLockDBDictionaryKey];
        [tempDict setObject:@"0" forKey:PhoneUageDBDictionaryKey];
        [tempDict setObject:@"0" forKey:AddictionScoreDBDictionaryKey];
        [tempDict setObject:timeStampToSave forKey:@"CurrentTimeStamp"];
        [self saveUserDetailInSqlite:tempDict];
    }
    return dataInSqlite;
}


#pragma mark update data:
-(NSString *)updateAfterEachTimeInterval:(double)currentTimestamp updateDatabse:(NSDictionary *)dataBaseDict
{
    
    NSString * lockScreen=[dataBaseDict objectForKey:TotalScreenLockDBDictionaryKey];
    NSString *phoneUsagesStr=[dataBaseDict objectForKey:PhoneUageDBDictionaryKey];
     NSString *addictionScoreStr=[dataBaseDict objectForKey:AddictionScoreDBDictionaryKey];
    //---
    NSString *stringData;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"SocioMeterDB.sqlite"];
    
    char *err;
    if(sqlite3_open([databasePath UTF8String], &_databaseHandle)==SQLITE_OK){
        NSString *query = [NSString stringWithFormat:@"UPDATE %@  SET DAILYADDICTIONSCORE = %@,TotalScreenLock=%@,TotalPhUsagesTime=%@ WHERE CURRENTDAYTIMESTAMP = %ld ",SocioMeterDB,addictionScoreStr,lockScreen,phoneUsagesStr,(long)currentTimestamp];
        const char *update_statement=[query UTF8String];
        if(sqlite3_exec(_databaseHandle, update_statement, NULL, NULL, &err)==SQLITE_OK)
        {
            NSLog(@"update Done");
            
            if([[Singletoneclass sharedSingleton].graphSelected isEqualToString:PhoneUageDBDictionaryKey])
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadWeeklyGraph" object:PhoneUageDBDictionaryKey];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadMonthlyGraph" object:PhoneUageDBDictionaryKey];
            }
            else
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadWeeklyGraph" object:AddictionScoreDBDictionaryKey];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadMonthlyGraph" object:AddictionScoreDBDictionaryKey];
            }
           
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadPieChart" object:@""];

            
        }
        else{
            NSLog(@"%s",sqlite3_errmsg(_databaseHandle));
        }
        
    }
    
    
    return stringData;
}

-(NSString *)updateAddictionScore:(double)currentTimestamp updateDatabse:(NSDictionary *)dataBaseDict
{
    
    NSString * lockScreen=[dataBaseDict objectForKey:@"TotalScreenLock"];
    NSString *phoneUsagesStr=[dataBaseDict objectForKey:@"TotalPhUsagesTime"];
   // NSString *currentDateStr=[dataBaseDict objectForKey:@"CurrentTimeStamp"];
   // NSString *AddictionScoreStr=[dataBaseDict objectForKey:@"DailyAddictionScore"];
    //---
    NSString *stringData;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"SocioMeterDB.sqlite"];
   
    char *err;
    int dailyAddictionScore=[[[NSUserDefaults standardUserDefaults]objectForKey:getAddictionScore]intValue];
    if(sqlite3_open([databasePath UTF8String], &_databaseHandle)==SQLITE_OK){
            NSString *query = [NSString stringWithFormat:@"UPDATE %@  SET DAILYADDICTIONSCORE = %d,TotalScreenLock=%d,TotalPhUsagesTime=%d WHERE CURRENTDAYTIMESTAMP = %f ",SocioMeterDB,dailyAddictionScore,lockScreen.intValue,phoneUsagesStr.intValue,currentTimestamp];
        const char *update_statement=[query UTF8String];
        if(sqlite3_exec(_databaseHandle, update_statement, NULL, NULL, &err)==SQLITE_OK)
           {NSLog(@"update Done");
        [self  resetAllPhoneUsage];
               
               //After Resetting Create New Row For New Day
               NSMutableDictionary * tempDict=[[NSMutableDictionary alloc]init];
               [tempDict setObject:@"0" forKey:TotalScreenLockDBDictionaryKey];
               [tempDict setObject:@"0" forKey:PhoneUageDBDictionaryKey];
               [tempDict setObject:@"0" forKey:AddictionScoreDBDictionaryKey];
               [tempDict setObject:[HelperDataBase currentDayTimeStamp:[NSDate date]] forKey:@"CurrentTimeStamp"];
               [self saveUserDetailInSqlite:tempDict];
        }
        else{
             NSLog(@"%s",sqlite3_errmsg(_databaseHandle));
        }
        
    }

    
    return stringData;
}




-(NSDictionary*)convertJsonToDictionary:(NSString*)jsonToDict
{
    NSData *data = [jsonToDict dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error=nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

    return dictionary;
}
//------

#pragma mark RETURN Current Date

+(NSString*)currentDayTimeStamp:(NSDate*)currentDate
{
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    [calendar setTimeZone: [NSTimeZone localTimeZone]];
    
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSTimeZoneCalendarUnit fromDate:currentDate];
    
    [components setHour:00];
    [components setMinute:00];
    [components setSecond:00];
    
    NSDate* staringDateTime = [calendar dateFromComponents:components];
    return  [NSString stringWithFormat:@"%f",staringDateTime.timeIntervalSince1970];
}
-(void)alertbox:(NSString*)message andtitle:(NSString*)title{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title
                                                 message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(void)resetAllPhoneUsage
{
    [Singletoneclass sharedSingleton].phoneLockCount=[NSNumber numberWithInt:0];
    [Singletoneclass sharedSingleton].phoneUsageTime=[NSNumber numberWithInt:0];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:lockValue];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:phUsagesTime];
    [[NSUserDefaults standardUserDefaults]setObject:[HelperDataBase currentDayTimeStamp:[NSDate date]] forKey:@"RunningDayTimeStamp"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdatePhoneUsageAndLock" object:nil];

}
-(float)calculateAndReturnScore
{
    int screenLck=[[NSUserDefaults standardUserDefaults] objectForKey:lockValue];
    int minuteTime=[[NSUserDefaults standardUserDefaults]objectForKey:phUsagesTime];
    return (screenLck/2+minuteTime/4);

}
@end
