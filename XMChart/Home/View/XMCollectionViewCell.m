//
//  XMCollectionViewCell.m
//  XMChart
//
//  Created by 钱海超 on 2018/5/24.
//  Copyright © 2018年 北京大账房信息技术有限公司. All rights reserved.
//

#import "XMCollectionViewCell.h"

@implementation XMCollectionViewCell

static const CGFloat kPadding = 15;             // 同一行 item 之间的间距
static const CGFloat kLinePadding = 10;         // 不同行之间的间距

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews {
    CGFloat width = (SCREEN_WIDTH - 2 * kLinePadding - kPadding)/ 2 - 60;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 15, width, width)];
    _imageView.backgroundColor = RANDOM_COLOR;
    [self addSubview:_imageView];

    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, width + 15, width, 30)];
    _priceLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_priceLabel];

    _buyButton = [[UIButton alloc] initWithFrame:CGRectMake(30, width + 45, width, 40)];
    _buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_buyButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buyButton setBackgroundColor:RGB(34, 73, 243)];
    [self addSubview:_buyButton];

    
}


@end
