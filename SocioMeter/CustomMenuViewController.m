
//
//  CustomMenuViewController.m
//  MOVYTFmenu
//
//  Created by Sumit Ghosh on 27/05/14.
//  Copyright (c) 2014 Sumit Ghosh. All rights reserved.
//

#import "CustomMenuViewController.h"
#import <objc/runtime.h>
#import "ViewController.h"
#import "AppDelegate.h"
#import "AchievementViewController.h"
#import "SettingsViewController.h"
#import "Singletoneclass.h"
#import "LanguageUiView.h"
#import "Reachability.h"
@interface CustomMenuViewController ()
{
    NSInteger updateValue;
    NSString *userID;
    UIView * viewLogo;
    UIImageView *chatLabelImg,*menuLabelImg,*momentLabelImg;
    UIImageView *launchImg;
}
@property (nonatomic,strong)UITabBar *customTabBar;
@end

@implementation CustomMenuViewController
@synthesize viewControllers = _viewControllers;






#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated
{
       [self.menuTableView reloadData];


  
}


//Received Notification Method



#pragma mark -
-(void) setViewControllers:(NSArray *)viewControllers{
    
    _viewControllers = [viewControllers copy];
    
    for (UIViewController *viewController in _viewControllers ) {
        [self addChildViewController:viewController];
        
        viewController.view.frame = CGRectMake(0, 90,[UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-90);
        [viewController didMoveToParentViewController:self];
    }
}




-(void) setSelectedViewController:(UIViewController *)selectedViewController{
    _selectedViewController = selectedViewController;
}

-(void) setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
}

-(NSArray *) getAllViewControllers{
    return self.viewControllers;
}
-(void) setSelectedSection:(NSInteger)selectedSection{
    _selectedSection = selectedSection;
}


#pragma mark - view did load
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired=1;
    tap.delegate=self;

    
//    self.arrayMenuImages=[[NSArray alloc]initWithObjects:@"Home2",@"entertainment_menuicon",@"lifestyle_menuicon",@"travel_menu_icon", @"viral_menuicon",@"auditions_menuicon",@"contest_menuicon",@"notification_menuicon",nil];
    
    screenSize = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)40/255 green:(CGFloat)40/255 blue:(CGFloat)40/255 alpha:1];


    
    //Add View SubView;
    self.mainsubView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    NSLog(@"Main sub view frame X=-=- %f \n Y == %f",[UIScreen mainScreen].bounds.origin.x,[UIScreen mainScreen].bounds.origin.y);
   // self.mainsubView.backgroundColor = [UIColor colorWithRed:(CGFloat)210/255 green:(CGFloat)237/255 blue:(CGFloat)240/255 alpha:(CGFloat)1];
    [self.view addSubview:self.mainsubView];
    
//Add Header View

    
    CGRect frame = CGRectMake(0, 0, Screen_width, 60);
    self.headerView = [[UIView alloc] initWithFrame:frame];
    self.headerView.backgroundColor =[UIColor colorWithRed:(CGFloat)41/255 green:(CGFloat)67/255 blue:(CGFloat)161/255 alpha:1];
    [self.mainsubView addSubview:self.headerView];
   
        
    
    NSArray *headerArray=[[NSArray alloc]initWithObjects:@"SocioMeter",@"App Usage",@"Settings",@"Achievements", nil];
    
    UILabel *headerLbl=[[UILabel alloc]initWithFrame:CGRectMake(65, 20, 100, 30)];
    headerLbl.text=[headerArray objectAtIndex:0];
    headerLbl.font=[UIFont boldSystemFontOfSize:17.0f];
    headerLbl.textColor=[UIColor whiteColor];
    [self.headerView addSubview:headerLbl];
    //=======================================
