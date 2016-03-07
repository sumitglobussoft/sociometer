
//
//  DashBarViewController.m
//  SocioMeter
//
//  Created by Sumit Ghosh on 26/12/15.
//  Copyright © 2015 Sumit Ghosh. All rights reserved.
//

#import "DashBarViewController.h"
#import "HMSegmentedControl.h"
#import "EColumnChartLabel.h"
#import "EColumnDataModel.h"
#import "EFloatBox.h"
#import "EColor.h"
#import "Singletoneclass.h"
#import "SettingsViewController.h"
#import "CalenderHelper.h"
#import "HelperDataBase.h"
#import "ManageSmartNotifcation.h"
#import "ApiHelperClass.h"
#import "NSObject+CalenderHelperMethods.h"
#define AddictionScore @"DailyAdditionScore"
#define PhoneUsage @"TotalPhoneUsage"
@interface DashBarViewController () 
{
    HMSegmentedControl *segmentedControl;
    NSMutableArray *weekDays;
    NSMutableArray *totalDateArr;
    UILabel * dateLbl;
    NSString *lastmonthDate;
    NSDate *sevenDaysAgo;
    NSString *savenDateStr;
    NSDate *beginningOfWeek,*startingDayOfWeek,*endDayOfWeek;
    NSDate *firstDateInCurrentMonth,*lastdateOfMonth;
}
@property (nonatomic, strong) NSArray *xAxisdataColumnChart;
@property (nonatomic, strong) NSArray  * monthlyDatesXAxis;
@property (nonatomic, strong) EFloatBox *eFloatBox;

@property (nonatomic, strong) EColumn *eColumnSelected;
@property (nonatomic, strong) UIColor *tempColor;

@end

@implementation DashBarViewController
@synthesize tempColor = _tempColor;
@synthesize eFloatBox = _eFloatBox;
@synthesize eColumnChart = _eColumnChart;
@synthesize xAxisdataColumnChart = _xAxisdataColumnChart;
@synthesize eColumnSelected = _eColumnSelected;
@synthesize valueLabel = _valueLabel;
@synthesize totalScore;
@synthesize ePieChart = _ePieChart , screenlockLbl;
@synthesize monthlyScoreValues,weeklyScoreValues,weeklyPhUsgesScoreValue;
@synthesize weeklyView,todayView,monthlyView,dateCount,_eColumnChartForPhUsages,_eColumnChartForWeeklyAddiction;


- (void)viewDidLoad {
    [super viewDidLoad];
    firstDateInCurrentMonth=[self firstDayOfMonth:[NSDate date]];
    // [self CreateUI];
    //-----------
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePhoneUsageAndLock:) name:@"UpdatePhoneUsageAndLock" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWeeklyGraphUpdationOnEvents:) name:@"ReloadWeeklyGraph" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMonthlyGraphUpdationOnEvents:) name:@"ReloadMonthlyGraph" object:nil];
    [ [NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPieChart) name:@"ReloadPieChart" object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabel:) name:@"Updatelbl" object:nil];
    self.view.backgroundColor=[UIColor whiteColor];
    //-------------
    [self userSocimeter];
   beginningOfWeek =[self findFirstDayOfWeek];
}



-(void)viewDidAppear:(BOOL)animated
{    [super viewDidAppear:YES];

    [self createUI];
    
}

-(void)updateDetails
{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckFirstTime"] isEqual:@"First"]){
        NSLog(@"Not first Time");
        
    }
    
    else{
        NSLog(@"First Time");
        
        [[NSUserDefaults standardUserDefaults]setObject:@"First" forKey:checkFirstTime];
        [[NSUserDefaults standardUserDefaults]synchronize];
       
       
    }
  
}
#pragma mark UserSocimeter Usages Service
-(void)userSocimeter
{
   // userId,lockCount,phoneUsageSeconds,addScore,timeStamp
    
//    NSUUID *userId;
//    userId = [UIDevice currentDevice].identifierForVendor;
//    NSString *userIdStr=[NSString stringWithFormat:@"%@",userId];
//    NSLog(@"deviceUDID: %@",userIdStr);
    
    NSString* userId = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    NSLog(@"output is : %@", userId);
    //---
    NSString *lockStr=@"5";
    [[NSUserDefaults standardUserDefaults]objectForKey:lockValue];
   //--
    NSString *phoneUsagesSec=[[NSUserDefaults standardUserDefaults]objectForKey:phUsagesTime];
    //--
    totalScore=[self calculateTotalScore];
    [Singletoneclass sharedSingleton].totalAddictionScore=totalScore;
    NSLog(@"addScore %d",totalScore);
    //--
    NSString *totalAddtictionScore=[NSString stringWithFormat:@"%d",totalScore];
    //--
    NSString * timeStamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
   //--
    ApiHelperClass *apiObj=[[ApiHelperClass alloc]init];
   //--
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (lockStr!=nil&&phoneUsagesSec!=nil&lockStr!=nil&&totalAddtictionScore!=nil) {
            NSDictionary *dict=@{@"userId":userId,@"lockCount":lockStr,@"phoneUsageSeconds":phoneUsagesSec,@"addScore":totalAddtictionScore,@"timeStamp":timeStamp};
            id dataReturned=[apiObj userSociometerDetails:dict];
            NSLog(@"%@",dataReturned);
            
        }
    });
    
    //--
 
    
}


#pragma mark Creating UI

-(void)createUI
{
 
    //-------------------segmentController
    
    NSArray *arrList=[[NSArray alloc]initWithObjects:@"Today", @"Weekly", @"Monthly", nil];
    
    NSMutableArray *langChange=[[NSMutableArray alloc]init];
    for (int i=0; i<arrList.count; i++) {
      NSString *strr=[NSString stringWithFormat:@"%@",[self languageSelectedStringForKey:[NSString stringWithFormat:@"%@",[arrList objectAtIndex:i]]]];
        
        //[langChange arrayByAddingObject:strr];
        [langChange addObject:strr];
    }

    segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:langChange];
    [segmentedControl setBorderColor:[UIColor colorWithRed:140/255 green:200/255 blue:235/255 alpha:1]];
    [segmentedControl setFrame:CGRectMake(0, Screen_height-100, Screen_width, 40)];
    [segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [self segmentedControlChangedValue];
    }];

   [segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
       NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]}];
       return attString;
   }];
    segmentedControl.selectionIndicatorHeight = 2.0f;
    segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl.backgroundColor = [UIColor colorWithRed:(CGFloat)234/255 green:(CGFloat)234/255 blue:(CGFloat)234/255 alpha:1];
    segmentedControl.selectionIndicatorColor = [UIColor blackColor];
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    segmentedControl.selectedSegmentIndex = HMSegmentedControlNoSegment;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlBorderTypeRight;
    segmentedControl.shouldAnimateUserSelection = NO;
    segmentedControl.tag = 2;
    [self circleChart];
    [self.view addSubview:segmentedControl];
    //--
  }
#pragma mark ----

