//
//  XMCartViewController.m
//  XMChart
//
//  Created by 钱海超 on 2018/5/24.
//  Copyright © 2018年 北京大账房信息技术有限公司. All rights reserved.
//

#import "XMCartViewController.h"
#import "XMCartBottomView.h"
#import "XMCartSectionView.h"
#import "XMShopModel.h"
#import "XMCartCell.h"

#define TAG_CELLBTN 0x1000
#define TAG_HEADERBTN 0x0100
static NSString *const XMCartCellIde = @"XMCartCell";
static NSString *const XMCartEditCellIde = @"XMCartEditCell";
@interface XMCartViewController ()<UITableViewDelegate,UITableViewDataSource,XMCartCellDelegate,XMCartSectionViewDelegate,XMCartBottomViewDelegate>
@property (nonatomic,copy)   NSString       *path;
@property (nonatomic,strong) XMCartBottomView       *bottomView;
@property (nonatomic,strong) UITableView       *tableView;
@property (nonatomic,strong) NSMutableArray       *shopList; //购物车数据列表
@end

@implementation XMCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //导航条设置
    [self layoutNavigationBar];

    //创建UI
    [self layoutUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //刷新购物车列表
    [self refreshCartList];

    self.bottomView.isEdit = NO;
    self.bottomView.allChooseBtn.selected = NO;
    self.navigationItem.rightBarButtonItem.title = @"编辑";
}

#pragma mark - 导航条设置
- (void)layoutNavigationBar
{
    self.navigationItem.title = @"购物车";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAllGoods:)];
}

#pragma mark - 创建UI
- (void)layoutUI
{
    [self tableView];
    [self bottomView];
}

#pragma mark - 代理方法
/**
 * UITableViewDelegate和UITableViewDataSource
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.shopList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XMShopModel *shopItem = self.shopList[section];
    return shopItem.goods.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMShopModel *shopItem = self.shopList[indexPath.section];
//    XMCartCell *cell = nil;
//    if(shopItem.isEdit){
//        cell = [tableView dequeueReusableCellWithIdentifier:XMCartEditCellIde forIndexPath:indexPath];
//    }else{
//        cell = [tableView dequeueReusableCellWithIdentifier:XMCartCellIde forIndexPath:indexPath];
//    }
    NSString *identifier = shopItem.isEdit ? @"XMCartEditCell" : @"XMCartCell";
    XMCartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"XMCartCell" owner:self options:nil];
        cell = shopItem.isEdit ? cells.lastObject : cells.firstObject;
    }
    cell.goodItem = shopItem.goods[indexPath.row];
    cell.delegate = self;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    XMCartSectionView *sectionHeadView = [XMCartSectionView seciontView];
    sectionHeadView.shopItem = self.shopList[section];
    sectionHeadView.delegate = self;
    return sectionHeadView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == self.shopList.count - 1 ? 0 : 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionFooterView = [[UIView alloc] init];
    sectionFooterView.backgroundColor = BACKGROUND_GRAY_COLOR;
    return sectionFooterView;
}

/**
 * XMCartCellDelegate
 */
//选择商品
- (void)cartCell:(XMCartCell *)cell didSelectedWithGoodItem:(XMGoodModel *)goodItem
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    XMShopModel *shopItem = self.shopList[indexPath.section];

    goodItem.chooseState = ! goodItem.chooseState;

    BOOL shopAllChoose = YES;
    for(XMGoodModel *good in shopItem.goods){
        shopAllChoose &= good.chooseState;
    }
    shopItem.chooseState = shopAllChoose;

    BOOL allChoose = YES;
    for(XMShopModel *shopItem in self.shopList){
        allChoose &= shopItem.chooseState;
    }
    [self.tableView reloadData];

    self.bottomView.allChooseBtn.selected = allChoose;
    //更新底部按钮
    [self updateBottomView];
}
//删除商品
- (void)cartCell:(XMCartCell *)cell didDeleteWithGoogItem:(XMGoodModel *)googItem
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确认要删除这个宝贝吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        XMShopModel *shopItem = self.shopList[indexPath.section];
        if(shopItem.goods.count > 1){
            NSMutableArray *goodItems = shopItem.goods.mutableCopy;
            [goodItems removeObjectAtIndex:indexPath.row];
            shopItem.goods = goodItems;
        }else{
            [self.shopList removeObjectAtIndex:indexPath.section];
        }
        //修改本地缓存
        [self writeToFile];

        [self.tableView reloadData];
        [self updateBottomView];
    }];

    [alertVC addAction:cancelAction];
    [alertVC addAction:confirmAction];
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];
}

/**
 * XMCartSectionViewDelegate
 */
//选择商铺
- (void)cartSectionView:(XMCartSectionView *)cartBottomView didSelectedShopItem:(XMShopModel *)shopItem
{
    shopItem.chooseState = !shopItem.chooseState;
    for(XMGoodModel *goodItem in shopItem.goods){
        goodItem.chooseState = shopItem.chooseState;
    }
    BOOL allChoose = YES;
    for(XMShopModel *shopInfo in self.shopList){
        allChoose &= shopInfo.chooseState;
    }

    [self.tableView reloadData];

    self.bottomView.allChooseBtn.selected = allChoose;
    //更新底部按钮
    [self updateBottomView];

}

//编辑商铺
- (void)cartSectionView:(XMCartSectionView *)cartBottomView didEditShopItem:(XMShopModel *)shopItem
{
    shopItem.isEdit = !shopItem.isEdit;
    [self.tableView reloadData];
}