// Add Container View
    
    frame = CGRectMake(0,60, Screen_width, Screen_height);
    self.contentContainerView = [[UIView alloc] initWithFrame:frame];
    self.contentContainerView.backgroundColor = [UIColor grayColor];
    self.contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.mainsubView addSubview:self.contentContainerView];
    //------------------

    
    UIImage *menu = [UIImage imageNamed:@"main_menu"];
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton.frame = CGRectMake(0, 0, 50, 60);
    [self.menuButton addTarget:self action:@selector(menuButtonClciked:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuButton setImage:menu forState:UIControlStateNormal];
    self.menuButton.imageEdgeInsets=UIEdgeInsetsMake(15, 10, 5, 5);
    //self.menuButton.backgroundColor=[UIColor redColor];
    [self.headerView addSubview:self.menuButton];


    //===================================

    //Add current class Lable
    
  UITapGestureRecognizer*  logoTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logoTap)];
      menuLabelImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.menuButton.frame.origin.x+self.menuButton.frame.size.width+20, 20, 30, 30)];
    menuLabelImg.userInteractionEnabled=YES;
    [menuLabelImg addGestureRecognizer: logoTapGes];
    menuLabelImg.image = [UIImage imageNamed:@"search_icon.png"];
    [self.headerView addSubview:menuLabelImg];
    
    UITapGestureRecognizer*  chatTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chatTap)];
    chatLabelImg = [[UIImageView alloc]initWithFrame:CGRectMake(menuLabelImg.frame.origin.x+menuLabelImg.frame.size.width+20, 20, 30, 30)];
    chatLabelImg.userInteractionEnabled=YES;
    [chatLabelImg addGestureRecognizer:chatTapGes];
    chatLabelImg.image = [UIImage imageNamed:@"chat_icon_default.png"];
    [self.headerView addSubview:chatLabelImg];
    
     UITapGestureRecognizer*  activityTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(activityTap)];
    momentLabelImg = [[UIImageView alloc]initWithFrame:CGRectMake(chatLabelImg.frame.origin.x+chatLabelImg.frame.size.width+20, 20, 30, 30)];
    momentLabelImg.userInteractionEnabled=YES;
    [momentLabelImg addGestureRecognizer:activityTapGes];
    momentLabelImg.image = [UIImage imageNamed:@"heart_icon.png"];
    [self.headerView addSubview:momentLabelImg];
    
    
    
    //====================================
    
    self.selectedIndex = 0;
    self.selectedViewController = [_viewControllers objectAtIndex:0];
       [self updateViewContainer];
    [self createMenuTableView];
//    [self createAccountTable];
    //Adding Swipr Gesture
    
          //===============
    self.swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureLeft:)];
    self.swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.mainsubView addGestureRecognizer:self.swipeGestureLeft];
    //===============
    self.swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureRight:)];
    self.swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.mainsubView addGestureRecognizer:self.swipeGestureRight];
    
    //---
    [self updateDetails];
}



