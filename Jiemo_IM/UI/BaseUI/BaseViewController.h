//
//  BaseViewController.h
//  JM_IM_Demo
//
//  Created by merrill on 2018/5/15.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationController.h"

@interface BaseViewController : UIViewController

+ (NavigationController *)sharedNavigation;

@end
