//
//  SYTouchManager.m
//  SYTouchManager
//
//  Created by Herman on 2018/10/24.
//  Copyright © 2018年 Herman. All rights reserved.
//

#import "SYTouchManager.h"
#import <LocalAuthentication/LocalAuthentication.h>

#define GetSystemVersionTouch ([[UIDevice currentDevice].systemVersion floatValue])

@implementation SYTouchManager

/**
 指纹识别功能
 
 @param title 提示标题
 @param cancelTitle 取消按钮标题
 @param passwordTitle 密码验证按钮（指纹验证失败时，出现密码按钮，点击弹窗输入密码验证）
 @param manager 验证回调
 */
+ (void)touchManagerWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle passwordTitle:(NSString *)passwordTitle manager:(void (^)(NSInteger type, NSString *message))manager
{
    // 判断设备是否支持Touch ID
    if (GetSystemVersionTouch < 8.0) {
        if (manager) {
            manager(TouchTypeInvalid, @"不支持指纹功能");
        }
    } else {
        LAContext *ctx = [[LAContext alloc] init];
        // 提示标题
        if ([ctx respondsToSelector:@selector(localizedReason)]) {
            ctx.localizedReason = title;
        }
        // 设置 输入密码 按钮的标题
        ctx.localizedFallbackTitle = passwordTitle; // @"验证登录密码";
        // 设置 取消 按钮的标题 iOS10之后
        ctx.localizedCancelTitle = cancelTitle;// @"取消";
        // 检测指纹数据库更改 验证成功后返回一个NSData对象，否则返回nil
        // ctx.evaluatedPolicyDomainState;
        // 这个属性应该是类似于支付宝的指纹开启应用，如果你打开他解锁之后，按Home键返回桌面，再次进入支付宝是不需要录入指纹的。因为这个属性可以设置一个时间间隔，在时间间隔内是不需要再次录入。默认是0秒，最长可以设置5分钟
        // ctx.touchIDAuthenticationAllowableReuseDuration = 5;
        
        NSError *error;
        // 判断设备是否支持指纹识别
        if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
            
            // 验证指纹是否匹配，需要弹出输入密码的弹框的话：iOS9之后用 LAPolicyDeviceOwnerAuthentication；iOS9之前用LAPolicyDeviceOwnerAuthenticationWithBiometrics
            LAPolicy policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
            if (GetSystemVersionTouch >= 9.0) {
                policy = LAPolicyDeviceOwnerAuthentication;
            }
            [ctx evaluatePolicy:policy localizedReason:title reply:^(BOOL success, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (success) {
                        if (manager) {
                            manager(TouchTypeSuccess, @"指纹验证成功");
                        }
                    } else {
                        if (manager) {
                            manager(error.code, error.description);
                        }
                    }
                });
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (manager) {
                    manager(error.code, error.description);
                }
            });
        }
    }
}

@end