-(void)updateDetails
{
 
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckFirstTime"] isEqual:@"First"]){
        NSLog(@"Not first Time");

    }
    
    else{
        [[NSUserDefaults standardUserDefaults]setObject:@"First" forKey:@"CheckFirstTime"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSLog(@"First Time");
        //[self updateDetailsAction];

    
    }
}
-(void)updateDetailsAction
{
//    launchImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
//    [launchImg setImage:[UIImage imageNamed:@"splash_screen.png"]];
//    launchImg.userInteractionEnabled=YES;
//    [self.mainsubView addSubview:launchImg];
    
    UpdateDetailsView * updateView=[[UpdateDetailsView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.mainsubView addSubview:updateView];
    
}
-(void)languageViewAction
{
    LanguageUiView *languageView=[[LanguageUiView alloc]initWithFrame:[UIScreen mainScreen].bounds];
   
    [self.mainsubView addSubview:languageView];
}



-(void)logoTap
{
    
    
   // XPostN(@"logoTap");
    
    
  //  XRmN(@"logoTap");
    
  
}

-(void)chatTap
{
    
    
   // XPostN(@"chatTap");
    //XRmN(@"chatTap");
    
    
}
-(void)activityTap
{
    
    
   // XPostN(@"activityTap");
    //XRmN(@"activityTap");
    
    
}

-(void)feedselect
{
    [UIView animateWithDuration:.3 animations:^{
        
       
        menuLabelImg.frame= CGRectMake(self.menuButton.frame.origin.x+self.menuButton.frame.size.width+20, 20, 30, 30);
        chatLabelImg.frame= CGRectMake(menuLabelImg.frame.origin.x+menuLabelImg.frame.size.width+20, 20, 30, 30);
        momentLabelImg.frame= CGRectMake(chatLabelImg.frame.origin.x+chatLabelImg.frame.size.width+20, 20, 30, 30);
        
    } completion:^(BOOL finished)
     {
         menuLabelImg.image=[UIImage imageNamed:@"search_icon.png"];
         chatLabelImg.image=[UIImage imageNamed:@"chat_icon_default"];
         momentLabelImg.image=[UIImage imageNamed:@"heart_icon"];
     }];
   
    
    
}


-(void)chatselect
{
    
    
    [UIView animateWithDuration:.3 animations:^{
        
        
        menuLabelImg.frame= CGRectMake(self.menuButton.frame.origin.x+self.menuButton.frame.size.width+20, 20, 30, 30);
        chatLabelImg.frame= CGRectMake(menuLabelImg.frame.origin.x+menuLabelImg.frame.size.width+20, 15, 40, 40);
        momentLabelImg.frame= CGRectMake(chatLabelImg.frame.origin.x+chatLabelImg.frame.size.width+20, 20, 30, 30);
    } completion:^(BOOL finished)
     {
         menuLabelImg.image=[UIImage imageNamed:@"search_icon.png"];
        /// chatLabelImg.image=[SingletonClass imageNamed:@"chat_icon_active.png" withColor:golden];;
         momentLabelImg.image=[UIImage imageNamed:@"heart_icon"];
         //         chatLabelImg.image = [UIImage imageNamed:@"chat_icon_active.png"];
     }];
    
    
}

-(void)parentselect
{
    
    [UIView animateWithDuration:.3 animations:^{
        
        menuLabelImg.frame= CGRectMake(self.menuButton.frame.origin.x+self.menuButton.frame.size.width+20, 20, 30, 30);
        chatLabelImg.frame= CGRectMake(menuLabelImg.frame.origin.x+menuLabelImg.frame.size.width+20, 20, 30, 30);
        momentLabelImg.frame= CGRectMake(chatLabelImg.frame.origin.x+chatLabelImg.frame.size.width+20, 15, 40, 40);
        
        
        
    } completion:^(BOOL finished)
     {
         menuLabelImg.image=[UIImage imageNamed:@"search_icon.png"];
         chatLabelImg.image=[UIImage imageNamed:@"chat_icon_default"];
         //         momentLabelImg.image=[UIImage imageNamed:@"file_folder_active"];
        // momentLabelImg.image = [SingletonClass imageNamed:@"heart_icon" withColor:golden];
     }];
    
}



#pragma mark -
#pragma mark -Create Table
//-(void)createAccountTable
//{
////    profileImageView.hidden=YES;
////    userProfile.hidden=YES;
//    
//    
//    if (!self.accountTableView)
//    {
//        self.selectedIndex = 0;
//        self.accountTableView = [[UITableView alloc] initWithFrame:CGRectMake(Screen_width-250, Screen_height/3,300, Screen_height-140) style:UITableViewStylePlain];
//        
//        self.accountTableView.backgroundColor =  [UIColor colorWithRed:(CGFloat)255/255 green:(CGFloat)255/255 blue:(CGFloat)255/255 alpha:1];
//        
//        self.accountTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.accountTableView.delegate = self;
//        self.accountTableView.dataSource = self;
////        self.accountTableView.backgroundColor=[UIColor clearColor];
//    }
//    else
//    {
//        [self.accountTableView reloadData];
//    }
//    
//    [self.view insertSubview:self.accountTableView belowSubview:self.mainsubView];
//    
//    
//    
//    
//}

-(void) createMenuTableView
{

    
    if (!self.menuTableView)
    {
        self.selectedIndex = 0;
        self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,Screen_width, 254) style:UITableViewStylePlain];
        //self.menuTableView.backgroundColor=[UIColor greenColor];
        //self.menuTableView.backgroundColor =  [UIColor colorWithRed:(CGFloat)255/255 green:(CGFloat)255/255 blue:(CGFloat)255/255 alpha:1];
        
        //self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.menuTableView.delegate = self;
        self.menuTableView.dataSource = self;
        self.menuTableView.scrollEnabled=NO;
        UIImageView *socioImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_width-100, 60)
                               ];
        socioImg.image=[UIImage imageNamed:@"pro_btn.png"];
        //[self.view addSubview:socioImg];
        self.menuTableView.backgroundColor=[UIColor clearColor];
    }
    else
    {
        
        [self.menuTableView reloadData];
    }
    
    [self.view insertSubview:self.menuTableView belowSubview:self.mainsubView];
    
    
