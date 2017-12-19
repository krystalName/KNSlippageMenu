//
//  KNLateralSlideAnimat.m
//  KNSlippageMenu
//
//  Created by 刘凡 on 2017/12/19.
//  Copyright © 2017年 leesang. All rights reserved.
//

#import "KNLateralSlideAnimat.h"
#import "KNTransitionMethod.h"

@interface KNLateralSlideAnimat()

///出现的配置
@property(nonatomic, strong)KNInteractiveTransition *interactiveShow;
///隐藏的配置
@property(nonatomic, strong)KNInteractiveTransition *interactiveHidden;

@end

@implementation KNLateralSlideAnimat

-(instancetype)initWithSilppageConfig:(KNSlippageConfig *)slippageConfig
{
    if (self = [super init]) {
        _slippageConfig = slippageConfig;
    }
    return self;
}

+(instancetype)lateralSideAnimatorWithSilppageConfig:(KNSlippageConfig *)slippageConfig
{
    return [[self alloc] initWithSilppageConfig:slippageConfig];
}

-(void)setSlippageConfig:(KNSlippageConfig *)slippageConfig{
    _slippageConfig = slippageConfig;
    [self.interactiveShow setValue:slippageConfig forKey:@"slippageConfig"];
    [self.interactiveHidden setValue:slippageConfig forKey:@"slippageConfig"];
}



@end
