//
//  ViewController.m
//  WallMessaging
//
//  Created by AxSys on 6/7/16.
//  Copyright © 2016 AxSys. All rights reserved.
//

#import "ViewController.h"

#import "THSenderChatTableViewCell.h"

#import "THReceiverChatTableViewCell.h"

#import "NSData+Base64.h"



@interface ViewController (){
    
    NSInteger pageIndex;
    BOOL isloadMore;
    NSMutableArray *itemsDataArr,*itemsUserNameArr,*itemImgArray;
    SRHubConnection *hubConnection;
    SRHubProxy *chatHub;
    connectionState thConnectionState;
    NSMutableDictionary *usersColorsDic;
    int returnint;
    
    NSString *strUrl;
    
    NSString *str;
    
    NSString *mesText;
    
    CGRect previousRect;
    
    UIImage *senderImgName;
    
    
    
    NSData *imgData;
    
    NSString *finalImagePath;
    
    BOOL newMedia;
    
    NSString *imageName;
    
    NSString *filename;
    
    CGImageRef cgImg;
    
    UIImage *image;
    
    NSString *encodedData;
    
    UILabel *lblDesc,*lblTitle;
    
    UIImageView *imv;
}

-(void)sendMessage:(NSString *)messageTxt;

@end

@implementation ViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initialiseSubViews];
    
     senderImgName=[[UIImage alloc]init];
    
    itemsDataArr=[[NSMutableArray alloc]init];
    
    itemsUserNameArr=[[NSMutableArray alloc]init];
    
    itemImgArray=[[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view.
    self.msgTxtView.editable = NO;
    
   
   
    
    
    [_sendBtn setBackgroundImage:[UIImage imageNamed:@"send_btn"] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    


}




- (void)keyboardDidShow: (NSNotification *) notif{
    [self scrollToLastCell];
}
//- (void)keyboardDidHide: (NSNotification *)notif
//{
//   // [self hideDismissButtonAndKeyboard];
//    
//   
//    [_msgTxtView resignFirstResponder];
//}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [self.ChattblView reloadData];
}

-(void)initialiseSubViews
{
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithCustomView:spaceView];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:space];
    
//    self.navigationItem.titleView=[self navigationItemTitleWithLabelWithText:_chatTitle];
    
    
    isloadMore = YES;
    [self createConnection];
    if (_chatId!=0) {
        pageIndex =1;
      //  [self requestChatDetailForId:_chatId currentIndex:1];//Inital pageindex as 1
    }
    
    [_ChattblView registerNib:[UINib nibWithNibName:@"THSenderChatTableViewCell" bundle:[NSBundle mainBundle]]  forCellReuseIdentifier:@"THSenderChatTableViewCell"];
    
    [_ChattblView registerNib:[UINib nibWithNibName:@"THReceiverChatTableViewCell" bundle:[NSBundle mainBundle]]  forCellReuseIdentifier:@"THReceiverChatTableViewCell"];

}

-(void)reloadContentWithData:(NSMutableArray *)chatMsgsArr

