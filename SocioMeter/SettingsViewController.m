//
//  SettingsViewController.m
//  SocioMeter
//
//  Created by Sumit Ghosh on 26/12/15.
//  Copyright © 2015 Sumit Ghosh. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingTableViewCell.h"
#import "AppDelegate.h"
#import "Singletoneclass.h"
#import "AchievementViewController.h"
#import "ApiHelperClass.h"
#import "LanguageUiView.h"
#import "DashBarViewController.h"
#import "ManageSmartNotifcation.h"
#import "NotifyMeAtUnlockUiView.h"
#import "Reachability.h"
@interface SettingsViewController ()
{
    NSString *strLan;
    NSString *strLab;
    NSString *title;
    UITextView *commentTxtField;
    NSDateFormatter *dateFormatter;
    UISwitch* smartNotificationSwitch;
    UISwitch *switchView;
    UIActivityIndicatorView *activityIndicator;
}
@end

@implementation SettingsViewController
@synthesize selectedLanguage,dateView,dateOfBirthLbl,stringFrmtForgender;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createUI];
    //[self notifyMeAtUnlockAction];
    // Do any additional setup after loading the view.
}

-(void)createUI
{

 smartNotificationSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(Screen_width-79, 25, 79, 40)];
    
     settingsTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height-60)];
    settingsTableview.delegate=self;
    settingsTableview.dataSource=self;
    [self.view addSubview:settingsTableview];
    //---
    
    //[self activityAction];
    
}

-(void)activityAction
{
    CGSize windowSize =[UIScreen  mainScreen].bounds.size;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.frame = CGRectMake(windowSize.width/2-20, windowSize.height/2-55,40 ,40);
    activityIndicator.color = [UIColor blackColor];
    activityIndicator.alpha = 1;
    [self.view addSubview:activityIndicator];
    //[self placeSearchbaseId];
   // mapviewbtn1.hidden=YES;
    [activityIndicator startAnimating];
    
    
}

#pragma TableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    SettingTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[SettingTableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    
    if (indexPath.section==0&&indexPath.row==0) {
  
        cell.primaryLabel.text=[self languageSelectedStringForKey:@"Show Smart Notification"];
        cell.secondaryLabel.text=[self languageSelectedStringForKey:@"(notification about phone overuse)"];
        [smartNotificationSwitch addTarget:self action:@selector(smartNotificationSwitchAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:smartNotificationSwitch];
 
    }
    else if (indexPath.section==1)
    {
        NSArray *sociometerArray=[[NSArray alloc]initWithObjects:@"App Language",@"Update Details",@"Feedback",@"About",@"Share SocioMeter", nil];
                if (indexPath.row==0) {
    
            
            cell.primaryLabel.text=[self languageSelectedStringForKey:@"App Language"];
            cell.secondaryLabel.text=[self languageSelectedStringForKey:@"(use Socimeter in other language)"];
        }
        else{
            UILabel *socioLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, 250, 20)];
            socioLbl.textColor = [UIColor colorWithRed:(CGFloat)38/255 green:(CGFloat)81/255 blue:(CGFloat)166/255 alpha:(CGFloat)1];
            socioLbl.font = [UIFont systemFontOfSize:17];
            socioLbl.text=[self languageSelectedStringForKey:[NSString stringWithFormat:@"%@",[sociometerArray objectAtIndex:indexPath.row]]];
            [cell.contentView addSubview:socioLbl];
            
        }
        if (indexPath.row==4) {
            UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_width/2, 15, 40, 40)];
            [shareBtn setImage:[UIImage imageNamed:@"setting_share"] forState:UIControlStateNormal];
            [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:shareBtn];

            
        }
  
    }

    return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView==settingsTableview) {

    switch (section) {
        case 0:
            return @"Notification";
            break;
            case 1:
            return @"SocioMeter";
            break;
           
           }
    }
          return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   if (tableView==settingsTableview) {
        return 60;
   }
   else{
       return 0;
   }
    }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
