//
//  ViewController.m
//  SCInfiniteTableViewDemo
//
//  Created by Aevitx on 14/12/12.
//  Copyright (c) 2014年 Aevit. All rights reserved.
//

#import "ViewController.h"
#import "SCInfiniteTableView.h"

#define CELL_NUM    20

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return CELL_NUM;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld个，共%d个", (long)indexPath.row, CELL_NUM];
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@, 上一行循环为［19］", cell.textLabel.text];
    } else if (indexPath.row == 19) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@, 下一行循环为［0］", cell.textLabel.text];
    }
    return cell;
}

@end
