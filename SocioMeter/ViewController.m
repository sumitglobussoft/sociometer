//
//  ViewController.m
//  SocioMeter
//
//  Created by Sumit Ghosh on 24/12/15.
//  Copyright © 2015 Sumit Ghosh. All rights reserved.
//

#import "ViewController.h"
#import "HMSegmentedControl.h"
#import "CustomMenuViewController.h"
#import "AchievementViewController.h"
#import "SettingsViewController.h"
#import "MenuBarViewController.h"



@interface ViewController ()

@end

@implementation ViewController
@synthesize ePieChart = _ePieChart;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
  
}
-(void)viewDidAppear:(BOOL)animated
{

  }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