if (tableView==settingsTableview) {
    if (indexPath.section==0&&indexPath.row==1) {
        return 100;
    }
    return 70;
}
else{
    return 55;
}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIImage *myImage = [UIImage imageNamed:@"header_image.png"];
    self.view.backgroundColor=[UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
    imageView.frame = CGRectMake(0, 1, Screen_width, 50);
    imageView.backgroundColor=[UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    [view addSubview:imageView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 728, 25)];
    titleLabel.textColor=[UIColor whiteColor];
    [view addSubview:titleLabel];

    if (tableView==settingsTableview) {
        
        if (section == 0) {
      
        titleLabel.text =[self languageSelectedStringForKey:@"Notificaion and Pop-ups"];
        }
        else if (section==1){
        titleLabel.text = @"SocioMeter";
        }
    
        return view;
    }
    else{
        return nil;
    }
        return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section
{
  
    if (section==0)
    {
        return 1;
    }
    else if (section==1)
    {
        return 5;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==self.languagetableView) {
            return 1;
    }else{
        return 2;
 
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   if (indexPath.row==3)
    {
        [self aboutAction];

    }

    
    if (indexPath.section==1&&indexPath.row==1) {
        [self updateDetailsAction];
    }
   else if (indexPath.section==1&&indexPath.row==0) {
        [self languageViewAction];
         //[settingsTableview reloadData];
    }
   else if (indexPath.section==1 && indexPath.row==2) {
        [self feedbackAction];
    }
   
    
}

#pragma mark Changing Language

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
#pragma mark About row
-(void)aboutAction
{
    UIImageView *aboutImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    [aboutImageView setImage:[UIImage imageNamed:@"aboutus_bg.png"]];
    aboutImageView.userInteractionEnabled=YES;
    aboutImageView.backgroundColor=[UIColor clearColor];
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:aboutImageView];
    //----
    UIButton *crossBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    crossBtn.frame=CGRectMake(Screen_width-50, 10, 50, 50);
    [crossBtn setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    [crossBtn addTarget:self action:@selector(crossAction) forControlEvents:UIControlEventTouchUpInside];
    [aboutImageView addSubview:crossBtn];
    //--
    //---
    NSString *appVersionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    NSLog(@"appVersion: %@",appVersionStr);
    //---
    UILabel *appVersionLbl=[[UILabel alloc]initWithFrame:CGRectMake(40, Screen_height-150, Screen_width-80, 20)];
    appVersionLbl.text=[NSString stringWithFormat:@"App Version  %@",appVersionStr];
    appVersionLbl.textAlignment=NSTextAlignmentCenter;
    appVersionLbl.textColor=[UIColor whiteColor];
    [aboutImageView addSubview:appVersionLbl];
    //--
    UILabel *supportLbl=[[UILabel alloc]initWithFrame:CGRectMake(30, Screen_height-100, 100, 20)];
    supportLbl.textColor=[UIColor whiteColor];
    supportLbl.text=@"Support - ";
    [aboutImageView addSubview:supportLbl];
    //--
    UIButton *mailBtn=[[UIButton alloc]initWithFrame:CGRectMake( 70, Screen_height-100, 270, 20)];
    [mailBtn setTitle:@"alhuseinm@gmail.com" forState:UIControlStateNormal];
    [mailBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [mailBtn addTarget:self action:@selector(mailAction:) forControlEvents:UIControlEventTouchUpInside];
    mailBtn.userInteractionEnabled=YES;
    [aboutImageView addSubview:mailBtn];
    //--
    UIButton *facebookBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, Screen_height-50, Screen_width/2-40, 30)];
    [facebookBtn setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
    [facebookBtn addTarget:self action:@selector(fbLikeUsAction) forControlEvents:UIControlEventTouchUpInside];
    facebookBtn.backgroundColor=[UIColor blueColor];
    [aboutImageView addSubview:facebookBtn];
    //--
    UIButton *twitterBtn=[[UIButton alloc]initWithFrame:CGRectMake(Screen_width/2+20, Screen_height-50, Screen_width/2-40, 30)];
    [twitterBtn setImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
    [twitterBtn addTarget:self action:@selector(twitterLikeUsAction) forControlEvents:UIControlEventTouchUpInside];
    twitterBtn.backgroundColor=[UIColor blueColor];
    [aboutImageView addSubview:twitterBtn];
    
}
-(void)crossAction
{
    [[[[[UIApplication sharedApplication]keyWindow]subviews]lastObject]removeFromSuperview];
 
}
-(void)fbLikeUsAction
{
    NSURL *url = [NSURL URLWithString:@"https://www.facebook.com/appsociometer"];
    [[UIApplication sharedApplication] openURL:url];
}
-(void)twitterLikeUsAction
{
    NSURL *url = [NSURL URLWithString:@"https://twitter.com/appsociometer"];
    [[UIApplication sharedApplication] openURL:url];
}
-(void)mailAction:(id)sender
{
    
    
    MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
    composeVC.mailComposeDelegate = self;
    
    // Configure the fields of the interface.
    [composeVC setToRecipients:@[@"address@example.com"]];
    [composeVC setSubject:@"Hello!"];
    [composeVC setMessageBody:@"Hello from California!" isHTML:NO];
    
    // Present the view controller modally.
    [self presentViewController:composeVC animated:YES completion:nil];

    
    
//       MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc]init];
//        mailComposer.mailComposeDelegate = self;
//        [mailComposer setSubject:@"Test mail"];
//    [mailComposer setToRecipients:[NSArray arrayWithObjects:@"email@email.com",nil]];
//    NSArray *usersTo = [NSArray arrayWithObject: @"nobody@stackoverflow.com"];
//    [mailComposer setToRecipients:usersTo];
//        [mailComposer setMessageBody:@"Testing messagefor the test mail" isHTML:NO];
//    [self presentViewController:mailComposer animated:YES completion:nil];

}
#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        NSLog(@"Result : %d",result);
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
   //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark Share Action

-(void)shareBtnAction
{
    
    NSString *url=@"";
    NSArray *objectsToShare = @[UIActivityTypeMessage,UIActivityTypePostToFacebook,UIActivityTypePostToTwitter];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    
    NSArray *excludedActivities = @[url, UIActivityTypeMessage,UIActivityTypePostToFacebook,UIActivityTypePostToTwitter];
    controller.excludedActivityTypes = excludedActivities;
    
    
    [self presentViewController:controller animated:YES completion:nil];
    
    
    
}
#pragma Mark FeedbackView:=

-(void)feedbackAction
{
    
   
    
    UIView *feedTransparantView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    feedTransparantView.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
   // feedTransparantView.alpha=0.5;
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:feedTransparantView];
    //-----
    UIView *feedBackView=[[UIView alloc]initWithFrame:CGRectMake(20, 150, Screen_width-40, 254)];
    feedBackView.backgroundColor=Bluecolor;
    [feedTransparantView addSubview:feedBackView];
    //---
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,feedBackView.bounds.size.width , 60)];
    headerView.backgroundColor=[UIColor  whiteColor];
    [feedBackView addSubview:headerView];
    //--
    UILabel * headerLbl=[[UILabel alloc]initWithFrame:CGRectMake(60, 20,feedBackView.bounds.size.width-120 , 20)];
    headerLbl.text=@"Feedback";
    headerLbl.textAlignment=NSTextAlignmentLeft;
    headerLbl.textColor=Bluecolor;
    [headerLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
    [feedBackView addSubview:headerLbl];
    
    //--
    UIImageView * socioLogo=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 42)];
    [socioLogo setImage:[UIImage imageNamed:@"socio_icon.png"]];
    [headerView addSubview:socioLogo];
    //----
    UILabel *textLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 60, feedBackView.bounds.size.width-20, 100)];
    textLbl.text=[self languageSelectedStringForKey:@"We’d love to hear from you. If you have any comment or suggestion please type it here and press Send"];
    textLbl.numberOfLines=0;
    textLbl.textColor=[UIColor whiteColor];
    [feedBackView addSubview:textLbl];
    //----
    
    commentTxtField = [[UITextView  alloc] initWithFrame:
    CGRectMake(10,160 , feedBackView.bounds.size.width-20, 40)];
    commentTxtField.text=@"";
    [commentTxtField setFont:[UIFont boldSystemFontOfSize:14]];
    commentTxtField.delegate=self;
    CGRect frame = commentTxtField.frame;
    frame.size.height = commentTxtField.contentSize.height;
    commentTxtField.frame = frame;
    [feedBackView addSubview:commentTxtField];

    //--
    UIButton *cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, feedBackView.bounds.size.height-45,feedBackView.bounds.size.width/2-2 , 45)];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelBtn.backgroundColor=[UIColor whiteColor];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [feedBackView addSubview:cancelBtn];
    
    //---
    UIButton *sendBtn=[[UIButton alloc]initWithFrame:CGRectMake(feedBackView.bounds.size.width/2, feedBackView.bounds.size.height-45,feedBackView.bounds.size.width/2 , 45)];
    [sendBtn setTitle:@"Send" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(feddBackService) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.backgroundColor=[UIColor whiteColor];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [feedBackView addSubview:sendBtn];
   
}
-(void)cancelAction{
    [[[[[UIApplication sharedApplication]keyWindow]subviews]lastObject]removeFromSuperview];
  
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}
#pragma mark UserSocimeter Usages Service
-(void)feddBackService
{

    
    NSString* userId = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    NSLog(@"output is : %@", userId);
  
    //--
    NSString *feedbackMessage=[NSString stringWithFormat:@"%@",commentTxtField.text];
    //feedbackMessage,userId
    ApiHelperClass *apiObj=[[ApiHelperClass alloc]init];
    NSDictionary *dict=@{@"userId":userId,@"feedbackMessage":feedbackMessage};
    
    id dataReturned=[apiObj userFeedBackMessage:dict];
    
    if([[dataReturned objectForKey:@"code"] intValue]==198)
    {
    }
    else
    {
        
        //[self addAlertView:[dataReturned objectForKey:@"message"]];
    }
    [self networkCheck];
    [[[[[UIApplication sharedApplication]keyWindow]subviews]lastObject]removeFromSuperview];

    
}




