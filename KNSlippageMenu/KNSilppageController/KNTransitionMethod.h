//
//  KNTransitionMethod.h
//  KNSlippageMenu
//
//  Created by 刘凡 on 2017/12/15.
//  Copyright © 2017年 leesang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KNSlippageConfig.h"


//状态
typedef NS_ENUM(NSUInteger, KNTransitionMethodType){
    KNTransitionMethodTypeShow = 0,
    KNTransitionMethodTypeHideed
};

///动画类型
typedef NS_ENUM(NSInteger , KNTransitionAnimation){
    KNTransitionAnimationDefault = 0,
    KNTransitionAnimationMask
};



@interface KNTransitionMethod : NSObject


/**
 实例方法创建

 @param methodType 状态。 是隐藏还是现实
 @param animationType 动画。默认的还是mask
 @param SlippageConfig 滑动的基本配置
 @return 返回本身
 */
-(instancetype)initWithMethodType:(KNTransitionMethodType)methodType AnimationType:(KNTransitionAnimation)animationType SlippageConfig:(KNSlippageConfig *)SlippageConfig;

/**
 类方法创建
 
 @param methodType 状态。 是隐藏还是现实
 @param animationType 动画。默认的还是mask
 @param SlippageConfig 滑动的基本配置
 @return 返回本身
 */
+(instancetype)transitionWithType:(KNTransitionMethodType)methodType AnimationType:(KNTransitionAnimation)animationType SlippageConfig:(KNSlippageConfig *)SlippageConfig;

@end

@interface MaskView :UIView <UIGestureRecognizerDelegate>

@property (nonatomic, copy)NSArray *toViewSubViews;

/**
 创建单例
 
 @return 返回本身
 */
+(instancetype)shareInstance;

///释放单例
+(void)releaseInstance;

@end


//所有通知的固定名字
UIKIT_EXTERN NSString *const KNLateralSlideAnimatorKey;
UIKIT_EXTERN NSString *const KNLateralSlideMaskViewKey;
UIKIT_EXTERN NSString *const KNLateralSlideInterativeKey;

UIKIT_EXTERN NSString *const KNLateralSlidePanNotication;
UIKIT_EXTERN NSString *const KNLateralSlideTapNotication;
