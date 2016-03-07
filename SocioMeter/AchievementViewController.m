//
//  AchievementViewController.m
//  SocioMeter
//
//  Created by Sumit Ghosh on 26/12/15.
//  Copyright © 2015 Sumit Ghosh. All rights reserved.
//

#import "AchievementViewController.h"
#import "HMSegmentedControl.h"
#import "CustomMenuViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "Singletoneclass.h"
#import "SettingsViewController.h"
#import "NSObject+CalenderHelperMethods.h"
#import "ApiHelperClass.h"
#import "PhoneUsageModelClass.h"
#import "HelperDataBase.h"
#import "DashBarViewController.h"
@interface AchievementViewController ()
{
    SettingsViewController * settingVc;
    NSArray *listOffAllScore;
}
@end

@implementation AchievementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self dashboard];
    self.view.backgroundColor=[UIColor whiteColor];
  settingVc=[[SettingsViewController alloc]init];
   // [self feddBackAction];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self updateSummeryWithStone];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createUI];
        });
    });
    

}
#pragma mark CreatingUI

-(void)createUI
{
    UIView * scoreView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 90)];
    scoreView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:scoreView];
    //---
    UIImageView *greenImg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 45, 45)];
    [greenImg setImage:[UIImage imageNamed:@"green_stone.png"]];
    [scoreView addSubview:greenImg];
    //----
    UIImageView *yellowImg=[[UIImageView alloc]initWithFrame:CGRectMake(scoreView.bounds.size.width/2-40, 15, 45, 45)];
    [yellowImg setImage:[UIImage imageNamed:@"yellow_stone.png"]];
    [scoreView addSubview:yellowImg];
        //----
    UIImageView *redImg=[[UIImageView alloc]initWithFrame:CGRectMake(scoreView.bounds.size.width-100, 15, 45, 45)];
    [redImg setImage:[UIImage imageNamed:@"red_stone.png"]];
    [scoreView addSubview:redImg];
    //--
    UIImageView *greencloseImg=[[UIImageView alloc]initWithFrame:CGRectMake(70, 30, 15 , 18)];
    greencloseImg.image=[UIImage imageNamed:@"close.png"];
    [scoreView addSubview:greencloseImg];
    //----
    UIImageView *redcloseImg=[[UIImageView alloc]initWithFrame:CGRectMake(scoreView.bounds.size.width/2+10, 30, 15 , 18)];
    redcloseImg.image=[UIImage imageNamed:@"close.png"];
    [scoreView addSubview:redcloseImg];
    //---
    UIImageView *yellocloseImg=[[UIImageView alloc]initWithFrame:CGRectMake(scoreView.bounds.size.width-50, 30, 15 , 18)];
    yellocloseImg.image=[UIImage imageNamed:@"close.png"];
    [scoreView addSubview:yellocloseImg];
    //----
   
    UILabel *greenLbl=[[UILabel alloc]initWithFrame:CGRectMake(90, 30, 20, 18)];
    greenLbl.text=@"0";
    greenLbl.textColor=Ggreen;
    [scoreView addSubview:greenLbl];
    //---
    UILabel * yellowLbl=[[UILabel alloc]initWithFrame:CGRectMake(scoreView.bounds.size.width/2+30, 30, 30, 18)];
    yellowLbl.textColor=Yyellow;
    yellowLbl.text=@"0";
    [scoreView addSubview:yellowLbl];
    //----
    UILabel * redLbl=[[UILabel alloc]initWithFrame:CGRectMake(scoreView.bounds.size.width-30, 30, 30, 18)];
    redLbl.textColor=RredColor;
    redLbl.text=@"0";
    [scoreView addSubview:redLbl];
    //--
   // int addictionScore=[[[NSUserDefaults standardUserDefaults]objectForKey:getAddictionScore]intValue];
    //setObject:totalScoreStr forKey:getAddictionScore];
    //---
    PhoneUsageModelClass *phUsagesClass=[[PhoneUsageModelClass alloc]init];

    NSDate *dateConverted = [NSDate dateWithTimeIntervalSince1970:[[[NSUserDefaults standardUserDefaults]objectForKey:@"RunningDayTimeStamp" ]  longLongValue]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *strCurrentDate = [formatter stringFromDate:dateConverted];
    
    NSDate *currentDate=[formatter dateFromString:strCurrentDate];
    
    int differenceInDay= [phUsagesClass compareDate:currentDate];
    //--
    //Retrive Data to update the Graph
    CalenderHelper  * calenderHelper=[[CalenderHelper alloc]init];
    HelperDataBase *helperDB=[[HelperDataBase alloc]init];
    DashBarViewController *dashbar=[[DashBarViewController alloc]init];
    NSArray * dbData= [ helperDB retrivePhoneUsage:[calenderHelper findFirstDayOfWeek].timeIntervalSince1970 higherTimeStamp:[calenderHelper findLastDayOfWeek].timeIntervalSince1970];
    
    [self setColumnDataValuesWeekly:dbData];
    NSLog(@"dbData %@",dbData);
    
    //--calculateTotal Stone
    int addictionScore;
    for(int i=0; i<[listOffAllScore count]; i++)
    {
        addictionScore = [((NSNumber*)[listOffAllScore objectAtIndex:i]) intValue];
    
    
    if(addictionScore<=50)
    {
        int greenStoneInt = [[[NSUserDefaults standardUserDefaults] objectForKey:@"greenStone"] intValue];
        greenStoneInt = greenStoneInt +1;
        NSString* value = [NSString stringWithFormat:@"%d",greenStoneInt];
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"greenStone"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        greenLbl.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"greenStone"];
        
    }
    
    else if (differenceInDay==1&&addictionScore<=80)
    {
        int yellowStoneInt = [[[NSUserDefaults standardUserDefaults] objectForKey:@"yellowStone"] intValue];
        yellowStoneInt = yellowStoneInt +1;
        NSString* value = [NSString stringWithFormat:@"%d",yellowStoneInt];
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"yellowStone"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        yellowLbl.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"yellowStone"];
        
    }
    else if (differenceInDay==1&&addictionScore<=350)
    {
        int redStoneInt = [[[NSUserDefaults standardUserDefaults] objectForKey:@"redStone"] intValue];
        redStoneInt = redStoneInt +1;
        NSString* value = [NSString stringWithFormat:@"%d",redStoneInt];
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"redStone"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        redLbl.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"redStone"];
    }
    }
    //--
    self.achievementTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 70, Screen_width, Screen_height-100)];
     self.achievementTableview.delegate=self;
     self.achievementTableview.dataSource=self;
    self.achievementTableview.separatorStyle=NO;
    self.achievementTableview.scrollEnabled=NO;
    [self.view addSubview: self.achievementTableview];

}


