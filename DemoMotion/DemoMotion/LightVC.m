//
//  LightVC.m
//  DemoMotion
//
//  Created by Herman on 2018/10/24.
//  Copyright © 2018年 Herman. All rights reserved.
//

#import "LightVC.h"
#import "SYMotionHeader.h"

@interface LightVC ()

@property (nonatomic, strong) SYLightManager *lightManager;
@property (nonatomic, strong) UIButton *button;

@end

@implementation LightVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"环境光感";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.button];
    [self lightMotion];
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}

- (void)lightMotion
{
    [self.lightManager motionLightComplete:^(BOOL isEnable, float bright, AVCaptureTorchMode mode) {
        NSLog(@"enable = %@, bright = %@, mode = %ld", @(isEnable), @(bright), mode);
    }];
}

#pragma mark - 响应

- (void)buttonClick:(UIButton *)button
{
    [self.lightManager motionLightManager:^(BOOL isEnable, AVCaptureTorchMode mode) {
        if (isEnable) {
            if (mode == AVCaptureTorchModeOn) {
                button.selected = YES;
            } else if (mode == AVCaptureTorchModeOff) {
                button.selected = NO;
            }
        }
    }];
}
#pragma mark - getter

- (SYLightManager *)lightManager
{
    if (_lightManager == nil) {
        _lightManager = [[SYLightManager alloc] init];
    }
    return _lightManager;
}

- (UIButton *)button
{
    if (_button == nil) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 60.0, 44.0)];
        [_button setTitle:@"关" forState:UIControlStateNormal];
        [_button setTitle:@"开" forState:UIControlStateSelected];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end
