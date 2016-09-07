//
//  AlbumViewController.h
//  ZLPhotoBrowser
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AlbumCollectionViewCell.h"

@interface AlbumViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *myCollection;

@property (nonatomic,assign) NSInteger collectionIndex;

@end






