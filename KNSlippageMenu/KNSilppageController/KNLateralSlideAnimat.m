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

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [KNTransitionMethod transitionWithType:KNTransitionMethodTypeShow AnimationType:_Animatio SlippageConfig:_slippageConfig];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [KNTransitionMethod transitionWithType:KNTransitionMethodTypeHideed AnimationType:_Animatio SlippageConfig:_slippageConfig];
}

//Presenttation
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return self.interactiveShow.interacting ? self.interactiveShow : nil;
}
//dismiss
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    
    return self.interactiveHidden.interacting ? self.interactiveHidden : nil;
}



@end
