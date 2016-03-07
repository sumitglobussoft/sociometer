//
//  UpdateDetailsView.h
//  SocioMeter
//
//  Created by Sumit Ghosh on 29/01/16.
//  Copyright © 2016 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>





@protocol UpdateViewDelegate <NSObject>

@required

@end

@interface UpdateDetailsView : UIView

@property (nonatomic, weak) id<UpdateViewDelegate> delegate;
-(void)updateDetailsAction;

@property(nonatomic,strong)UIView *updateView,*dateView;
@property(nonatomic,strong)UILabel *dateOfBirthLbl;
@property(nonatomic,strong)UIButton *firstUnselectRadioBtn,*secondUnselectRadioBtn, *saveBtn;
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,strong)NSString *title,*stringFrmtForgender;
@end
