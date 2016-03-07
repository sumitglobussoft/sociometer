//
//  SettingsViewController.h
//  SocioMeter
//
//  Created by Sumit Ghosh on 26/12/15.
//  Copyright © 2015 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateDetailsView.h"
#import <MessageUI/MessageUI.h>
#import "EPieChart.h"
@interface SettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UpdateViewDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate,EPieChartDelegate,EPieChartDataSource>
{
    UITableView * settingsTableview;
    UIDatePicker *datePicker;
}
@property(nonatomic,strong)UIView *languageView;
@property(nonatomic,strong)UIView *updateView,*dateView;

@property(nonatomic,strong) UITableView *languagetableView;
@property (assign,readwrite) int selectedLanguage;
@property(strong,nonatomic)UILabel *dateOfBirthLbl;
@property(nonatomic,strong)NSString *stringFrmtForgender;

@property(strong,nonatomic)UIButton * secondUnselectRadioBtn,* firstUnselectRadioBtn;
-(NSString*) languageSelectedStringForKey:(NSString*) key;
-(void)languageViewAction;
-(void)updateDetailsAction;
@end
