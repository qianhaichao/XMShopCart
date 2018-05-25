//
//  XMCartBottomView.h
//  XMChart
//
//  Created by 钱海超 on 2018/5/24.
//  Copyright © 2018年 北京大账房信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMCartBottomView;

typedef NS_ENUM(NSUInteger, XMCartBottomViewButtonType) {
    XMCartBottomViewButtonType_Settle = 0, //结算
    XMCartBottomViewButtonType_Delete, //删除
};

@protocol XMCartBottomViewDelegate <NSObject>

/**
 全选
 */
- (void)cartBottomView:(XMCartBottomView *)cartBottomView didSelectedAllWithState:(BOOL)state;


/**
 底部结算或删除
 */
- (void)cartBottomView:(XMCartBottomView *)cartBottomView didSelectedSettleWithType:(XMCartBottomViewButtonType)type;
@end

@interface XMCartBottomView : UIView

@property (weak, nonatomic) IBOutlet UIButton *allChooseBtn; //全选按钮
@property (weak, nonatomic) IBOutlet UILabel *totalLbl; //合计标签
@property (weak, nonatomic) IBOutlet UIButton *settleBtn; //结算那妞

@property (nonatomic,assign) BOOL       isEdit; //编辑状态
@property (nonatomic,weak) id<XMCartBottomViewDelegate> delegate; //代理


/**
 快速创建
 */
+ (instancetype)bottomView;





@end
