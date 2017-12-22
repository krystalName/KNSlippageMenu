//
//  ViewController.m
//  KNSlippageMenu
//
//  Created by 刘凡 on 2017/12/14.
//  Copyright © 2017年 leesang. All rights reserved.
//

#import "ViewController.h"
#import "LeftViewController.h"

#import "UIViewController+KNLateralSlippage.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSMutableArray *datadSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.frame = self.view.bounds;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    //注册手势驱动
    __weak typeof (self)weakSelf = self;
    [self kn_registerShowIntractiveWithEdgeGesture:NO direction:KNSlippageDirectionLeft transitionBlock:^{
        [weakSelf leftClick];
    }];
    
}

- (NSMutableArray *)datadSource {
    if (_datadSource == nil) {
        _datadSource = [NSMutableArray arrayWithArray:@[@"仿QQ左侧划出",@"仿QQ右侧划出",@"左侧划出并缩小",@"右侧划出并缩小",@"遮盖在上面从左侧划出",@"遮盖在上面从右侧划出"]];
    }
    return _datadSource;
}



#pragma 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  50;
}



#pragma mark - 设置总共的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datadSource.count;
    
}


-(void)leftClick{
    
    LeftViewController *vc = [[LeftViewController alloc]init];
    
    [self kn_ShowDrawerViewController:vc animationType:KNTransitionAnimationDefault configuration:nil];
    
}


#pragma mark - 设置cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.datadSource[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self leftClick];
    }
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor redColor];
    }
    return _tableView;
}

@end
