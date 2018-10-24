//
//  SYLightManager.m
//  SYLightManager
//
//  Created by Herman on 2018/10/24.
//  Copyright © 2018年 Herman. All rights reserved.
//

#import "SYLightManager.h"

@interface SYLightManager () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *sessionLight;
@property (nonatomic, copy) void (^sessionLightBlock)(BOOL isEnable, float bright, AVCaptureTorchMode mode);

@end

@implementation SYLightManager

/**
 环境光传感器
 
 @param complete 光感回调
 */
- (void)motionLightComplete:(void (^)(BOOL isEnable, float bright, AVCaptureTorchMode mode))complete
{
    // 获取硬件设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device && device.hasFlash) {
        self.sessionLightBlock = [complete copy];
        // 启动会话
        [self.sessionLight startRunning];
    } else {
        if (complete) {
            complete(NO, 0.0, AVCaptureTorchModeOff);
        }
    }
}

/**
 闪光灯
 
 @param manager 闪光灯控制回调
 */
- (void)motionLightManager:(void (^)(BOOL isEnable, AVCaptureTorchMode mode))manager
{
    BOOL isEnable = YES;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device && device.hasFlash) {
        if (device.torchMode == AVCaptureTorchModeOn) {
            // 打开时，关闭
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        } else if (device.torchMode == AVCaptureTorchModeOff) {
            // 关闭时，打开
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOn];
            [device unlockForConfiguration];
        }
    } else {
        isEnable = NO;
    }
    
    if (manager) {
        manager(isEnable, device.torchMode);
    }
}

#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    //
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //
    if (self.sessionLightBlock) {
        self.sessionLightBlock(YES, brightnessValue, device.torchMode);
    }
}

#pragma mark getter

- (AVCaptureSession *)sessionLight
{
    if (_sessionLight == nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        // 创建输入流
        AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc]initWithDevice:device error:nil];
        // 创建设备输出流
        AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
        [output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        // AVCaptureSession属性
        _sessionLight = [[AVCaptureSession alloc] init];
        // 设置为高质量采集率
        [_sessionLight setSessionPreset:AVCaptureSessionPresetHigh];
        // 添加会话输入和输出
        if ([_sessionLight canAddInput:input]) {
            [_sessionLight addInput:input];
        }
        if ([_sessionLight canAddOutput:output]) {
            [_sessionLight addOutput:output];
        }
    }
    return _sessionLight;
}

@end
