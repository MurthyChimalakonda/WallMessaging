//
//  DashboardViewController.m
//  WallMessaging
//
//  Created by AxSys on 7/7/16.
//  Copyright © 2016 AxSys. All rights reserved.
//

#import "DashboardViewController.h"

#import "DAKeyboardControl.h"

#import "NSData+Base64.h"

@interface DashboardViewController ()

{
    SRHubConnection *hubConnection;
    SRHubProxy *chatHub;
    connectionState thConnectionState;
    
}

@end

@implementation DashboardViewController

@synthesize ascrollView,aview,moodTxtView,commentsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //  [self.navigationController setNavigationBarHidden:YES];;
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    commentsArray=[NSMutableArray array];
    
    
    ascrollView=[[UIScrollView alloc]init];
    
    ascrollView.frame=self.view.bounds;
    
    ascrollView.contentSize = CGSizeMake(320, 800);
    
    ascrollView.delegate=self;
    
    ascrollView.showsVerticalScrollIndicator=YES;
    
    ascrollView.showsHorizontalScrollIndicator=NO;
    
    ascrollView.userInteractionEnabled=YES;
    
    ascrollView.scrollEnabled=YES;
    
    [self.view addSubview:ascrollView];
    
    
    // Creating A UIView
    
    aview=[[UIView alloc]initWithFrame:CGRectMake(3, 20, 310, 130)];
    
    aview.backgroundColor=[UIColor colorWithRed:242/255.f green:242/255.f blue:242/255.f alpha:1.0f];
    
    aview.layer.borderWidth=1;
    
    aview.layer.borderColor = [[UIColor colorWithRed:180/255.f green:187/255.f blue:205/255.f alpha:1.0f]CGColor];
    
    [self.ascrollView addSubview:aview];
    
    [[UITableView appearance] setSeparatorColor:[UIColor whiteColor]];
    
    
//    profilePicImg=[[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 40, 40)];
//    
//    profilePicImg.image=[UIImage imageNamed:@"stevejobs.jpg"];
//    
//    profilePicImg.backgroundColor=[UIColor clearColor];
//    
//    [aview addSubview:profilePicImg];
    
    
    // mood Text view
    
    moodTxtView=[[UITextView alloc]initWithFrame:CGRectMake(6, 5, 300, 50)];
    
    moodTxtView.delegate=self;
    
    moodTxtView.scrollEnabled=YES;
    
    moodTxtView.userInteractionEnabled=YES;
    
    moodTxtView.text=@"What's on your mind?";
    
    [aview addSubview:moodTxtView];
    
    
    // upload camera button action
    
//    uploadCamerabutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [uploadCamerabutton addTarget:self
//                           action:@selector(uploadCameraMethod)
//                 forControlEvents:UIControlEventTouchUpInside];
//    
//    [uploadCamerabutton setImage:[UIImage imageNamed:@"ipic_camera.png"] forState:UIControlStateNormal];
//    
//    uploadCamerabutton.frame = CGRectMake(80, 105, 23, 23);
//    
//    [aview addSubview:uploadCamerabutton];
//    
//    
//    cameraName=[[UILabel alloc]initWithFrame:CGRectMake(106, 105, 60, 20)];
//    
//    cameraName.text=@"Photo";
//    
//    [cameraName setFont:[UIFont boldSystemFontOfSize:12]];
//    
//    cameraName.userInteractionEnabled=NO;
//    
//    cameraName.textColor=[UIColor blackColor];
//    
//    cameraName.backgroundColor=[UIColor grayColor];
//    
//    [aview addSubview:cameraName];
    
    
    postButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [postButton addTarget:self
                   action:@selector(postMethod)
         forControlEvents:UIControlEventTouchUpInside];
    
    [postButton setTitle:@"Post" forState:UIControlStateNormal];
    
//    [postButton setTitle:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    postButton.frame = CGRectMake(230,80, 60, 20);
    
    
    
    postButton.backgroundColor=[UIColor colorWithRed:91/255.f green:116/255.f blue:168/255.f alpha:1.0f];
    
    [aview addSubview:postButton];
    
    
      [self createConnection];
    
}