//--
-(void)setColumnDataValuesWeekly:(NSArray*)savedValuesInDb
{
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    for(int i=0;i<savedValuesInDb.count;i++)
    {
        NSDictionary * tempDict=[savedValuesInDb objectAtIndex:i];
        [tempArray addObject: [tempDict objectForKey:@"DailyAdditionScore"]];
    }
    for(int i=(int)tempArray.count ; i<(int)tempArray.count;i++)
    {
        [tempArray addObject:@"0"];
    }
   listOffAllScore=[NSArray arrayWithArray:tempArray];
}
#pragma Mark UI for Selected row .

-(void)selectFirstRow
{
    UIImageView * blackScrnImg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, Screen_width-10, Screen_height-10)];
    [blackScrnImg setImage:[UIImage imageNamed:@"popup.png"]];
    blackScrnImg.userInteractionEnabled=YES;
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:blackScrnImg];
    //----
    UILabel *greenLbl=[[UILabel alloc]initWithFrame:CGRectMake(40, 20,  blackScrnImg.bounds.size.width-80, 20)];
    greenLbl.text=[settingVc languageSelectedStringForKey:@"Green Day"];
    greenLbl.textAlignment=NSTextAlignmentCenter;
    greenLbl.textColor=[UIColor whiteColor];
    [blackScrnImg addSubview:greenLbl];
    //---
    UIImageView *characeterImg=[[UIImageView alloc]initWithFrame:CGRectMake(40, 70, blackScrnImg.bounds.size.width-80, blackScrnImg.bounds.size.height-170)];
    [characeterImg setImage:[UIImage imageNamed:@"greenbar"]];
    [blackScrnImg addSubview:characeterImg];
    //---
    UIImageView * lockImg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 130, 260, 260)];
    [lockImg setImage:[UIImage imageNamed:@"lock_img"]];
    [blackScrnImg addSubview:lockImg];
    //----
    UILabel *shareLbl=[[UILabel alloc]initWithFrame:CGRectMake(40, blackScrnImg.bounds.size.height-60, 200, 20)];
    shareLbl.text= [settingVc languageSelectedStringForKey:@"Share Your Achievement"];
    shareLbl.textAlignment=NSTextAlignmentCenter;
    shareLbl.textColor=[UIColor whiteColor];
    [blackScrnImg addSubview:shareLbl];
    //----
    UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(blackScrnImg.bounds.size.width-70, blackScrnImg.bounds.size.height-70, 40, 40)];
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [blackScrnImg addSubview:shareBtn];
    //----
    UIButton *crossBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    crossBtn.frame=CGRectMake(blackScrnImg.bounds.size.width-50, 10, 50, 50);
    [crossBtn setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    [crossBtn addTarget:self action:@selector(crossAction) forControlEvents:UIControlEventTouchUpInside];
    [blackScrnImg addSubview:crossBtn];
    //--
   
    
}