/**
 * XMCartBottomViewDelegate
 */
//全选
- (void)cartBottomView:(XMCartBottomView *)cartBottomView didSelectedAllWithState:(BOOL)state
{
    for(XMShopModel *shopItem in self.shopList){
        shopItem.chooseState = state;
        for(XMGoodModel *goodItem in shopItem.goods){
            goodItem.chooseState = state;
        }
    }
    [self.tableView reloadData];
    [self updateBottomView];
}

//结算或删除
- (void)cartBottomView:(XMCartBottomView *)cartBottomView didSelectedSettleWithType:(XMCartBottomViewButtonType)type
{
    if(type == XMCartBottomViewButtonType_Delete){ //删除
        NSMutableArray *cartList = self.shopList.mutableCopy;
        for(XMShopModel *shopItem in self.shopList){
            if(shopItem.chooseState){
                [cartList removeObject:shopItem];
            }else{
                NSMutableArray *goodList = shopItem.goods.mutableCopy;
                for(XMGoodModel *goodItem in shopItem.goods){
                    if(goodItem.chooseState){
                        [goodList removeObject:goodItem];
                    }
                }
                shopItem.goods = goodList;
            }
        }

        self.shopList = cartList.mutableCopy;
        [self writeToFile];
        [self.tableView reloadData];
        [self updateBottomView];
    }else{ //结算
        NSLog(@"----结算----");
    }

}

#pragma mark - 事件监听

/**
 编辑
 */
- (void)editAllGoods:(UIBarButtonItem *)barButtonItem
{
    BOOL isEdit = [barButtonItem.title isEqualToString:@"编辑"];
    barButtonItem.title = isEdit ? @"完成" : @"编辑";
    for(XMShopModel *shopItem in self.shopList){
        shopItem.isEdit = isEdit;
    }
    self.bottomView.isEdit = isEdit;
    [self.tableView reloadData];
}

#pragma mark - 私有方法
/**
 刷新购物车
 */
- (void)refreshCartList
{
    NSArray *plistArr = [XMPlistTool readPlistArrayWithPath:self.path];
    self.shopList = [NSMutableArray array];
    for(NSDictionary *shopDic in plistArr){
        XMShopModel *shopItem = [XMShopModel mj_objectWithKeyValues:shopDic];
        [self.shopList addObject:shopItem];
    }
    [self.tableView reloadData];
}
/**
 * 更新底部工具条
 */
- (void)updateBottomView
{
    CGFloat totalPrice = 0;
    for(XMShopModel *shopItem in self.shopList){
        for(XMGoodModel *goodItem in shopItem.goods){
            if(goodItem.chooseState){
                totalPrice += [goodItem.current_price floatValue];
            }
        }
    }
    self.bottomView.totalLbl.text = [NSString stringWithFormat:@"合计：¥%.2f",totalPrice];
    [self.bottomView.totalLbl setLabelText:self.bottomView.totalLbl.text Color:TEXT_BLACK_COLOR Range:NSMakeRange(0, 3)];
}


/**
 写入本地缓存
 */
- (void)writeToFile
{
    NSMutableArray *newCartArr = [NSMutableArray array];
    for(XMShopModel *shopItem in self.shopList){
        NSMutableDictionary *shopDic = [shopItem mj_JSONObject];
        [shopDic removeObjectForKey:@"chooseState"];
        [shopDic removeObjectForKey:@"isEdit"];
        NSArray *goods = shopDic[@"goods"];
        for(NSMutableDictionary *goodDic in goods){
            [goodDic removeObjectForKey:@"chooseState"];
        }
        [newCartArr addObject:shopDic];
    }
    [newCartArr writeToFile:self.path atomically:YES];
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if(_tableView) return _tableView;
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    if(self.navigationController.viewControllers.count == 1){
        _tableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - BOTTOMVIEW_HEIGHT - TABBAR_HEIGHT);
    }else{
        _tableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - BOTTOMVIEW_HEIGHT);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [_tableView registerNib:[UINib nibWithNibName:@"XMCartCell" bundle:nil] forCellReuseIdentifier:XMCartCellIde];
//    [_tableView registerNib:[UINib nibWithNibName:@"XMCartEditCell" bundle:nil] forCellReuseIdentifier:XMCartEditCellIde];
    _tableView.rowHeight = 90;
    [self.view addSubview:_tableView];
    return _tableView;
}
- (XMCartBottomView *)bottomView
{
    if(_bottomView) return _bottomView;
    _bottomView = [XMCartBottomView bottomView];
    if(self.navigationController.viewControllers.count == 1){
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT - BOTTOMVIEW_HEIGHT, SCREEN_WIDTH, BOTTOMVIEW_HEIGHT);
    }else{
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - BOTTOMVIEW_HEIGHT, SCREEN_WIDTH, BOTTOMVIEW_HEIGHT);
    }
    _bottomView.totalLbl.text = @"合计 : ¥0.00";
    [_bottomView.totalLbl setLabelText:_bottomView.totalLbl.text Color:TEXT_BLACK_COLOR Range:NSMakeRange(0, 3)];
    _bottomView.delegate = self;
    [self.view addSubview:_bottomView];
    return _bottomView;
}
- (NSString *)path
{
    if(!_path){
        _path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"cart.plist"];
        NSLog(@"购物车文件路径-------%@",_path);
    }
    return _path;
}


@end