//    self.menuTableView.tableHeaderView=[self tableHeader];
    
}

#pragma mark -


-(void)profile{
    
    
   // ProfileViewController *pro =[[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
   // pro.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    //[self presentViewController:pro animated:YES completion:nil];
}

-(void)handleSwipeGestureRight:(UISwipeGestureRecognizer *)swipeGesture
{
//    self.accountTableView.hidden=YES;
    self.menuTableView.hidden=NO;

    userProfile.hidden=NO;
    
    
    if (self.mainsubView.frame.origin.x==0) {
        
        [UIView animateWithDuration:.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
              self.mainsubView.frame = CGRectMake(Screen_width-100, 0,Screen_width, Screen_height);
            
//            self.mainsubView.frame = CGRectMake(Screen_width*3/4, Screen_height/3,Screen_width, Screen_height);
           // self.mainsubView.alpha=.5;
//            self.mainsubView.userInteractionEnabled=NO;
            
        }completion:nil];
        
    }
    else
    {
       
//        [UIView animateWithDuration:.5 animations:^{
//            self.mainsubView.frame = CGRectMake(0, 0,screenSize.size.width, screenSize.size.height);
//            
//        }completion:^(BOOL finish){
//            
//            self.swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
//        }];
//        self.accountTableView.hidden=NO;
//     self.menuTableView.hidden=YES;
//
//        userProfile.hidden=YES;
    }
}
-(void)handleSwipeGestureLeft:(UISwipeGestureRecognizer *)swipeGesture
{
    
    if (self.mainsubView.frame.origin.x==0)
    {

//        [UIView animateWithDuration:.5 animations:^{
//            self.mainsubView.frame = CGRectMake(-240, 0,Screen_width, Screen_height);
//        }completion:^(BOOL finish){
//        }];
//        self.accountTableView.hidden=NO;
//        profileImageView.hidden=YES;
//        userProfile.hidden=YES;
//
//        self.menuTableView.hidden=YES;
    }
    else
    {
    
        userProfile.hidden=NO;

//        self.accountTableView.hidden=YES;
        self.menuTableView.hidden=NO;
        [UIView animateWithDuration:.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.mainsubView.frame = CGRectMake(0, 0,Screen_width, Screen_height);
            self.mainsubView.alpha=1;
              self.mainsubView.userInteractionEnabled=YES;
            
        }completion:nil];
        //
    }
}
#pragma mark -
-(void) menuButtonClciked:(id)sender
{
//   self.accountTableView.hidden=YES;
    self.menuTableView.hidden=NO;
  
    userProfile.hidden=NO;
    //self.headerView.hidden=YES;
    //[self.headerView removeFromSuperview];
    
    //[self.contentContainerView removeFromSuperview];

    if (self.mainsubView.frame.origin.x==0) {
        
//        [UIView animateWithDuration:.5 animations:^{
//            self.mainsubView.frame = CGRectMake(Screen_width*3/4, Screen_height/3,Screen_width, Screen_height);
//        }completion:^(BOOL finish){
//        }];
        [UIView animateWithDuration:.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            //self.mainsubView.alpha=.5;
            //self.mainsubView.alpha=1;
//              self.mainsubView.userInteractionEnabled=NO;
             self.mainsubView.frame = CGRectMake(Screen_width-100, 0,Screen_width, Screen_height);
           
            UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.mainsubView.bounds];
            self.mainsubView.layer.masksToBounds = NO;
            self.mainsubView.layer.shadowColor = [UIColor blackColor].CGColor;
            self.mainsubView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
            self.mainsubView.layer.shadowOpacity = 1.0f;
            self.mainsubView.layer.shadowPath = shadowPath.CGPath;
           
        }completion:^(BOOL finished){
            

//
//            [UIView animateWithDuration:.5 animations:^{
//                profileImageView.frame=CGRectMake(5, 15, viewLogo.frame.size.height/3, viewLogo.frame.size.height/3);
//            } completion:^(BOOL finished) {
//                
//                CABasicAnimation *scale =[CABasicAnimation animationWithKeyPath:@"transform.scale"];
//                scale.duration=.5;
//                scale.repeatCount=HUGE_VAL;
//                scale.autoreverses=YES;
//                scale.fromValue=[NSNumber numberWithFloat:1];
//                scale.toValue=[NSNumber numberWithFloat:.8];
//                [profileImageView.layer addAnimation:scale forKey:@"scale"];
//            }];
            

            
        }];
    }
    else
    {
        [UIView animateWithDuration:.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.mainsubView.alpha=1;
              self.mainsubView.userInteractionEnabled=YES;
            self.mainsubView.frame = CGRectMake(0, 0,Screen_width, Screen_height);
            
        }completion:^(BOOL finished){
            
             self.swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
            
        }];
        
