//
//  XMHomeViewController.m
//  XMChart
//
//  Created by 钱海超 on 2018/5/24.
//  Copyright © 2018年 北京大账房信息技术有限公司. All rights reserved.
//

#import "XMHomeViewController.h"
#import "XMGoodItem.h"
#import "XMCollectionViewCell.h"
#import "XMPlistTool.h"
#define TAG_BTN 0x1000
static const CGFloat kPadding = 15;             // 同一行 item 之间的间距
static const CGFloat kLinePadding = 10;         // 不同行之间的间距

@interface XMHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView                 *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout       *layout;

@property (nonatomic,strong) NSArray        *goodsList; //商品列表
@property (nonatomic,copy)   NSString       *path; //商品列表文件路径


@end

@implementation XMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //导航条设置
    [self layoutNavigationBar];

    //UI布局
    [self layoutUI];
}

#pragma mark - 导航条设置
- (void)layoutNavigationBar
{
    self.navigationItem.title = @"商城";
}

#pragma mark - UI布局
- (void)layoutUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self collectionView];
}

#pragma mark - 事件监听

/**
 加入购物车
 */
- (void)addToCart:(UIButton *)sender
{
    XMGoodItem *goodItem = self.goodsList[sender.tag - TAG_BTN];
    NSMutableArray *cartArray = [XMPlistTool readPlistArrayWithPath:self.path];
    BOOL hasEqualShop = NO;
    BOOL hasEqualGood = NO;

    for(NSMutableDictionary *shopDic in cartArray){
        NSMutableArray *goodsArr = shopDic[@"goods"];
        //是否有相同的商铺
        if([shopDic[@"shop_id"] isEqualToString:goodItem.shop_id]){
            for(NSMutableDictionary *goodDic in goodsArr){
                if([goodDic[@"goods_id"] isEqualToString:goodItem.goods_id]){
                    hasEqualGood  = YES;
                    int count = [goodDic[@"goods_count"] intValue];
                    if(count < [goodItem.goods_limit intValue] || goodItem.goods_limit == nil){
                        goodDic[@"goods_count"] = @(count + 1);
                    }else{
                        [MBProgressHUD showHint:@"超过限购，无法添加"];
                    }
                    //移除重复信息
                    [goodDic removeObjectForKey:@"shop_id"];
                    [goodDic removeObjectForKey:@"shop_name"];
                }
            }
            if(!hasEqualGood){
                NSMutableDictionary *newCartDic = [goodItem mj_JSONObject];
                newCartDic[@"goods_count"] = @(1);
                [goodsArr addObject:newCartDic];
            }
            hasEqualShop = YES;
            [cartArray writeToFile:self.path atomically:YES];
        }
    }

    if(!hasEqualShop){
        NSMutableArray *goodsArr = [NSMutableArray array];
        NSMutableDictionary *newCartDic = [goodItem mj_JSONObject];
        [newCartDic removeObjectForKey:@"shop_id"];
        [newCartDic removeObjectForKey:@"shop_name"];
        newCartDic[@"goods_count"] = @(1);
        [goodsArr addObject:newCartDic];

        NSMutableDictionary *shopDic = [NSMutableDictionary dictionaryWithDictionary:@{@"shop_id":goodItem.shop_id,@"shop_name":goodItem.shop_name,@"goods":goodsArr}];
        [cartArray addObject:shopDic];
        [cartArray writeToFile:self.path atomically:YES];
    }
}

#pragma mark - 代理方法
/**
 * UICollectionViewDelegate
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.goodsList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XMCollectionViewCell" forIndexPath:indexPath];
    XMGoodItem *item = self.goodsList[indexPath.item];
    cell.imageView.image = [UIImage imageNamed:item.goods_image];
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",item.current_price];
    cell.buyButton.tag = TAG_BTN + indexPath.row;
    [cell.buyButton addTarget:self action:@selector(addToCart:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - 懒加载
- (NSArray *)goodsList
{
    if(!_goodsList){
        _goodsList = [XMGoodItem mj_objectArrayWithFilename:@"goodsList.plist"];
    }
    return _goodsList;
}
- (NSString *)path
{
    if(!_path){
        _path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"cart.plist"];
        NSLog(@"购物车文件路径-------%@",_path);
    }
    return _path;
}
- (UICollectionView *)collectionView
{
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[XMCollectionViewCell class] forCellWithReuseIdentifier:@"XMCollectionViewCell"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)layout
{
    if(_layout) return _layout;
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.minimumInteritemSpacing = kPadding;
    _layout.minimumLineSpacing = kLinePadding;
    _layout.sectionInset = UIEdgeInsetsMake(0, kLinePadding, 0, kLinePadding);
    CGFloat width = (SCREEN_WIDTH - kLinePadding * 2 - kPadding) / 2;
    _layout.itemSize = CGSizeMake(width, width + 30);
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    return _layout;
}

@end