- (void)segmentedControlChangedValue
{
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    if ((long)segmentedControl.selectedSegmentIndex==0) {
        [self.dateImg removeFromSuperview];
        [self circleChart];
        weeklyView.hidden=YES;
        monthlyView.hidden=YES;
        
    }
    else if ((long)segmentedControl.selectedSegmentIndex==1){
        todayView.hidden=YES;
        monthlyView.hidden=YES;
        //--
        HelperDataBase * helperDB=[[HelperDataBase alloc]init];
            NSArray * dbData= [ helperDB retrivePhoneUsage:[self findFirstDayOfWeek].timeIntervalSince1970 higherTimeStamp:[self findLastDayOfWeek].timeIntervalSince1970];
            [self getCurrentValueFromDb:dbData];
            [self setWeeklyColumnChartData:dbData];
            [self columnChartView];
            
            NSLog(@"dbData %@",dbData);
        
        
    }
    else if ((long)segmentedControl.selectedSegmentIndex==2){
        todayView.hidden=YES;
        weeklyView.hidden=YES;
        //--
        HelperDataBase * helperDB=[[HelperDataBase alloc]init];
        //We have to pass first and last day of month (Correct kar lena)
        NSArray * dbData= [ helperDB retrivePhoneUsage:[self firstDayOfMonth:[NSDate date]].timeIntervalSince1970 higherTimeStamp:[self lastDayOfMonth:[NSDate date]].timeIntervalSince1970];
        [self getCurrentValueFromDb:dbData];
        //-------------------------
        NSMutableArray * tempArray=[[NSMutableArray alloc]init];
        dateCount=(int)[self numberOfDaysInMonthCount:[NSDate date]];
        for (int i=1;i<=dateCount; i++)
        {
            [tempArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        monthlyScoreValues=[NSArray arrayWithArray:tempArray];
        //--------------------------
        [self setColumnDataValuesMonthly:dbData valueType:AddictionScore];
        [self monthlycolumnChart];
    }
    
    
}
#pragma mark -----

-(void)circleChart
{
    todayView=[[UIView alloc]initWithFrame:CGRectMake(5, 5, Screen_width-10, Screen_height-115)];
    todayView.backgroundColor=[UIColor colorWithRed:(CGFloat)234/255 green:(CGFloat)234/255 blue:(CGFloat)234/255 alpha:1];
    [self.view addSubview:todayView];
    [self epiechartAction];
    //---
    UIView *horizantalLine=[[UIView alloc]initWithFrame:CGRectMake(0, Screen_height/2-100, Screen_width-10, 5)];
    horizantalLine.backgroundColor=[UIColor whiteColor];
    [todayView addSubview:horizantalLine];
    //---
    [self randomImage];
    //---
    UIButton *screenlockBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, Screen_height-175, Screen_width/2-10, 50)];
    screenlockBtn.backgroundColor=[UIColor colorWithRed:(CGFloat)41/255 green:(CGFloat)67/255 blue:(CGFloat)161/255 alpha:1];
    [screenlockBtn.layer setBorderWidth:1.0];
    [screenlockBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [screenlockBtn.layer setShadowOffset:CGSizeMake(1, 1)];
    [screenlockBtn.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [screenlockBtn.layer setShadowOpacity:0.3];
    [todayView addSubview:screenlockBtn];
    
    //---
    UIImageView * lockScrenImg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 30, 30)];
    [lockScrenImg setImage:[UIImage imageNamed:@"lock_icon"]];
    [screenlockBtn addSubview:lockScrenImg];
    //----
    screenlockLbl=[[UILabel alloc]initWithFrame:CGRectMake(70, 10, 40, 15)];
    NSString *phoneLock=[NSString stringWithFormat:@"%@",[Singletoneclass sharedSingleton].phoneLockCount];
    [[NSUserDefaults standardUserDefaults]setObject:phoneLock forKey:lockValue];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    screenlockLbl.text=phoneLock;
    //[NSString stringWithFormat:@"%@",[Singletoneclass sharedSingleton].phoneLockCount];
    //[NSString stringWithFormat:@"%@",[Singletoneclass sharedSingleton].phoneLockCount];
    screenlockLbl.textColor=[UIColor whiteColor];
    [screenlockBtn addSubview:screenlockLbl];
    //-----
    UILabel *screenlockTitel=[[UILabel alloc]initWithFrame:CGRectMake(50, 20, 100, 30)];
    screenlockTitel.text=[self languageSelectedStringForKey:@"Screen Unlocks"];
    screenlockTitel.font = [UIFont systemFontOfSize:12];
    screenlockTitel.textColor=[UIColor whiteColor];
    [screenlockBtn addSubview:screenlockTitel];
    //-----
    UIButton *phUsageBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_width/2+10, Screen_height-175, Screen_width/2-25, 50)];
    [phUsageBtn.layer setBorderWidth:1.0];
    [phUsageBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [phUsageBtn.layer setShadowOffset:CGSizeMake(1, 1)];
    [phUsageBtn.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [phUsageBtn.layer setShadowOpacity:0.3];
    phUsageBtn.backgroundColor=[UIColor colorWithRed:(CGFloat)41/255 green:(CGFloat)67/255 blue:(CGFloat)161/255 alpha:1];
    [todayView addSubview:phUsageBtn];
    
    //-------
    UIImageView * phUsageImg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 30, 30)];
    [phUsageImg setImage:[UIImage imageNamed:@"time_icon"]];
    [phUsageBtn addSubview:phUsageImg];
    //----
    self.phusageTimeLbl=[[UILabel alloc]initWithFrame:CGRectMake(70, 10, 40, 15)];
    //---timeInterVal
    NSString *phoneUsagesTime=[NSString stringWithFormat:@"%@",[Singletoneclass sharedSingleton].phoneUsageTime];
    [[NSUserDefaults standardUserDefaults]setObject:phoneUsagesTime forKey:phUsagesTime];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //---
    
    self.phusageTimeLbl.text=[self calculateTotalTimeInterval];
    self.phusageTimeLbl.textColor=[UIColor whiteColor];
    [phUsageBtn addSubview:self.phusageTimeLbl];
    
    //--
    UILabel *phusageTitel=[[UILabel alloc]initWithFrame:CGRectMake(50, 20, 100, 30)];
    phusageTitel.text=[self languageSelectedStringForKey:@"Phone Usage"];
    phusageTitel.font = [UIFont systemFontOfSize:12];
    phusageTitel.textColor=[UIColor whiteColor];
    [phUsageBtn addSubview:phusageTitel];
    //----
   }
#pragma mark------

-(void)columnChartView
{
    //----
    [Singletoneclass sharedSingleton].graphSelected=AddictionScoreDBDictionaryKey;
    weeklyView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height-100)];
    weeklyView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:weeklyView];
    //----
    self.dateImg=[[UIImageView alloc]initWithFrame:CGRectMake(30, 10, Screen_width-60, 40)];
    [self.dateImg setImage:[UIImage imageNamed:@"slider_bg.png"]];
    self.dateImg.userInteractionEnabled=YES;
    [weeklyView addSubview:self.dateImg];
    dateLbl=[[UILabel alloc]initWithFrame:CGRectMake(40, 5,self.dateImg.frame.size.width-80, 35)];
    dateLbl.text=savenDateStr;
    dateLbl.textAlignment=NSTextAlignmentCenter;
    dateLbl.textColor=[UIColor whiteColor];
    [self.dateImg addSubview:dateLbl];
    //----
    UIButton *leftsidebarBtn=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    [leftsidebarBtn setImage:[UIImage imageNamed:@"left_slider"] forState:UIControlStateNormal];
    [leftsidebarBtn addTarget:self action:@selector(weeklyLeftSliderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.dateImg addSubview:leftsidebarBtn];
    //----
    UIButton *rightsidebarBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.dateImg.bounds.size.width-35, 5, 30, 30)];
    [rightsidebarBtn setImage:[UIImage imageNamed:@"right_slider"] forState:UIControlStateNormal];
    [rightsidebarBtn addTarget:self action:@selector(weeklyRightSliderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.dateImg addSubview:rightsidebarBtn];
    //---
    UIButton *addictionBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, Screen_height-170, Screen_width/2-10, 50)];
    addictionBtn.backgroundColor=[UIColor colorWithRed:(CGFloat)41/255 green:(CGFloat)67/255 blue:(CGFloat)161/255 alpha:1];
    [addictionBtn.layer setBorderWidth:1.0];
    [addictionBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [addictionBtn.layer setShadowOffset:CGSizeMake(1, 1)];
    [addictionBtn.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [addictionBtn.layer setShadowOpacity:0.3];
    [addictionBtn addTarget:self action:@selector(addictionScoreBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [weeklyView addSubview:addictionBtn];
    
    //---
    UIImageView * lockScrenImg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 35, 35)];
    [lockScrenImg setImage:[UIImage imageNamed:@"addiction_icon"]];
    [addictionBtn addSubview:lockScrenImg];
    //-----
    UILabel *screenlockTitel=[[UILabel alloc]initWithFrame:CGRectMake(50, 20, 100, 15)];
    screenlockTitel.text=[self languageSelectedStringForKey:@"Addiction Score"];
    screenlockTitel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    screenlockTitel.textColor=[UIColor whiteColor];
    [addictionBtn addSubview:screenlockTitel];
    //-----
    UIButton *phUsageBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_width/2+10, Screen_height-170, Screen_width/2-25, 50)];
    phUsageBtn.backgroundColor=[UIColor colorWithRed:(CGFloat)41/255 green:(CGFloat)67/255 blue:(CGFloat)161/255 alpha:1];
    [phUsageBtn.layer setBorderWidth:1.0];
    [phUsageBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [phUsageBtn.layer setShadowOffset:CGSizeMake(1, 1)];
    [phUsageBtn.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [phUsageBtn.layer setShadowOpacity:0.3];
    [phUsageBtn addTarget:self action:@selector(phoneUsagesBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [weeklyView addSubview:phUsageBtn];
    
    //-------
    UIImageView * phUsageImg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 30, 30)];
    [phUsageImg setImage:[UIImage imageNamed:@"time_icon"]];
    [phUsageBtn addSubview:phUsageImg];
    
    //-----
    UILabel *phusageTitel=[[UILabel alloc]initWithFrame:CGRectMake(50, 20, 100, 15)];
    phusageTitel.text=[self languageSelectedStringForKey:@"Phone Usage"];
    phusageTitel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    phusageTitel.textColor=[UIColor whiteColor];
    [phUsageBtn addSubview:phusageTitel];
    //------
      //-------
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    UILabel *chartYAxisDescription = [[UILabel alloc] init];
    chartYAxisDescription.font = font;
    chartYAxisDescription.text = @"Addiction Score";
    chartYAxisDescription.font=[UIFont systemFontOfSize:12];
    chartYAxisDescription.textColor=[UIColor lightGrayColor];
    CGSize size = [@"Addiction Score" sizeWithAttributes:@{NSFontAttributeName:font}];
    chartYAxisDescription.frame = CGRectMake(-60, Screen_height/2, size.width, size.height);
    [chartYAxisDescription.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
    chartYAxisDescription.transform = CGAffineTransformMakeRotation(-(M_PI) / 2);
    [weeklyView addSubview:chartYAxisDescription];
    //---------------Adding AddictionScore Label
   self.graphDescriptionLabel=[[UILabel alloc]init];
    self.graphDescriptionLabel.text=[NSString stringWithFormat:@"Avg.Addiction Score: %.2f",(float)[self calculateAverageScore:self.presentFetchedDataFromDb keyValue:AddictionScoreDBDictionaryKey]];
    self.graphDescriptionLabel.textColor=[UIColor colorWithRed:(CGFloat)14/255 green:(CGFloat)44/255 blue:(CGFloat)149/255 alpha:1];
    self.graphDescriptionLabel.textAlignment=NSTextAlignmentCenter;
    [weeklyView addSubview:self.graphDescriptionLabel];
    [self weeklyColumnChart];
    
}
-(void)weeklyColumnChart
{
    _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(50, 100, Screen_width-80, Screen_height/2-55)];
    if(IS_IPAD)
    {
        _eColumnChart.frame=CGRectMake(50,200, Screen_width-100, Screen_height/2-55);
    }
    
    [_eColumnChart setColumnsIndexStartFromLeft:YES];
    _eColumnChart.typeOfGraph=@"Weekly";
    [_eColumnChart setDelegate:self];
    [_eColumnChart setDataSource:self];
    [weeklyView addSubview:_eColumnChart];

    CGFloat hhChart=_eColumnChart.frame.origin.y+_eColumnChart.frame.size.height+20;
    UILabel * descriptionXAxisValues=[[UILabel alloc]initWithFrame:CGRectMake(20,hhChart, Screen_width-40,15)];
    descriptionXAxisValues.textColor=[UIColor lightGrayColor];
    descriptionXAxisValues.font=[UIFont systemFontOfSize:12];
    descriptionXAxisValues.textAlignment=NSTextAlignmentCenter;
    descriptionXAxisValues.text=@"Date";
    [weeklyView addSubview:descriptionXAxisValues];
    self.graphDescriptionLabel.frame=CGRectMake(50,hhChart+20,Screen_width-100, 20);
}
#pragma mark WeeklyslideButtonClick
-(void)weeklyLeftSliderBtnClick
{
    [self substractSliderDate:beginningOfWeek end:sevenDaysAgo];
}
-(void)weeklyRightSliderBtnClick
{
    [self addSliderDate:beginningOfWeek end:sevenDaysAgo];
}
#pragma mark--------

-(void)epiechartAction
{
    //--
    //---
    NSString *totalScoreStr=[NSString stringWithFormat:@"%f",[self calculateTotalScore]];
    //--
    NSString *currentTimeStamp=[[NSUserDefaults standardUserDefaults]objectForKey:@"RunningDayTimeStamp"];
    //--
 //   [helperDb retriveAndCheck:timeStamp andAddNewDict:dict];
    //-
    [[NSUserDefaults standardUserDefaults]setObject:currentTimeStamp forKey:@"HasLaunchedOnce"];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@" first Time");
     //   [helperDb retriveAndCheck:timeStamp andAddNewDict:dict];
    }
    //--
    [[NSUserDefaults standardUserDefaults]setObject:totalScoreStr forKey:getAddictionScore];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //-----
    [Singletoneclass sharedSingleton].totalAddictionScore=[self calculateTotalScore];
    int currentDegree=totalScore*360/100;
    //-----
      EPieChartDataModel *ePieChartDataModel = [[EPieChartDataModel alloc] initWithBudget:currentDegree current:totalScore estimate:77];
    if (Screen_height==568)
    {
        _ePieChart = [[EPieChart alloc] initWithFrame:CGRectMake(0, 0, Screen_width/2, 180)
                                   ePieChartDataModel:ePieChartDataModel];
    }
    else if (Screen_height==480)
    {
        _ePieChart = [[EPieChart alloc] initWithFrame:CGRectMake(0, 0, Screen_width/2, 140)
                                   ePieChartDataModel:ePieChartDataModel];
    }
    else if (Screen_height==667)
    {
        
        _ePieChart = [[EPieChart alloc] initWithFrame:CGRectMake(0, 0, Screen_width/2, 200)
                                   ePieChartDataModel:ePieChartDataModel];
       
    }
    else{
               _ePieChart = [[EPieChart alloc] initWithFrame:CGRectMake(0, 0, Screen_width/2, 200)
                                   ePieChartDataModel:ePieChartDataModel];
    }
    if(IS_IPAD)
    {
        _ePieChart = [[EPieChart alloc] initWithFrame:CGRectMake(0, 0, Screen_width/2, 200)
                                   ePieChartDataModel:ePieChartDataModel];
    }
    _ePieChart.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [_ePieChart setDelegate:self];
    [_ePieChart setDataSource:self];
    [todayView addSubview:_ePieChart];
    //--
   // [self checkdifferenceOfADay];
}

