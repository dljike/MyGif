//
//  AlbumCollectionViewCell.m
//  ZLPhotoBrowser
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 long. All rights reserved.
//

#import "AlbumCollectionViewCell.h"

@implementation AlbumCollectionViewCell

- (void)awakeFromNib {
 
    
    self.webView.scrollView.scrollEnabled = NO;
 [self.webView setUserInteractionEnabled:NO];//是否支持交互
    
    
    for (UIScrollView* view in self.webView.subviews)
    {
        if ([view isKindOfClass:[UIScrollView class]])
        {
            view.bounces = NO;
        }
    }
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView setOpaque:NO];// 不透明
    self.webView.scalesPageToFit = YES;  // 自适应大小
    
 
    
  
}

@end