-(void)selectSecondRow
{
    UIImageView * blackScrnImg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, Screen_width-10, Screen_height-10)];
    [blackScrnImg setImage:[UIImage imageNamed:@"popup.png"]];
    blackScrnImg.userInteractionEnabled=YES;
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:blackScrnImg];
    //----
    UILabel *greenLbl=[[UILabel alloc]initWithFrame:CGRectMake(40, 20,  blackScrnImg.bounds.size.width-80, 20)];
    greenLbl.text=[settingVc languageSelectedStringForKey:@"Green Week"];
    greenLbl.textAlignment=NSTextAlignmentCenter;
    greenLbl.textColor=[UIColor whiteColor];
    [blackScrnImg addSubview:greenLbl];
    //---
    UIImageView *characeterImg=[[UIImageView alloc]initWithFrame:CGRectMake(40, 70, blackScrnImg.bounds.size.width-80, blackScrnImg.bounds.size.height-170)];
    [characeterImg setImage:[UIImage imageNamed:@"keepitgreen"]];
    [blackScrnImg addSubview:characeterImg];
    //---
    UIImageView * lockImg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 130, 260, 260)];
    [lockImg setImage:[UIImage imageNamed:@"lock_img"]];
    [blackScrnImg addSubview:lockImg];
    //----
    UILabel *shareLbl=[[UILabel alloc]initWithFrame:CGRectMake(40, blackScrnImg.bounds.size.height-60, 200, 20)];
    shareLbl.text= [settingVc languageSelectedStringForKey:@"Share Your Achievement"];
    shareLbl.textAlignment=NSTextAlignmentCenter;
    shareLbl.textColor=[UIColor whiteColor];
    [blackScrnImg addSubview:shareLbl];
    //----
    UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(blackScrnImg.bounds.size.width-70, blackScrnImg.bounds.size.height-70, 40, 40)];
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [blackScrnImg addSubview:shareBtn];
    //----
    UIButton *crossBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    crossBtn.frame=CGRectMake(blackScrnImg.bounds.size.width-50, 10, 50, 50);
    [crossBtn setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    [crossBtn addTarget:self action:@selector(crossAction) forControlEvents:UIControlEventTouchUpInside];
    [blackScrnImg addSubview:crossBtn];
    //--
    
    
}

