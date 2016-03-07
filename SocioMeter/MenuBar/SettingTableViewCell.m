//
//  SettingTableViewCell.m
//  SocioMeter
//
//  Created by Sumit Ghosh on 28/12/15.
//  Copyright © 2015 Sumit Ghosh. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

@synthesize primaryLabel,secondaryLabel,imageLabel,distanceLabel,switchBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        primaryLabel = [[UILabel alloc]init];
        primaryLabel.textColor = [UIColor colorWithRed:(CGFloat)38/255 green:(CGFloat)81/255 blue:(CGFloat)166/255 alpha:(CGFloat)1];
        primaryLabel.font = [UIFont systemFontOfSize:17];
        
        secondaryLabel = [[UILabel alloc]init];
        secondaryLabel.font =  [UIFont systemFontOfSize:12];
        secondaryLabel.textColor = [UIColor colorWithRed:(CGFloat)38/255 green:(CGFloat)81/255 blue:(CGFloat)166/255 alpha:(CGFloat)1];
        secondaryLabel.lineBreakMode=YES;
        
        
        distanceLabel=[[UILabel alloc]init];
        distanceLabel.font=[UIFont systemFontOfSize:10];
        
        [self.contentView addSubview:self.primaryLabel];
        [self.contentView addSubview:self.secondaryLabel];
        [self.contentView addSubview:self.distanceLabel];
        
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    
    frame= CGRectMake(boundsX+10 ,5, 320, 27);
    primaryLabel.frame = frame;
    primaryLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    frame= CGRectMake(boundsX+10 ,25, 230, 30);
    secondaryLabel.frame = frame;
    secondaryLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    secondaryLabel.numberOfLines=0;
    frame= CGRectMake(boundsX+280 ,2, 18, 18);
    imageLabel.frame=frame;
    
    frame=CGRectMake(boundsX+260, 25, 250, 50);
    distanceLabel.frame=frame;
    
    frame=CGRectMake(boundsX+260, 25, 250, 50);
    switchBtn.frame=frame;
    
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
