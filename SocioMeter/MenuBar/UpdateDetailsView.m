//
//  UpdateDetailsView.m
//  SocioMeter
//
//  Created by Sumit Ghosh on 29/01/16.
//  Copyright © 2016 Sumit Ghosh. All rights reserved.
//

#import "UpdateDetailsView.h"
#import "AppDelegate.h"
#import "ApiHelperClass.h"
#import "Singletoneclass.h"
#import "LanguageUiView.h"

@implementation UpdateDetailsView
@synthesize dateOfBirthLbl,dateView,datePicker,title,saveBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSUserDefaults standardUserDefaults]setObject:@"updateView" forKey:@"updateViewDisplay"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self updateDetailsAction];
        
        }
    return self;
}



#pragma mark update DetailsView

-(void)updateDetailsAction
{
    
    UIImageView *launchImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    [launchImg setImage:[UIImage imageNamed:@"splash_screen"]];
    launchImg.userInteractionEnabled=YES;
    [self addSubview:launchImg];
    //-----
    self.updateView=[[UIView alloc]initWithFrame:CGRectMake(20, 150, Screen_width-40, 250)];
    self.updateView.backgroundColor=[UIColor whiteColor];
    
    //AppDelegate *feedBackdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [launchImg addSubview:self.updateView];
    //---
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.updateView.bounds.size.width , 60)];
    headerView.backgroundColor=Bluecolor;
    [self.updateView addSubview:headerView];
    //--
    UILabel * headerLbl=[[UILabel alloc]initWithFrame:CGRectMake(60, 20,self.updateView.bounds.size.width-120 , 20)];
    headerLbl.text=@"Update Details";
    //[self languageSelectedStringForKey:@"Update Details"];
    headerLbl.textAlignment=NSTextAlignmentLeft;
    headerLbl.textColor=[UIColor whiteColor];
    [headerLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.updateView addSubview:headerLbl];
    
    //--
    UIImageView * socioLogo=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 42)];
    [socioLogo setImage:[UIImage imageNamed:@"socio_icon.png"]];
    [headerView addSubview:socioLogo];
    //--
    UILabel * birthdayNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 80,120 , 25)];
    birthdayNameLbl.text=@"Birthday :";
    //[self languageSelectedStringForKey:@"Birthday :"];
    birthdayNameLbl.textAlignment=NSTextAlignmentLeft;
    birthdayNameLbl.textColor=Bluecolor;
    [birthdayNameLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.updateView addSubview:birthdayNameLbl];
    //--
    UIButton * callenderBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.updateView.bounds.size.width-50, 80, 25,25 )];
    [callenderBtn setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    [callenderBtn addTarget:self action:@selector(selectDateAction) forControlEvents:UIControlEventTouchUpInside];
    [self.updateView addSubview:callenderBtn];
    //--
    dateOfBirthLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.updateView.bounds.size.width-150, 80, 100,25 )];
    dateOfBirthLbl.textColor=Bluecolor;
    dateOfBirthLbl.text=@"set Date";
    [self.updateView addSubview:dateOfBirthLbl];
    //--
    UILabel * genderNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 150,120 , 25)];
    genderNameLbl.text=@"Gender :";
    //[self languageSelectedStringForKey:@"Gender :"];
    genderNameLbl.textAlignment=NSTextAlignmentLeft;
    genderNameLbl.textColor=Bluecolor;
    [genderNameLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.updateView addSubview:genderNameLbl];
    //--
    UIButton * maleBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.updateView.bounds.size.width-120, 150, 35,35 )];
    [maleBtn setImage:[UIImage imageNamed:@"male"] forState:UIControlStateNormal];
    [self.updateView addSubview:maleBtn];
    //--
    UIButton * femalBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.updateView.bounds.size.width-50, 150, 35,35 )];
    [femalBtn setImage:[UIImage imageNamed:@"female"] forState:UIControlStateNormal];
    [self.updateView addSubview:femalBtn];
    //---
    self.firstUnselectRadioBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.updateView.bounds.size.width-140, 150, 20,20 )];
    [self.firstUnselectRadioBtn setImage:[UIImage imageNamed:@"radio-btn"] forState:UIControlStateNormal];
    [self.firstUnselectRadioBtn setImage:[UIImage imageNamed:@"selected-radio-btn"] forState:UIControlStateSelected];
    [self.firstUnselectRadioBtn addTarget:self action:@selector(maleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.updateView addSubview:self.firstUnselectRadioBtn];
    //--
    self.secondUnselectRadioBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.updateView.bounds.size.width-80, 150, 20,20 )];
    [self.secondUnselectRadioBtn setImage:[UIImage imageNamed:@"radio-btn"] forState:UIControlStateNormal];
    [self.secondUnselectRadioBtn setImage:[UIImage imageNamed:@"selected-radio-btn"] forState:UIControlStateSelected];
    [self.secondUnselectRadioBtn addTarget:self action:@selector(femaleAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.updateView addSubview:self.secondUnselectRadioBtn];
    //--
   saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.updateView.bounds.size.height-30,self.updateView.bounds.size.width , 40)];
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.backgroundColor=Bluecolor;
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.updateView addSubview:saveBtn];
    //--
    
}

#pragma Mark UserInstallation UpdateService