-(void)checkdifferenceOfADay
{
    NSDate *dateConverted = [NSDate dateWithTimeIntervalSince1970:[[[NSUserDefaults standardUserDefaults]objectForKey:@"RunningDayTimeStamp" ]  longLongValue]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *strCurrentDate = [formatter stringFromDate:dateConverted];
    
    NSDate *currentDate=[formatter dateFromString:strCurrentDate];
    PhoneUsageModelClass *phoneUsages=[[PhoneUsageModelClass alloc]init];
    int differenceInDay= [phoneUsages compareDate:currentDate];
    if(differenceInDay==1)
    {
        [phoneUsages saveUserData];
    }
    
}
-(void)compareDAte
{
    NSDate *today = [NSDate date];

    NSDate *compareDate=[NSDate dateWithTimeIntervalSince1970:[[[NSUserDefaults standardUserDefaults]objectForKey:@"RunningDayTimeStamp" ]  longLongValue]];
    NSComparisonResult compareResult = [today compare : compareDate];
    
    if (compareResult == NSOrderedAscending)
    {
        NSLog(@"CompareDate is in the future");
    }
    else if (compareResult == NSOrderedDescending)
    {
        NSLog(@"CompareDate is in the past");
    }
    else
    {
        NSLog(@"Both dates are the same");
    }
}


-(NSString *)calculateTotalTimeInterval
{
    int minutesInt=[[[NSUserDefaults standardUserDefaults]objectForKey:phUsagesTime]intValue];
    int hours = (int)minutesInt /60;
    int timeLeft=minutesInt-60*hours;
    NSString *timeDiff;
    if(timeLeft/10>=1)
    {
         timeDiff= [NSString stringWithFormat:@"%d:%d", hours,timeLeft];

    }
    else
    {
       timeDiff = [NSString stringWithFormat:@"%d:0%d", hours,timeLeft];

    }
    return timeDiff;
}
-(void)dateCountingLogic
{
    //---
    NSDate *currentDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:currentDate];
    [components setDay:([components day]-([components weekday]-1))];
    
    beginningOfWeek = [gregorian dateFromComponents:components];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd, MMM"];
    NSString *dateString_first = [dateFormatter stringFromDate:beginningOfWeek];
    
    NSString* dateString = dateString_first;
    
    NSDateFormatter* fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"dd, MMM"];
    NSDate* date = [fmt dateFromString:dateString];
    
    //NSLog(@"First_date: %@", date);
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:+ 6];
    
    
    sevenDaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:beginningOfWeek options:0];
    
    savenDateStr=[NSString stringWithFormat:@"%@-%@",dateString_first,[dateFormatter stringFromDate:sevenDaysAgo]];
    
    NSLog(@"%@date11,%@",[dateFormatter stringFromDate:currentDate],[dateFormatter stringFromDate:sevenDaysAgo]);
    //------

}

-(void)setWeeklyColumnChartData:(NSArray*)dbData
{
    [self dateCountingLogic];
    //----------------------------------------
    NSMutableArray *temp = [NSMutableArray array];
    ///[self addSliderDate:beginningOfWeek end:sevenDaysAgo];
    NSArray * weeklyDateToDiplayOnXAxis=[self setArrayOfDatesForXaxis:@""];
    weeklyScoreValues=[NSArray arrayWithArray:weeklyDateToDiplayOnXAxis];
    [self setColumnDataValuesWeekly:dbData valueType:AddictionScoreDBDictionaryKey];
    for (int i = 0; i < weeklyDateToDiplayOnXAxis.count; i++)
    {
        NSString * weeklyDateDisplayStr=[NSString stringWithFormat:@"%@",  [weeklyDateToDiplayOnXAxis objectAtIndex:i]];
        if(i>7)
        {
            weeklyDateDisplayStr=@"";
        }
        
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:weeklyDateDisplayStr value:[[weeklyScoreValues objectAtIndex: i] floatValue] index:i unit:nil];
        
        [temp addObject:eColumnDataModel];
        //[weekDays addObject:temp];
       // NSLog(@"arr11 == %@",temp);
        
    }
    
    _xAxisdataColumnChart = [NSArray arrayWithArray:temp];
  //  NSLog(@"arr list== %@",[NSArray arrayWithArray:temp]);
    

}

#pragma mark Monthly ColumnChart UI

