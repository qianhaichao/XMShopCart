//
//  XMCartSectionView.m
//  XMChart
//
//  Created by 钱海超 on 2018/5/24.
//  Copyright © 2018年 北京大账房信息技术有限公司. All rights reserved.
//

#import "XMCartSectionView.h"
#import "XMShopModel.h"

@interface XMCartSectionView()

@property (weak, nonatomic) IBOutlet UIButton *shopTitleBtn;// 选择按钮
@property (weak, nonatomic) IBOutlet UIButton *editBtn; //编辑按钮

@end

@implementation XMCartSectionView

/**
 快速创建
 */
+ (instancetype)seciontView
{
    return [[NSBundle mainBundle] loadNibNamed:@"XMCartSectionView" owner:self options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.layer.borderColor = BACKGROUND_GRAY_COLOR.CGColor;
    self.layer.borderWidth = 1.0f;
}

#pragma mark - setter/getter方法
- (void)setShopItem:(XMShopModel *)shopItem
{
    _shopItem = shopItem;

    [self.shopTitleBtn setTitle:shopItem.shop_name forState:UIControlStateNormal];
    self.shopTitleBtn.selected = shopItem.chooseState;
    self.editBtn.selected = shopItem.isEdit;
}

#pragma mark - 事件监听

/**
 选择商品
 */
- (IBAction)chooseShopBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(self.delegate && [self.delegate respondsToSelector:@selector(cartSectionView:didSelectedShopItem:)]){
        [self.delegate cartSectionView:self didSelectedShopItem:self.shopItem];
    }
}


/**
 编辑商铺
 */
- (IBAction)editShopBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(self.delegate && [self.delegate respondsToSelector:@selector(cartSectionView:didEditShopItem:)]){
        [self.delegate cartSectionView:self didEditShopItem:self.shopItem];
    }
}

@end