-(void)selectThirdRow
{
    UIImageView * blackScrnImg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, Screen_width-10, Screen_height-10)];
    [blackScrnImg setImage:[UIImage imageNamed:@"popup.png"]];
    blackScrnImg.userInteractionEnabled=YES;
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:blackScrnImg];
    //----
    UILabel *greenLbl=[[UILabel alloc]initWithFrame:CGRectMake(40, 20,  blackScrnImg.bounds.size.width-80, 20)];
    greenLbl.text=[settingVc languageSelectedStringForKey:@"Doing Great"];
    greenLbl.textAlignment=NSTextAlignmentCenter;
    greenLbl.textColor=[UIColor whiteColor];
    [blackScrnImg addSubview:greenLbl];
    //---
    UIImageView *characeterImg=[[UIImageView alloc]initWithFrame:CGRectMake(40, 70, blackScrnImg.bounds.size.width-80, blackScrnImg.bounds.size.height-170)];
    [characeterImg setImage:[UIImage imageNamed:@"gettingitright"]];
    [blackScrnImg addSubview:characeterImg];
    //---
    UIImageView * lockImg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 130, 260, 260)];
    [lockImg setImage:[UIImage imageNamed:@"lock_img"]];
    [blackScrnImg addSubview:lockImg];
    //----
    UILabel *shareLbl=[[UILabel alloc]initWithFrame:CGRectMake(40, blackScrnImg.bounds.size.height-60, 200, 20)];
    shareLbl.text= [settingVc languageSelectedStringForKey:@"Share Your Achievement"];
    shareLbl.textAlignment=NSTextAlignmentCenter;
    shareLbl.textColor=[UIColor whiteColor];
    [blackScrnImg addSubview:shareLbl];
    //----
    UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(blackScrnImg.bounds.size.width-70, blackScrnImg.bounds.size.height-70, 40, 40)];
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [blackScrnImg addSubview:shareBtn];
    //----
    UIButton *crossBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    crossBtn.frame=CGRectMake(blackScrnImg.bounds.size.width-50, 10, 50, 50);
    [crossBtn setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    [crossBtn addTarget:self action:@selector(crossAction) forControlEvents:UIControlEventTouchUpInside];
    [blackScrnImg addSubview:crossBtn];
    //--
    
    
}

-(void)selectFourthRow
{
    UIImageView * blackScrnImg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, Screen_width-10, Screen_height-10)];
    [blackScrnImg setImage:[UIImage imageNamed:@"popup.png"]];
    blackScrnImg.userInteractionEnabled=YES;
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:blackScrnImg];
    //----
    UILabel *greenLbl=[[UILabel alloc]initWithFrame:CGRectMake(40, 20,  blackScrnImg.bounds.size.width-80, 20)];
    greenLbl.text=[settingVc languageSelectedStringForKey:@"Green Month"];
    greenLbl.textAlignment=NSTextAlignmentCenter;
    greenLbl.textColor=[UIColor whiteColor];
    [blackScrnImg addSubview:greenLbl];
    //---
    UIImageView *characeterImg=[[UIImageView alloc]initWithFrame:CGRectMake(40, 70, blackScrnImg.bounds.size.width-80, blackScrnImg.bounds.size.height-170)];
    [characeterImg setImage:[UIImage imageNamed:@"sociometerguru"]];
    [blackScrnImg addSubview:characeterImg];
    //---
    UIImageView * lockImg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 130, 260, 260)];
    [lockImg setImage:[UIImage imageNamed:@"lock_img"]];
    [blackScrnImg addSubview:lockImg];
    //----
    UILabel *shareLbl=[[UILabel alloc]initWithFrame:CGRectMake(40, blackScrnImg.bounds.size.height-60, 200, 20)];
    shareLbl.text= [settingVc languageSelectedStringForKey:@"Share Your Achievement"];
    shareLbl.textAlignment=NSTextAlignmentCenter;
    shareLbl.textColor=[UIColor whiteColor];
    [blackScrnImg addSubview:shareLbl];
    //----
    UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(blackScrnImg.bounds.size.width-70, blackScrnImg.bounds.size.height-70, 40, 40)];
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [blackScrnImg addSubview:shareBtn];
    //----
    UIButton *crossBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    crossBtn.frame=CGRectMake(blackScrnImg.bounds.size.width-50, 10, 50, 50);
    [crossBtn setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    [crossBtn addTarget:self action:@selector(crossAction) forControlEvents:UIControlEventTouchUpInside];
    [blackScrnImg addSubview:crossBtn];
    //--
    
    
}