-(void)saveAction
{
    
    NSUUID *deviceId;
    deviceId = [UIDevice currentDevice].identifierForVendor;
    NSLog(@"deviceUDID: %@",deviceId);

    //---
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    NSLog(@"appVersion: %@",appVersion);
    //--
    
    //--
    NSString *deviceType= [[UIDevice currentDevice] model];
    NSLog(@"model: %@", deviceType);
    //--
    NSString *deviceName=[[UIDevice currentDevice]name];
    NSLog(@"deviceType: %@",deviceName);
    //--
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryName = [currentLocale objectForKey:NSLocaleCountryCode];
    NSLog(@"countryName: %@",countryName);
    
    //--
    NSString *birthday=[[NSString alloc]init];
    birthday=title;
    NSLog(@"countryName: %@",birthday);
    //--
    NSString *gender=[[NSString alloc]init];
    gender=self.stringFrmtForgender;
    
    ApiHelperClass * apiObj=[[ApiHelperClass alloc]init];
    //  NSString * postString=[NSString stringWithFormat:@"deviceName=%@&deviceId=%@&country=%@&birthDay=%@&gender=%@&deviceType=%@&appVersion=%@",deviceName,deviceId,countryName,birthday,gender,deviceType,appVersion];
    
    
    if (gender!=nil && birthday!=nil)
    {
        NSDictionary *dict=@{@"deviceName":deviceName,@"deviceId":deviceId,@"country":countryName,@"birthDay":birthday,@"gender":gender,@"deviceType":deviceType,@"appVersion":appVersion};
        id dataReturned=[apiObj userSignUpMethod:dict];
     //[self removeFromSuperview];
        [self LanguageView];

    }
    else{
        UIAlertView *messagesAlert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please Provide your details" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [messagesAlert show];
    }
    //--
//    [[NSUserDefaults standardUserDefaults]setObject:@"updateView" forKey:@"removeUpdateView"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    //--
    [self LanguageView];

    
}


//---call language View
-(void)LanguageView
{
    LanguageUiView *languageView=[[LanguageUiView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self addSubview:languageView];
    //[self removeFromSuperview];
}


- (void)maleAction:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    self.stringFrmtForgender=[NSString stringWithFormat:@"male"];
    NSLog(@"%@",self.stringFrmtForgender);
    [self.firstUnselectRadioBtn setSelected:YES];
    [self.secondUnselectRadioBtn setSelected:NO];
  //  [[NSUserDefaults standardUserDefaults]setBool:self.firstUnselectRadioBtn forKey:@"radioBtnAction"];
    [[NSUserDefaults standardUserDefaults]synchronize];
 
}

- (void)femaleAction:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    self.stringFrmtForgender=[NSString stringWithFormat:@"female"];
    NSLog(@"%@",self.stringFrmtForgender);
    [self.firstUnselectRadioBtn setSelected:NO];
    [self.secondUnselectRadioBtn setSelected:YES];
   // [[NSUserDefaults standardUserDefaults]setBool:self.secondUnselectRadioBtn forKey:@"radioBtnAction"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
#pragma mark DatePicker

-(void)selectDateAction
{
    self.updateView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    self.updateView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.4];
    AppDelegate *feedBackdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [feedBackdelegate.window addSubview:self.updateView];
    //-------------
    dateView=[[UIView alloc]initWithFrame:CGRectMake(20, 100, Screen_width-40, Screen_height-180)];
    dateView.backgroundColor=[UIColor whiteColor];
    AppDelegate *dateViewdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [dateViewdelegate.window addSubview:dateView];
    //-------------
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, dateView.frame.size.width, 45)];
    headerView.backgroundColor=[UIColor orangeColor];
    [dateView addSubview:headerView];
    //-------------
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, dateView.frame.size.width, 45)];
    headerLabel.text=@"Update Date";
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor whiteColor];
    [dateView addSubview:headerLabel];
    //-------------
    UILabel *datelabel = [[UILabel alloc] init];
    datelabel.frame = CGRectMake(0, 55, dateView.frame.size.width, 40);
    datelabel.backgroundColor = [UIColor clearColor];
    datelabel.textColor = [UIColor orangeColor];
    datelabel.font = [UIFont fontWithName:@"Verdana-Bold" size: 14.0];
    datelabel.textAlignment = NSTextAlignmentCenter;
    //-------------
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    datelabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]];
    [dateView addSubview:datelabel];
    //-------------
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 100, dateView.frame.size.width, 200)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.hidden = NO;
    [datePicker addTarget:self action:@selector(Pick:) forControlEvents:UIControlEventValueChanged];
    datePicker.date = [NSDate date];
    [dateView addSubview:datePicker];
    //---
    UIButton *okBtn=[[UIButton alloc]initWithFrame:CGRectMake(dateView.frame.size.width-70, dateView.frame.size.height-40, 60, 20)];
    [okBtn setTitle:@"OK" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:okBtn];
    //---
    UIButton *cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(dateView.frame.size.width-150, dateView.frame.size.height-40, 60, 20)];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:cancelBtn];
    
    
}

-(void)okBtnAction
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyy"];
    title = [dateFormatter stringFromDate:datePicker.date];
    NSLog(@"title title%@",title);
    [[NSUserDefaults standardUserDefaults]setObject:title forKey:selectedDateOfBirth];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //title=[Singletoneclass sharedSingleton].dateOfBirth;
    dateOfBirthLbl.text=title;
    //[selectDateButton setTitle:title forState:UIControlStateNormal];
    [self.updateView removeFromSuperview];
    [dateView removeFromSuperview];
}
-(void)cancelBtnAction
{
    [self.updateView removeFromSuperview];
    [dateView removeFromSuperview];
}

-(void)Pick:(id)sender
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyy"];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"hh:mm a"];
}
@end
