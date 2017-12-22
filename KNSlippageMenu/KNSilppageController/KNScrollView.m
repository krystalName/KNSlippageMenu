//
//  KNScrollView.m
//  KNSlippageMenu
//
//  Created by 刘凡 on 2017/12/22.
//  Copyright © 2017年 leesang. All rights reserved.
//

#import "KNScrollView.h"

@implementation KNScrollView

/**
 *  重写手势，如果是左滑，则禁用掉scrollview自带的
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        if([pan translationInView:self].x > 0.0f && self.contentOffset.x == 0.0f) {
            return NO;
        }
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}


@end