-(void)selectFiveRow
{
    UIImageView * blackScrnImg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, Screen_width-10, Screen_height-10)];
    [blackScrnImg setImage:[UIImage imageNamed:@"popup.png"]];
    blackScrnImg.userInteractionEnabled=YES;
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:blackScrnImg];
    //----
    UILabel *greenLbl=[[UILabel alloc]initWithFrame:CGRectMake(40, 20,  blackScrnImg.bounds.size.width-80, 20)];
    greenLbl.text=[settingVc languageSelectedStringForKey:@"Phone Usage King"];
    greenLbl.textAlignment=NSTextAlignmentCenter;
    greenLbl.textColor=[UIColor whiteColor];
    [blackScrnImg addSubview:greenLbl];
    //---
    UIImageView *characeterImg=[[UIImageView alloc]initWithFrame:CGRectMake(40, 70, blackScrnImg.bounds.size.width-80, blackScrnImg.bounds.size.height-170)];
    [characeterImg setImage:[UIImage imageNamed:@"phoneusageking"]];
    [blackScrnImg addSubview:characeterImg];
    //---
    UIImageView * lockImg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 130, 260, 260)];
    [lockImg setImage:[UIImage imageNamed:@"lock_img"]];
    [blackScrnImg addSubview:lockImg];
    //----
    UILabel *shareLbl=[[UILabel alloc]initWithFrame:CGRectMake(40, blackScrnImg.bounds.size.height-60, 200, 20)];
    shareLbl.text= [settingVc languageSelectedStringForKey:@"Share Your Achievement"];
    shareLbl.textAlignment=NSTextAlignmentCenter;
    shareLbl.textColor=[UIColor whiteColor];
    [blackScrnImg addSubview:shareLbl];
    //----
    UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(blackScrnImg.bounds.size.width-70, blackScrnImg.bounds.size.height-70, 40, 40)];
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [blackScrnImg addSubview:shareBtn];
    //----
    UIButton *crossBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    crossBtn.frame=CGRectMake(blackScrnImg.bounds.size.width-50, 10, 50, 50);
    [crossBtn setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    [crossBtn addTarget:self action:@selector(crossAction) forControlEvents:UIControlEventTouchUpInside];
    [blackScrnImg addSubview:crossBtn];
    //--
    
    
}
-(void)crossAction
{
    [[[[[UIApplication sharedApplication]keyWindow]subviews]lastObject]removeFromSuperview];
    
}
#pragma mark Tableview Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0)
    {
        [self selectFirstRow];

    }
    else if (indexPath.row==1)
    {
        [self selectSecondRow];
    }
    else if (indexPath.row==2)
    {
        [self selectThirdRow];
    }
    else if (indexPath.row==3)
    {
        [self selectFourthRow];
    }
    else if (indexPath.row==4)
    {
        [self selectFiveRow];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UIImageView *lockImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 40, 40)];
    [lockImg setImage:[UIImage imageNamed:@"setting_lock"]];
    [cell.contentView addSubview:lockImg];
    
    //------
    NSArray *acivementArray=[[NSArray alloc]initWithObjects:@"Green Day",@"Green Week",@"Doing Great",@"Green Month",@"Phone Usages King", nil];
    UILabel *titelLbl=[[UILabel alloc]initWithFrame:CGRectMake(70, 10, Screen_width-70, 20)];
    titelLbl.textColor=[UIColor grayColor];
    titelLbl.text=[self languageSelectedStringForKey:[NSString stringWithFormat:@"%@",[acivementArray objectAtIndex:indexPath.row]]];
    [cell.contentView addSubview:titelLbl];
