//
//  DemoViewController.h
//  WallMessaging
//
//  Created by AxSys on 6/7/16
//  Copyright © 2016 AxSys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCellTableViewCell.h"
#import "CommentTableViewCell.h"
#import "TextTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface DemoViewController : UIViewController<UITextFieldDelegate>
{
    NSInteger intSectionClicked;
    
    NSInteger textsection;
    NSString *commonstring;
}
@property (strong, nonatomic) IBOutlet UITextView *txtCommentview;

@property (strong, nonatomic) IBOutlet UITableView *tblFB;

- (IBAction)postMethod:(UIButton *)sender;
- (IBAction)cellcomment:(UIButton *)sender;



@end