-(void)monthlycolumnChart
{
    [Singletoneclass sharedSingleton].graphSelected=AddictionScoreDBDictionaryKey;
    //----
    monthlyView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height-100)];
    monthlyView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:monthlyView];
    //----
    self.dateImg=[[UIImageView alloc]initWithFrame:CGRectMake(30, 10, Screen_width-60, 40)];
    [self.dateImg setImage:[UIImage imageNamed:@"slider_bg.png"]];
    self.dateImg.userInteractionEnabled=YES;
    [monthlyView addSubview:self.dateImg];
    //---
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:zone];
    [formatter setDateFormat:@"dd, MMM"];
    //--
    
    ManageSmartNotifcation *manageSmartVc=[[ManageSmartNotifcation alloc]init];
    [manageSmartVc setStartingTime:today];
    
    //---
   firstDateInCurrentMonth =[self firstDayOfMonth:today];
    NSString *firstdateOfMonth = [formatter stringFromDate:firstDateInCurrentMonth];
    NSLog(@"%@",firstDateInCurrentMonth);
    //---
    lastdateOfMonth=[self lastDayOfMonth:today];
    lastmonthDate=[formatter stringFromDate:lastdateOfMonth];
    NSString *monthDate=[NSString stringWithFormat:@"%@-%@",firstdateOfMonth,lastmonthDate];
    //------
    dateLbl=[[UILabel alloc]initWithFrame:CGRectMake(40, 5, Screen_width-140, 35)];
    dateLbl.text=monthDate;
    dateLbl.textAlignment=NSTextAlignmentCenter;
    dateLbl.textColor=[UIColor whiteColor];
    [self.dateImg addSubview:dateLbl];
    //----
    UIButton *leftsidebarBtn=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    [leftsidebarBtn setImage:[UIImage imageNamed:@"left_slider"] forState:UIControlStateNormal];
    [leftsidebarBtn addTarget:self action:@selector(leftSliderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.dateImg addSubview:leftsidebarBtn];
    //----
    UIButton *rightsidebarBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.dateImg.bounds.size.width-35, 5, 30, 30)];
    [rightsidebarBtn setImage:[UIImage imageNamed:@"right_slider"] forState:UIControlStateNormal];
    [rightsidebarBtn addTarget:self action:@selector(rightSliderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.dateImg addSubview:rightsidebarBtn];
    //---
    UIButton *addictionBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, Screen_height-170, Screen_width/2-10, 50)];
    addictionBtn.backgroundColor=[UIColor colorWithRed:(CGFloat)41/255 green:(CGFloat)67/255 blue:(CGFloat)161/255 alpha:1];
    [addictionBtn.layer setBorderWidth:1.0];
    [addictionBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [addictionBtn.layer setShadowOffset:CGSizeMake(1, 1)];
    [addictionBtn.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [addictionBtn.layer setShadowOpacity:0.3];
    [addictionBtn addTarget:self action:@selector(addictionScoreBtnForMonthly) forControlEvents:UIControlEventTouchUpInside];
    [monthlyView addSubview:addictionBtn];
    //---
    UIImageView * lockScrenImg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 35, 35)];
    [lockScrenImg setImage:[UIImage imageNamed:@"addiction_icon"]];
    [addictionBtn addSubview:lockScrenImg];
   
    //-----
    UILabel *screenlockTitel=[[UILabel alloc]initWithFrame:CGRectMake(50, 20, 100, 15)];
    screenlockTitel.text=[self languageSelectedStringForKey:@"Addiction Score"];
    screenlockTitel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    screenlockTitel.textColor=[UIColor whiteColor];
    [addictionBtn addSubview:screenlockTitel];
    //-----
    UIButton *phUsageBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_width/2+10, Screen_height-170, Screen_width/2-25, 50)];
    phUsageBtn.backgroundColor=[UIColor colorWithRed:(CGFloat)41/255 green:(CGFloat)67/255 blue:(CGFloat)161/255 alpha:1];
    [phUsageBtn.layer setBorderWidth:1.0];
    [phUsageBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [phUsageBtn.layer setShadowOffset:CGSizeMake(1, 1)];
    [phUsageBtn.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [phUsageBtn.layer setShadowOpacity:0.3];
    [phUsageBtn addTarget:self action:@selector(phUsagesBtnForMonthly) forControlEvents:UIControlEventTouchUpInside];
    [monthlyView addSubview:phUsageBtn];
    //-------
    UIImageView * phUsageImg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 30, 30)];
    [phUsageImg setImage:[UIImage imageNamed:@"time_icon"]];
    [phUsageBtn addSubview:phUsageImg];
    //-----
    UILabel *phusageTitel=[[UILabel alloc]initWithFrame:CGRectMake(50, 20, 100, 15)];
    phusageTitel.text=[self languageSelectedStringForKey:@"Phone Usage"];
    phusageTitel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    phusageTitel.textColor=[UIColor whiteColor];
    [phUsageBtn addSubview:phusageTitel];
  //--
    //------
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    UILabel *chartYAxisDescription = [[UILabel alloc] init];
    chartYAxisDescription.font = font;
    chartYAxisDescription.text = @"Addiction Score";
    chartYAxisDescription.font=[UIFont systemFontOfSize:12];
    chartYAxisDescription.textColor=[UIColor lightGrayColor];
    CGSize size = [@"Addiction Score" sizeWithAttributes:@{NSFontAttributeName:font}];
    chartYAxisDescription.frame = CGRectMake(-60, Screen_height/2, size.width, size.height);
    [chartYAxisDescription.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
    chartYAxisDescription.transform = CGAffineTransformMakeRotation(-(M_PI) / 2);
    [monthlyView addSubview:chartYAxisDescription];

    //---------------Adding AddictionScore Label
    self.graphDescriptionLabel=[[UILabel alloc]init];
    self.graphDescriptionLabel.text=[NSString stringWithFormat:@"Avg.Addiction Score %.2f",(float)[self calculateAverageScore:self.presentFetchedDataFromDb keyValue:AddictionScoreDBDictionaryKey]];
    self.graphDescriptionLabel.textColor=[UIColor colorWithRed:(CGFloat)14/255 green:(CGFloat)44/255 blue:(CGFloat)149/255 alpha:1];
    self.graphDescriptionLabel.textAlignment=NSTextAlignmentCenter;
    [monthlyView addSubview:self.graphDescriptionLabel];
    [self monthlyChartWithAddictionScore];
  
}
-(void)monthlyChartWithAddictionScore
{
    NSMutableArray *temp = [NSMutableArray array];
    NSDate *date=[NSDate date];
    dateCount= [self numberOfDaysInMonthCount:date];
    NSArray * dateToDiplayOnXAxis=[self oneMonthDateList:date];
    int dateSum=1;
    for (int i = 0; i <dateCount; i++)
    {
        NSString * dateDisplayStr=@"";
       if(i%3==0)
       {
          dateDisplayStr=[NSString stringWithFormat:@"%d",dateSum];
           dateSum=dateSum+3;
       }
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:dateDisplayStr value:[[monthlyScoreValues objectAtIndex: i] floatValue] index:i unit:nil];
        [temp addObject:eColumnDataModel];
        //[weekDays addObject:eColumnDataModel];
      //  NSLog(@"arr11 == %@",temp);
    }
    _xAxisdataColumnChart = [NSArray arrayWithArray:temp];
    //NSLog(@"arr list== %@",[NSArray arrayWithArray:temp]);
    _ecolumnChartMonthly= [[EColumnChart alloc] initWithFrame:CGRectMake(50, 100, Screen_width-80, Screen_height/2-55)];
    if(IS_IPAD)
    {
        _ecolumnChartMonthly.frame=CGRectMake(50,200, Screen_width-100, Screen_height/2-55);
    }
    [_ecolumnChartMonthly setColumnsIndexStartFromLeft:YES];
    [_ecolumnChartMonthly setDelegate:self];
    [_ecolumnChartMonthly setDataSource:self];
    [monthlyView addSubview:_ecolumnChartMonthly];
    
    CGFloat hhChart=_ecolumnChartMonthly.frame.origin.y+_ecolumnChartMonthly.frame.size.height+20;
    UILabel * descriptionXAxisValues=[[UILabel alloc]initWithFrame:CGRectMake(20,hhChart, Screen_width-40,15)];
    descriptionXAxisValues.textColor=[UIColor lightGrayColor];
    descriptionXAxisValues.font=[UIFont systemFontOfSize:12];
    descriptionXAxisValues.textAlignment=NSTextAlignmentCenter;
    descriptionXAxisValues.text=@"Date";
    [monthlyView addSubview:descriptionXAxisValues];
    self.graphDescriptionLabel.frame=CGRectMake(50,hhChart+20,Screen_width-100, 20);
}
#pragma mark List of monthly date

-(NSArray *)oneMonthDateList:(NSDate*)tempDate
{
    NSMutableArray * tempArray=[[NSMutableArray alloc]init];
    int lastTerm=(int)([self numberOfDaysInMonthCount:tempDate]-1)/3+1;
    int dateToPrint=1;
    for (int i = 1; i <=lastTerm; i++)
    {
        [tempArray addObject:[NSString stringWithFormat:@"%d",dateToPrint]];
        dateToPrint=dateToPrint+3;
     }
    return tempArray;
}


- (NSDate *)dateByAddingTwoDayFromDate:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *minusOneDay = [[NSDateComponents alloc] init];
    [minusOneDay setDay:+3];
    NSDate *newDate = [cal dateByAddingComponents:minusOneDay
                                           toDate:date
                                          options:NSWrapCalendarComponents];
    return newDate;
}
#pragma mark PhoneUsage Action

