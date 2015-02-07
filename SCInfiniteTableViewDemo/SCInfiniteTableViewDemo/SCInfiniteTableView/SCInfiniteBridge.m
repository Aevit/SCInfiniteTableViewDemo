//
//  SCInfiniteBridge.m
//  SCInfiniteTableViewDemo
//
//  Created by Aevitx on 14/12/12.
//  Copyright (c) 2014年 Aevit. All rights reserved.
//

#import "SCInfiniteBridge.h"

@implementation SCInfiniteBridge

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([_middleBridge respondsToSelector:aSelector]) {
        return _middleBridge;
    }
    if ([_receiver respondsToSelector:aSelector]) {
        return _receiver;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([_middleBridge respondsToSelector:aSelector]) {
        return YES;
    }
    if ([_receiver respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

@end
