//
//  XMHomeViewController.h
//  XMChart
//
//  Created by 钱海超 on 2018/5/24.
//  Copyright © 2018年 北京大账房信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XMHomeViewControllerDelegate <NSObject>

/**
 刷新购物车
 */
- (void)refreshCart;
@end

@interface XMHomeViewController : UIViewController

@property (nonatomic,weak) id<XMHomeViewControllerDelegate> delegate;

@end