-(void)okAction
{
    
    [[[[[UIApplication sharedApplication]keyWindow]subviews]lastObject]removeFromSuperview];
    
   UIAlertView *englishAlert = [[UIAlertView alloc]initWithTitle:[self languageSelectedStringForKey:@"Restart Sociometer"]  message:[self languageSelectedStringForKey:@"Restart Sociometer for changes to take effect."] delegate:self cancelButtonTitle:[self languageSelectedStringForKey:@"Cancel"] otherButtonTitles:[self languageSelectedStringForKey:@"Ok"], nil];
    [englishAlert show];
    [settingsTableview reloadData];
    
    
}

//--

#pragma mark LanguageView :=

-(void)languageViewAction
{
    UIView *languageTransparantView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    languageTransparantView.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:languageTransparantView];
    //-----
    self.languageView=[[UIView alloc]initWithFrame:CGRectMake(20, 150, Screen_width-40, 200)];
    self.languageView.backgroundColor=Bluecolor;
    [languageTransparantView addSubview:self.languageView];
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
    self.firstUnselectRadioBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.languageView.bounds.size.width-40, 80, 25,25 )];
    [self.firstUnselectRadioBtn setImage:[UIImage imageNamed:@"radio-btn"] forState:UIControlStateNormal];
    [self.firstUnselectRadioBtn setImage:[UIImage imageNamed:@"selected-radio-btn"] forState:UIControlStateSelected];
    [self.firstUnselectRadioBtn addTarget:self action:@selector(englishAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.languageView addSubview:self.firstUnselectRadioBtn];
    //--
    self.secondUnselectRadioBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.languageView.bounds.size.width-40, 130, 25,25 )];
    [self.secondUnselectRadioBtn setImage:[UIImage imageNamed:@"radio-btn"] forState:UIControlStateNormal];
    [self.secondUnselectRadioBtn setImage:[UIImage imageNamed:@"selected-radio-btn"] forState:UIControlStateSelected];
    [self.secondUnselectRadioBtn addTarget:self action:@selector(arabicAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.languageView addSubview:self.secondUnselectRadioBtn];
    //--
    //--
    UIButton *okBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.languageView.bounds.size.height-30,self.languageView.bounds.size.width , 40)];
    [okBtn setTitle:@"OK" forState:UIControlStateNormal];
    okBtn.backgroundColor=[UIColor whiteColor];
    [okBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
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
#pragma mark update DetailsView
-(void)updateAction
{
    UpdateDetailsView * updateView=[[UpdateDetailsView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:updateView];
}
-(void)updateDetailsAction
{
    UIView *updateDetailsTransparantView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    updateDetailsTransparantView.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
   AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:updateDetailsTransparantView];
    //-----
    self.updateView=[[UIView alloc]initWithFrame:CGRectMake(20, 150, Screen_width-40, 250)];
    self.updateView.backgroundColor=[UIColor whiteColor];
    //AppDelegate *feedBackdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [updateDetailsTransparantView addSubview:self.updateView];
    //---
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.updateView.bounds.size.width , 60)];
    headerView.backgroundColor=Bluecolor;
    [self.updateView addSubview:headerView];
    //--
    UILabel * headerLbl=[[UILabel alloc]initWithFrame:CGRectMake(60, 20,self.updateView.bounds.size.width-120 , 20)];
    headerLbl.text=[self languageSelectedStringForKey:@"Update Details"];
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
    birthdayNameLbl.text=[self languageSelectedStringForKey:@"Birthday :"];
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
    
    dateOfBirthLbl.text=[[NSUserDefaults standardUserDefaults]objectForKey:selectedDateOfBirth];
    //[Singletoneclass sharedSingleton].dateOfBirth;
    [self.updateView addSubview:dateOfBirthLbl];
    //--
    UILabel * genderNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 150,120 , 25)];
    genderNameLbl.text=[self languageSelectedStringForKey:@"Gender :"];
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
     self.firstUnselectRadioBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.updateView.bounds.size.width-150, 150, 25,25)];
    [self.firstUnselectRadioBtn setImage:[UIImage imageNamed:@"radio-btn"] forState:UIControlStateNormal];
    [self.firstUnselectRadioBtn setImage:[UIImage imageNamed:@"selected-radio-btn"] forState:UIControlStateSelected];
    [self.firstUnselectRadioBtn addTarget:self action:@selector(maleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.updateView addSubview:self.firstUnselectRadioBtn];
    //--
    self.secondUnselectRadioBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.updateView.bounds.size.width-80, 150, 25,25 )];
    [self.secondUnselectRadioBtn setImage:[UIImage imageNamed:@"radio-btn"] forState:UIControlStateNormal];
    [self.secondUnselectRadioBtn setImage:[UIImage imageNamed:@"selected-radio-btn"] forState:UIControlStateSelected];
    [self.secondUnselectRadioBtn addTarget:self action:@selector(femaleAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.updateView addSubview:self.secondUnselectRadioBtn];
     //--
    UIButton *saveBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.updateView.bounds.size.height-30,self.updateView.bounds.size.width , 40)];
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
    
   
    NSString* deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"deviceUDID: %@",deviceId);
    
    //---
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    NSLog(@"appVersion: %@",appVersion);
    //--
   NSString *OSType =@"mac";
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
    gender=stringFrmtForgender;
    
    ApiHelperClass * apiObj=[[ApiHelperClass alloc]init];
    