{
    
    
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendButtonClicked:(id)sender {
    
     _str1=@"Ryan";
    
    returnint=0;
    
    [self sendMessage:_msgTxtView.text];
    
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    if ([[_msgTxtView.text stringByTrimmingCharactersInSet: set] length] == 0)
    
    {
        
        _msgTxtView.text=@"";
        
        returnint=0;
        
        [self.ChattblView reloadData];
        
        [self scrollToLastCell];
        
    }
    
    else if (thConnectionState == connected && [_msgTxtView.text length]>0 && ![_msgTxtView.text isEqualToString:@"Type your message"])
    
    {
        
        _sendBtn.userInteractionEnabled=YES;
        
        [self sendMessage:_msgTxtView.text];
        
    }

}


//Register for notifications
-(void)registerForNotifications{
    
    _str1=@"Ryan";
    
    NSArray *arr = [NSArray arrayWithObjects:_str1, nil];
    
    [chatHub invoke:@"getNotifications" withArgs:arr completionHandler:^(id response,NSError *error){
        NSLog(@"get notification Response ::%@...%@",response,error);
    }];
    if (thConnectionState == connected) {
        if (_chatId == 0) {
          //  [self joinGroup];
        }else{
            [self getDetailChatHistory];
        }
    }
}


-(void)sendMessage:(NSString *)messageTxt {
   
  str=@"Ryan";
    
  mesText=messageTxt;
    
    NSLog(@"image name is:%@",filename);
    
//    senderImgName=[UIImage imageNamed:filename];
//    
//    NSLog(@"sender image name is :%@",senderImgName);
//    
//    NSString *str1=filename;
//    
//    NSLog(@"sender image name is:%@",str1);
//    
//  imgData=[NSData dataWithData:UIImageJPEGRepresentation(senderImgName, 0)];
//    
//   finalImagePath=[imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    finalImagePath=@"";
    
     NSString *str1=@"";
    
    NSLog(@"Final image path is:%@", finalImagePath);
    
    NSArray *arr = [NSArray arrayWithObjects:str,
                        messageTxt,finalImagePath,str1,nil];
    
    NSLog(@"Array objects are:%@", arr);
    
    [chatHub invoke:@"Send" withArgs:arr completionHandler:^(id response,NSError *err){
        
    NSLog(@"Sent message response:%@",response);
        
        if (response) {
            
        //message sent successfully
            
            _msgTxtView.text=@"";
            
            [_sendBtn setBackgroundImage:[UIImage imageNamed:@"send_btn"] forState:UIControlStateNormal];
            
            _sendBtn.userInteractionEnabled=YES;
            
            }
        
        else{
            
            [self resetTextView];
            
        }
        
    }];
    
}


-(void)resetTextView{
    
_msgTxtView.text=@"";
    
[_sendBtn setBackgroundImage:[UIImage imageNamed:@"send_btn"] forState:UIControlStateNormal];
    
_sendBtn.userInteractionEnabled=YES;
    
}




//get chat history
-(void)getDetailChatHistory{
    //    args.add(groupID);
    
        NSString *username=@"Ryan";
        
        NSArray *arr = [NSArray arrayWithObjects:username,nil];
        
        [chatHub invoke:@"getChatHistory" withArgs:arr completionHandler:^(id response,NSError *error){
            NSLog(@"chat history ::%@...%@",response,error);
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSMutableArray *msgArr = [response valueForKey:@"R"];
                pageIndex=1;isloadMore=YES;
                [self reloadContentWithData:msgArr];
//            }else if ([response isKindOfClass:[NSString class]]) {
//                NSDictionary *responseDic = [THUtilities convertJsonStringToDictionary:response];
//                NSMutableArray *msgArr = [[THChatBL sharedChatManager] parseDetailChatHistory:response];
//                pageIndex=1;isloadMore=YES;
//                [self reloadContentWithData:msgArr];
//            }
       
            }
        }];
}

        

-(void)messagesReceived:(id)data

