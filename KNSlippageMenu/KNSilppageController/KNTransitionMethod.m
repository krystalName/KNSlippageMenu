//
//  KNTransitionMethod.m
//  KNSlippageMenu
//
//  Created by 刘凡 on 2017/12/15.
//  Copyright © 2017年 leesang. All rights reserved.
//

#import "KNTransitionMethod.h"
#import <objc/runtime.h>

@interface KNTransitionMethod ()

@property (nonatomic, weak)KNSlippageConfig *SlippageConfig;


@end

@implementation KNTransitionMethod
{
    KNTransitionMethodType _MethodType;
    KNTransitionAnimation _AnimationType;
}


-(instancetype)initWithMethodType:(KNTransitionMethodType)methodType AnimationType:(KNTransitionAnimation)animationType SlippageConfig:(KNSlippageConfig *)SlippageConfig
{
    if (self = [super init]) {
        _MethodType = methodType;
        _AnimationType = animationType;
        _SlippageConfig = SlippageConfig;

    }
    return self;
}


+(instancetype)transitionWithType:(KNTransitionMethodType)methodType AnimationType:(KNTransitionAnimation)animationType SlippageConfig:(KNSlippageConfig *)SlippageConfig
{
    return [[self alloc] initWithMethodType:methodType AnimationType:animationType SlippageConfig:SlippageConfig];
}


#pragma mark - UIViewControllerAnimatedTransitioning
-(NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return _MethodType == KNTransitionMethodTypeShow ? 0.25f : 0.25f;
}

-(void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    switch (_MethodType) {
            //判断如果是出现的情况下。 跳转到 animationViewShow
        case KNTransitionMethodTypeShow:
            [self animationViewShow:transitionContext];
            break;
            //否则就是隐藏的情况下
        case KNTransitionMethodTypeHideed:
            [self animationViewHidden:transitionContext];
            break;
        default:
            break;
    }
}

#pragma mark - privateMethods

-(void)animationViewShow:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (_AnimationType) {
            //判断如果是默认动画情况下
        case KNTransitionAnimationDefault:
            [self defaultAnimationWithContext:transitionContext];
            break;
            //掩盖的动画情况下
         case KNTransitionAnimationMask:
            [self maskAnimationWithContext:transitionContext];
            break;
        default:
            break;
    }
}

//隐藏view的自定义动画
-(void)animationViewHidden:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    MaskView *maskView = [MaskView shareInstance];
    //从集合里面找。 如果找到了这个maskView 就移除
    for (UIView *view in toVC.view.subviews) {
        if (![maskView.toViewSubViews containsObject:view]) {
            [view removeFromSuperview];
        }
    }
    
    UIView *containerView = [transitionContext containerView];
    UIImageView *backImageView;
    if ([containerView.subviews.firstObject isKindOfClass:[UIImageView class]])
        backImageView = containerView.subviews.firstObject;
    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.01 relativeDuration:0.99 animations:^{
            toVC.view.transform = CGAffineTransformIdentity;
            fromVC.view.transform = CGAffineTransformIdentity;
            maskView.alpha = 0;
            backImageView.transform = CGAffineTransformMakeScale(1.4, 1.4);
        }];
        
    } completion:^(BOOL finished) {
        if (![transitionContext transitionWasCancelled]) {
            maskView.toViewSubViews = nil;
            [MaskView releaseInstance];
            [backImageView removeFromSuperview];
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}

//默认跳转的动画
-(void)defaultAnimationWithContext:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    //自定义跳转动画
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //创建蒙版
    MaskView *maskView = [MaskView shareInstance];
    maskView.frame = fromVC.view.bounds;
    //加上去
    [fromVC.view addSubview:maskView];
    UIView *containerView = [transitionContext containerView];
    
    UIImageView *imageView;
    if (self.SlippageConfig.backImage) {
        imageView = [[UIImageView alloc]initWithFrame:containerView.bounds];
        imageView.image = self.SlippageConfig.backImage;
        imageView.transform = CGAffineTransformMakeScale(1.4, 1.4);
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    [containerView addSubview:imageView];
    
    CGFloat width = self.SlippageConfig.distance;
    CGFloat x = - width / 2;
    CGFloat ret = 1;
    if (self.SlippageConfig.direction == KNSlippageDirectionRight) {
        x = KSCREEN_WIDTH - width /2;
        ret = -1;
    }
    toVC.view.frame = CGRectMake(x, 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(ret * width, 0);
    CGAffineTransform t2 = CGAffineTransformMakeScale(1.0, self.SlippageConfig.scaleY);
    CGAffineTransform fromVCTransform = CGAffineTransformConcat(t1, t2);
    CGAffineTransform toVCTransform;
    
    if (self.SlippageConfig.direction == KNSlippageDirectionRight){
        toVCTransform = CGAffineTransformMakeTranslation(ret * (x - CGRectGetWidth(containerView.frame) + width), 0);
    }else{
        toVCTransform = CGAffineTransformMakeTranslation(ret * width / 2, 0);
    }
    
    //用动画去处理
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:0 animations:^{
       
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0 animations:^{
            fromVC.view.transform = fromVCTransform;
            toVC.view.transform = toVCTransform;
            imageView.transform = CGAffineTransformIdentity;
            maskView.alpha = self.SlippageConfig.backGroundAlpha;
        }];
        
    } completion:^(BOOL finished) {
        if (![transitionContext transitionWasCancelled]) {
            maskView.userInteractionEnabled = YES;
            maskView.toViewSubViews = fromVC.view.subviews;
            [transitionContext completeTransition:YES];
            [containerView addSubview:fromVC.view];
        }else{
            [imageView removeFromSuperview];
            [MaskView releaseInstance];
            [transitionContext completeTransition:NO];
        }
    }];
    
}