//    if (gender!=nil && birthday!=nil)
//    {
//      NSDictionary *dict=@{@"deviceName":deviceName,@"deviceId":deviceId,@"country":countryName,@"birthDay":birthday,@"gender":gender,@"deviceType":deviceType,@"appVersion":appVersion};
//        id dataReturned=[apiObj userSignUpMethod:dict];
//        NSLog(@"%@",dataReturned);
//        [[[[[UIApplication sharedApplication]keyWindow]subviews]lastObject]removeFromSuperview];
//
//    }
//    else{
//        UIAlertView *messagesAlert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please Provide your details" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//        [messagesAlert show];
//    }
    
//---
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]; [self.view addSubview:spinner];
    
    //switch to background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        //back to the main thread for the UI call
        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner startAnimating];
            if (gender!=nil && birthday!=nil)
            {
                NSDictionary *dict=@{@"deviceName":deviceName,@"deviceId":deviceId,@"country":countryName,@"birthDay":birthday,@"gender":gender,@"deviceType":deviceType,@"appVersion":appVersion,@"OsType":OSType};
                id dataReturned=[apiObj userSignUpMethod:dict];
                NSLog(@"%@",dataReturned);
                
            }
            else{
                UIAlertView *messagesAlert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please Provide your details" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                [messagesAlert show];
            }
            
        });
        // more on the background thread
        
        // parsing code code
        
        //back to the main thread for the UI call
        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner stopAnimating];

        });
    });
    
    [[[[[UIApplication sharedApplication]keyWindow]subviews]lastObject]removeFromSuperview];

    [self networkCheck];
    
}

