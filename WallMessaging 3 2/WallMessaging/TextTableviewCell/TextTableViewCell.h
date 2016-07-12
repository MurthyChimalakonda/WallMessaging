//
//  TextTableViewCell.h
//  WallMessaging
//
//  Created by AxSys on 6/7/16
//  Copyright © 2016 AxSys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField *txtComment;
@property (strong, nonatomic) IBOutlet UIButton *btnComment;

@end