//-----
    NSArray *scoreArray=[[NSArray alloc]initWithObjects:@"(Score 50 or less in day)",@"(Score 50 or less on all days of week)",@"(Get an average of 50 or less in the week)",@"(Get an average of 50 or less in the month)", @"(Get an average phone usages of 1 hour or less in week)",nil];
    UILabel *scoreTitelLbl=[[UILabel alloc]initWithFrame:CGRectMake(70, 35, Screen_width-100, 30)];
    scoreTitelLbl.font =  [UIFont systemFontOfSize:12];
    scoreTitelLbl.textColor = [UIColor colorWithRed:(CGFloat)38/255 green:(CGFloat)81/255 blue:(CGFloat)166/255 alpha:(CGFloat)1];
    scoreTitelLbl.lineBreakMode=YES;
    scoreTitelLbl.numberOfLines=0;
    scoreTitelLbl.text=[self languageSelectedStringForKey:[NSString stringWithFormat:@"%@",[scoreArray objectAtIndex:indexPath.row]]];
    [cell.contentView addSubview:scoreTitelLbl];
    ////---
    int addictionScore=[Singletoneclass sharedSingleton].totalAddictionScore;
   // NSDate *todayDate=[[NSDate alloc]init];
    [self currentDayFromTwelveAm];
    if (indexPath.row==0 && addictionScore<=50&&[self currentDayFromTwelveAm])
    {
        UIImageView *greenBarImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 40, 40)];
        [greenBarImg setImage:[UIImage imageNamed:@"greenbar"]];
        [cell.contentView addSubview:greenBarImg];
        [lockImg removeFromSuperview];
    }
    
      return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return [indexPath row] + 150;
    
    return 70;
}

#pragma Mark Changing Language 

-(NSString*) languageSelectedStringForKey:(NSString*) key
{
    NSString *path;
    self.cahngeStrValue=[[NSString alloc]init];
    if([[Singletoneclass sharedSingleton].languageChanged isEqualToString:@"English"])
        path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    
    if([[Singletoneclass sharedSingleton].languageChanged isEqualToString:@"Arabic"])
        path = [[NSBundle mainBundle] pathForResource:@"ar" ofType:@"lproj"];
    else{
        path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    }
    NSBundle* languageBundle = [NSBundle bundleWithPath:path];
    NSString* str=[languageBundle localizedStringForKey:key value:@"" table:nil];
    
    return str;
}
#pragma mark updateUserSummery
-(void)updateSummeryWithStone
{
    
   
    
    NSString* userId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"output is : %@", userId);
    //--
    NSString *greenStoneStr=@"5";
    NSString *yellowStoneStr=@"2";
    NSString *redStoneStr=@"4";
    //--
//redStones,yellowStones,greenStones,userId
    ApiHelperClass *apiObj=[[ApiHelperClass alloc]init];
    NSDictionary *dict=@{@"redStones":redStoneStr,@"yellowStones":yellowStoneStr,@"greenStones":greenStoneStr,@"userId":userId};
    
    id dataReturned=[apiObj updateUserSummery:dict];
    
    if([[dataReturned objectForKey:@"code"] intValue]==198)
    {
    }
    else
    {
        
        //[self addAlertView:[dataReturned objectForKey:@"message"]];
    }
    
    
}
#pragma mark Check Difference Of A Day

//-(void)checkdifferenceOfADay
//{
//    NSDate *dateConverted = [NSDate dateWithTimeIntervalSince1970:[[[NSUserDefaults standardUserDefaults]objectForKey:@"RunningDayTimeStamp" ]  longLongValue]];
//    PhoneUsageModelClass *phUsagesClass=[[PhoneUsageModelClass alloc]init];
//    int differenceInDay= [phUsagesClass compareDate:dateConverted];
//    if(differenceInDay==1)
//    {
//        [self saveUserData];
//    }
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
