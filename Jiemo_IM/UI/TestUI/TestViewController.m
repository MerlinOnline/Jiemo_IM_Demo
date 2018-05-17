//
//  TestViewController.m
//  Jiemo_IM
//
//  Created by merrill on 2018/5/15.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "TestViewController.h"
#import "IMClientManager.h"
#import "ChatViewController.h"

@interface TestViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTK;
@property (weak, nonatomic) IBOutlet UITextField *friendIdTf;


@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)loginBtnClick:(id)sender {
    
    [[IMClientManager sharedInstance] loginImplWithUserId:self.accountTF.text andUserToken:self.passwordTK.text];
}

- (IBAction)logoutBtnClick:(id)sender {
    [[IMClientManager sharedInstance] logoutImpl];
}

- (IBAction)senderMsgBtnClick:(id)sender {
    [self.friendIdTf resignFirstResponder];
    ChatViewController *chatVC = [ChatViewController new];
    chatVC.friendId = self.friendIdTf.text;
    [self.navigationController pushViewController:chatVC animated:YES];
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
