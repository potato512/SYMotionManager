//
//  SYTouchManager.h
//  SYTouchManager
//
//  Created by Herman on 2018/10/24.
//  Copyright © 2018年 Herman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 -1: 连续三次指纹识别错误
 -2: 在TouchID对话框中点击了取消按钮
 -3: 在TouchID对话框中点击了输入密码按钮
 -4: TouchID对话框被系统取消，例如按下Home或者电源键
 -5 未设置密码
 -8: 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码，或在设置页页重新启用
 
 注意：
 1、苹果从iPhone5S开始，具有指纹识别技术，从iOS8.0之后苹果允许第三方 App 使用 Touch ID进行身份验证。
 2、连续三次指纹识别错误后，会自动弹出密码框，通过Touch ID的密码进行身份验证，如果此时取消密码验证，再2次指纹识别失败后，也就是 3 + 2 = 5次指纹识别失败后，Touch ID功能被锁定，就只能通过密码来进行身份验证和解锁Touch ID 功能。
 3、设置密码、指纹解锁
 （1）有密码，无指纹时，弹出密码输入解锁
 （2）有密码，有指纹时，先弹出指纹解锁，后可选择弹窗密码输入解锁
 （3）无密码，无指纹时，提示没有设置密码
 （4）无密码，有指纹时，不存在这种情况，必须两者同时设置，或至少设置密码
 */

/// 指纹验证状态
typedef NS_ENUM(NSInteger, TouchType)
{
    /// 没有指纹功能
    TouchTypeInvalid = -999,
    /// 验证成功
    TouchTypeSuccess = 1000,
    /// 连续3次验证错误，
    TouchTypeFailedThree = -1,
    /// 用户点击取消
    TouchTypeCancel = -2,
    /// 密码输入验证
    TouchTypeCheckPassword = -3,
    /// 系统取消验证
    TouchTypeSystemCancel = -4,
    /// 未设置密码
    TouchTypeNotSet = -5,
    /// 连续5次验证错误
    TouchTypeFailedFive = -8
};

NS_ASSUME_NONNULL_BEGIN

@interface SYTouchManager : NSObject

/**
 指纹识别功能
 
 @param title 提示标题
 @param cancelTitle 取消按钮标题
 @param passwordTitle 密码验证按钮（指纹验证失败时，出现密码按钮，点击弹窗输入密码验证）
 @param manager 验证回调
 */
+ (void)touchManagerWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle passwordTitle:(NSString *)passwordTitle manager:(void (^)(NSInteger type, NSString *message))manager;

@end

NS_ASSUME_NONNULL_END
