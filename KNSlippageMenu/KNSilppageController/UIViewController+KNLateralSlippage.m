//
//  UIViewController+KNLateralSlippage.m
//  KNSlippageMenu
//
//  Created by 刘凡 on 2017/12/19.
//  Copyright © 2017年 leesang. All rights reserved.
//

#import "UIViewController+KNLateralSlippage.h"
#import "KNInteractiveTransition.h"
#import "KNTransitionMethod.h"
#import <objc/runtime.h>

@implementation UIViewController (KNLateralSlippage)

-(void)kn_ShowDrawerViewController:(UIViewController *)viewController animationType:(KNTransitionAnimation)AnimationType configuration:(KNSlippageConfig *)Slippageconfig
{
    if (viewController == nil) return;
    
    if (Slippageconfig == nil )
        Slippageconfig = [KNSlippageConfig defaultConfiguration];
    
    
    KNLateralSlideAnimat *animator = objc_getAssociatedObject(self, &KNLateralSlideAnimatorKey);
    
    if (animator == nil) {
        animator = [KNLateralSlideAnimat lateralSideAnimatorWithSilppageConfig:Slippageconfig];
        //用retime重新设置
        objc_setAssociatedObject(viewController, &KNLateralSlideAnimatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    viewController.transitioningDelegate = animator;
    
    KNInteractiveTransition *interactiveHidden = [KNInteractiveTransition interactiveWithTransitionMethodType:KNTransitionMethodTypeHideed];
    //设置weakVC
    [interactiveHidden setValue:viewController forKey:@"weakVC"];
    //设置滑动方向
    [interactiveHidden setValue:@(Slippageconfig.direction) forKey:@"direction"];

    [animator setValue:interactiveHidden forKey:@"interactiveHidden"];
    //设置配置Config
    [animator setSlippageConfig:Slippageconfig];
    animator.Animatio = AnimationType;
    
    [self presentViewController:viewController animated:YES completion:nil];
}


-(void)kn_registerShowIntractiveWithEdgeGesture:(BOOL)openEdgeGesture direction:(KNSlippageDirection)direction transitionBlock:(void (^)(void))transitionBlock
{
    
    //动画。
    KNLateralSlideAnimat *animat = [KNLateralSlideAnimat lateralSideAnimatorWithSilppageConfig:nil];
    //delegate
    self.transitioningDelegate = animat;
    
    //设置动画
    objc_setAssociatedObject(self, &KNLateralSlideAnimatorKey, animat, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //配置
    KNInteractiveTransition *InteractiveShow = [KNInteractiveTransition interactiveWithTransitionMethodType:KNTransitionMethodTypeShow];
    [InteractiveShow addPanGestureForViewController:self];
    [InteractiveShow setValue:@(openEdgeGesture) forKey:@"openEdgeGesture"];
    [InteractiveShow setValue:transitionBlock forKey:@"transitionBlock"];
    [InteractiveShow setValue:@(direction) forKey:@"direction"];
    //设置动画
    [animat setValue:InteractiveShow forKey:@"interactiveShow"];
    
}


-(void)kn_pushViewController:(UIViewController *)viewController
{
    //获取rootViewController
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav;
    
    //判断
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbar = (UITabBarController *)rootVC;
        NSInteger index = tabbar.selectedIndex;
        nav = tabbar.childViewControllers[index];
    }
    else if ([rootVC isKindOfClass:[UINavigationController class]]){
        nav = (UINavigationController *)rootVC;
    }
    else if ([rootVC isKindOfClass:[UIViewController class]]){
        NSLog(@"Tihs NO UINavigationController");
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [nav pushViewController:viewController animated:NO];
    
}

@end