- (void)maleAction:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    self.stringFrmtForgender=[NSString stringWithFormat:@"male"];
    NSLog(@"%@",self.stringFrmtForgender);
    //[[NSUserDefaults standardUserDefaults]setBool:self.secondUnselectRadioBtn forKey:@"radioBtnAction"];
    [[NSUserDefaults standardUserDefaults]objectForKey:@"radioBtnAction"];
    [self.firstUnselectRadioBtn setSelected:YES];
    [self.secondUnselectRadioBtn setSelected:NO];
}

- (void)femaleAction:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    self.stringFrmtForgender=[NSString stringWithFormat:@"female"];
    NSLog(@"%@",self.stringFrmtForgender);
    [[NSUserDefaults standardUserDefaults]objectForKey:@"radioBtnAction"];
    [self.firstUnselectRadioBtn setSelected:NO];
    [self.secondUnselectRadioBtn setSelected:YES];
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
   
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyy"];
     title = [dateFormatter stringFromDate:datePicker.date];
    NSLog(@"title title%@",title);
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

    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyy"];
       NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"hh:mm a"];
}

#pragma mark notifyMeAtunlockSwitch
-(void)notifymeSwitchAction:(id)sender
{
    if ([sender isOn])
    {
    NSLog(@"Switch is ON");
    NotifyMeAtUnlockUiView *notifyView=[[NotifyMeAtUnlockUiView alloc]initWithFrame:[UIScreen mainScreen].bounds];
   [self.view addSubview:notifyView];

    }
    else
    {
    NSLog(@"Switch is OFF");
    }
}

