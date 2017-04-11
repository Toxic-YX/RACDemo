//
//  ViewController.m
//  RACStudy
//
//  Created by 骆驼鱼 on 17/3/15.
//  Copyright © 2017年 毒药_YX. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <MJRefresh/MJRefresh.h>
#import "MyCell.h"
#import "Model.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSMutableArray <Entity *>*dataArr;

@property (strong, nonatomic) Model *model;

@property(copy, nonatomic) NSString *urlString;

@end

static NSString *CellID = @"CellID";
@implementation ViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
  [super viewDidLoad];
 
  self.urlString = @"http://c.m.163.com//nc/article/headline/T1348647853363/0-20.html";
  [self.tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellReuseIdentifier:CellID];
  __weak typeof(self) weakSelf = self;
  self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [weakSelf loadData];
  }];
  self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    [weakSelf loadMoreData];
  }];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
   [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 自定义方法
- (void)loadData {
   [self loadDataForType:1 withURL:self.urlString];
}

- (void)loadMoreData {
  [self loadDataForType:2 withURL:self.urlString];
}

- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring {
  @weakify(self);
  [[self.model.fetchEntityCommand execute:allUrlstring] subscribeNext:^(NSArray *arr) {
    @strongify(self);
    if (type == 1) {
      self.dataArr = [arr mutableCopy];
      [self.tableView.mj_header endRefreshing];
      [self.tableView reloadData];
    }else if (type == 2){
      [self.dataArr addObjectsFromArray:arr];
      [self.tableView.mj_footer endRefreshing];
      [self.tableView reloadData];
    }
  } error:^(NSError *error) {
    NSLog(@"%@",error.userInfo);
  }];
}
#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MyCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
  Entity *entity = self.dataArr[indexPath.row];
  cell.entity = entity;
  return cell;
}

#pragma mark -  懒加载
- (NSMutableArray<Entity *> *)dataArr {
  if (!_dataArr) {
    _dataArr = [NSMutableArray array];
  }
  return _dataArr;
}

- (Model *)model {
  if (!_model) {
    _model = [[Model alloc] init];
  }
  return _model;
}
@end
