//
//  MainViewController.m
//  JM_IM_Demo
//
//  Created by merrill on 2018/5/15.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "MainViewController.h"
#import "TestViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"homeText", nil);
    
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    testButton.frame = CGRectMake(100, 100, 200, 50);
    [testButton setTitle:@"testView" forState:UIControlStateNormal];
    [testButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    
}

- (void)testButtonClick:(id)sender {
    
    TestViewController *testVC= [[TestViewController alloc]initWithNibName:@"TestViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:testVC animated:YES];
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
