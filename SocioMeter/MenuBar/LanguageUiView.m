//
//  LanguageUiView.m
//  SocioMeter
//
//  Created by Sumit Ghosh on 03/02/16.
//  Copyright © 2016 Sumit Ghosh. All rights reserved.
//

#import "LanguageUiView.h"
#import "AppDelegate.h"
#import "Singletoneclass.h"
@implementation LanguageUiView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSUserDefaults standardUserDefaults]setObject:@"languageView" forKey:@"languageViewDisplay"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self languageViewAction];
        
    }
    return self;
}

#pragma mark LanguageView :=

-(void)languageViewAction
{
    
    self.launchImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    [self.launchImg setImage:[UIImage imageNamed:@"splash_screen.png"]];
    self.launchImg.userInteractionEnabled=YES;
    [self addSubview:self.launchImg];
    //---
//    UIView *languageTransparantView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
//    languageTransparantView.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
//    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [delegate.window addSubview:languageTransparantView];
    //-----
    self.languageView=[[UIView alloc]initWithFrame:CGRectMake(20, 150, Screen_width-40, 200)];
    self.languageView.backgroundColor=Bluecolor;
    [self.launchImg addSubview:self.languageView];
    //---
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.languageView.bounds.size.width , 60)];
    headerView.backgroundColor=[UIColor  whiteColor];
    [self.languageView addSubview:headerView];
    //--
    UILabel * headerLbl=[[UILabel alloc]initWithFrame:CGRectMake(60, 20,self.languageView.bounds.size.width-120 , 20)];
    headerLbl.text=[self languageSelectedStringForKey:@"App Language"];
    headerLbl.textAlignment=NSTextAlignmentLeft;
    headerLbl.textColor=Bluecolor;
    [headerLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.languageView addSubview:headerLbl];
    
    //--
    UIImageView * socioLogo=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 42)];
    [socioLogo setImage:[UIImage imageNamed:@"socio_icon.png"]];
    [headerView addSubview:socioLogo];
    
    //--
    UILabel * ChangeEngilshLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 80,120 , 25)];
    ChangeEngilshLbl.text=[self languageSelectedStringForKey:@"English "];
    ChangeEngilshLbl.textAlignment=NSTextAlignmentLeft;
    ChangeEngilshLbl.textColor=[UIColor whiteColor];
    [ChangeEngilshLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.languageView addSubview:ChangeEngilshLbl];
    //---
    UILabel * birthdayNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 130,120 , 25)];
    birthdayNameLbl.text=[self languageSelectedStringForKey:@"عربي "];
    birthdayNameLbl.textAlignment=NSTextAlignmentLeft;
    birthdayNameLbl.textColor=[UIColor whiteColor];
    [birthdayNameLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [self.languageView addSubview:birthdayNameLbl];
    //--
    self.firstUnselectRadioBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.languageView.bounds.size.width-40, 80, 20,20 )];
    [self.firstUnselectRadioBtn setImage:[UIImage imageNamed:@"radio-btn"] forState:UIControlStateNormal];
    [self.firstUnselectRadioBtn setImage:[UIImage imageNamed:@"selected-radio-btn"] forState:UIControlStateSelected];
    [self.firstUnselectRadioBtn addTarget:self action:@selector(englishAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.languageView addSubview:self.firstUnselectRadioBtn];
    //--
    self.secondUnselectRadioBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.languageView.bounds.size.width-40, 130, 20,20 )];
    [self.secondUnselectRadioBtn setImage:[UIImage imageNamed:@"radio-btn"] forState:UIControlStateNormal];
    [self.secondUnselectRadioBtn setImage:[UIImage imageNamed:@"selected-radio-btn"] forState:UIControlStateSelected];
    [self.secondUnselectRadioBtn addTarget:self action:@selector(arabicAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.languageView addSubview:self.secondUnselectRadioBtn];
    //--
    //--
    UIButton *okBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.languageView.bounds.size.height-30,self.languageView.bounds.size.width , 40)];
    [okBtn setTitle:@"OK" forState:UIControlStateNormal];
    okBtn.backgroundColor=[UIColor whiteColor];
    [okBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.languageView addSubview:okBtn];
}
- (void)englishAction:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    [self.firstUnselectRadioBtn setSelected:YES];
    [self.secondUnselectRadioBtn setSelected:NO];
    [Singletoneclass sharedSingleton].languageChanged=@"English";
}

- (void)arabicAction:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    [self.secondUnselectRadioBtn setSelected:YES];
    [self.firstUnselectRadioBtn setSelected:NO];
    [Singletoneclass sharedSingleton].languageChanged=@"Arabic";
    
}
#pragma Mark Changing Language :=
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

-(void)cancelAction
{
    
    //[[[[[UIApplication sharedApplication]keyWindow]subviews]lastObject]removeFromSuperview];
    
   UIAlertView *englishAlert = [[UIAlertView alloc]initWithTitle:[self languageSelectedStringForKey:@"Restart Sociometer"]  message:[self languageSelectedStringForKey:@"Restart Sociometer for changes to take effect."] delegate:self cancelButtonTitle:[self languageSelectedStringForKey:@"Cancel"] otherButtonTitles:[self languageSelectedStringForKey:@"Ok"], nil];
    [englishAlert show];
    //[settingsTableview reloadData];
    //[[NSUserDefaults standardUserDefaults]setObject:@"removeLaunchScreen" forKey:removeScreen];
    [[[NSUserDefaults standardUserDefaults]objectForKey:removeScreen] removeFromSuperview];
    [self removeFromSuperview];
    [self.launchImg removeFromSuperview];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
