//
//  ViewController.m
//  ZLPhotoBrowser
//
//  Created by long on 15/12/1.
//  Copyright © 2015年 long. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
{
    ZLPhotoActionSheet *actionSheet;
    NSArray *photoArr;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    actionSheet = [[ZLPhotoActionSheet alloc] init];
    //设置照片最大选择数
    actionSheet.maxSelectCount = 5;
    //设置照片最大预览数
    actionSheet.maxPreviewCount = 20;
    
    
    
}

- (IBAction)RightItem:(id)sender {
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title =@"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    
    AlbumViewController *album = [[AlbumViewController alloc]init];
    [self.navigationController pushViewController:album animated:YES];
    
    
}

- (IBAction)CreateAction:(id)sender {
    
    if (photoArr.count<2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"照片数量不能少于2张" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSString *timestr = [Utils getNowTime];
    
    [self creategif:photoArr name:timestr];
    // 清除照片
     __weak typeof(self) weakSelf = self;
     [weakSelf.baseView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (IBAction)btnSelectPhoto_Click:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [actionSheet showWithSender:self animate:YES completion:^(NSArray<UIImage *> * _Nonnull selectPhotos) {
        photoArr = selectPhotos;
        [weakSelf.baseView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width/4-2;
        for (int i = 0; i < selectPhotos.count; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i%4*(width+2), i/4*(width+2), width, width)];
            imgView.image = selectPhotos[i];
            [weakSelf.baseView addSubview:imgView];
        }
    }];
}


-(void)creategif:(NSArray *)arr name:(NSString *)namestr
{
    
    //图像目标
    CGImageDestinationRef destination;
    NSString *path ;
    //创建输出路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentStr = [document objectAtIndex:0];
    NSString *textDirectory = [documentStr stringByAppendingPathComponent:@"gif"];
    
    
    [fileManager createDirectoryAtPath:textDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *gifName = [NSString stringWithFormat:@"%@.gif",namestr];
    path = [textDirectory stringByAppendingPathComponent:gifName];
    
    
    
    
    
    //创建CFURL对象
    /*
     CFURLCreateWithFileSystemPath(CFAllocatorRef allocator, CFStringRef filePath, CFURLPathStyle pathStyle, Boolean isDirectory)
     
     allocator : 分配器,通常使用kCFAllocatorDefault
     filePath : 路径
     pathStyle : 路径风格,我们就填写kCFURLPOSIXPathStyle 更多请打问号自己进去帮助看
     isDirectory : 一个布尔值,用于指定是否filePath被当作一个目录路径解决时相对路径组件
     */
    CFURLRef url = CFURLCreateWithFileSystemPath (
                                                  kCFAllocatorDefault,
                                                  (CFStringRef)path,
                                                  kCFURLPOSIXPathStyle,
                                                  false);
    
    //通过一个url返回图像目标
    destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, arr.count, NULL);
    
    //设置gif的信息,播放间隔时间,基本数据,和delay时间
    NSDictionary *frameProperties = [NSDictionary
                                     dictionaryWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0.3], (NSString *)kCGImagePropertyGIFDelayTime, nil]
                                     forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    //设置gif信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [dict setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCGImagePropertyGIFHasGlobalColorMap];
    
    [dict setObject:(NSString *)kCGImagePropertyColorModelRGB forKey:(NSString *)kCGImagePropertyColorModel];
    
    [dict setObject:[NSNumber numberWithInt:8] forKey:(NSString*)kCGImagePropertyDepth];
    
    [dict setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
    NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:dict
                                                              forKey:(NSString *)kCGImagePropertyGIFDictionary];
    //合成gif
    for (UIImage* dImg in arr)
    {
        CGImageDestinationAddImage(destination, dImg.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)gifProperties);
    CGImageDestinationFinalize(destination);
    CFRelease(destination);
    
    photoArr = [NSArray array];
    
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title =@"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    AlbumViewController *album = [[AlbumViewController alloc] init];
    [self.navigationController pushViewController:album animated:YES];
 
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
