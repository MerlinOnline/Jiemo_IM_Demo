//
//  NavigationController.m
//  JM_IM_Demo
//
//  Created by merrill on 2018/5/15.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    __weak typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //修复navigationController侧滑关闭失效的问题
        self.interactivePopGestureRecognizer.delegate = (id)weakSelf;
    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

// 重写自定义的UINavigationController中的push方法
// 处理tabbar的显示隐藏
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    if (self.childViewControllers.count==1) {
        viewController.hidesBottomBarWhenPushed = YES; //viewController是将要被push的控制器
    }
    [super pushViewController:viewController animated:animated];
}

+(void)load{
//    [[UINavigationBar appearance] setBarTintColor:[UIColor blueColor]];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]]; // 按钮颜色
//    [UINavigationBar appearance].backItem.title = @"";
//    [UINavigationBar appearance].translucent = NO;
//    NSDictionary *titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor] ,NSFontAttributeName : [UIFont systemFontOfSize:18]};
//    [[UINavigationBar appearance] setTitleTextAttributes:titleTextAttributes];
//    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
//    
//    
//    [[UINavigationBar appearance]  setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