-(void)createConnection

{
    
    NSURL *url=[NSURL URLWithString:@"http://192.168.100.157/chatwall"];
    
    NSString *str1=[url absoluteString];
    
    hubConnection = [SRHubConnection connectionWithURLString:str1 queryString:nil];
    
    
    
    // Create a proxy to the chat service
    
    chatHub = [hubConnection  createHubProxy:@"Chat"];
    [chatHub on:@"onHubConnected" perform:self selector:@selector(onHubConnected)];
    
    [chatHub on:@"messageReceived" perform:self selector:@selector(messagesReceived:)];
    
    [chatHub on:@"OnHubDisconnected" perform:self selector:@selector(onHubDisconnected)];
    [chatHub on:@"onGroupJoined" perform:self selector:@selector(onGroupJoined:)];
    [chatHub on:@"onGroupJoinFailed" perform:self selector:@selector(onGroupJoinFailed:)];
    [chatHub on:@"onChatHistoryObtained" perform:self selector:@selector(onChatHistoryObtained:)];
    [chatHub on:@"onChatHistoryObtainFailed" perform:self selector:@selector(onChatHistoryObtainFailed:)];
    [chatHub on:@"onMessageSent" perform:self selector:@selector(onMessageSent:)];
    [chatHub on:@"onMessageSendingFailed" perform:self selector:@selector(onMessageSendingFailed:)];
    [chatHub on:@"onNewMessage" perform:self selector:@selector(onNewMessage:)];
    [chatHub on:@"onNewNotification" perform:self selector:@selector(onNewNotification:)];
    
    // Start the connection
    [hubConnection setDelegate:self];
    [hubConnection start];
}


//Closing hub connection
-(void)closeHubConnection{
    [hubConnection stop];
    chatHub = nil;
    hubConnection.delegate = nil;
    hubConnection = nil;
}


//On hub connected
-(void)onHubConnected{
    NSLog(@"onHubConnected");
}
//On Hub dis connected
-(void)onHubDisconnected{
    NSLog(@"onHubDisConnected");
}
//On group joined ,connection open start chat
-(void)onGroupJoined:(NSString *)tgroupId{
    NSLog(@"onGroupJoined:%@",tgroupId);
}
//On group joined ,connection open start chat
-(void)onGroupJoinFailed:(NSString *)tgroupId{
    NSLog(@"onGroupJoinFailed:%@",tgroupId);
}
//onChatHistoryObtained refersh tableview
-(void)onChatHistoryObtained:(NSString *)tgroupId{
    NSLog(@"onChatHistoryObtained:%@",tgroupId);
}
//onChatHistoryObtainFailed obtaining still
-(void)onChatHistoryObtainFailed:(NSString *)tgroupId{
    NSLog(@"onChatHistoryObtainFailed:%@",tgroupId);
}

//onMessageSent
-(void)onMessageSent:(NSString *)tgroupId{
    NSLog(@"onMessageSent:%@",tgroupId);
}
//onMessageSendingFailed
-(void)onMessageSendingFailed:(NSString *)tgroupId{
    NSLog(@"onMessageSendingFailed:%@",tgroupId);
}
//NewMessage refresh tableview by appending it to tableview
-(void)onNewMessage:(NSString *)tgroupId{
    NSLog(@"onNewMessage:%@",tgroupId);
}
//new notification
-(void)onNewNotification:(id)message{
    NSLog(@"onNewNotification:%@",message);
}


-(void)messagesReceived:(id)data

{
    
}


