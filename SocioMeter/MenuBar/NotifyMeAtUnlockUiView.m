//
//  NotifyMeAtUnlockUiView.m
//  SocioMeter
//
//  Created by Sumit Ghosh on 05/02/16.
//  Copyright © 2016 Sumit Ghosh. All rights reserved.
//

#import "NotifyMeAtUnlockUiView.h"
#import "Singletoneclass.h"

@implementation NotifyMeAtUnlockUiView
{
    UIView *transparantView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self notifyMeAtUnlockAction];
        
    }
    return self;
}

-(void)notifyMeAtUnlockAction
{
    transparantView=[[UIView alloc]initWithFrame:CGRectMake(10, 10, Screen_width-20, Screen_height-20)];
    transparantView.backgroundColor=[UIColor colorWithWhite:1 alpha:0.5];
    [self addSubview:transparantView];
    //--
    int totalScoreValue=[Singletoneclass sharedSingleton].totalAddictionScore;
    NSLog(@"addScore %d",totalScoreValue);
    int currentDegree=totalScoreValue*360/100;
    //-----
    EPieChartDataModel *ePieChartDataModel = [[EPieChartDataModel alloc] initWithBudget:currentDegree current:totalScoreValue estimate:77];
    
    EPieChart *_ePieChart = [[EPieChart alloc] initWithFrame:CGRectMake(0, 0, 120, 120)
                                          ePieChartDataModel:ePieChartDataModel];
    _ePieChart.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    [_ePieChart setDelegate:self];
    [_ePieChart setDataSource:self];
    [self addSubview:_ePieChart];
    [self randomImage];
}

-(void)randomImage
{
    int addScore=30;
    if (addScore<=50) {
        
        UIImageView * charactrImg=[[UIImageView alloc]initWithFrame:CGRectMake(100, 0, Screen_width-220, Screen_height/2-120)];
        NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"m1.png", @"m2.png", @"m4.png", @"m5.png",@"m6.png", @"m7.png", @"m8.png", @"m9.png", nil];
        charactrImg.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count]-1)]];
        
        [transparantView addSubview:charactrImg];
        //---RandomText
        UILabel *characterLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, Screen_height/2-135, Screen_width-30,30)];
        NSArray *textArray=[[NSArray alloc]initWithObjects:@"I like to see you are in the Green Zone",@"Well done so far",@"Keep up the good work",@"Good, you are on top of things. I like it",@"You are making Socio happy with this good performance",@"Aim to stay in the Green Zone today.",@"Yup! Stay green.",@"You are awesome so far!",@"Have fewer unlocks to remain in the Green Zone.",@"Use your phone less to keep in the Green Zone.", nil];
        
        characterLbl.text=[self languageSelectedStringForKey:[NSString stringWithFormat:@"%@",[textArray objectAtIndex:arc4random_uniform((uint32_t)[textArray count])]]];
        characterLbl.adjustsFontSizeToFitWidth = YES;
        characterLbl.numberOfLines=0;
        characterLbl.font=[UIFont systemFontOfSize:12];
        characterLbl.textAlignment=NSTextAlignmentCenter;
        [transparantView addSubview:characterLbl];
        
    }
    else if (addScore<=80){
        UIImageView * charactrImg=[[UIImageView alloc]initWithFrame:CGRectMake(100, 0, Screen_width-200, Screen_height/2-140)];
        NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"m1.png", @"m2.png", @"m3.png", @"m4.png", @"m5.png", nil];
        charactrImg.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
        [transparantView addSubview:charactrImg];
        //---RandomText
        UILabel *characterLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, Screen_height/2-135, Screen_width-30,30)];
        NSArray *textArray=[[NSArray alloc]initWithObjects:@"Avoid unnecessary screen unlocks.",@"Avoid having the phone around you all the time.",@"OK, you started to worry me. Take it easy.",@"You are in the Yellow Zone now. Watch it.",@"Use your phone only when you need it.",@"How about you leave your phone for like an hour?",@"Are you sure you need to use your phone this much?",@"How about you socialize with people face-to-face?",@"Make sure you don't go into the red zone!",@"OK, Socio is worried.", nil];
        
        characterLbl.text=[self languageSelectedStringForKey:[NSString stringWithFormat:@"%@",[textArray objectAtIndex:arc4random_uniform((uint32_t)[textArray count])]]];
        
        characterLbl.adjustsFontSizeToFitWidth = YES;
        characterLbl.numberOfLines=0;
        characterLbl.font=[UIFont systemFontOfSize:12];
        characterLbl.textAlignment=NSTextAlignmentCenter;
        [transparantView addSubview:characterLbl];
        
        
        
    }
    else if (addScore>=80)
    {
        UIImageView * charactrImg=[[UIImageView alloc]initWithFrame:CGRectMake(100, 0, Screen_width-200, Screen_height/2-140)];
        NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"m1.png", @"m2.png", @"m3.png", @"m4.png", @"m5.png", nil];
        charactrImg.image = [UIImage imageNamed:[imageNameArray objectAtIndex:arc4random_uniform((uint32_t)[imageNameArray count])]];
        [transparantView addSubview:charactrImg];
        //---RandomText
        UILabel *characterLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, Screen_height/2-135, Screen_width-30,30)];
        NSArray *textArray=[[NSArray alloc]initWithObjects:@"OK, Socio is really worried now.",@"I'm afraid you are in the Red Zone now!",@"You used your phone a lot today. You want to put it away?",@"Come on! I know you can do better than this.",@"Look how much time you spent on your phone today.",@"Are you sure you need to use your phone this much?",@"You are carried away. Take it easy.",@"You are in the Red Zone. Isn't it time to put the phone away?",@"I feel sorry for your phone!",@"You know Socio cares for you. Please put the phone away.", nil];
        
       characterLbl.text=[self languageSelectedStringForKey:[NSString stringWithFormat:@"%@",[textArray objectAtIndex:arc4random_uniform((uint32_t)[textArray count])]]];
        
        characterLbl.adjustsFontSizeToFitWidth = YES;
        characterLbl.numberOfLines=0;
        characterLbl.font=[UIFont systemFontOfSize:12];
        characterLbl.textAlignment=NSTextAlignmentCenter;
        [transparantView addSubview:characterLbl];
    }
    
    
}
-(NSString*) languageSelectedStringForKey:(NSString*) key
{
    
    NSString *path;
    
    // NSString *strLan = [userDefault objectForKey:@"language"];
    
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
