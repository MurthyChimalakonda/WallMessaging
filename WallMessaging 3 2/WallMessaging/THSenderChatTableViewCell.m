//
//  THSenderChatTableViewCell.m
//  WallMessaging
//
//  Created by AxSys on 6/7/16.
//  Copyright © 2016 AxSys. All rights reserved.
//

#import "THSenderChatTableViewCell.h"

@implementation THSenderChatTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _userImgView=[[UIImageView alloc]init];
        
        _userImgView.image=[UIImage imageNamed:@""];
        
        _userImgView.layer.cornerRadius=_userImgView.frame.size.width / 2;
        _userImgView.layer.borderWidth=2.0;
        _userImgView.clipsToBounds=YES;
        _userImgView.layer.borderColor=[UIColor clearColor].CGColor;
        
        _msgTextView=[[UITextView alloc]init];
        
    }
    
    return self;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
