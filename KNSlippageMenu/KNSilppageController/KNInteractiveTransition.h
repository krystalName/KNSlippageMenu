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

//是否可以互动
@property(nonatomic, assign) BOOL interacting;

@end
