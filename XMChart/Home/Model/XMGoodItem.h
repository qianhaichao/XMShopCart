//
//  XMGoodModel.h
//  XMChart
//
//  Created by 钱海超 on 2018/5/24.
//  Copyright © 2018年 北京大账房信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGoodItem : NSObject

/** 商品id*/
@property (nonatomic, copy) NSString *goods_id;
/** 商品名称*/
@property (nonatomic, copy) NSString *goods_name;
/** 店铺id*/
@property (nonatomic, copy) NSString *shop_id;
/** 店铺名称*/
@property (nonatomic, copy) NSString *shop_name;
/** 商品图片*/
@property (nonatomic, copy) NSString *goods_image;
/** 商品属性*/
@property (nonatomic, copy) NSString *goods_property;
/** 商品限购*/
@property (nonatomic, copy) NSString *goods_limit;
/** 原价*/
@property (nonatomic, copy) NSNumber *original_price;
/** 现价*/
@property (nonatomic, copy) NSNumber *current_price;

@end
