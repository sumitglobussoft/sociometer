//
//  SettingTableViewCell.h
//  SocioMeter
//
//  Created by Sumit Ghosh on 28/12/15.
//  Copyright © 2015 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell
{
    UILabel *primaryLabel;
    UILabel *secondaryLabel;
    UIImageView *thirdLabel;
    UILabel *distanceLabel;
}
@property(nonatomic,retain)UILabel *primaryLabel;
@property(nonatomic,retain)UILabel *secondaryLabel;
@property(nonatomic,strong)UIImageView *imageLabel;
@property(nonatomic,strong)UILabel *distanceLabel;
@property(nonatomic,strong)UILabel *switchBtn;
@end
