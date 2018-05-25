//
//  UIButton+TitleImageSpacing.h
//  XMChart
//
//  Created by 钱海超 on 2018/5/24.
//  Copyright © 2018年 北京大账房信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XMButtonEdgeInsetsStyle) {
    XMButtonEdgeInsetsStyleTop,    // image在上，label在下
    XMButtonEdgeInsetsStyleLeft,   // image在左，label在右
    XMButtonEdgeInsetsStyleBottom, // image在下，label在上
    XMButtonEdgeInsetsStyleRight   // image在右，label在左
};

@interface UIButton (TitleImageSpacing)

/**
 * 设置button的titleLabel和imageView的布局样式，及间距
 *
 * @param style titleLabel和imageView的布局样式
 * @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(XMButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end
