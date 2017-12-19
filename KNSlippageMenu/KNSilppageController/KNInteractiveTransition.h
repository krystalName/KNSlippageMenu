//
//  KNInteractiveTransition.h
//  KNSlippageMenu
//
//  Created by 刘凡 on 2017/12/18.
//  Copyright © 2017年 leesang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNTransitionMethod.h"

@interface KNInteractiveTransition : UIPercentDrivenInteractiveTransition

///是否可以互动
@property(nonatomic, assign) BOOL interacting;
///滑动配置
@property(nonatomic, weak)KNSlippageConfig *slippageConfig;

-(instancetype)initWithTransitionMethodType:(KNTransitionMethodType )MethodType;
+(instancetype)interactiveWithTransitionMethodType:(KNTransitionMethodType)MethodType;

- (void)addPanGestureForViewController:(UIViewController *)viewController;
@end
