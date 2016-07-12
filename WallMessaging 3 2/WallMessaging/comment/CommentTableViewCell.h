//
//  CommentTableViewCell.h
//  WallMessaging
//
//  Created by AxSys on 6/7/16
//  Copyright © 2016 AxSys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgmain;
@property (strong, nonatomic) IBOutlet UILabel *lblmain;
@property (strong, nonatomic) IBOutlet UITextField *txtComment;
@property (strong, nonatomic) IBOutlet UIButton *btnComment;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *txtCommentHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnCommentHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *txtCommentTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnCommentTop;
@end