//-(void)uploadCameraMethod
//
//{
//    if ([UIImagePickerController isSourceTypeAvailable:
//         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
//    {
//        UIImagePickerController *imagePicker =
//        [[UIImagePickerController alloc] init];
//        imagePicker.delegate = self;
//        imagePicker.sourceType =
//        UIImagePickerControllerSourceTypePhotoLibrary;
//        imagePicker.mediaTypes = [NSArray arrayWithObjects:
//                                  (NSString *) kUTTypeImage,
//                                  nil];
//        imagePicker.allowsEditing = NO;
//        [self presentViewController:imagePicker animated:YES completion:nil];
//        newMedia = NO;
//    }
//    
//    
//}
//
//-(void)choosePhotoFromExistingImages
//
//{
//    {
//        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
//        {
//            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
//            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            controller.allowsEditing = NO;
//            controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
//            controller.delegate = self;
//            [self.navigationController presentViewController: controller animated: YES completion: nil];
//        }
//        
//    }
//    
//}
//
//
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    
//    image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    NSData *data = UIImageJPEGRepresentation(image, 0);
//    encodedData =[data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//    
//    NSURL *resourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
//    
//    resourceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
//    
//    ALAssetsLibrary *assetLibrary = [ALAssetsLibrary new];
//    [assetLibrary assetForURL:resourceURL
//                  resultBlock:^(ALAsset *asset) {
//                      
//                      ALAssetRepresentation *assetRep = [asset defaultRepresentation];
//                      cgImg = [assetRep fullResolutionImage];
//                      filename = [assetRep filename];
//                      
//                      NSLog(@"file name is:%@", filename);
//                      
//                      [self performSelector:@selector(postMethod) withObject:nil afterDelay:0.0];
//                      
//                  }
//                 failureBlock:^(NSError *error) {
//                     NSLog(@"%@", error);
//                 }];
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
//{
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}

-(void)uploadToServer

{
    
    
}


-(void)postMethod

{
    
    
    
    
    
    int popUpCount=0;
    
    popUpCount=popUpCount+1;
    
    int yPosition=0;
    
    
    
    if (popUpCount<=3) {
        
        yPosition = yPosition+160;
        
        popView=[[UIView alloc]initWithFrame:CGRectMake(3, yPosition, self.view.frame.size.width-20, 140)];
        popView.backgroundColor=[UIColor colorWithRed:242/255.f green:242/255.f blue:242/255.f alpha:1.0f];
        
       
        [ascrollView addSubview: popView];
        popView.tag=popUpCount;
        
        
        commenterName=[[UILabel alloc]initWithFrame:CGRectMake(40, 5, 60, 20)];
        
        commenterName.userInteractionEnabled=NO;
        
        commenterName.text=@"Ryan:";
        
        commenterName.textColor=[UIColor blackColor];
        
        [popView addSubview:commenterName];
        
        NSData *data = [[NSData alloc] initWithData:[NSData
                                                     dataFromBase64String:encodedData]];
        
        shareImg=[[UIImageView alloc]initWithFrame:CGRectMake(63, 35, 60, 60)];
        
        shareImg.image=[UIImage imageWithData:data];
        
        shareImg.backgroundColor=[UIColor clearColor];
        
        [popView addSubview:shareImg];
        
        
        commentImg=[[UIImageView alloc]initWithFrame:CGRectMake(3, 5, 20, 20)];
        
        commentImg.image=[UIImage imageNamed:@"stevejobs.jpg"];
        
        commentImg.backgroundColor=[UIColor clearColor];
        
        [popView addSubview:commentImg];
        
        
        
        NSString *str=moodTxtView.text;
        
        NSLog(@"The string value is:%@",str);
        
        
        UITextView *textMsg=[[UITextView alloc]initWithFrame:CGRectMake(105, 3, 100, 40)];
        
        
        textMsg.delegate=self;
        
        textMsg.backgroundColor=[UIColor clearColor];
        
        textMsg.scrollEnabled=YES;
        
        textMsg.userInteractionEnabled=YES;
        
        textMsg.text=str;
        
        [popView addSubview:textMsg];
        
        [self relativeDateStringForDate];
        
        timeStampLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 35, 60, 20)];
        
        
        timeStampLabel.text=dateComponent;
        
        timeStampLabel.textColor=[UIColor blackColor];
        
        [popView addSubview:timeStampLabel];
        
        
        // comment Button Action
        
        commentButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [commentButton addTarget:self
                          action:@selector(commentViewAppear)
                forControlEvents:UIControlEventTouchUpInside];
        
        [commentButton setTitle:@"comment" forState:UIControlStateNormal];
        
        commentButton.frame = CGRectMake(190,90, 100, 20);
        
        commentButton.backgroundColor=[UIColor colorWithRed:91/255.f green:116/255.f blue:168/255.f alpha:1.0f];
        
        [commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
       // commentButton.backgroundColor=[UIColor grayColor];
        
        [popView addSubview:commentButton];
        
        
       // [self sendMessages:moodTxtView.text];
        
        
      //  [self resetTextView];
        
        
        
        
    }
    
}


