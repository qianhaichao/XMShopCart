//
//  XMCollectionViewCell.h
//  XMChart
//
//  Created by 钱海超 on 2018/5/24.
//  Copyright © 2018年 北京大账房信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMCollectionViewCell : UICollectionViewCell

/** 商品图片 */
@property (nonatomic, strong) UIImageView *imageView;
/** 价格标签 */
@property (nonatomic, strong) UILabel *priceLabel;
/** 加入购物车按钮 */
@property (nonatomic, strong) UIButton *buyButton;

@end
