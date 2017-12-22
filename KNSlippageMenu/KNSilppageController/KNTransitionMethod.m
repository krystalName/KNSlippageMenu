//
//  KNTransitionMethod.m
//  KNSlippageMenu
//
//  Created by 刘凡 on 2017/12/15.
//  Copyright © 2017年 leesang. All rights reserved.
//

#import "KNTransitionMethod.h"
//#import <objc/runtime.h>

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
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return _MethodType == KNTransitionMethodTypeShow ? 0.25f : 0.25f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    switch (_MethodType) {
        case KNTransitionMethodTypeShow:
            [self animationViewShow:transitionContext];
            break;
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
    if (_AnimationType == KNTransitionAnimationDefault)
    {
        [self defaultAnimationWithContext:transitionContext];
        
    }else if (_AnimationType == KNTransitionAnimationMask)
    {
        [self maskAnimationWithContext:transitionContext];
        
    }
}

- (void)defaultAnimationWithContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    MaskView *maskView = [MaskView shareInstance];
    maskView.frame = fromVC.view.bounds;
    [fromVC.view addSubview:maskView];
    UIView *containerView = [transitionContext containerView];
    
    UIImageView *imageV;
    if (self.SlippageConfig.backImage) {
        imageV = [[UIImageView alloc] initWithFrame:containerView.bounds];
        imageV.image = self.SlippageConfig.backImage;
        imageV.transform = CGAffineTransformMakeScale(1.4, 1.4);
        imageV.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    [containerView addSubview:imageV];
    
    CGFloat width = self.SlippageConfig.distance;
    CGFloat x = - width / 2;
    CGFloat ret = 1;
    if (self.SlippageConfig.direction == KNSlippageDirectionRight) {
        x = KSCREEN_WIDTH - width / 2;
        ret = -1;
    }
    toVC.view.frame = CGRectMake(x, 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(ret * width, 0);
    CGAffineTransform t2 = CGAffineTransformMakeScale(1.0, self.SlippageConfig.scaleY);
    CGAffineTransform fromVCTransform = CGAffineTransformConcat(t1, t2);
    CGAffineTransform toVCTransform;
    if (self.SlippageConfig.direction == KNSlippageDirectionRight) {
       toVCTransform = CGAffineTransformMakeTranslation(ret * (x - CGRectGetWidth(containerView.frame) + width), 0);
    }else {
        toVCTransform = CGAffineTransformMakeTranslation(ret * width / 2, 0);
    }
    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:0 animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0 animations:^{
            
            fromVC.view.transform = fromVCTransform;
            toVC.view.transform = toVCTransform;
            imageV.transform = CGAffineTransformIdentity;
            maskView.alpha = self.SlippageConfig.maskAlpha;
            
        }];
        
    } completion:^(BOOL finished) {
        if (![transitionContext transitionWasCancelled]) {
            maskView.userInteractionEnabled = YES;
            maskView.toViewSubViews = fromVC.view.subviews;
            [transitionContext completeTransition:YES];
            [containerView addSubview:fromVC.view];
        }else {
            [imageV removeFromSuperview];
            [MaskView releaseInstance];
            [transitionContext completeTransition:NO];
        }
    }];
    
}

- (void)animationViewHidden:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    MaskView *maskView = [MaskView shareInstance];
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
            maskView.alpha = self.SlippageConfig.maskAlpha;
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