- (NSString *)relativeDateStringForDate
{
    
    NSDate *date;
    
    NSCalendarUnit units = NSDayCalendarUnit | NSWeekOfYearCalendarUnit |
    NSMonthCalendarUnit | NSYearCalendarUnit ;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate: date];
    NSDate *today = [cal dateFromComponents:components1];
    
    components1 = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    NSDate *thatdate = [cal dateFromComponents:components1];
    
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:thatdate
                                                                     toDate:today
                                                                    options:0];
    
    
    
    if (components.year > 0) {
        dateComponent= [NSString stringWithFormat:@"%ld years ago", (long)components.year];
        
        NSLog(@"Time stamp is:%@",dateComponent);
        
    } else if (components.month > 0) {
        dateComponent= [NSString stringWithFormat:@"%ld months ago", (long)components.month];
        NSLog(@"Time stamp is:%@",dateComponent);
        
    } else if (components.weekOfYear > 0) {
        dateComponent= [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
        NSLog(@"Time stamp is:%@",dateComponent);
        
    } else if (components.day > 0) {
        if (components.day > 1) {
            dateComponent= [NSString stringWithFormat:@"%ld days ago", (long)components.day];
            
            NSLog(@"Time stamp is:%@",dateComponent);
        }
    }
    
    return dateComponent;
}


//-(void)sendMessages:(NSString *)messageTxt1
//
//{
//    
//}


//-(void)resetTextView
//
//{
//    moodTxtView.text=@"";
//    
//    [postButton setTitle:@"Post" forState:UIControlStateNormal];
//    
//    postButton.userInteractionEnabled=YES;
//}

-(void)commentViewAppear

{
    
    NSLog(@"Comment View Appears");
    
       atableView = [[UITableView alloc] initWithFrame:CGRectMake(0,280,self.view.bounds.size.width,40)];
    
    atableView.delegate=self;
    
    atableView.dataSource=self;
    
   [ascrollView addSubview:atableView];
    
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
    self.view.bounds.size.height - 40.0f,self.view.bounds.size.width,
    40.0f)];
    
   
    
    msgTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f,420.0f,260,40)];
    
    msgTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    msgTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [ascrollView addSubview:msgTextField];
    
    sendButton1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    sendButton1.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    [sendButton1 setTitle:@"Send" forState:UIControlStateNormal];
    
    sendButton1.frame = CGRectMake(280,430,40,20);
    
    [sendButton1 addTarget:self action:@selector(sendData) forControlEvents:UIControlEventTouchUpInside];
    
    [ascrollView addSubview:sendButton1];
    
    
    self.view.keyboardTriggerOffset = toolBar.bounds.size.height;
    
    [self.view addKeyboardPanningWithFrameBasedActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
       
        
        CGRect toolBarFrame = toolBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        toolBar.frame = toolBarFrame;
        
        CGRect tableViewFrame = atableView.frame;
        
        tableViewFrame.size.height = toolBarFrame.origin.y;
        
        atableView.frame = tableViewFrame;
        
    } constraintBasedActionHandler:nil];
    
}

-(void)sendData

{
    [self sendMessage:msgTextField.text];
    
    //    cellData=msgTextField.text;
    //
    //    [commentsArray addObject:cellData];
    
    [atableView reloadData];
    
}

-(void)sendMessage:(NSString *)messageTxt

{
    commentsArray=[NSMutableArray arrayWithObjects:messageTxt, nil];
    
    NSLog(@"Comments Array is:%@",commentsArray);
    
    // [tableView reloadData];
    
    [self resetTextField];
    
}

-(void)resetTextField

