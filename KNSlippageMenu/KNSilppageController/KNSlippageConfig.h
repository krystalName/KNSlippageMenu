//
//  KNSlippageConfig.h
//  KNSlippageMenu
//
//  Created by 刘凡 on 2017/12/15.
//  Copyright © 2017年 leesang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define KSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width


typedef NS_ENUM(NSInteger, KNSlippageDirection){
    KNSlippageDirectionLeft = 0, //左侧滑出
    KNSlippageDirectionRight   //右侧滑出
};

@interface KNSlippageConfig : NSObject

///根据控制器可偏移的距离，默认为屏幕的4/3
@property(nonatomic, assign)float distance;

///背景的透明度 默认0.3
@property(nonatomic, assign)float backGroundAlpha;

///根据控制器在y方向的缩放。 默认设为不缩放
@property(nonatomic, assign)float scaleY;

///菜单滑出的方向
@property(nonatomic, assign)KNSlippageDirection direction;

//动画切换过程中， 最底层的背景图片
@property(nonatomic, strong)UIImage *backImage;


/**
 默认配置

 @return 配置对象本身
 */
+(instancetype)defaultConfiguration;


/**
 创建一个配置对象的实例方法

 @param distance 便宜距离
 @param alpha 透明度
 @param scaleY Y方向的缩放
 @param direction 滑出方向
 @param backImage 动画过程中。最底层的背景图片
 @return 配置对象本身
 */
- (instancetype)initWithDistance:(float)distance maskAlpha:(float)alpha scaleY:(float)scaleY direction:(KNSlippageDirection)direction backImage:(UIImage *)backImage;


/**
 创建一个配置对象的类方法
 
 @param distance 偏移距离
 @param alpha 遮罩的透明度
 @param scaleY y方向的缩放
 @param direction 滑出方向
 @param backImage 动画切换过程中，最底层的背景图片
 @return 配置对象本身
 */
+ (instancetype)configurationWithDistance:(float)distance maskAlpha:(float)alpha scaleY:(float)scaleY direction:(KNSlippageDirection)direction backImage:(UIImage *)backImage;

@end
