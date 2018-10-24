//
//  TouchVC.m
//  DemoMotion
//
//  Created by Herman on 2018/10/24.
//  Copyright © 2018年 Herman. All rights reserved.
//

#import "TouchVC.h"
#import "SYMotionHeader.h"

@interface TouchVC ()

@end

@implementation TouchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"指纹识别";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"touch" style:UIBarButtonItemStyleDone target:self action:@selector(touchClick)];
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}

- (void)touchClick
{
    [SYTouchManager touchManagerWithTitle:@"传感器指纹功能验证" cancelTitle:@"取消" passwordTitle:@"输入密码验证" manager:^(NSInteger type, NSString * _Nonnull message) {
        NSLog(@"type = %ld, message = %@", type, message);
        [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%ld", type] message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil] show];
    }];
}

@end
