//
//  Utils.m     工具类
//  PlayMusicTool
//
//  Created by 陈 宏 on 12-6-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"


@implementation Utils

static Utils * _instance;

+(Utils *)sharesInstance
{
    @synchronized(self)
    {
        if (_instance==nil) {
            _instance=[[super allocWithZone:NULL] init];
        }
    }
    return _instance;
}



// 获取当前时间
+(NSString *)getNowTime
{
    
    NSDate *now = [NSDate date];
    NSString *str = [NSString stringWithFormat:@"%@",now];
    NSString *strUrl = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *tempstr = [strUrl stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *timestr = [tempstr stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *dataStr = [timestr stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    return dataStr;
}





@end
