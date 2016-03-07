//
//  MenuBarViewController.m
//  SocioMeter
//
//  Created by Sumit Ghosh on 26/12/15.
//  Copyright © 2015 Sumit Ghosh. All rights reserved.
//

#import "MenuBarViewController.h"
#import "ViewController.h"
#import "HMSegmentedControl.h"
#import "CustomMenuViewController.h"
#import "AchievementViewController.h"
#import "SettingsViewController.h"
#import "DashBarViewController.h"
#import "Singletoneclass.h"
#import "EPieChart.h"
@interface MenuBarViewController ()

@end

@implementation MenuBarViewController
@synthesize ePieChart = _ePieChart;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(dashboard) withObject:nil afterDelay:2];
    [self CreateUI];
    // Do any additional setup after loading the view.
}

-(void)CreateUI
{
    CGSize windowSize =[UIScreen mainScreen].bounds.size;
    
    //-------------------segmentController
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Today", @"Weekly", @"Monthly",]];
    [segmentedControl setBorderColor:[UIColor colorWithRed:140/255 green:200/255 blue:235/255 alpha:1]];
    [segmentedControl setFrame:CGRectMake(0, windowSize.height-180, windowSize.width, 60)];
    [segmentedControl setIndexChangeBlock:^(NSInteger index) {
        NSLog(@"Selected index %ld (via block)", (long)index);
    }];
    
    [segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName :[UIFont boldSystemFontOfSize:20]}];
        return attString;
    }];
    segmentedControl.selectionIndicatorHeight = 2.0f;
    segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl.backgroundColor = [UIColor colorWithRed:(CGFloat)60/255 green:(CGFloat)144/255 blue:(CGFloat)189/255 alpha:1];
    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    segmentedControl.titleTextAttributes=@{NSFontAttributeName :[UIFont boldSystemFontOfSize:20]};
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    segmentedControl.selectedSegmentIndex = HMSegmentedControlNoSegment;
    //segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionIndicatorColor = Bluecolor;

    segmentedControl.shouldAnimateUserSelection = NO;
    segmentedControl.tag = 2;
    [self.view addSubview:segmentedControl];
    [self performSelector:@selector(dashboard) withObject:nil afterDelay:0];


}
-(void)viewDidAppear:(BOOL)animated
{    [super viewDidAppear:YES];
    [self customMenuViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
+(CustomMenuViewController*)showMenuBar
{
    SettingsViewController *settingView=[[SettingsViewController alloc]init];
    DashBarViewController *dashboardVC=[[DashBarViewController alloc]init];
    dashboardVC.title=[settingView languageSelectedStringForKey:@"DashBoard"];
    
    //SettingsViewController *settingView=[[SettingsViewController alloc]init];
    settingView.title=[settingView languageSelectedStringForKey:@"Settings"];
 
    AchievementViewController *achieveView=[[AchievementViewController alloc]init];
    achieveView.title=[settingView languageSelectedStringForKey:@"Achievements"];
    
    CustomMenuViewController *customMenuView =[[CustomMenuViewController alloc] init];
    customMenuView.numberOfSections = 1;
    customMenuView.viewControllers = @[dashboardVC,settingView,achieveView];
    return customMenuView;
    
}




@end