//        self.accountTableView.hidden=YES;
        self.menuTableView.hidden=NO;
       
        userProfile.hidden=NO;

    }

}




#pragma mark -
#pragma mark TableView Delegate and DataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 74;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
    viewLogo=[[UIView alloc]init];
    viewLogo.frame=CGRectMake(0, 0, Screen_width, Screen_height/3);
    viewLogo.backgroundColor=[UIColor whiteColor];
    [self.menuTableView.tableHeaderView addSubview:viewLogo];
    //----
    UIImageView * socioLogo=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 50, 52)];
    socioLogo.image=[UIImage imageNamed:@"socio_icon"];
    [viewLogo addSubview:socioLogo];
    
    //----
    UILabel * socioLbl=[[UILabel alloc]initWithFrame:CGRectMake(70, 30, Screen_width-60, 20)];
    socioLbl.text=@"SocioMeter";
    socioLbl.textColor=[UIColor colorWithRed:(CGFloat)41/255 green:(CGFloat)67/255 blue:(CGFloat)161/255 alpha:1];
    [socioLbl setFont:[UIFont boldSystemFontOfSize:20]];

    [viewLogo addSubview:socioLbl];
    
    
    
    
    //rounded profile image
    
//    profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, viewLogo.frame.size.height/2-50,100,100)];
//    //[profileImageView setImageWithURL:[SingletonClass sharedSingleton].pPic placeholderImage:[UIImage imageNamed:@"pfImage.png"]];
//    profileImageView.contentMode = UIViewContentModeScaleAspectFill;
//    profileImageView.clipsToBounds = YES;
//    profileImageView.userInteractionEnabled=YES;
////    profileImageView.layer.cornerRadius=profileImageView.frame.size.height/2;    //make image view round = height/2
//    [profileImageView addGestureRecognizer:tap];
//    
//    [viewLogo addSubview:profileImageView];
//    
//    
//    
//    
//    userProfile = [[UILabel alloc]initWithFrame:CGRectMake(profileImageView.frame.size.width+profileImageView.frame.origin.x+10, viewLogo.frame.size.height/2-20, 100, 20)];
//    userProfile.textColor=[UIColor whiteColor];
//    //userProfile.text=[NSString stringWithFormat:@"%@",[SingletonClass sharedSingleton].f_name];
//    userProfile.textAlignment=NSTextAlignmentCenter;
//    userProfile.adjustsFontSizeToFitWidth=YES;
//    [viewLogo addSubview:userProfile];
//    
//    UIButton*profileButton = [[UIButton alloc]initWithFrame:CGRectMake(profileImageView.frame.size.width+profileImageView.frame.origin.x+10, viewLogo.frame.size.height/2+20, 100, 20)];
//    [profileButton setTitle:@"View Profile" forState:UIControlStateNormal];
//    //[profileButton setTitleColor:white forState:UIControlStateNormal];
//    [profileButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
//    [viewLogo addSubview:profileButton];
//
//    
//    
//    UIButton*settingBtn = [[UIButton alloc]initWithFrame:CGRectMake(viewLogo.frame.size.width-40, viewLogo.frame.size.height-40, 25, 25)];
//    [settingBtn setBackgroundImage:[UIImage imageNamed:@"settings_menuicon.png"] forState:UIControlStateNormal];
//    [settingBtn addTarget:self action:@selector(profile) forControlEvents:UIControlEventTouchUpInside];
//    [viewLogo addSubview:settingBtn];
    
