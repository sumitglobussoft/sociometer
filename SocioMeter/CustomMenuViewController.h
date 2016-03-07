//
//  CustomMenuViewController.h
//  MOVYT
//
//  Created by Sumit Ghosh on 27/05/14.
//  Copyright (c) 2014 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>


#define _offsetValue 62
#define _animated  YES



@interface CustomMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITabBarDelegate,UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer *tap;
    UIImageView *imageVUser;
    UILabel *lblUserName;
    UIImageView *profileImageView;
    UILabel *lblLifeTime;
    UILabel *userProfile;
    //----------
    
    CGRect screenSize;
}

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, copy) NSArray *viewControllers,*arrayMenuImages;
@property (nonatomic, assign) NSInteger numberOfSections;
@property (nonatomic, copy) UIViewController *selectedViewController;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger selectedSection;
@property (nonatomic, strong) UIView *mainsubView;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureLeft,*swipeGestureRight;


-(NSArray *) getAllViewControllers;
@end

@interface UIViewController (CustomMenuViewControllerItem)

@property (nonatomic, strong) CustomMenuViewController *customMenuViewController;
@end
