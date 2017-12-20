//
//  UIViewController+KNLateralSlippage.h
//  KNSlippageMenu
//
//  Created by 刘凡 on 2017/12/19.
//  Copyright © 2017年 leesang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNLateralSlideAnimat.h"
#import "KNSlippageConfig.h"

@interface UIViewController (KNLateralSlippage)



/**
 呼出测滑控制器的方法(主要)

 @param viewController 需要测滑显示出来的控制器
 @param AnimationType 测滑过程的动画类型
 @param Slippageconfig 测滑过程中一些参数配置。如果传nil 会创建一个默认配置参数
 */
-(void)kn_ShowDrawerViewController:(UIViewController *)viewController
                     animationType:(KNTransitionAnimation)AnimationType
                     configuration:(KNSlippageConfig *)Slippageconfig;



/**
 注册手势驱动方法。调用之后会添加一个支持测滑手势到本控制器

 @param openEdgeGesture 是否开启边缘手势,边缘手势范围里边缘50以内
 @param direction 呼出测滑的方向。默认left
 @param transitionBlock 手势过程中执行的操作。传正点presenr的事件就可以了
 */
-(void)kn_registerShowIntractiveWithEdgeGesture:(BOOL)openEdgeGesture
                                      direction:(KNSlippageDirection)direction
                                transitionBlock:(void(^)(void))transitionBlock;


/**
 自定义的push方法
 因为侧滑出来的控制器实际上是通过present出来的，这个时候是没有导航控制器的，而侧滑出来的控制器上面的一些点击事件需要再push下一个控制器的时候，我们只能通过寻找到根控制器找到对应的导航控制器再进行push操作，QQ的效果能证明是这么实现的
 @param viewController 需要push出来的控制器
 */
-(void)kn_pushViewController:(UIViewController *)viewController;

@end