//    UILabel *lblEmail=[[UILabel alloc]initWithFrame:CGRectMake(10, profileImageView.frame.origin.y+profileImageView.frame.size.height+20, 200, 15)];
//    //    [lblEmail sizeToFit];
//    if ([SingletonClass sharedSingleton].emailID) {
//        
//        
//        lblEmail.text=[NSString stringWithFormat:@"%@",[SingletonClass sharedSingleton].emailID];
//        
//    }
//    lblEmail.font=[UIFont systemFontOfSize:13];
//    
//    [viewLogo addSubview:lblEmail];
    return viewLogo;

    
    
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.menuTableView)
    {
    if (section==0) {
        
        return self.viewControllers.count;
    }
    else if (section == 1){
//        return self.secondSectionViewControllers.count;
    }
    }
//    else if (tableView==self.accountTableView)
//    {
//        return self.secondSectionViewControllers.count;
//    }
    return 0;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;

    }
   
    
    UIImageView * proImage=[[UIImageView alloc]initWithFrame:CGRectMake(0,0 , 100, 74)];
    proImage.image=[UIImage imageNamed:@"go_pro.png"];
    ///////[self.view addSubview:proImage];
    
    if(tableView==self.menuTableView)
    {
    NSString * title=[NSString stringWithFormat:@"%@",[(UIViewController *)[_viewControllers objectAtIndex:indexPath.row] title]];
        self.arrayMenuImages=[[NSArray alloc]initWithObjects:@"dashboard.png",@"achivment.png",@"appusage.png",@"achivment.png",@"achivment.png", nil];
        UIImageView *menuImage=[[UIImageView alloc]initWithFrame:CGRectMake(10,10,30,30)];
        menuImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.arrayMenuImages objectAtIndex:indexPath.row]]];
        menuImage.contentMode=UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:menuImage];

        if (indexPath.row==0) {
            menuImage.image=[UIImage imageNamed:@"dashboard.png"];
        }
        else if (indexPath.row==1)
        {
            menuImage.image=[UIImage imageNamed:@"setting.png"];
            
        }
        else if (indexPath.row==2)
        {
            menuImage.image=[UIImage imageNamed:@"achivment.png"];
            
        }
        
        //---
        UILabel *menutextLbl=[[UILabel alloc]initWithFrame:CGRectMake(55, 12, 150, 25)];
        menutextLbl.textColor=[UIColor whiteColor];
        menutextLbl.text=title;
        [cell.contentView addSubview:menutextLbl];
        
    //cell.textLabel.text=title;
 
       
    
    }
//    else if(tableView==self.accountTableView)
//    {
//        NSString *title=[NSString stringWithFormat:@"%@",[(UIViewController *)[_secondSectionViewControllers objectAtIndex:indexPath.row]title]];
//        
//        cell.textLabel.text=title;
//    
//    }
    
    return cell;
    
    
    }