-(void)phoneUsagesBtnAction
{
    [Singletoneclass sharedSingleton].graphSelected=PhoneUageDBDictionaryKey;
    [self reloadWeeklyGraphOnEvents:PhoneUageDBDictionaryKey];
     self.graphDescriptionLabel.text=[NSString stringWithFormat:@"Avg.Phone Usage: %.2f",(float)[self calculateAverageScore:self.presentFetchedDataFromDb keyValue:PhoneUageDBDictionaryKey]];
}
-(void)phUsagesBtnForMonthly
{
    [Singletoneclass sharedSingleton].graphSelected=PhoneUageDBDictionaryKey;
    [self reloadMonthlyGraphOnEvents:PhoneUageDBDictionaryKey];
     self.graphDescriptionLabel.text=[NSString stringWithFormat:@"Avg.Phone Usage: %.2f",(float)[self calculateAverageScore:self.presentFetchedDataFromDb keyValue:PhoneUageDBDictionaryKey]];
}
/** Reload Weekly Graph Method*/
-(void)reloadWeeklyGraphOnEvents:(NSString*)keyValue
{
    weeklyScoreValues=[NSArray arrayWithArray:weekDays];
    //Changing Key For Phone Usage Rest Graph Reloading Process is same
    [self setColumnDataValuesWeekly:self.presentFetchedDataFromDb valueType:keyValue];
    NSMutableArray *temp=[[NSMutableArray alloc]init];
    
    for (int i = 0; i < weekDays.count; i++)
    {
        NSString * weeklyDateDisplayStr=[NSString stringWithFormat:@"%@",  [weekDays objectAtIndex:i]];
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:weeklyDateDisplayStr value:[[weeklyScoreValues objectAtIndex: i] floatValue] index:i unit:nil];
        [temp addObject:eColumnDataModel];
      //  NSLog(@"arr11 == %@",temp);
        
    }
   // NSLog(@"arr list== %@",[NSArray arrayWithArray:temp]);
    if (_eColumnChart!=nil) {
        [_eColumnChart removeFromSuperview];
        _eColumnChart=nil;
        _xAxisdataColumnChart = [NSArray arrayWithArray:temp];
        _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(50, 100, Screen_width-80, Screen_height/2-55)];
        if(IS_IPAD)
        {
            _eColumnChart.frame=CGRectMake(50,200, Screen_width-100, Screen_height/2-55);
        }
        if([keyValue isEqual:PhoneUageDBDictionaryKey])
        {
            _eColumnChart.showHorizontalLabelsWithInteger=TRUE;
        }
        else
        {
            _eColumnChart.showHorizontalLabelsWithInteger=FALSE;

        }
        [_eColumnChart setColumnsIndexStartFromLeft:YES];
        _eColumnChart.typeOfGraph=@"Weekly";
        [_eColumnChart setDelegate:self];
        [_eColumnChart setDataSource:self];
        [weeklyView addSubview:_eColumnChart];

    }

}
//This Method is used to reduce redundancy in code
/** Reload Monthly Graph Method*/
-(void)reloadMonthlyGraphOnEvents:(NSString *)keyValue
{
    dateCount=(int) [self numberOfDaysInMonthCount:firstDateInCurrentMonth];
    //---------
    NSMutableArray * tempArray=[[NSMutableArray alloc]init];
    for(int i=1;i<=dateCount;i++)
    {
        [tempArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    monthlyScoreValues=tempArray;
    //Changing Key For Phone Usage Rest Graph Reloading Process is same
    [self setColumnDataValuesMonthly:self.presentFetchedDataFromDb valueType:keyValue];
    
    //------------------
    _xAxisdataColumnChart = [self createDataModelForMonthlyGraph:firstDateInCurrentMonth];
    [_ecolumnChartMonthly removeFromSuperview];
    _ecolumnChartMonthly=nil;
    _ecolumnChartMonthly= [[EColumnChart alloc] initWithFrame:CGRectMake(50, 100, Screen_width-80, Screen_height/2-55)];
    if(IS_IPAD)
    {
        _eColumnChart.frame=CGRectMake(50,200, Screen_width-100, Screen_height/2-55);
    }
    if([keyValue isEqual:PhoneUageDBDictionaryKey])
    {
        _ecolumnChartMonthly.showHorizontalLabelsWithInteger=TRUE;
    }
    else
    {
        _ecolumnChartMonthly.showHorizontalLabelsWithInteger=FALSE;
 
    }
    [_ecolumnChartMonthly setColumnsIndexStartFromLeft:YES];
    [_ecolumnChartMonthly setDelegate:self];
    [_ecolumnChartMonthly setDataSource:self];
    [monthlyView addSubview:_ecolumnChartMonthly];
 
}
#pragma mark AddictionScore Action

-(void)addictionScoreBtnAction
{
    [Singletoneclass sharedSingleton].graphSelected=AddictionScoreDBDictionaryKey;
        [self reloadWeeklyGraphOnEvents:AddictionScore];
      self.graphDescriptionLabel.text=[NSString stringWithFormat:@"Avg.Addiction Score: %.2f",(float)[self calculateAverageScore:self.presentFetchedDataFromDb keyValue:AddictionScoreDBDictionaryKey]];
}
-(void)addictionScoreBtnForMonthly
{
    [Singletoneclass sharedSingleton].graphSelected=AddictionScoreDBDictionaryKey;
    [self reloadMonthlyGraphOnEvents:AddictionScore];
    self.graphDescriptionLabel.text=[NSString stringWithFormat:@"Avg.Addiction Score: %.2f",(float)[self calculateAverageScore:self.presentFetchedDataFromDb keyValue:AddictionScoreDBDictionaryKey]];

}

#pragma mark-Add Slider Date

-(void)addSliderDate:(NSDate*)start end:(NSDate*)endWeekDate
{
    
     NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd, MMM"];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:+ 6];
      beginningOfWeek=[endWeekDate dateByAddingTimeInterval:24*60*60];
     sevenDaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:beginningOfWeek options:0];
    savenDateStr=[NSString stringWithFormat:@"%@-%@",[formatter stringFromDate:beginningOfWeek],[formatter stringFromDate:sevenDaysAgo]];
    
    dateLbl.text=savenDateStr;
    //--
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd"];
    NSString *dateString_first = [dateFormatter stringFromDate:sevenDaysAgo];
//    NSLog(@"First_date: %@", dateString_first);
    NSMutableArray *temp=[[NSMutableArray alloc]init];
    weekDays = [[NSMutableArray alloc] initWithCapacity:7];
    NSDate * tempDate=beginningOfWeek;
    for (int i = 0; i < 7; i++)
    {
        NSString *weekDay = [dateFormatter stringFromDate:tempDate];
        [weekDays addObject:weekDay];
        tempDate = [self dateBySubtractingOneDayFromDate:tempDate];
    }
      //--
    weeklyScoreValues=[NSArray arrayWithArray:weekDays];
    HelperDataBase * helperDB=[[HelperDataBase alloc]init];
    NSArray * dbData= [ helperDB retrivePhoneUsage:beginningOfWeek.timeIntervalSince1970 higherTimeStamp:[sevenDaysAgo dateByAddingTimeInterval:24*60*60].timeIntervalSince1970];
    [self getCurrentValueFromDb:dbData];
    [self setColumnDataValuesWeekly:dbData valueType:AddictionScoreDBDictionaryKey];

     for (int i = 0; i < weekDays.count; i++)
        
    {
        NSString * weeklyDateDisplayStr=[NSString stringWithFormat:@"%@",  [weekDays objectAtIndex:i]];
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:weeklyDateDisplayStr value:[[weeklyScoreValues objectAtIndex: i] floatValue] index:i unit:nil];
         [temp addObject:eColumnDataModel];
    //    NSLog(@"arr11 == %@",temp);
        
    }
    _xAxisdataColumnChart = [NSArray arrayWithArray:temp];
  //  NSLog(@"arr list== %@",[NSArray arrayWithArray:temp]);
    
    if (_eColumnChart!=nil) {
        [_eColumnChart removeFromSuperview];
        _eColumnChart=nil;
        _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(50, 100, Screen_width-80, Screen_height/2-55)];
        if(IS_IPAD)
        {
            _eColumnChart.frame=CGRectMake(50,200, Screen_width-100, Screen_height/2-55);
        }
        [_eColumnChart setColumnsIndexStartFromLeft:YES];
        _eColumnChart.typeOfGraph=@"Weekly";
        [_eColumnChart setDelegate:self];
        [_eColumnChart setDataSource:self];
        [weeklyView addSubview:_eColumnChart];
    }
    }




//#pragma mark-Add Slider Date
//-(void)addSliderDate:(NSDate*)start end:(NSDate*)endWeekDate{
//    
//    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"dd, MMM"];
//    // NSDate* date = [fmt dateFromString:dateString];
//    
//    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//    [dateComponents setDay:+ 6];
//    
//    
//    beginningOfWeek=[endWeekDate dateByAddingTimeInterval:24*60*60];
//    
//    sevenDaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:beginningOfWeek options:0];
//    
//    savenDateStr=[NSString stringWithFormat:@"%@-%@",[formatter stringFromDate:beginningOfWeek
//                                                      ],[formatter stringFromDate:sevenDaysAgo]];
//    dateLbl.text=savenDateStr;
//    
//    
//}
#pragma mark-Add Slider Date
-(void)substractSliderDate:(NSDate*)start end:(NSDate*)endWeekDate{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd, MMM"];
    // NSDate* date = [fmt dateFromString:dateString];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-7];
    
    
    sevenDaysAgo=[endWeekDate dateByAddingTimeInterval:-7*24*60*60];
    
    beginningOfWeek = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:beginningOfWeek options:0];
    
    savenDateStr=[NSString stringWithFormat:@"%@-%@",[formatter stringFromDate:beginningOfWeek
                                                      ],[formatter stringFromDate:sevenDaysAgo]];
    dateLbl.text=savenDateStr;
    
    
    //--
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd"];
    NSString *dateString_first = [dateFormatter stringFromDate:beginningOfWeek];
 //   NSLog(@"First_date: %@", dateString_first);
    NSMutableArray *temp=[[NSMutableArray alloc]init];
    weekDays = [[NSMutableArray alloc] initWithCapacity:7];
    NSDate * tempDate=beginningOfWeek;
    for (int i = 0; i < 7; i++)
    {
        NSString *weekDay = [dateFormatter stringFromDate:tempDate];
        [weekDays addObject:weekDay];
        tempDate = [self dateBySubtractingOneDayFromDate:tempDate];
    }
    //--
    //--
    weeklyScoreValues=[NSArray arrayWithArray:weekDays];
    HelperDataBase * helperDB=[[HelperDataBase alloc]init];
    NSArray * dbData= [ helperDB retrivePhoneUsage:beginningOfWeek.timeIntervalSince1970 higherTimeStamp:[sevenDaysAgo dateByAddingTimeInterval:24*60*60].timeIntervalSince1970];
    [self getCurrentValueFromDb:dbData];
    [self setColumnDataValuesWeekly:dbData valueType:AddictionScoreDBDictionaryKey];

    for (int i = 0; i < weekDays.count; i++)
        
    {
        NSString * weeklyDateDisplayStr=[NSString stringWithFormat:@"%@",  [weekDays objectAtIndex:i]];
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:weeklyDateDisplayStr value:[[weeklyScoreValues objectAtIndex: i] floatValue] index:i unit:nil];
        [temp addObject:eColumnDataModel];
     //   NSLog(@"arr11 == %@",temp);
        
    }
  //  NSLog(@"arr list== %@",[NSArray arrayWithArray:temp]);
    if (_eColumnChart!=nil) {
        [_eColumnChart removeFromSuperview];
        _eColumnChart=nil;
        _xAxisdataColumnChart = [NSArray arrayWithArray:temp];
        [self weeklyColumnChart];

    }
}

#pragma mark Methods Changing Graph Dates
-(void)leftSliderBtnClick
{
    [self decrementMonth:firstDateInCurrentMonth];
}
-(void)rightSliderBtnClick
{
    [self incrementMonth:lastdateOfMonth];
}

