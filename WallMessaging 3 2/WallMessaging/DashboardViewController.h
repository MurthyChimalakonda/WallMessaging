//
//  DashboardViewController.h
//  WallMessaging
//
//  Created by AxSys on 7/7/16.
//  Copyright © 2016 AxSys. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MobileCoreServices/MobileCoreServices.h>

#import <AssetsLibrary/AssetsLibrary.h>

#import "NSData+Base64.h"

#import <SRHubConnectionInterface.h>

#import <SRConnectionDelegate.h>

#import <SRHubProxyInterface.h>

#import <SRHubConnection.h>

#import <SRHubProxy.h>

#import <AFNetworking.h>



@interface DashboardViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,SRHubConnectionInterface,SRConnectionDelegate,SRHubProxyInterface>

{
    
    UIScrollView *ascrollView;
    
    UIView *aview,*commentView;
    
    UIImageView *profilePicImg,*shareImg,*commentImg,*imgView;
    
    UITextView *moodTxtView,*commentTxtView;
    
    UIButton *uploadCamerabutton,*postButton,*sendButton,*commentButton,*closeButton,*sendButton1;
    
    BOOL newMedia;
    
    UILabel *cameraName,*commenterName,*lbl,*timeStampLabel;
    
    NSString *encodedData,*filename;;
    
    UIImage *image;;
    
    CGImageRef cgImg;
    
    NSMutableArray *commentsArray;
    
    UITextField *msgTextField;
    
    UITableView *atableView;
    
    NSString *cellData;
    
    NSString *dateComponent;;
    
    UIView *popView;;
}

@property(nonatomic,strong) UIScrollView *ascrollView;

@property(nonatomic,strong) UIView *aview;

@property(nonatomic,strong) UITextView *moodTxtView;

@property(nonatomic,strong) NSMutableArray *commentsArray;

-(void)sendMessage:(NSString *)messageTxt;

-(void)sendMessages:(NSString *)messageTxt1;


@end
