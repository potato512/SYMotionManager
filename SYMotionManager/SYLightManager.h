//
//  SYLightManager.h
//  SYLightManager
//
//  Created by Herman on 2018/10/24.
//  Copyright © 2018年 Herman. All rights reserved.
//  环境光传感器

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/*
 应用场景
 根据环境的亮度去调整屏幕的亮度
 1、在黑暗情况下，手机会自动调暗屏幕亮度，以防刺眼；
 2、相机拍照时光线暗时会自动打开闪光灯；
 3、在黑暗的情况下扫码时检测到特别暗就自动提示打开闪光灯。
 
 注意：
 plist文件中需要配置"NSCameraUsageDescription"，以允许用户使用相机，如：环境光感需要使用相机，是否允许用户访问？
*/

NS_ASSUME_NONNULL_BEGIN

@interface SYLightManager : NSObject

/**
 环境光传感器
 
 @param complete 光感回调
 */
- (void)motionLightComplete:(void (^)(BOOL isEnable, float bright, AVCaptureTorchMode mode))complete;

/**
 闪光灯
 
 @param manager 闪光灯控制回调
 */
- (void)motionLightManager:(void (^)(BOOL isEnable, AVCaptureTorchMode mode))manager;

@end

NS_ASSUME_NONNULL_END