-(void)incrementMonth:(NSDate*)endDay
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:zone];
    [formatter setDateFormat:@"dd, MMM"];
    
    firstDateInCurrentMonth =[self firstDayOfMonth:[endDay dateByAddingTimeInterval:24*60*60]];
    NSString *firstdateOfMonth = [formatter stringFromDate:firstDateInCurrentMonth];
    lastdateOfMonth=[self lastDayOfMonth:[endDay dateByAddingTimeInterval:24*60*60]];
    lastmonthDate=[formatter stringFromDate:lastdateOfMonth];
    NSString *monthDate=[NSString stringWithFormat:@"%@-%@",firstdateOfMonth,lastmonthDate];
    
    dateLbl.text=monthDate;
    dateCount= [self numberOfDaysInMonthCount:firstDateInCurrentMonth];
    //---------
    NSMutableArray * tempArray=[[NSMutableArray alloc]init];
    for(int i=1;i<=dateCount;i++)
    {
        [tempArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    monthlyScoreValues=tempArray;
    HelperDataBase * helperDB=[[HelperDataBase alloc]init];
    NSArray * dbData= [ helperDB retrivePhoneUsage:firstDateInCurrentMonth.timeIntervalSince1970 higherTimeStamp:lastdateOfMonth.timeIntervalSince1970];
    [self getCurrentValueFromDb:dbData];
    [self setColumnDataValuesMonthly:dbData valueType:AddictionScoreDBDictionaryKey];
    //------------------
    _xAxisdataColumnChart = [self createDataModelForMonthlyGraph:firstDateInCurrentMonth];
//    NSLog(@"arr list== %@",_xAxisdataColumnChart);
    [_ecolumnChartMonthly removeFromSuperview];
    _ecolumnChartMonthly=nil;
    _ecolumnChartMonthly= [[EColumnChart alloc] initWithFrame:CGRectMake(50, 100, Screen_width-80, Screen_height/2-55)];
    if(IS_IPAD)
    {
        _eColumnChart.frame=CGRectMake(50,200, Screen_width-100, Screen_height/2-55);
    }
    [_ecolumnChartMonthly setColumnsIndexStartFromLeft:YES];
    [_ecolumnChartMonthly setDelegate:self];
    [_ecolumnChartMonthly setDataSource:self];
    [monthlyView addSubview:_ecolumnChartMonthly];
    //---------
}
#pragma mark-Decrement Month
-(void)decrementMonth:(NSDate*)first
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:zone];
    [formatter setDateFormat:@"dd, MMM"];
    //---
    firstDateInCurrentMonth =[self firstDayOfMonth:[first dateByAddingTimeInterval:-24*60*60]];
    NSString *firstdateOfMonth = [formatter stringFromDate:firstDateInCurrentMonth];
    NSLog(@"%@",firstDateInCurrentMonth);
    //---
    lastdateOfMonth=[self lastDayOfMonth:firstDateInCurrentMonth];
    lastmonthDate=[formatter stringFromDate:lastdateOfMonth];
    NSString *monthDate=[NSString stringWithFormat:@"%@-%@",firstdateOfMonth,lastmonthDate];
    dateLbl.text=monthDate;
    
    //------------------
    NSMutableArray * tempArray=[[NSMutableArray alloc]init];
    dateCount= [self numberOfDaysInMonthCount:firstDateInCurrentMonth];

    for(int i=1;i<=[self numberOfDaysInMonthCount:firstDateInCurrentMonth];i++)
    {
        [tempArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    monthlyScoreValues=tempArray;
    HelperDataBase * helperDB=[[HelperDataBase alloc]init];
    NSArray * dbData= [ helperDB retrivePhoneUsage:[self firstDayOfMonth:firstDateInCurrentMonth].timeIntervalSince1970 higherTimeStamp:[self lastDayOfMonth:lastdateOfMonth].timeIntervalSince1970];
    [self getCurrentValueFromDb:dbData];
    [self setColumnDataValuesMonthly:dbData valueType:AddictionScoreDBDictionaryKey];
    //------------------
    
    _xAxisdataColumnChart = [self createDataModelForMonthlyGraph:firstDateInCurrentMonth];
 //   NSLog(@"arr list== %@",_xAxisdataColumnChart);
    [_ecolumnChartMonthly removeFromSuperview];
    _ecolumnChartMonthly=nil;
    _ecolumnChartMonthly=[[EColumnChart alloc] initWithFrame:CGRectMake(50, 100, Screen_width-80, Screen_height/2-55)];
    if(IS_IPAD)
    {
        _eColumnChart.frame=CGRectMake(50,200, Screen_width-100, Screen_height/2-55);
    }
    [_ecolumnChartMonthly setColumnsIndexStartFromLeft:YES];
    [_ecolumnChartMonthly setDelegate:self];
    [_ecolumnChartMonthly setDataSource:self];
    [monthlyView addSubview:_ecolumnChartMonthly];
    
}

-(NSArray*)createDataModelForMonthlyGraph:(NSDate*)date
{
    NSMutableArray *temp = [NSMutableArray array];
    
   // dateCount= [calender numberOfDaysInMonthCount:date];
    int dateSum=1;
    for (int i = 0; i <[self numberOfDaysInMonthCount:date]; i++)
    {
        NSString * dateDisplayStr=@"";
        if(i%3==0)
        {
            dateDisplayStr=[NSString stringWithFormat:@"%d",dateSum];
            dateSum=dateSum+3;
        }
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:dateDisplayStr value:[[monthlyScoreValues objectAtIndex: i] floatValue] index:i unit:nil];
        [temp addObject:eColumnDataModel];
        //[weekDays addObject:eColumnDataModel];
     //   NSLog(@"arr11 == %@",temp);
    }
    return temp;
}

-(void)randomImage
{
    
    if (totalScore<=50) {
        
    UIImageView * charactrImg=[[UIImageView alloc]initWithFrame:CGRectMake(85, 0, Screen_width-180, Screen_height/2-130)];
        charactrImg.contentMode=UIViewContentModeScaleAspectFit;
    NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"m1.png", @"m2.png", @"m4.png", @"m5.png",@"m6.png", @"m7.png", @"m8.png", @"m9.png", nil];
    charactrImg.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count]-1)]];
        
   [todayView addSubview:charactrImg];
    //---RandomText
    UILabel *characterLbl=[[UILabel alloc]initWithFrame:CGRectMake(20, Screen_height/2-135, Screen_width-40,30)];
    NSArray *textArray=[[NSArray alloc]initWithObjects:@"I like to see you are in the Green Zone",@"Well done so far",@"Keep up the good work",@"Good, you are on top of things. I like it",@"You are making Socio happy with this good performance",@"Aim to stay in the Green Zone today.",@"Yup! Stay green.",@"You are awesome so far!",@"Have fewer unlocks to remain in the Green Zone.",@"Use your phone less to keep in the Green Zone.", nil];
    
    characterLbl.text=[self languageSelectedStringForKey:[NSString stringWithFormat:@"%@",[textArray objectAtIndex:arc4random_uniform((uint32_t)[textArray count])]]];
    characterLbl.adjustsFontSizeToFitWidth = YES;
    characterLbl.numberOfLines=0;
    characterLbl.font=[UIFont systemFontOfSize:12];
    characterLbl.textAlignment=NSTextAlignmentCenter;
    [todayView addSubview:characterLbl];
        
    }
    else if (totalScore<=80){
        UIImageView * charactrImg=[[UIImageView alloc]initWithFrame:CGRectMake(100, 0, Screen_width-200, Screen_height/2-140)];
        NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"m1.png", @"m2.png", @"m3.png", @"m4.png", @"m5.png", nil];
        charactrImg.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
        [todayView addSubview:charactrImg];
        //---RandomText
        UILabel *characterLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, Screen_height/2-135, Screen_width-30,30)];
        NSArray *textArray=[[NSArray alloc]initWithObjects:@"Avoid unnecessary screen unlocks.",@"Avoid having the phone around you all the time.",@"OK, you started to worry me. Take it easy.",@"You are in the Yellow Zone now. Watch it.",@"Use your phone only when you need it.",@"How about you leave your phone for like an hour?",@"Are you sure you need to use your phone this much?",@"How about you socialize with people face-to-face?",@"Make sure you don't go into the red zone!",@"OK, Socio is worried.", nil];
        
        characterLbl.text=[self languageSelectedStringForKey:[NSString stringWithFormat:@"%@",[textArray objectAtIndex:arc4random_uniform((uint32_t)[textArray count])]]];
        
        characterLbl.adjustsFontSizeToFitWidth = YES;
        characterLbl.numberOfLines=0;
        characterLbl.font=[UIFont systemFontOfSize:12];
        characterLbl.textAlignment=NSTextAlignmentCenter;
        [todayView addSubview:characterLbl];
        
    }
    else if (totalScore<=350)
    {
        UIImageView * charactrImg=[[UIImageView alloc]initWithFrame:CGRectMake(100, 0, Screen_width-200, Screen_height/2-140)];
        NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"m1.png", @"m2.png", @"m3.png", @"m4.png", @"m5.png", nil];
        charactrImg.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
        [todayView addSubview:charactrImg];
        //---RandomText
        UILabel *characterLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, Screen_height/2-135, Screen_width-30,30)];
        NSArray *textArray=[[NSArray alloc]initWithObjects:@"OK, Socio is really worried now.",@"I'm afraid you are in the Red Zone now!",@"You used your phone a lot today. You want to put it away?",@"Come on! I know you can do better than this.",@"Look how much time you spent on your phone today.",@"Are you sure you need to use your phone this much?",@"You are carried away. Take it easy.",@"You are in the Red Zone. Isn't it time to put the phone away?",@"I feel sorry for your phone!",@"You know Socio cares for you. Please put the phone away.", nil];
        
        characterLbl.text=[self languageSelectedStringForKey:[NSString stringWithFormat:@"%@",[textArray objectAtIndex:arc4random_uniform((uint32_t)[textArray count])]]];
        
        characterLbl.adjustsFontSizeToFitWidth = YES;
        characterLbl.numberOfLines=0;
        characterLbl.font=[UIFont systemFontOfSize:12];
        characterLbl.textAlignment=NSTextAlignmentCenter;
        [todayView addSubview:characterLbl];
    }
    

}
#pragma Mark Changing Language

-(NSString*) languageSelectedStringForKey:(NSString*) key
{
    
    NSString *path;
    
    if([[Singletoneclass sharedSingleton].languageChanged isEqualToString:@"English"])
        path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    
    else if([[Singletoneclass sharedSingleton].languageChanged isEqualToString:@"Arabic"])
        path = [[NSBundle mainBundle] pathForResource:@"ar" ofType:@"lproj"];
    else{
        path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    }
    NSBundle* languageBundle = [NSBundle bundleWithPath:path];
    NSString* str=[languageBundle localizedStringForKey:key value:@"" table:nil];
    return str;
    
}


-(void)updatePhoneUsageAndLock:(NSNotification*) notify
{
    screenlockLbl.text =[NSString stringWithFormat:@"%@",[Singletoneclass sharedSingleton].phoneLockCount];
    self.phusageTimeLbl.text=[self calculateTotalTimeInterval];
    NSString *phoneLock=[NSString stringWithFormat:@"%@",[Singletoneclass sharedSingleton].phoneLockCount];
    [[NSUserDefaults standardUserDefaults]setObject:phoneLock forKey:lockValue];
    [[NSUserDefaults standardUserDefaults]synchronize];

}