#pragma mark smartNotificationSwitch

- (void)smartNotificationSwitchAction:(id)sender
{
    if([sender isOn]){
        ManageSmartNotifcation *smartNotificationVC=[[ManageSmartNotifcation alloc]init];
        [smartNotificationVC fireNotificationWithAddictionScore];
        NSLog(@"Switch is ON");
         [switchView setOn:YES animated:NO];
        [[NSUserDefaults standardUserDefaults]setObject:@"switchOn" forKey:@"switchOnState"];
        [[NSUserDefaults standardUserDefaults]synchronize];
       
        //smartNotificationSwitch.on=YES;
    } else{
        //smartNotificationSwitch.on=NO;
    [[NSUserDefaults standardUserDefaults]setObject:@"switchOff" forKey:@"switchOffState"];
        NSLog(@"Switch is OFF");
    }
    
}


#pragma mark Rechability Code
-(BOOL)networkCheck
{
    
    Reachability *wifiReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:
        {
            NSLog(@"NETWORKCHECK: Not Connected");
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Check internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];

            return NO;
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"NETWORKCHECK: Connected Via WWAN");
            return YES;
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"NETWORKCHECK: Connected Via WiFi");
            return YES;
            break;
        }
    }
    return NO;
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [[[[[UIApplication sharedApplication]keyWindow]subviews]lastObject]removeFromSuperview];
  
    }
}
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
