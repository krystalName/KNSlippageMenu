//
//  KNInteractiveTransition.m
//  KNSlippageMenu
//
//  Created by 刘凡 on 2017/12/18.
//  Copyright © 2017年 leesang. All rights reserved.
//

#import "KNInteractiveTransition.h"

@interface KNInteractiveTransition()

///弱引用weakViewController
@property(nonatomic, weak) UIViewController *weakVC;

@property(nonatomic, assign) KNTransitionMethodType MethodType;

///是否打开手势
@property(nonatomic, assign) BOOL openEdgeGesture;

///滑动方向
@property(nonatomic, assign) KNSlippageDirection direction;

///定时器
@property(nonatomic, strong) CADisplayLink *link;

//配置block
@property(nonatomic, copy) void (^transitionBlock)(void);

@end

@implementation KNInteractiveTransition
{
    ///百分比
    CGFloat _percent;
    ///保持计数
    CGFloat _remaincount;
    ///完成
    BOOL _toFinish;
    ///曾经百分比
    CGFloat _oncePercent;
}




///初始化方法。 设置类型。添加两个通知
-(instancetype)initWithTransitionMethodType:(KNTransitionMethodType)MethodType
{
    if (self = [super init]) {
        _MethodType = MethodType;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(singleTap) name:KNLateralSlideTapNotication object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHiddenPanGesture:) name:KNLateralSlidePanNotication object:nil];
    }
    
    return self;
}
///类方法
+(instancetype)interactiveWithTransitionMethodType:(KNTransitionMethodType)MethodType
{
    return [[self alloc] initWithTransitionMethodType:MethodType];
}

///dismissView
-(void)singleTap{
    [self.weakVC dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 懒加载
-(CADisplayLink *)link{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _link;
}


///给vc添加一个手势。隐藏手势
-(void)addPanGestureForViewController:(UIViewController *)viewController
{
    self.weakVC = viewController;
    
    //添加隐藏点击手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleShowPanGestur:)];
    [viewController.view addGestureRecognizer:panGesture];
}

-(void)handleShowPanGestur:(UIPanGestureRecognizer *)panGesture{
    if (_MethodType == KNTransitionMethodTypeHideed) {
        return;
    }
    [self handleGesture:panGesture];
}


//统一处理隐藏
-(void)handleHiddenPanGesture:(NSNotification *)note{
    if (_MethodType == KNTransitionMethodTypeShow) return;
    UIPanGestureRecognizer *panGesture = note.object;
    [self handleGesture:panGesture];
}

//隐藏
-(void)hiddenBeganTranslationX:(CGFloat )x{
    
    
    if ((x > 0 && _direction == KNSlippageDirectionLeft ) || (x < 0 && _direction == KNSlippageDirectionRight)) return;
    
    //开启vc里面的互动
    self.interacting = YES;
    [self.weakVC dismissViewControllerAnimated:YES completion:nil];
}

//显示
-(void)showBeganTranslationX:(CGFloat)x gesture:(UIPanGestureRecognizer *)PanGesture{
    
    //显示状态就不做任何处理
    if ((x < 0 && _direction == KNSlippageDirectionLeft) || (x > 0 && _direction == KNSlippageDirectionRight)) return;
    
    CGFloat locX = [PanGesture locationInView:_weakVC.view].x;
    
    //判断显示状态不做处理
    if (_openEdgeGesture && ((locX > 50 && _direction == KNSlippageDirectionLeft) || (locX < CGRectGetWidth(_weakVC.view.frame) - 50 && _direction == KNSlippageDirectionRight))) {
        return;
    }
    //否则就能点击交互
    self.interacting = YES;
    if (_transitionBlock) {
        _transitionBlock();
    }
    
}



-(void)handleGesture:(UIPanGestureRecognizer *)panGesture
{
    CGFloat x = [panGesture locationInView:panGesture.view].x;

    _percent = 0;
    
    _percent = x / panGesture.view.frame.size.width;
    
    if ( (_direction == KNSlippageDirectionRight && _MethodType == KNTransitionMethodTypeShow) ||
       (_direction == KNSlippageDirectionLeft && _MethodType == KNTransitionMethodTypeHideed) ) {
        _percent = -_percent;
    }
    
    switch (panGesture.state) {
            //点击开始
        case UIGestureRecognizerStateBegan:
        {
            if (_MethodType == KNTransitionMethodTypeShow) {
                [self showBeganTranslationX:x gesture:panGesture];
            }else
            {
                [self hiddenBeganTranslationX:x];
            }
            break;
        }
         //开始改变
        case UIGestureRecognizerStateChanged:
        {
            _percent = fminf(fmaxf(_percent, 0.001),1.0);
            [self updateInteractiveTransition:_percent];
            break;
        }
            //结束
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateEnded:
        {
            self.interacting = NO;
            if (_percent > 0.5) {
                [self startDisplayerLink:_percent toFinish:YES];
            }else{
                [self startDisplayerLink:_percent toFinish:NO];
            }
            break;
        }
            
        default:
            break;
    }
    
}



-(void)startDisplayerLink:(CGFloat)percent toFinish:(BOOL)finish{
    _toFinish = finish;
    //保持时间
    CGFloat remainDuration = finish ? self.duration * (1 - percent) : self.duration * percent;
    _remaincount = 60 * remainDuration;
    _oncePercent = finish ? (1 - percent) / _remaincount : percent / _remaincount;
    
    [self stopDisplayerLink];
}

#pragma mark - displayerLink
- (void)starDisplayLink {
    [self link];
}

- (void)stopDisplayerLink {
    [self.link invalidate];
    self.link = nil;
}


- (void)update {
    
    if (_percent >= 1 && _toFinish) {
        [self stopDisplayerLink];
        [self finishInteractiveTransition];
    }else if (_percent <= 0 && !_toFinish) {
        [self stopDisplayerLink];
        [self cancelInteractiveTransition];
    }else {
        if (_toFinish) {
            _percent += _oncePercent;
        }else {
            _percent -= _oncePercent;
        }
        _percent = fminf(fmaxf(_percent, 0.0), 1.0);
        [self updateInteractiveTransition:_percent];
    }
}




-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