#pragma mark Calculate Score
-(float)calculateAverageScore:(NSArray*)dbData keyValue:(NSString*)keyValue
{
    float summation=0;
    for(int j=0;j<dbData.count;j++)
    {
       NSDictionary * tempDict=[dbData objectAtIndex:j];
        if ([keyValue isEqualToString:PhoneUageDBDictionaryKey])
        {
            float timeInMinutes=[[tempDict objectForKey:keyValue] floatValue]/60.00;
            summation=timeInMinutes+summation;
        }
        else
        {
            summation=[[tempDict objectForKey:keyValue] intValue]+summation;
 
        }
    }
    
    return summation/dbData.count;
}
-(float)calculateTotalScore
{
    int screenLck =[[NSString stringWithFormat:@"%@",[Singletoneclass sharedSingleton].phoneLockCount]intValue];
    int minuteTime=[[NSString stringWithFormat:@"%@",[Singletoneclass sharedSingleton].phoneUsageTime]intValue];
    //-
       return (screenLck/2+minuteTime/4);
    
}
#pragma Calculate Number Of Days For Xaxis
#pragma Calculate Number Of Days For Xaxis
- (NSArray *)setArrayOfDatesForXaxis:(NSString*)type
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    
    NSMutableArray *temp = [NSMutableArray array];
    
    NSDate *currentDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:currentDate];
    [components setDay:([components day]-([components weekday]-1))];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    NSString *dateString_first = [dateFormatter stringFromDate:beginningOfWeek];
  //  NSLog(@"First_date: %@", dateString_first);
    
    
    weekDays = [[NSMutableArray alloc] initWithCapacity:7];
    NSDate * tempDate=beginningOfWeek;
    for (int i = 0; i < 7; i++)
    {
        NSString *weekDay = [formatter stringFromDate:tempDate];
        [weekDays addObject:weekDay];
        tempDate = [self dateBySubtractingOneDayFromDate:tempDate];
    }
    if([type isEqualToString:@""])
    {
        
    }
    else
    {
        
    }
   // NSLog(@"Weekdays ==>>>%@",weekDays);
    return weekDays;
}


//- (NSArray *)setArrayOfDatesForXaxis:(NSString*)type
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"dd"];
//    
//        NSDate *currentDate = [NSDate date];
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:currentDate];
//    [components setDay:([components day]-([components weekday]-1))];
//    
//    beginningOfWeek = [gregorian dateFromComponents:components];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd"];
//    NSString *dateString_first = [dateFormatter stringFromDate:beginningOfWeek];
//    NSLog(@"First_date: %@", dateString_first);
//    
//    
//    weekDays = [[NSMutableArray alloc] initWithCapacity:7];
//    for (int i = 0; i < 7; i++)
//    {
//        NSString *weekDay = [formatter stringFromDate:beginningOfWeek];
//        [weekDays addObject:weekDay];
//        beginningOfWeek = [self dateBySubtractingOneDayFromDate:beginningOfWeek];
//        }
//    if([type isEqualToString:@""])
//    {
//        
//    }
//    else
//    {
//        
//    }
//    NSLog(@"Weekdays ==>>>%@",weekDays);
//    return weekDays;
//}

- (NSDate *)dateBySubtractingOneDayFromDate:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *minusOneDay = [[NSDateComponents alloc] init];
    [minusOneDay setDay:+1];
    NSDate *newDate = [cal dateByAddingComponents:minusOneDay
                                           toDate:date
                                          options:NSWrapCalendarComponents];
    return newDate;
}

-(NSArray *)setArrayOfDatesForMonthlyXaxis:(NSArray *)dateType
{
    return weekDays;
}
#pragma -mark- EPieChartDelegate

- (void) ePieChart:(EPieChart *)ePieChart
didTurnToBackViewWithBackView:(UIView *)backView
{
   
}

- (void) ePieChart:(EPieChart *)ePieChart didTurnToFrontViewWithFrontView:(UIView *)frontView
{
    
}


#pragma mark Weekly Chart

#pragma -mark- EColumnChartDataSource

- (NSInteger)numberOfColumnsInEColumnChart:(EColumnChart *)eColumnChart
{
    return [_xAxisdataColumnChart count];
}

- (NSInteger)numberOfColumnsPresentedEveryTime:(EColumnChart *)eColumnChart
{
 if ((long)segmentedControl.selectedSegmentIndex==1){

      return 7;
}
else if ((long)segmentedControl.selectedSegmentIndex==2){

    return dateCount;
}
    return 0;
}

- (EColumnDataModel *)highestValueEColumnChart:(EColumnChart *)eColumnChart
{
    EColumnDataModel *maxDataModel = nil;
    float maxValue = FLT_MIN;
    for (EColumnDataModel *dataModel in _xAxisdataColumnChart)
    {
        if (dataModel.value > maxValue)
        {
            maxValue = dataModel.value;
       //     NSLog(@"maxValue  %f",dataModel.value);
            maxDataModel = dataModel;
        //    NSLog(@"maxValue111  %@",_xAxisdataColumnChart);
            
        }
    }
    return maxDataModel;
}

- (EColumnDataModel *)eColumnChart:(EColumnChart *)eColumnChart valueForIndex:(NSInteger)index
{
    if (index >= [_xAxisdataColumnChart count] || index < 0) return nil;
    return [_xAxisdataColumnChart objectAtIndex:index];
}

#pragma mark Reload Column Chart View
//- (EColumnDataModel *)highestValueEColumnChart:(EColumnChart *)eColumnChart
//{
//    EColumnDataModel *maxDataModel = nil;
//    
//
//
//  
//    float maxValue = FLT_MIN;
//    for (EColumnDataModel *dataModel in _xAxisdataColumnChart)
//    {
//        if (dataModel.value > maxValue)
//        {
//            //maxValue = dataModel.value;
//            NSLog(@"maxValue  %f",dataModel.value);
//            maxDataModel = dataModel;
//            NSLog(@"maxValue111  %@",_xAxisdataColumnChart);
//
//        }
//  }
//    return maxDataModel;
//}
//
//- (EColumnDataModel *)eColumnChart:(EColumnChart *)eColumnChart valueForIndex:(NSInteger)index
//{
//    if (index >= [_xAxisdataColumnChart count] || index < 0) return nil;
//    return [_xAxisdataColumnChart objectAtIndex:index];
//}

- (UIColor *)colorForEColumn:(EColumn *)eColumn
{
//    int retriveScore;
//    for(int i=0; i<[weeklyScoreValues count]; i++)
//    {
//        retriveScore = [((NSNumber*)[weeklyScoreValues objectAtIndex:i]) intValue];
//        if (retriveScore<=50)
//        {
//            return  [UIColor colorWithRed:(CGFloat)8/255 green:(CGFloat)138/255 blue:(CGFloat)41/255 alpha:1];
// 
//        }else if (retriveScore<=80){
//            return [UIColor colorWithRed:(CGFloat)255/255 green:(CGFloat)194/255 blue:(CGFloat)0/255 alpha:1];
//  
//        }
//        else if (retriveScore<=350)
//        {
//            [UIColor redColor];
//        }
//        
//    }

    return   [UIColor colorWithRed:(CGFloat)20/255 green:(CGFloat)114/255 blue:(CGFloat)27/255 alpha:1];
}
#pragma mark Reload On Updation
-(void)reloadWeeklyGraphUpdationOnEvents:(NSNotification*)keyValue
{
    HelperDataBase * helperDB=[[HelperDataBase alloc]init];
    NSArray * dbData= [ helperDB retrivePhoneUsage:[self findFirstDayOfWeek].timeIntervalSince1970 higherTimeStamp:[self findLastDayOfWeek].timeIntervalSince1970];
    [self getCurrentValueFromDb:dbData];
    weeklyScoreValues=[NSArray arrayWithArray:weekDays];
    //Changing Key For Phone Usage Rest Graph Reloading Process is same
    [self setColumnDataValuesWeekly:dbData valueType:keyValue.object];
    NSMutableArray *temp=[[NSMutableArray alloc]init];
    
    for (int i = 0; i < weekDays.count; i++)
    {
        NSString * weeklyDateDisplayStr=[NSString stringWithFormat:@"%@",  [weekDays objectAtIndex:i]];
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:weeklyDateDisplayStr value:[[weeklyScoreValues objectAtIndex: i] floatValue] index:i unit:nil];
        [temp addObject:eColumnDataModel];
        //  NSLog(@"arr11 == %@",temp);
        
    }
    // NSLog(@"arr list== %@",[NSArray arrayWithArray:temp]);
    if (_eColumnChart!=nil) {
        [_eColumnChart removeFromSuperview];
        _eColumnChart=nil;
        _xAxisdataColumnChart = [NSArray arrayWithArray:temp];
                _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(50, 100, Screen_width-80, Screen_height/2-55)];
        if(IS_IPAD)
        {
            _eColumnChart.frame=CGRectMake(50,200, Screen_width-100, Screen_height/2-55);
        }
        if([keyValue.object isEqualToString:PhoneUageDBDictionaryKey])
        {
            _eColumnChart.showHorizontalLabelsWithInteger=TRUE;
        }
        else
        {
            _eColumnChart.showHorizontalLabelsWithInteger=FALSE;
            
        }

        [_eColumnChart setColumnsIndexStartFromLeft:YES];
        _eColumnChart.typeOfGraph=@"Weekly";
        [_eColumnChart setDelegate:self];
        [_eColumnChart setDataSource:self];
        [weeklyView addSubview:_eColumnChart];
