//
//  KNLateralSlideAnimat.h
//  KNSlippageMenu
//
//  Created by 刘凡 on 2017/12/19.
//  Copyright © 2017年 leesang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNSlippageConfig.h"
#import "KNInteractiveTransition.h"

@interface KNLateralSlideAnimat : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) KNSlippageConfig *slippageConfig;
@property (nonatomic, assign) KNTransitionAnimation  Animatio;


///实例方法创建
- (instancetype)initWithSilppageConfig:(KNSlippageConfig *)slippageConfig;

///类方法创建
+ (instancetype)lateralSideAnimatorWithSilppageConfig:(KNSlippageConfig *)slippageConfig;


@end
