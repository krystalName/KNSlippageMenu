//
//  KNSlippageConfig.m
//  KNSlippageMenu
//
//  Created by 刘凡 on 2017/12/15.
//  Copyright © 2017年 leesang. All rights reserved.
//

#import "KNSlippageConfig.h"



@implementation KNSlippageConfig


//默认初始化
+(instancetype)defaultConfiguration
{
    return [KNSlippageConfig configurationWithDistance:KSCREEN_WIDTH maskAlpha:0.4 scaleY:1 direction:KNSlippageDirectionLeft backImage:nil];
}


//实例初始化
-(instancetype)initWithDistance:(float)distance maskAlpha:(float)alpha scaleY:(float)scaleY direction:(KNSlippageDirection)direction backImage:(UIImage *)backImage
{
    if (self = [super init]) {
        
        _distance  = distance;
        _backGroundAlpha = alpha;
        _direction = direction;
        _backImage = backImage;
        _scaleY = scaleY;
    }
    return self;
}

//类初始化
+(instancetype)configurationWithDistance:(float)distance maskAlpha:(float)alpha scaleY:(float)scaleY direction:(KNSlippageDirection)direction backImage:(UIImage *)backImage
{
   return  [[self alloc]initWithDistance:distance maskAlpha:alpha scaleY:scaleY direction:direction backImage:backImage];
}

-(float)distance{
    if (_direction == 0) {
        return KSCREEN_WIDTH *0.75;
    }
    return _distance;
}

-(float)backGroundAlpha{
    if (_backGroundAlpha == 0) {
        return 0.4;
    }
    return _backGroundAlpha;
}

-(float)scaleY{
    if (_scaleY == 0) {
        return 1.0;
    }
    return _scaleY;
}

@end
