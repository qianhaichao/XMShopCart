//
//  XMPlistTool.h
//  XMChart
//
//  Created by 钱海超 on 2018/5/24.
//  Copyright © 2018年 北京大账房信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMPlistTool : NSObject


/**
 获取plist内容

 @param path plist路径
 */
+ (NSMutableArray *)readPlistArrayWithPath:(NSString *)path;



@end
