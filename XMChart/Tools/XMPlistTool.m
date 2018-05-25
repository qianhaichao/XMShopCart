//
//  XMPlistTool.m
//  XMChart
//
//  Created by 钱海超 on 2018/5/24.
//  Copyright © 2018年 北京大账房信息技术有限公司. All rights reserved.
//

#import "XMPlistTool.h"

@implementation XMPlistTool

/**
 获取plist内容

 @param path plist路径
 */
+ (NSMutableArray *)readPlistArrayWithPath:(NSString *)path
{
    NSMutableArray *muteArr = nil;
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]){ //文件不存在
        muteArr = [NSMutableArray array];
    }else{
        muteArr = [NSMutableArray arrayWithContentsOfFile:path];
    }
    return muteArr;
}

@end
