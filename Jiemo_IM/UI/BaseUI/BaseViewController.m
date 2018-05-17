//
//  BaseViewController.m
//  JM_IM_Demo
//
//  Created by merrill on 2018/5/15.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

+ (NavigationController *)sharedNavigation {
    id baseViewController = [self new];
    NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:baseViewController];
    
    return navigationController;
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
