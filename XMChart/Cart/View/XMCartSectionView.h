//
//  XMCartSectionView.h
//  XMChart
//
//  Created by 钱海超 on 2018/5/24.
//  Copyright © 2018年 北京大账房信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMShopModel,XMCartSectionView;

@protocol XMCartSectionViewDelegate <NSObject>

/**
 店铺选择
 */
- (void)cartSectionView:(XMCartSectionView *)cartBottomView didSelectedShopItem:(XMShopModel *)shopItem;


/**
 编辑
 */
- (void)cartSectionView:(XMCartSectionView *)cartBottomView didEditShopItem:(XMShopModel *)shopItem;
@end


@interface XMCartSectionView : UIView

@property (nonatomic,strong) XMShopModel       *shopItem; //店铺信息
@property (nonatomic,weak) id<XMCartSectionViewDelegate> delegate; //代理

/**
 快速创建
 */
+ (instancetype)seciontView;

@end
