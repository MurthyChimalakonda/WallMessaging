//
//  THReceiverChatTableViewCell.h
//  WallMessaging
//
//  Created by AxSys on 6/7/16.
//  Copyright © 2016 AxSys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THReceiverChatTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *userImgView;

@property (strong, nonatomic) IBOutlet UIView *chatBgView;

@property (strong, nonatomic) IBOutlet UILabel *msgDateLbl;

@property (strong, nonatomic) IBOutlet UITextView *msgTextView;



@end