//        CGFloat hhChart=_eColumnChart.frame.origin.y+_eColumnChart.frame.size.height+20;
//        self.graphDescriptionLabel.frame=CGRectMake(50,hhChart,Screen_width-100, 20);

    }
    
}
//This Method is used to reduce redundancy in code
/** Reload Monthly Graph Method*/
-(void)reloadMonthlyGraphUpdationOnEvents:(NSNotification*)keyValue
{
    
    HelperDataBase * helperDB=[[HelperDataBase alloc]init];
    //We have to pass first and last day of month (Correct kar lena)
    
    NSArray * dbData= [ helperDB retrivePhoneUsage:[self firstDayOfMonth:[NSDate date]].timeIntervalSince1970 higherTimeStamp:[self lastDayOfMonth:[NSDate date]].timeIntervalSince1970];
    [self getCurrentValueFromDb:dbData];
    
    dateCount=(int) [self numberOfDaysInMonthCount:firstDateInCurrentMonth];
    //---------
    NSMutableArray * tempArray=[[NSMutableArray alloc]init];
    for(int i=1;i<=dateCount;i++)
    {
        [tempArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    monthlyScoreValues=tempArray;
    //Changing Key For Phone Usage Rest Graph Reloading Process is same
    [self setColumnDataValuesMonthly:dbData valueType:keyValue.object];
    
    //------------------
    _xAxisdataColumnChart = [self createDataModelForMonthlyGraph:firstDateInCurrentMonth];
    [_ecolumnChartMonthly removeFromSuperview];
    _ecolumnChartMonthly=nil;
    _ecolumnChartMonthly= [[EColumnChart alloc] initWithFrame:CGRectMake(50, 100, Screen_width-80, Screen_height/2-55)];
    if(IS_IPAD)
    {
        _eColumnChart.frame=CGRectMake(50,200, Screen_width-100, Screen_height/2-55);
    }
    if([keyValue.object isEqualToString:PhoneUageDBDictionaryKey])
    {
        _ecolumnChartMonthly.showHorizontalLabelsWithInteger=TRUE;
    }
    else
    {
        _ecolumnChartMonthly.showHorizontalLabelsWithInteger=FALSE;
        
    }

    [_ecolumnChartMonthly setColumnsIndexStartFromLeft:YES];
    [_ecolumnChartMonthly setDelegate:self];
    [_ecolumnChartMonthly setDataSource:self];
    [monthlyView addSubview:_ecolumnChartMonthly];
    
}
-(void)reloadPieChart
{
    [_ePieChart removeFromSuperview];
    [Singletoneclass sharedSingleton].totalAddictionScore=[self calculateTotalScore];
    totalScore=[self calculateTotalScore];
    int currentDegree=totalScore*360/100;
    //-----
    EPieChartDataModel *ePieChartDataModel = [[EPieChartDataModel alloc] initWithBudget:currentDegree current:totalScore estimate:77];
    if (Screen_height==568)
    {
        _ePieChart = [[EPieChart alloc] initWithFrame:CGRectMake(0, 0, Screen_width/2, 180)
                                   ePieChartDataModel:ePieChartDataModel];
    }
    else if (Screen_height==480)
    {
        _ePieChart = [[EPieChart alloc] initWithFrame:CGRectMake(0, 0, Screen_width/2, 140)
                                   ePieChartDataModel:ePieChartDataModel];
    }
    else if (Screen_height==667)
    {
        
        _ePieChart = [[EPieChart alloc] initWithFrame:CGRectMake(0, 0, Screen_width/2, 200)
                                   ePieChartDataModel:ePieChartDataModel];
        
    }
    else{
        _ePieChart = [[EPieChart alloc] initWithFrame:CGRectMake(0, 0, Screen_width/2, 200)
                                   ePieChartDataModel:ePieChartDataModel];
    }
    _ePieChart.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [_ePieChart setDelegate:self];
    [_ePieChart setDataSource:self];
    [todayView addSubview:_ePieChart];
    //--

}
#pragma -mark- EColumnChartDelegate
- (void)eColumnChart:(EColumnChart *)eColumnChart
     didSelectColumn:(EColumn *)eColumn
{
    NSLog(@"Index: %ld  Value: %f", (long)eColumn.eColumnDataModel.index, eColumn.eColumnDataModel.value);
    
//    if (_eColumnSelected)
//    {
//        _eColumnSelected.barColor = _tempColor;
//    }
//    _eColumnSelected = eColumn;
//    _tempColor = eColumn.barColor;
//    eColumn.barColor = [UIColor colorWithRed:(CGFloat)18/255 green:(CGFloat)114/255 blue:(CGFloat)27/255 alpha:1];
    
    _valueLabel.text = [NSString stringWithFormat:@"%.1f",eColumn.eColumnDataModel.value];
    
    NSLog(@"valueeeee %@",[NSString stringWithFormat:@"%.1f",eColumn.eColumnDataModel.value]);
    //----------------
    CGFloat eFloatBoxX = eColumn.frame.origin.x ;//+ eColumn.frame.size.width * 1.25;
    CGFloat eFloatBoxY = eColumn.frame.size.height-eColumn.grade;
    NSLog(@"values %f %f %f",eColumn.frame.origin.y,eColumn.frame.size.height,eColumn.grade);
    //--------------------
    UIImageView * boxImageView=[[UIImageView alloc]initWithFrame:CGRectMake(eFloatBoxX, eFloatBoxY-25, 25, 25)];
    boxImageView.image=[UIImage imageNamed:@"score.png"];
    boxImageView.tag=(int)eColumn.eColumnDataModel.index+500;
    [eColumnChart addSubview:boxImageView];
    //-----------
    
    UILabel * valueOnBox=[[UILabel alloc]initWithFrame:CGRectMake(boxImageView.bounds.origin.x,boxImageView.bounds.origin.y, 25,20)];
    valueOnBox.text=[NSString stringWithFormat:@"%.1f",eColumn.eColumnDataModel.value];
    valueOnBox.textAlignment=NSTextAlignmentCenter;
    valueOnBox.font=[UIFont systemFontOfSize:10];
    [boxImageView addSubview:valueOnBox];
    [self performSelector:@selector(removeWithDelay:) withObject:[NSNumber numberWithInt:(int)eColumn.eColumnDataModel.index+500] afterDelay:1];
    
}
//--
-(void)removeWithDelay:(NSNumber*)tagValue
{
    UIImageView * imgView=(UIImageView*)[self.view viewWithTag:tagValue.intValue];
    [imgView removeFromSuperview];
    imgView=nil;
}

- (void)eColumnChart:(EColumnChart *)eColumnChart
fingerDidEnterColumn:(EColumn *)eColumn
{
}

- (void)eColumnChart:(EColumnChart *)eColumnChart
fingerDidLeaveColumn:(EColumn *)eColumn
{
    
}

- (void)fingerDidLeaveEColumnChart:(EColumnChart *)eColumnChart
{
       
}


-(void)setColumnDataValuesMonthly:(NSArray*)savedValuesInDb valueType:(NSString*)valueTypeKey
{
    //-------------------------------------------------------------------------
    NSMutableArray *tempArray=[[NSMutableArray alloc]initWithArray:monthlyScoreValues];
    
    for(int i=0;i<monthlyScoreValues.count;i++)
    {
        BOOL flagValueChange=false;
        for(int j=0;j<savedValuesInDb.count;j++)
        {
            NSDictionary * tempDict=[savedValuesInDb objectAtIndex:j];
            int dbStartingDay= (int)[self getDayFromnTimeStamp:[[tempDict objectForKey:@"TodayTimeStamp"] integerValue]];
            if(dbStartingDay == [[monthlyScoreValues objectAtIndex:i] intValue])
            {
                flagValueChange=true;
                //If key is of Phone Usage
                if([valueTypeKey isEqualToString:PhoneUageDBDictionaryKey])
                {
                    float timeInMinutes=[[tempDict objectForKey:valueTypeKey] floatValue];
                    NSString * convertInHours=[NSString stringWithFormat:@"%f",timeInMinutes/60.00];
                    [tempArray replaceObjectAtIndex:i withObject: convertInHours];
                    
                }
                else
                {
                    [tempArray replaceObjectAtIndex:i withObject: [tempDict objectForKey:valueTypeKey]];
                    
                }
                

            }
        }
        if(!flagValueChange)
        {
            [tempArray replaceObjectAtIndex:i withObject: @"0"];
 
        }
    }
    
       monthlyScoreValues=[NSArray arrayWithArray:tempArray];

    //---------------------------------------------------------------------------
}

-(void)setColumnDataValuesWeekly:(NSArray*)savedValuesInDb valueType:(NSString*)valueTypeKey
{
    NSMutableArray *tempArray=[[NSMutableArray alloc]initWithArray:weeklyScoreValues];
    
    for(int i=0;i<weeklyScoreValues.count;i++)
    {
        BOOL flagValueChange=false;
        for(int j=0;j<savedValuesInDb.count;j++)
        {
            NSDictionary * tempDict=[savedValuesInDb objectAtIndex:j];
            int dbStartingDay= (int)[self getDayFromnTimeStamp:[[tempDict objectForKey:@"TodayTimeStamp"] integerValue]];
            if(dbStartingDay == [[weeklyScoreValues objectAtIndex:i] intValue])
            {
                //If key is of Phone Usage
                if([valueTypeKey isEqualToString:PhoneUageDBDictionaryKey])
                {
                    float timeInMinutes=[[tempDict objectForKey:valueTypeKey] floatValue];
                    NSString * convertInHours=[NSString stringWithFormat:@"%f",timeInMinutes/60.00];
                    [tempArray replaceObjectAtIndex:i withObject: convertInHours];

                }
                else
                {
                    [tempArray replaceObjectAtIndex:i withObject: [tempDict objectForKey:valueTypeKey]];

                }
                flagValueChange=true;
            }
        }
        if(!flagValueChange)
        {
            [tempArray replaceObjectAtIndex:i withObject: @"0"];
            
        }
    }
    
    weeklyScoreValues=[NSArray arrayWithArray:tempArray];
    
}
-(void)setColumnDataValuesForPhUsages:(NSArray*)savedValuesInDb
{
    NSMutableArray *tempArray=[[NSMutableArray alloc]init];
    for(int i=0;i<savedValuesInDb.count;i++)
    {
        NSDictionary * tempDict=[savedValuesInDb objectAtIndex:i];
        [tempArray addObject: [tempDict objectForKey:PhoneUageDBDictionaryKey]];
    }
    for(int i=(int)tempArray.count ; i<7;i++)
    {
        [tempArray addObject:@"0"];
    }
    weeklyPhUsgesScoreValue=[NSArray arrayWithArray:tempArray];
}
-(void)getCurrentValueFromDb:(NSArray*)dbValue
{
    self.presentFetchedDataFromDb=dbValue;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
