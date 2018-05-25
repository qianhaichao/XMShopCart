//
//  XMCartBottomView.m
//  XMChart
//
//  Created by 钱海超 on 2018/5/24.
//  Copyright © 2018年 北京大账房信息技术有限公司. All rights reserved.
//

#import "XMCartBottomView.h"

@interface XMCartBottomView()
@property (nonatomic,assign) XMCartBottomViewButtonType       type;
@end

@implementation XMCartBottomView

/**
 快速创建
 */
+ (instancetype)bottomView
{
    return [[NSBundle mainBundle] loadNibNamed:@"XMCartBottomView" owner:self options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    //默认结算
    self.type = XMCartBottomViewButtonType_Settle;
}

#pragma mark - setter方法
- (void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
    if(isEdit){
        [self.settleBtn setTitle:@"删除" forState:UIControlStateNormal];
        self.type = XMCartBottomViewButtonType_Delete;

    }else{
        [self.settleBtn setTitle:@"结算" forState:UIControlStateNormal];
        self.type = XMCartBottomViewButtonType_Settle;
    }
    self.totalLbl.hidden = isEdit;
}

#pragma mark - 事件监听

/**
 全选
 */
- (IBAction)chooseAllBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(self.delegate && [self.delegate respondsToSelector:@selector(cartBottomView:didSelectedAllWithState:)]){
        [self.delegate cartBottomView:self didSelectedAllWithState:sender.selected];
    }
}

/**
 结算
 */
- (IBAction)settleBtnClick:(UIButton *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(cartBottomView:didSelectedSettleWithType:)]){
        [self.delegate cartBottomView:self didSelectedSettleWithType:self.type];
    }
}

@end
