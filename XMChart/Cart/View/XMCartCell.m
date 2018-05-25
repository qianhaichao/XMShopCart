//
//  XMCartCell.m
//  XMChart
//
//  Created by 钱海超 on 2018/5/24.
//  Copyright © 2018年 北京大账房信息技术有限公司. All rights reserved.
//

#import "XMCartCell.h"
#import "XMShopModel.h"

@interface XMCartCell()

@property (weak, nonatomic) IBOutlet UIButton *chooseBtn; //选择按钮
@property (weak, nonatomic) IBOutlet UIImageView *goodImgView; //商品图标
@property (weak, nonatomic) IBOutlet UILabel *goodNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *propertyLbl;
@property (weak, nonatomic) IBOutlet UILabel *limitLbl;
@property (weak, nonatomic) IBOutlet UILabel *currentLbl;
@property (weak, nonatomic) IBOutlet UILabel *orignalLbl;
@property (weak, nonatomic) IBOutlet UILabel *contLbl;

@end

@implementation XMCartCell

#pragma mark - setter方法
- (void)setGoodItem:(XMGoodModel *)goodItem
{
    _goodItem = goodItem;

    self.goodNameLbl.text = goodItem.goods_name;
    self.propertyLbl.text = goodItem.goods_property;
    self.limitLbl.text = goodItem.goods_limit == nil ? @"" : [NSString stringWithFormat:@"限购%@件",goodItem.goods_limit];
    self.currentLbl.text = [NSString stringWithFormat:@"¥%@",goodItem.current_price];
    self.orignalLbl.text = [NSString stringWithFormat:@"¥%@",goodItem.original_price];
    self.contLbl.text = [NSString stringWithFormat:@"×%@",goodItem.goods_count];
    // 为原价加删除线
    [self.orignalLbl setLabelWithDelLine];

    self.chooseBtn.selected = goodItem.chooseState;
    self.goodImgView.backgroundColor = RANDOM_COLOR;
}

#pragma mark - 事件监听
/**
 选择
 */
- (IBAction)chooseBtnClick:(UIButton *)sender {

    sender.selected = !sender.selected;

    if(self.delegate && [self.delegate respondsToSelector:@selector(cartCell:didSelectedWithGoodItem:)]){
        [self.delegate cartCell:self didSelectedWithGoodItem:self.goodItem];
    }
}
/**
 删除
 */
- (IBAction)deleteBtnClick:(UIButton *)sender {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(cartCell:didDeleteWithGoogItem:)]){
        [self.delegate cartCell:self didDeleteWithGoogItem:self.goodItem];
    }
}

@end


