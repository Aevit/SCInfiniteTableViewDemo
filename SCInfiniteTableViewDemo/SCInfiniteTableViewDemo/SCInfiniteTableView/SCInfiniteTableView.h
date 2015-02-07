//
//  SCInfiniteTableView.h
//  SCInfiniteTableViewDemo
//
//  Created by Aevitx on 14/12/12.
//  Copyright (c) 2014年 Aevit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCInfiniteTableView : UITableView

@property (nonatomic, assign) BOOL isInfiniteScroll;

- (void)needDealloc;

@end
