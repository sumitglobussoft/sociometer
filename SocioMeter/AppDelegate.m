 //
//  AppDelegate.m
//  SocioMeter
//
//  Created by Sumit Ghosh on 24/12/15.
//  Copyright © 2015 Sumit Ghosh. All rights reserved.
//

#import "AppDelegate.h"
#import "AchievementViewController.h"
#import "DashBarViewController.h"
#import "HelperDataBase.h"
#import "SettingsViewController.h"
#import "ManageSmartNotifcation.h"
#import "PhoneUsageModelClass.h"
#import "Singletoneclass.h"
#import "MenuBarViewController.h"
#import "NSObject+CalenderHelperMethods.h"
#define NotifName_LockComplete @"com.apple.springboard.lockcomplete"
#define NotifName_LockState    @"com.apple.springboard.lockstate"
#define NotifName_LockComplete @"com.apple.springboard.lockcomplete"

@interface AppDelegate ()


@end
static NSString *screenLck;
NSString *lockState;
@implementation AppDelegate

#pragma mark Screen Unlock


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    HelperDataBase *helperDb=[[HelperDataBase alloc]init];
    [helperDb createDailyUsageTable:SocioMeterDB];
//To Fire Notification
     //----------
    NSLog(@"Date of 12:00 %@", [HelperDataBase currentDayTimeStamp:[NSDate date]]);
    [self checkTheTimeStampAndUpdateValues];
      //-----------
   // [self comapareDate];
    
    //------ Change App Root View Controller
     CustomMenuViewController * mainMenu=[MenuBarViewController showMenuBar];
    self.window.rootViewController=mainMenu;

    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    return YES;
    
}
-(void)checkTheTimeStampAndUpdateValues
{
    HelperDataBase *helperDb=[[HelperDataBase alloc]init];

    int timeStampSaved=[[[NSUserDefaults standardUserDefaults]objectForKey:@"RunningDayTimeStamp"]intValue];
    if(timeStampSaved==0)
    {
        //Condition for first run
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:lockValue];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:phUsagesTime];
        [Singletoneclass sharedSingleton].phoneLockCount=[NSNumber numberWithInt:0];
        [Singletoneclass sharedSingleton].phoneUsageTime=[NSNumber numberWithInt:0];
        [[NSUserDefaults standardUserDefaults]setObject:[HelperDataBase currentDayTimeStamp:[NSDate date]] forKey:@"RunningDayTimeStamp"];
        [helperDb retriveAndCheck:[[HelperDataBase currentDayTimeStamp:[NSDate date]] intValue]];

    }
   else if(timeStampSaved==[[HelperDataBase currentDayTimeStamp:[NSDate date]] intValue])
    {
        int lockCountTemp=[[[NSUserDefaults standardUserDefaults]objectForKey:lockValue] intValue];
        int phoneUsageTime=[[[NSUserDefaults standardUserDefaults]objectForKey:phUsagesTime]intValue];
        [Singletoneclass sharedSingleton].phoneLockCount=[NSNumber numberWithInt:lockCountTemp];
        [Singletoneclass sharedSingleton].phoneUsageTime=[NSNumber numberWithInt:phoneUsageTime];
    }
    else
    {
            //Check Difference and update the DB and assign timeStampValue
        //Update older value from singelton and create new row
        int lockCountTemp=[[[NSUserDefaults standardUserDefaults]objectForKey:lockValue] intValue];
        int phoneUsageTime=[[[NSUserDefaults standardUserDefaults]objectForKey:phUsagesTime]intValue];
        [Singletoneclass sharedSingleton].phoneLockCount=[NSNumber numberWithInt:lockCountTemp];
        [Singletoneclass sharedSingleton].phoneUsageTime=[NSNumber numberWithInt:phoneUsageTime];

        [helperDb retriveAndCheck:timeStampSaved];
    }
    //Start The Phone Usage Timer
    PhoneUsageModelClass * phoneUsageObject=[[PhoneUsageModelClass alloc]init:YES];

}

-(void)createUIToSendToSettings
{
    if(self.noticeImageView)
    {
        return;
    }
    self.noticeImageView=[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds] ;
    self.noticeImageView.image=[UIImage imageNamed:@"settingMessage.png"];
    self.noticeImageView.userInteractionEnabled=YES;
    [self.window addSubview:self.noticeImageView];
    //----------------------
    UIButton * pushToSettingView=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 180, 50)];
    [pushToSettingView setTitle:@"Go to Setting" forState:UIControlStateNormal];
    [pushToSettingView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    pushToSettingView.layer.borderColor=[UIColor blackColor].CGColor;
    pushToSettingView.layer.borderWidth=1;
    [pushToSettingView addTarget:self action:@selector(sendToSettingView) forControlEvents:UIControlEventTouchUpInside];
    [self.noticeImageView addSubview:pushToSettingView];
}
-(void)sendToSettingView
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
     ];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    
}

-(float)calculateTotalScore
{
    int screenLck =[[NSString stringWithFormat:@"%@",[Singletoneclass sharedSingleton].phoneLockCount]intValue];
    int minuteTime=[[NSString stringWithFormat:@"%@",[Singletoneclass sharedSingleton].phoneUsageTime]intValue];
    //-
    return (screenLck/2+minuteTime/4);
    
}




- (void)applicationDidEnterBackground:(UIApplication *)application {
    ManageSmartNotifcation * manageObj=[[ManageSmartNotifcation alloc]init];
    [manageObj fireNotificationWithAddictionScore];
    //[self terminateTheNotification];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
       // [self terminateTheNotification];
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
//--Foreground
    
    if([Singletoneclass checkBackgroundAppRefreshIsOn])
    {
        [self.noticeImageView removeFromSuperview];
        self.noticeImageView=nil;
    }
    else
    {
        [self createUIToSendToSettings];
        
    }
    PhoneUsageModelClass * phoneUsageObj=[[PhoneUsageModelClass alloc]init];
    [phoneUsageObj checkdifferenceOfADay];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    [self terminateTheNotification];
    [self terminateOnsaveData];
    ManageSmartNotifcation * manageObj=[[ManageSmartNotifcation alloc]init];
    [manageObj fireNotificationWithAddictionScore];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)terminateTheNotification
{
    UILocalNotification * localNotification = [[UILocalNotification alloc] init];
    [localNotification setFireDate:[NSDate dateWithTimeIntervalSinceNow:20]];
    localNotification.alertBody =@"Sociometer has stopped tracking your time.Please tap to re-start or re-open the app";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
-(void)terminateOnsaveData
{
    //Retrive Data to update the Graph
    PhoneUsageModelClass *phoneUsages=[[PhoneUsageModelClass alloc]init];
    //[phoneUsages saveUserData];
    //Retrive Data to update the Graph
    CalenderHelper  * calenderHelper=[[CalenderHelper alloc]init];
    HelperDataBase * helperDB=[[HelperDataBase alloc]init];
    [[NSUserDefaults standardUserDefaults]setObject:[HelperDataBase currentDayTimeStamp:[NSDate date]] forKey:@"RunningDayTimeStamp"];
    double strvalue=[[[NSUserDefaults standardUserDefaults]objectForKey:@"RunningDayTimeStamp"]doubleValue];
    float  addictionScore=[[[NSUserDefaults standardUserDefaults]objectForKey:getAddictionScore]floatValue];
  
    
}

@end