{
  
if(data)
        
    {
        NSArray *arrCount;
        
        NSArray *arr=(NSArray *)data;
        
        arrCount=[NSArray arrayWithObjects:arr, nil];
        
        NSString *str1=[arrCount description];
        
        NSArray* strArray = [str1 componentsSeparatedByString: @","];
        
       NSString* userName = [strArray objectAtIndex:0];
        
        NSLog(@"user Name  is :%@",userName);
        
        NSArray *arrName=[userName componentsSeparatedByString:@""];
        
        NSLog(@"arr is:%@",arrName);
        
        NSString *userNames=[arrName objectAtIndex:0];
        
        NSLog(@"User Name is:%@",userNames);
        
        userNames=[userNames stringByReplacingOccurrencesOfString:@"(\n    \"(" withString:@""];
        
        userNames=[userNames stringByReplacingOccurrencesOfString:@"((" withString:@""];
        
        userNames=[userNames stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        
         userNames=[userNames stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSArray *usernamearr1=[userNames componentsSeparatedByString:@""];
        
        NSLog(@"User Name array value is:%@",usernamearr1);
        
        [itemsUserNameArr addObject:usernamearr1];
        
        NSString *messageText=[strArray objectAtIndex:1];
        
        NSLog(@"message array is:%@",messageText);
        
        
        
        messageText=[messageText stringByReplacingOccurrencesOfString:@")\"\n)" withString:@""];
        
         messageText=[messageText stringByReplacingOccurrencesOfString:@"))" withString:@""];
        
         messageText=[messageText stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        
        messageText=[messageText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSArray *messagearr1=[messageText componentsSeparatedByString:@""];
        
        NSLog(@"Message array value is:%@",messagearr1);
        
        [itemsDataArr addObject:messagearr1];
        
     //   itemsDataArr=[NSMutableArray arrayWithObjects:arr,arr1, nil];
        
        NSLog(@"Items array is:%@",itemsDataArr);
        
        NSString *imgNames=[strArray objectAtIndex:2];
        
        NSLog(@"image Names are:%@",imgNames);
        
        NSArray *imagesArray=[NSArray arrayWithObjects:imgNames, nil];
        
        [itemImgArray addObject:imagesArray];
        
        
        [_ChattblView reloadData];
        
        if([str isEqualToString:str])
            
        {
            
            
        }
        
        else if (![str isEqualToString:str])
            
        {
            
            
        }
        
    }

}


-(void)insertObjectAtLast:(NSMutableArray *)msg{
    NSInteger index = [itemsDataArr count];
    [itemsDataArr insertObject:msg atIndex:index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.ChattblView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self scrollToLastCell];
    
}


//scrolling to last cell
-(void)scrollToLastCell{
    if ([itemsDataArr count]>0) {
        NSInteger lastRowNumber = [itemsDataArr count] - 1;
        NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
        [self.ChattblView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}


#pragma mark - Tableview Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor whiteColor];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [itemsDataArr count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (thConnectionState != connected)
    {
        return 20;
    }
    else
    {
        return 0;
    }
}






-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *CellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (itemsDataArr.count>0) {
        
        UIImageView  *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 3, 250, 80)];
        imgView.image = [UIImage imageNamed:@"speech-bubble-2-hi.png"];
        imgView.layer.borderColor = [UIColor clearColor].CGColor;
        imgView.tag = 5;
        [cell.contentView addSubview:imgView];
        
        
        NSArray *arr1=[[NSArray alloc]init];
        
        arr1=[itemsUserNameArr objectAtIndex:indexPath.row];
        
        NSString *strval=[arr1 objectAtIndex:0];
        
        lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(50, 5, 150, 20)];
        lblTitle.highlightedTextColor=[UIColor whiteColor];
        [cell.contentView addSubview:lblTitle];
        
        [lblTitle setFont:[UIFont boldSystemFontOfSize:14]];
        
        lblTitle.text=strval;
        
        [imgView addSubview:lblTitle];
        
        NSArray *arr2=[[NSArray alloc]init];
        
        arr2=[itemsDataArr objectAtIndex:indexPath.row];
        
        NSLog(@"array2 value is:%@",arr2);
       
        NSArray *arr3=[[NSArray alloc]init];
        
        
        
        arr3=[itemImgArray objectAtIndex:indexPath.row];
        
        NSLog(@"array3 image array value is:%@",arr3);
        
        if (arr2.count>0)
        {
        
            NSString *strmsg=[arr2 objectAtIndex:0];
            
            
            lblDesc=[[UILabel alloc]initWithFrame:CGRectMake(50, 22, 300, 20)];
            lblDesc.highlightedTextColor=[UIColor whiteColor];
            lblDesc.font=[UIFont systemFontOfSize:12.0];
            [cell.contentView addSubview:lblDesc];
            
            [lblDesc setHidden:NO];
            
            lblDesc.text=strmsg;
            
            [imgView addSubview:lblDesc];
            
            // imv.hidden=YES;
            // [imv setHidden:true];
            
        }
        
        
       if (arr3.count>0)
            
        {
            
        NSString *strImg=[arr3 objectAtIndex:0];
            
        NSData *data = [[NSData alloc] initWithData:[NSData
                        dataFromBase64String:strImg]];
            
        
            //Now data is decoded. You can convert them to UIImage
            
        imv = [[UIImageView alloc]initWithFrame:CGRectMake(93,12, 50, 50)];
            
        imv.image=[UIImage imageWithData:data];
            
            [imgView addSubview:imv];
            
            [lblDesc setHidden:YES];
            
            // lblDesc.hidden=YES;
            
        }
   }
//    
    
    return cell;
}


#pragma mark - Hub Proxy interface
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
    
    _ChattblView.tableFooterView=nil;
    
    self.msgTxtView.editable = YES;
    
    [self registerForNotifications];
    
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
        _ChattblView.tableHeaderView=nil;
        self.msgTxtView.editable = YES;
        [self.ChattblView reloadData];
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

#pragma mark UItextView methods
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{

//    returnint=1;
//    if ([textView.text isEqualToString:@"Type your message"])
//    {
//        [self messageTextViewWithoutPlaceholder];
//    }
//  
//    [self scrollToLastCell];
    
    if([_msgTxtView.text isEqualToString:@""] || [_msgTxtView.text isEqualToString:@""]){
        _msgTxtView.text = @"";
    }
    
    _msgTxtView.textColor = [UIColor blackColor];
    
    [UIView animateWithDuration:0.209 animations:^
     {
         _dock.transform = CGAffineTransformMakeTranslation(0, -250 - newLine);
     }
                     completion:^(BOOL finished){}];

    
    return YES;
}



- (void)textViewDidEndEditing:(UITextView *)textView {
    [_msgTxtView resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch * touch = [touches anyObject];
//    if(touch.phase == UITouchPhaseBegan) {
//        [_msgTxtView resignFirstResponder];
//        [self.view endEditing:YES];
//        
//        int height = returnPressed*20;
//        
//        [UIView animateWithDuration:0.209 animations:^
//         {
//             _dock.transform = CGAffineTransformMakeTranslation(0, -height);
//         }];
//        
//        if([_msgTxtView.text isEqualToString:@""]){
//            self->_msgTxtView.textColor = [UIColor lightGrayColor];
//            self->_msgTxtView.text = @"Place Holder";
//        }
//    }
     [_msgTxtView resignFirstResponder];
    
    [self.msgTxtView endEditing:YES];
}




//
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
//    NSRange resultRange = [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:NSBackwardsSearch];
//    if ([text length] == 1 && resultRange.location != NSNotFound) {
//        [textView resignFirstResponder];
//        return NO;
//    }
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    UITextPosition* pos = _msgTxtView.endOfDocument;
    
    CGRect currentRect = [_msgTxtView caretRectForPosition:pos];
    
    if (currentRect.origin.y > previousRect.origin.y || [_msgTxtView.text isEqualToString:@"\n"]){
        
        returnPressed +=1;
        
        if(returnPressed < 17 && returnPressed > 1){
            
            _msgTxtView.frame = CGRectMake(8, 8, _msgTxtView.frame.size.width, _msgTxtView.frame.size.height + 17);
            
            newLine = 17*returnPressed;
            
            [UIView animateWithDuration:0.1 animations:^
             {
                 _dock.transform = CGAffineTransformMakeTranslation(0, -250 - newLine);
             }
             ];
            
        }
    }
    previousRect = currentRect;
    
    
}

//UItextview with placeholder and color

//-(void)messageTextViewWithPlaceholder
//{
//    _msgTxtView.text=@"Type your message";
//    _msgTxtView.textColor=[UIColor colorWithRed:86.0/255.0 green:86.0/255.0 blue:96.0/255.0 alpha:1.0];
//    [self performSelector:@selector(setCursorToBeginning:) withObject:_msgTxtView afterDelay:0.01];
//}
//-(void)messageTextViewWithoutPlaceholder
//{
//    _msgTxtView.text=@"";
//    _msgTxtView.textColor=[UIColor blackColor];
//}
//
//- (void)setCursorToBeginning:(UITextView *)inView
//{
//    //you can change first parameter in NSMakeRange to wherever you want the cursor to move
//    inView.selectedRange = NSMakeRange(0, 0);
//}


-(void)hideDismissButtonAndKeyboard
{
   // _dismissBtn.hidden=YES;
    [_msgTxtView resignFirstResponder];
//    _chatTableViewBottom.constant= 0;
//    _inputViewHeigjt.constant=50;
}




//- (IBAction)attach:(id)sender {
//    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
//    delegate: self cancelButtonTitle: @"Cancel" destructiveButtonTitle: nil otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
//    [actionSheet showInView:self.view];
//    
//   }
//
//
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//
//{
//    
//    switch (buttonIndex) {
//        case 0:
//            [self takeNewPhotoFromCamera];
//            break;
//        case 1:
//            [self choosePhotoFromExistingImages];
//        default:
//            break;
//    }
//}

//-(void)takeNewPhotoFromCamera
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
//                                (NSString *) kUTTypeImage,
//                                nil];
//        imagePicker.allowsEditing = NO;
//        [self presentViewController:imagePicker animated:YES completion:nil];
//        newMedia = NO;
//    }
//
//}


-(void)choosePhotoFromExistingImages

{
    {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            controller.allowsEditing = NO;
            controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
            controller.delegate = self;
            [self.navigationController presentViewController: controller animated: YES completion: nil];
        }
        
    }
    
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
   [picker dismissViewControllerAnimated:YES completion:nil];
    
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(image, 0);
   encodedData =[data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
     NSURL *resourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
    
    resourceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
        ALAssetsLibrary *assetLibrary = [ALAssetsLibrary new];
        [assetLibrary assetForURL:resourceURL
                      resultBlock:^(ALAsset *asset) {
                          // get data
    
    
                          ALAssetRepresentation *assetRep = [asset defaultRepresentation];
                           cgImg = [assetRep fullResolutionImage];
                          filename = [assetRep filename];
    
                          NSLog(@"file name is:%@", filename);
    
                           [self performSelector:@selector(uploadToServer) withObject:nil afterDelay:0.0];
    
    
                      }
                     failureBlock:^(NSError *error) {
                         NSLog(@"%@", error);
                     }];
}

-(void)uploadToServer

{
    str=@"Ryan";
    
    
    NSLog(@"image name is:%@",filename);
    
//    senderImgName=[UIImage imageNamed:filename];
//    
//  
//    
//    NSLog(@"sender image name is :%@",senderImgName);
//    
    NSString *str1=filename;
    
    NSLog(@"sender image name is:%@",str1);
//
//    imgData=[NSData dataWithData:UIImageJPEGRepresentation(senderImgName, 0)];
//    
//    finalImagePath=[imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSLog(@"Final image path is:%@", encodedData);
    
    mesText=@"";
    
    NSArray *arr = [NSArray arrayWithObjects:str,
                    mesText,encodedData,str1,nil];
    
    NSLog(@"Array objects are:%@", arr);
    
    [chatHub invoke:@"Send" withArgs:arr completionHandler:^(id response,NSError *err){
        
        NSLog(@"Sent message response:%@",response);
        
        if (response) {
            
            //message sent successfully
            
            _msgTxtView.text=@"";
            
            [_sendBtn setBackgroundImage:[UIImage imageNamed:@"send_btn"] forState:UIControlStateNormal];
            
            _sendBtn.userInteractionEnabled=YES;
            
        }
        
        else{
            
            [self resetTextView];
            
        }
        
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
//    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)attach:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        newMedia = NO;
    }
}


// http://stackoverflow.com/questions/37828456/how-to-push-message-from-server-to-client-using-signalr


// https://github.com/DyKnow/SignalR-ObjC/issues/155

// https://github.com/DyKnow/SignalR-ObjC/issues/250

// https://github.com/DyKnow/SignalR-ObjC/issues/231

//  https://github.com/sibahota059/SPHChatBubble


//

@end
