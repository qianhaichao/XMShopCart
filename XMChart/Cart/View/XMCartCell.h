//
//  XMCartCell.h
//  XMChart
//
//  Created by 钱海超 on 2018/5/24.
//  Copyright © 2018年 北京大账房信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMCartCell,XMGoodModel;

@protocol XMCartCellDelegate <NSObject>

/**
 选择商品
 */
- (void)cartCell:(XMCartCell *)cell didSelectedWithGoodItem:(XMGoodModel *)goodItem;


/**
 删除商品
 */
- (void)cartCell:(XMCartCell *)cell didDeleteWithGoogItem:(XMGoodModel *)googItem;
@end

@interface XMCartCell : UITableViewCell


@property (nonatomic,strong) XMGoodModel       *goodItem; //商品信息模型

@property (nonatomic,weak) id<XMCartCellDelegate> delegate;

@end