- (void)maskAnimationWithContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    MaskView *maskView = [MaskView shareInstance];
    maskView.frame = fromVC.view.bounds;
    [fromVC.view addSubview:maskView];
    
    UIView *containerView = [transitionContext containerView];
    
    CGFloat width = self.SlippageConfig.distance;
    CGFloat x = - width;
    CGFloat ret = 1;
    if (self.SlippageConfig.direction == KNSlippageDirectionRight) {
        x = KSCREEN_WIDTH;
        ret = -1;
    }
    toVC.view.frame = CGRectMake(x, 0, width, CGRectGetHeight(containerView.frame));
    
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    
    CGAffineTransform toVCTransiform = CGAffineTransformMakeTranslation(ret * width , 0);
    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:0 animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0 animations:^{
            toVC.view.transform = toVCTransiform;
            maskView.alpha = self.SlippageConfig.backGroundAlpha;
        }];
        
    } completion:^(BOOL finished) {
        
        if (![transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:YES];
            maskView.toViewSubViews = fromVC.view.subviews;
            [containerView addSubview:fromVC.view];
            [containerView bringSubviewToFront:toVC.view];
            maskView.userInteractionEnabled = YES;
        }else {
            [MaskView releaseInstance];
            [transitionContext completeTransition:NO];
        }
    }];
    
    
}


@end


@implementation MaskView

static MaskView * kn_shareInstance = nil;

static dispatch_once_t kn_onceToken;

+ (instancetype)shareInstance {
    dispatch_once(&kn_onceToken, ^{
        kn_shareInstance = [[MaskView alloc] init];
    });
    return kn_shareInstance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
        
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self addGestureRecognizer:pan];
        
    }
    return self;
}

- (void)singleTap {
    [[NSNotificationCenter defaultCenter] postNotificationName:KNLateralSlideTapNotication object:self];
}

- (void)handleGesture:(UIPanGestureRecognizer *)pan {
    [[NSNotificationCenter defaultCenter] postNotificationName:KNLateralSlidePanNotication object:pan];
    
}


+(void)releaseInstance
{
    [kn_shareInstance removeFromSuperview];
    kn_onceToken = 0;
    kn_shareInstance = nil;
}


@end

NSString *const KNLateralSlideMaskViewKey = @"KNLateralSlideMaskViewKey";
NSString *const KNLateralSlideAnimatorKey = @"KNLateralSlideAnimatorKey";

NSString *const KNLateralSlidePanNotication = @"KNLateralSlidePanNotication";
NSString *const KNLateralSlideTapNotication = @"KNLateralSlideTapNotication";

