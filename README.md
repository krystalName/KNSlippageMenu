# KNSlippageMenu
简易使用测滑菜单～   加在任何的VC上。 没有使用限制～     能给我星星最好了。～

## 先来一张效果图~
![](https://github.com/krystalName/KNSlippageMenu/blob/master/SlippageMenu.gif)

 ## -------实现说明------
 
 ### 这个项目分为4各部分实现   
 + 1.创建一个类。 作为滑动菜单的配置。 设置一些基础。比如菜单的宽度。背景的透明度折射的角度。滑动方向
 + 2.创建一个类。作为菜单的所有实现方法类。就是一些处理滑动。点击后。设置加上一个maskView 设置一些需要的常量名称。 作为通知的名字
 + 3.创建一个类。处理这个菜单所有的手势方法。 然后计算菜单的设置方向。做一系列的改变
 + 4.创建一个类。处理自定义跳转动画。把上面三个类的方法结合起来。～ 
 + 5.创建一个扩展类。为UIViewController 的扩展类。 方便嵌入使用～ 设置3个方法。 注册菜单（注册手势）。 显示菜单。跳转到其他VC~
 
 
 ## ------ 使用说明 -----
 
``` objc
-(void)viewDidLoad{
    //注册手势驱动
    __weak typeof (self)weakSelf = self;
    
    //默认滑动手势向左边
    [self kn_registerShowIntractiveWithEdgeGesture:NO direction:KNSlippageDirectionLeft transitionBlock:^{
        [weakSelf leftClick];
    }];
 } 
    
```

```objc 
///调用方法
-(void)leftClick{
    
    //创建一个类
    LeftViewController *vc = [[LeftViewController alloc]init];
    
    //默认是滑动菜单。  使用maks是覆盖在VC上面出现的菜单
    [self kn_ShowDrawerViewController:vc animationType:KNTransitionAnimationDefault configuration:nil];
 
}

```