//- (UIView *)tableView : (UITableView *)tableView viewForHeaderInSection : (NSInteger) section {
//    
//
//    //UIImageView *imgVew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"go_pro"]];
//    return proImage;
//}
 -(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *firstColor = [UIColor blackColor];
    UIColor *secColor =  [UIColor blackColor];

    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = cell.contentView.frame;
    layer.colors = [NSArray arrayWithObjects:(id)firstColor.CGColor,(id)secColor.CGColor, nil];
    
    [cell.contentView.layer insertSublayer:layer atIndex:0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Dismiss Menu TableView with Animation
    if(tableView==self.menuTableView)
    {
        SettingsViewController *settingVc=[[SettingsViewController alloc]init];
        
    [UIView animateWithDuration:.5 animations:^{
        
        self.mainsubView.alpha=1;
          self.mainsubView.userInteractionEnabled=YES;
        self.mainsubView.frame = CGRectMake(0, 0, screenSize.size.width, screenSize.size.height);
        
    }completion:^(BOOL finished){
        //After completion
        //first check if new selected view controller is equals to previously selected view controller
        
        UIViewController *newViewController =[_viewControllers objectAtIndex:indexPath.row];
        if ([newViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)newViewController popToRootViewControllerAnimated:YES];
        }
        if (self.selectedIndex==indexPath.row  && self.selectedSection == indexPath.section) {
          //  return;
        }
        if (indexPath.row==0) {
            self.customTabBar.selectedItem = [self.customTabBar.items objectAtIndex:0];
        }
        else{
            self.customTabBar.selectedItem = nil;
        }
        
        switch (indexPath.row) {
            case 1:
               // XPostN(@"loadEnter");
                //XRmN(@"loadEnter");
                               break;
                
                case 2:
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"loadVideo" object:nil];
//                 [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loadVideo" object:nil];
                //XPostN(@"loadVideo");
               // XRmN(@"loadVideo");

                 break;
            case 3:
              
//                 [[NSNotificationCenter defaultCenter]postNotificationName:@"loadTravel" object:nil];
//                 [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loadTravel" object:nil];
               //XPostN(@"loadTravel");
                //XRmN(@"loadTravel");


                 break;
            case 4:
//                  [[NSNotificationCenter defaultCenter]postNotificationName:@"loadViral" object:nil];
//                  [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loadViral" object:nil];
                
                //XPostN(@"loadViral");
                //XRmN(@"loadViral");

                break;
            case 5:
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"loadAudition" object:nil];
//                [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loadAudition" object:nil];
//                
               // XPostN(@"loadAudition");
               // XRmN(@"loadAudition");

                
                break;

            case 6:
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"loadContest" object:nil];
//                 [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loadContest" object:nil];
                
               // XPostN(@"loadContest");
               // XRmN(@"loadContest");

               

                 break;
            case 7:
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"loadNoti" object:nil];
//                 [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loadNoti" object:nil];
               // XPostN(@"loadNoti");
               // XRmN(@"loadNoti");


                 break;
                
            default:
                break;
        }
        
        _selectedSection = indexPath.section;
        _selectedIndex = indexPath.row;
        
        [self getSelectedViewControllers:newViewController];
        updateValue = 0;
    }];

    }
    else
    {
//        [UIView animateWithDuration:.5 animations:^{
//            
//            self.mainsubView.frame = CGRectMake(0, 0, screenSize.size.width, screenSize.size.height);
//            
//        }completion:^(BOOL finished){
//            
////            UIViewController *newViewController =[_secondSectionViewControllers objectAtIndex:indexPath.row];
////            if ([newViewController isKindOfClass:[UINavigationController class]]) {
////                [(UINavigationController *)newViewController popToRootViewControllerAnimated:YES];
////            }
//            if (self.selectedIndex==indexPath.row  && self.selectedSection == indexPath.section) {
//                //  return;
//            }
//            if (indexPath.row==0) {
//                self.customTabBar.selectedItem = [self.customTabBar.items objectAtIndex:0];
//            }
//            else{
//                self.customTabBar.selectedItem = nil;
//            }
//            
//            _selectedSection = indexPath.section;
//            _selectedIndex = indexPath.row;
//            
////            [self getSelectedViewControllers:newViewController];
//            updateValue = 0;
//
//        }];
    }
}


#pragma mark -
-(void) getSelectedViewControllers:(UIViewController *)newViewController{
    // selected new view controller
    UIViewController *oldViewController = _selectedViewController;
    
    if (newViewController != nil) {
        [oldViewController.view removeFromSuperview];
        _selectedViewController = newViewController;
        
        [self updateViewContainer];
    }
}
-(void) updateViewContainer
{
    self.selectedViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    self.selectedViewController.view.frame = self.contentContainerView.bounds;
//    self.menuLabel.text=self.selectedViewController.title;
//    NSLog(@"menu label -=- %@",self.menuLabel.text);
    
//    self.menuLabel.frame=CGRectMake(80, 10, 100, 30);
    
    [self.contentContainerView addSubview:self.selectedViewController.view];
    
}
#pragma mark Tap Action


//-(void)tapAction:(UITapGestureRecognizer*)gesture{
//    
//    
//   // HomeViewController *home =[[HomeViewController alloc]init];
//    //[self presentViewController:home animated:YES completion:nil];
//    
//    
//    
//}





@end