{
    
    msgTextField.text=@"";
    
    [sendButton1 setTitle:@"Send" forState:UIControlStateNormal];
    
    sendButton1.userInteractionEnabled=YES;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor whiteColor];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [commentsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *identifier=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identifier"];
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 48, 48)]; // your cell's height
        imgView.tag = 1;
        [cell.contentView addSubview:imgView];
        imgView = nil;
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    //  cell.textLabel.text=[commentsArray objectAtIndex:indexPath.row];
    
    
    if(commentsArray.count>0)
        
    {
    
    imgView = (UIImageView *)[cell.contentView viewWithTag:1];
    
    imgView.image = [UIImage imageNamed:@"stevejobs.jpg"];
    
    
    
    lbl=[[UILabel alloc]initWithFrame:CGRectMake(80, 10, 300, 22)];
    
    lbl.font=[UIFont systemFontOfSize:20.0];
    
    lbl.textColor=[UIColor blackColor];
    
    lbl.text=[commentsArray objectAtIndex:indexPath.row];
    
    [cell.contentView addSubview:lbl];
        
    }
    
    
    return cell;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [atableView reloadData];
}

-(void)closeView

{
    [commentView setHidden:YES];
    
}


//receiving message from server
- (void)addMessage:(NSString *)message {
    // Print the message when it comes in
    NSLog(@"throttle received message::%@",message);
}
//receiving message from server
- (void)broadcast:(NSString *)message {
    // Print the message when it comes in
    NSLog(@"throttle broadCast message::%@",message);
}


//Connection established
-(void)connectionEstablished{
    
    atableView.tableFooterView=nil;
    
  //  self.msgTxtView.editable = YES;
    
  //  [self registerForNotifications];
    
}


#pragma mark - SR Connection delegate methods
- (void)SRConnectionDidOpen:(SRConnection *)connection
{
    
    NSLog(@"connection did open ::%@",connection);
    
    thConnectionState = connected;
    
    [self connectionEstablished];
    
    
}
- (void)SRConnection:(SRConnection *)connection didReceiveData:(id)data
{
    NSLog(@"connection receive data::%@..data::%@",connection,data);
    if (data) {
        NSArray *msgdata = [data objectForKey:@"A"];
        if (msgdata) {
            if ([msgdata count]==1) {//We are receiving notifcations two times we need to modify this
                NSDictionary *notificationData = [[msgdata objectAtIndex:0] valueForKey:@"notification"];
                if (notificationData) {
                    
                    //                    [self messagesReceived:[notificationData valueForKey:@"Chat"]];//update tableview with messages
                    
                    //   [self messagesReceived:[notificationData valueForKey:@"Chat"] strName:(NSString *)str  messageText:(NSString *)mesText];
                    
                }
            }
        }
    }
}
- (void)SRConnection:(SRConnection*)connection didChangeState:(connectionState)oldState newState:(connectionState)newState{
    
    NSLog(@"connection didChangeState ::%@...%d..%d",connection,oldState,newState);
    if (newState==connected) {
        thConnectionState = connected;
        atableView.tableHeaderView=nil;
      //  self.msgTxtView.editable = YES;
        [atableView reloadData];
        NSLog(@"tableview refresh");
        
        //  [self connectionEstablished];
    }
}
- (void)SRConnectionDidClose:(SRConnection *)connection
{
    NSLog(@"connection close ::%@",connection);
    thConnectionState = disconnected;
    if (self) {
        [self createConnection];
    }
}

- (void)SRConnection:(SRConnection *)connection didReceiveError:(NSError *)error
{
    thConnectionState = disconnected;
    NSLog(@"connection error::%@..error::%@",connection,error);
}
-(void)SRConnectionDidSlow:(id<SRConnectionInterface>)connection{
    NSLog(@"SRConnectionDidSlow ::%@",connection);
}
-(void)SRConnectionDidReconnect:(id<SRConnectionInterface>)connection{
    thConnectionState = connecting;
    NSLog(@"SRConnectionDidReconnect ::%@",connection);
}
-(void)SRConnectionWillReconnect:(id<SRConnectionInterface>)connection{
    NSLog(@"SRConnectionWillReconnect ::%@",connection);
    thConnectionState = connecting;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
