//
//  AlbumViewController.m
//  ZLPhotoBrowser
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 long. All rights reserved.
//

#import "AlbumViewController.h"

@interface AlbumViewController ()
{
    NSArray *gifNameArr;
    NSString *gifPath;
    UIButton *rightBtn;
    BOOL Edit;
    
}
@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Album";
    

    
    rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
   
    [rightBtn setTitle:@"Delete" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.myCollection registerNib:[UINib nibWithNibName:@"AlbumCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    
    
    
    [self getGifPaht];

}
-(void)rightBtnAction:(UIButton *)btn
{
    
    if (Edit) {// 修改完成
        Edit = !Edit;
        [rightBtn setTitle:@"Edit" forState:UIControlStateNormal];
        NSLog(@"11111111111");
    }else{// 点击修改
         Edit = !Edit;
        [rightBtn setTitle:@"Done" forState:UIControlStateNormal];
        NSLog(@"22222222222");
    }
    
    [self.myCollection reloadData];
    
}
-(void)getGifPaht
{
    
    //创建输出路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentStr = [document objectAtIndex:0];
    NSString *textDirectory = [documentStr stringByAppendingPathComponent:@"gif"];
    
    
    [fileManager createDirectoryAtPath:textDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *gifname = [NSString stringWithFormat:@""];
    gifPath = [textDirectory stringByAppendingPathComponent:gifname];
    
    NSLog(@"-------%@",gifPath);
    
    
    gifNameArr = [fileManager contentsOfDirectoryAtPath:gifPath error:nil];
    
    NSLog(@"%@",gifNameArr);
    
    [self.myCollection reloadData];
}




#pragma mark --collection  datasource  delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return gifNameArr.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
 
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
        CGFloat itemWidth = (ScreenWidth - 30)/2;
//        CGFloat itemHeight = 210*itemWidth/145;
        return CGSizeMake(itemWidth, itemWidth);
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
 
        return UIEdgeInsetsMake(10, 10, 0, 10);//分别为上、左、下、右
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
        static NSString *Cell = @"cell";
        AlbumCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:Cell forIndexPath:indexPath];
    
    if (Edit) {
        cell.deleteImgView.hidden = NO;
    }else{
        cell.deleteImgView.hidden = YES;
    }
    
    NSString *strUrl = [NSString stringWithFormat:@"%@/%@",gifPath,gifNameArr[indexPath.item]];
    NSURL *url = [NSURL fileURLWithPath:strUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [cell.webView loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    
        return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
  if (Edit) {
      self.collectionIndex = indexPath.item;
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
      alert.delegate = self;
      [alert show];
  }
    


}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",buttonIndex);
    if (buttonIndex == 1) {
        
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *strUrl = [NSString stringWithFormat:@"%@/%@",gifPath,gifNameArr[self.collectionIndex]];
            //删除你的文件
            [fileManager removeItemAtPath:strUrl error:nil];
        
            [self getGifPaht];
    }
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

@end
