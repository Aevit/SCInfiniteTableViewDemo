//
//  SCInfiniteTableView.m
//  SCInfiniteTableViewDemo
//
//  Created by Aevitx on 14/12/12.
//  Copyright (c) 2014年 Aevit. All rights reserved.
//

#import "SCInfiniteTableView.h"
#import "SCInfiniteBridge.h"

@interface SCInfiniteTableView () {
    NSInteger totalRowsNum; // 外部传入的cell总数
    BOOL isLessThanAScreenCellsNum;
}

@property (nonatomic, strong) SCInfiniteBridge *dataSourceBridge;

@end

@implementation SCInfiniteTableView

#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self commonInitForInfinite];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if(self) {
        [self commonInitForInfinite];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitForInfinite];
    }
    return self;
}

- (void)commonInitForInfinite {
    if (!_dataSourceBridge) {
        self.dataSourceBridge = [[SCInfiniteBridge alloc] init];
    }
//    self.showsVerticalScrollIndicator = NO;
    self.isInfiniteScroll = YES;
    isLessThanAScreenCellsNum = YES;
}

#pragma mark - public
- (void)needDealloc {
    self.delegate = nil; // 在这个tableview的父controller的dealloc方法里，需要置空，不然pop或dismiss controller后，tableView的didScrollView方法仍会执行，这时就会报错
    self.dataSource = nil;
}

#pragma mark - private
- (NSIndexPath*)getIndexPathForIndexPath:(NSIndexPath*)oldIndexPath {
    return (_isInfiniteScroll && !isLessThanAScreenCellsNum ? [NSIndexPath indexPathForRow:oldIndexPath.row % totalRowsNum inSection:oldIndexPath.section] : oldIndexPath);
}

- (NSInteger)getSectionForSection:(NSInteger)oldSection {
    return (_isInfiniteScroll && !isLessThanAScreenCellsNum ? oldSection % 3 : oldSection);
}

- (void)configureForInfiniteScroll {
    
    if (!_isInfiniteScroll || isLessThanAScreenCellsNum) {
        return;
    }
    CGFloat offsetY = self.contentOffset.y;
    if (offsetY < 0) {
        // 滑动到顶部，将offsetY调为中间
        offsetY = self.contentSize.height / 3.0;
    } else if (offsetY >= (self.contentSize.height - self.bounds.size.height)) {
        //滑动到底部，将offsetY调为中间
        offsetY = self.contentSize.height / 3.0 - self.bounds.size.height;
    }
    self.contentOffset = CGPointMake(self.contentOffset.x, offsetY);
}

#pragma mark - override
- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    if (!dataSource) {
        self.dataSourceBridge.middleBridge = nil;
        self.dataSourceBridge.receiver = nil;
        self.dataSourceBridge = nil;
        super.dataSource = nil;
        return;
    }
    self.dataSourceBridge.middleBridge = self;
    self.dataSourceBridge.receiver = dataSource;
    super.dataSource = (id)self.dataSourceBridge;
}

- (void)layoutSubviews {
    if (!_isInfiniteScroll) {
        [super layoutSubviews];
        return;
    }
    isLessThanAScreenCellsNum = (self.contentSize.height < self.bounds.size.height ? YES : NO);
    if (isLessThanAScreenCellsNum) {
        [super layoutSubviews];
        return;
    }
    [self configureForInfiniteScroll];
    [super layoutSubviews];
}

#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.dataSourceBridge.receiver respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        NSInteger sectionsNum = [self.dataSourceBridge.receiver numberOfSectionsInTableView:tableView];
        return sectionsNum * (_isInfiniteScroll && !isLessThanAScreenCellsNum ? 3 : 1);
    }
    return 1;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self.dataSourceBridge.receiver respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        return [self.dataSourceBridge.receiver tableView:tableView titleForHeaderInSection:[self getSectionForSection:section]];
    }
    return @"";
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if ([self.dataSourceBridge.receiver respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
        return [self.dataSourceBridge.receiver tableView:tableView titleForFooterInSection:[self getSectionForSection:section]];
    }
    return @"";
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.dataSourceBridge.receiver respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [self.dataSourceBridge.receiver tableView:tableView viewForHeaderInSection:[self getSectionForSection:section]];
    }
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self.dataSourceBridge.receiver respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [self.dataSourceBridge.receiver tableView:tableView viewForFooterInSection:[self getSectionForSection:section]];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    totalRowsNum = [self.dataSourceBridge.receiver tableView:tableView numberOfRowsInSection:section];
    if ([self numberOfSectionsInTableView:tableView] > 1) {
        return totalRowsNum;
    }
    return totalRowsNum * (_isInfiniteScroll && !isLessThanAScreenCellsNum ? 3 : 1);
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSourceBridge.receiver tableView:tableView cellForRowAtIndexPath:[self getIndexPathForIndexPath:indexPath]];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end
