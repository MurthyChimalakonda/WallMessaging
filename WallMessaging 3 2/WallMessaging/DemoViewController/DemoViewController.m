//
//  DemoViewController.m
//  WallMessaging
//
//  Created by AxSys on 6/7/16
//  Copyright © 2016 AxSys. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()
{
    NSMutableArray *mainary;
    NSMutableArray *CommentAray;
    NSMutableDictionary *sectionComment;
}

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mainary=[[NSMutableArray alloc]init];
    CommentAray=[[NSMutableArray alloc]init];
    sectionComment=[[NSMutableDictionary alloc]init];
    _tblFB.hidden=YES;
    // Do any additional setup after loading the view.
}

#pragma mark ---> UITableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    
  return[mainary count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 86.0;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *simpleTableIdentifier = @"MainCellTableViewCell";
    
    MainCellTableViewCell *cell = (MainCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainCellTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    cell.lblCommentview.text=[mainary objectAtIndex:section];

    return cell.contentView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([[sectionComment valueForKey:[NSString stringWithFormat:@"%ld",(long)section]] count]>0) {
            
     textsection=[[sectionComment valueForKey:[NSString stringWithFormat:@"%ld",(long)section]]count];
            
            NSLog(@"==data %@",[sectionComment valueForKey:[NSString stringWithFormat:@"%ld",(long)section]]);
        
        return [[sectionComment valueForKey:[NSString stringWithFormat:@"%ld",(long)section]] count]+1;

    }
    else
        return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==textsection) {
        
        return 64;
    }
    else
        return 100;
    
    
    
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"CommentTableViewCell";
    
    CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    NSLog(@"=====%lu",[[sectionComment valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]] count]);
    if (indexPath.row==textsection) {
        static NSString *simpleTableIdentifier = @"TextTableViewCell";
        TextTableViewCell *cell = (TextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
         cell.txtComment.layer.cornerRadius=8.0f;
        cell.txtComment.layer.masksToBounds=YES;
         cell.txtComment.layer.borderColor=[[UIColor brownColor]CGColor];
         cell.txtComment.layer.borderWidth= 1.0f;
        cell.txtComment.text=@"";
        cell.txtComment.tag=indexPath.section;
        cell.txtComment.delegate=self;
        cell.btnComment.tag=indexPath.section;
        return cell;
    }
   
    
  else  if ([[sectionComment valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]]count]==0 || indexPath.row==[[sectionComment valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]] count])
    {
        //cell.lblmain.text=[test objectAtIndex:indexPath.row];
        static NSString *simpleTableIdentifier = @"TextTableViewCell";
        TextTableViewCell *cell = (TextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        cell.txtComment.tag=indexPath.section;
        cell.txtComment.delegate=self;
        cell.btnComment.tag=indexPath.section;
        return cell;
    }
    

  
   else // ([[sectionComment valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]]count]>0) {
       
        
        cell.lblmain.text=[[sectionComment valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]]objectAtIndex:indexPath.row];
       NSLog(@"===%@",cell.lblmain.text);
        return cell;
       
    
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)postMethod:(UIButton *)sender {
    
    if (_tblFB.hidden==YES) {
        _tblFB.hidden=NO;
    }
    
    CommentAray=[[NSMutableArray alloc]init];

    if (mainary.count>0) {
        intSectionClicked=intSectionClicked+1;
        [mainary addObject:_txtCommentview.text];


    }
    
    else
    {
        intSectionClicked=0;
        [mainary addObject:_txtCommentview.text];


    }

    
    
    
    [_tblFB reloadData];
    
    
}





- (IBAction)cellcomment:(UIButton *)sender {
    
    
    UIButton *btn = (UIButton*)sender;
    NSLog(@"===%ld",(long)btn.tag);
    
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.tblFB];
    
    NSIndexPath *indexPath = [self.tblFB indexPathForRowAtPoint:touchPoint];
    
    TextTableViewCell *cell1 = [self.tblFB cellForRowAtIndexPath:indexPath];
    
    commonstring=cell1.txtComment.text;
    
    NSLog(@"tf text %@",commonstring);
    
    if ([commonstring isEqualToString:@""]) {
        
        NSLog(@"Blank String");
    }
    
    else
    {
        
        [CommentAray addObject:commonstring];
        [sectionComment setObject:CommentAray forKey:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
        [_tblFB reloadData];
    }
    
    
}
@end
