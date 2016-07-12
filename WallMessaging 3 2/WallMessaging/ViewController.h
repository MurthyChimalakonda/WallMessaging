//
//  ViewController.h
//  WallMessaging
//
//  Created by AxSys on 6/7/16.
//  Copyright © 2016 AxSys. All rights reserved.
//


#import <UIKit/UIKit.h>

#import <SRHubConnectionInterface.h>

#import <SRConnectionDelegate.h>

#import <SRHubProxyInterface.h>

#import <SRHubConnection.h>

#import <SRHubProxy.h>

#import <AFNetworking.h>

#import "NSData+Base64.h"

#import <AssetsLibrary/AssetsLibrary.h>




int returnPressed = 0;
int newLine;

@interface ViewController : UIViewController<SRHubConnectionInterface,SRConnectionDelegate,SRHubProxyInterface,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>



@property (strong, nonatomic) IBOutlet UITableView *ChattblView;

@property (strong, nonatomic) IBOutlet UITextView *msgTxtView;


@property (strong, nonatomic) IBOutlet UIButton *sendBtn;

- (IBAction)sendButtonClicked:(id)sender;

@property(nonatomic,readwrite)NSInteger chatId;


@property(nonatomic,strong)  NSString *str1;

@property (strong, nonatomic) IBOutlet UIView *dock;

@property (strong, nonatomic) IBOutlet UIButton *attachButton;




- (IBAction)attach:(id)sender;



@end

