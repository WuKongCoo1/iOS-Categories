//
//  UIImageView+WKWebVideoCache.m
//  CenturyGuard
//
//  Created by 吴珂 on 16/8/3.
//  Copyright © 2016年 sjyt. All rights reserved.
//

#import "UIImageView+WKWebVideoCache.h"
#import <objc/runtime.h>
#import "WKWebVideoOperation.h"
#import "UIImageView+PlayGIF.h"
#import "WKWebVideoManager.h"
#import "WKProgressView.h"
#import "WKWebVideoOperation.h"
#import "CGVideoInfoArchivingManager.h"


#define kLoadStatusBackGroundViewWH 100.f
#define kLoadStatusImageViewWH 40.f
#define kLoadStatusTextFieldW 80.f
#define kLoadStatusTextFieldH 20.f

#ifndef dispatch_main_async_safe//(block)

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#endif

static NSString * const WKLoadVideo = @"WKLoadVideo";
static NSString * const WKUploadVideo = @"WKUploadVideo";

static void * WKLoadOperationKey = &WKLoadOperationKey;
static void * WKUploadOperationKey = &WKUploadOperationKey;

static void * WKURLKey = &WKURLKey;

static void * WKProgressViewKey = &WKProgressViewKey;
static void * WKPreImageViewKey = &WKPreImageViewKey;
static void * WKLastFrameImageViewKey = &WKLastFrameImageViewKey;
static void * WKloadStatusImageViewKey = &WKloadStatusImageViewKey;
static void * WKloadStatusTextLabelKey = &WKloadStatusTextLabelKey;
static void * WKLoadProgressDictionaryKey = &WKLoadProgressDictionaryKey;

@implementation UIImageView (WKWebVideoCache)

- (void)wk_setGifImageWithVideoURL:(NSURL *)url firstFrame:(NSURL *)firstFrameURL progress:(WKWebVideoProgressBlock)progressBlock completedBlock:(WKWebVideoCompletedBlock)completedBlock
{
    [self wk_setGifImageWithVideoURL:url firstFrame:firstFrameURL placeholderImage:nil progress:progressBlock completed:completedBlock];
}

- (void)wk_setGifImageWithVideoURL:(NSURL *)url firstFrame:(NSURL *)firstFrameURL placeholderImage:(UIImage *)placeholder progress:(WKWebVideoProgressBlock)progressBlock completed:(WKWebVideoCompletedBlock)completedBlock {
    
    [self wk_cancelGifLoadOperationWithKey:WKLoadVideo];
    
    [self sd_setImageWithURL:firstFrameURL placeholderImage:placeholder];
    
    [self hideLoadStatusView];
    
    self.progressView.hidden = NO;
    
    CGVideoStatus status = [[CGVideoInfoArchivingManager sharedDataManager] excuteVideoStatusWithName:[url absoluteString]];
    
    if (status == CGVideoStatusConverting || status == CGVideoStatusDownloading || status == CGVideoStatusUploading) {
        [self privateShowPregressView:0.f];
    }
    
    [self stopGIF];
    
    objc_setAssociatedObject(self, WKURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (placeholder) {
        dispatch_main_async_safe(^{
            
        });
    }
    
    if (url) {
        __weak typeof(self)weakSelf = self;
        id <WKWebVideoOperation> operation = [[WKWebVideoManager sharedManager] downloadVideoWithURL:url progress:^(CGFloat progress) {
            
            [weakSelf privateShowPregressView:progress];
            
        } completed:^(NSURL *videoURL, NSError *error) {
            if (!error) {
                
                [weakSelf playGIfWithPath:[[WKWebVideoManager videoFileUrlWithVideoName:[url absoluteString]] stringByReplacingOccurrencesOfString:@".mp4" withString:@".gif"]];
            }
            if (completedBlock) {
                [weakSelf hideProgressView];
                completedBlock(videoURL, error);
            }
        }];
        
        [self wk_setImageLoadOperation:operation forKey:WKLoadVideo];
    }
}


- (NSMutableDictionary *)videoProgressDictionary
{
    NSMutableDictionary *progresses = objc_getAssociatedObject(self, WKLoadProgressDictionaryKey);
    if (progresses) {
        return progresses;
    }
    progresses = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, WKLoadProgressDictionaryKey, progresses, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return progresses;
}

- (NSMutableDictionary *)videoOperationDictionary {
    NSMutableDictionary *operations = objc_getAssociatedObject(self, WKLoadOperationKey);
    if (operations) {
        return operations;
    }
    operations = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, WKLoadOperationKey, operations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return operations;
}

- (void)wk_cancelGifLoadOperationWithKey:(NSString *)key {
    // Cancel in progress downloader from queue
    NSMutableDictionary *operationDictionary = [self videoOperationDictionary];
    id operations = [operationDictionary objectForKey:key];
    if (operations) {
        if ([operations isKindOfClass:[WKWebVideoCombineOperation class]]) {
            [(id<WKWebVideoOperation>) operations cancel];
        }

        [operationDictionary removeObjectForKey:key];
    }
}

- (void)wk_setImageLoadOperation:(id)operation forKey:(NSString *)key {
    [self wk_cancelGifLoadOperationWithKey:key];
    NSMutableDictionary *operationDictionary = [self videoOperationDictionary];
    
    @autoreleasepool {
        NSLog(@"-----operation%@", operation);
    }
    
    [operationDictionary setObject:operation forKey:key];
}

- (void)playGIfWithPath:(NSString *)path
{
    
    self.gifPath = path;
    [self startGIFWithRunLoopMode:NSRunLoopCommonModes];
    [self hideProgressView];
    self.image = nil;
    self.hidden = NO;
}

#pragma mark - AssociatedObject

- (void)setProgressView:(WKProgressView *)progressView
{
    objc_setAssociatedObject(self, WKProgressViewKey, progressView, OBJC_ASSOCIATION_RETAIN_NONATOMIC
                             );
}

- (WKProgressView *)progressView
{
    return objc_getAssociatedObject(self, WKProgressViewKey);
}


- (UIImageView *)preImageView
{
    return objc_getAssociatedObject(self, WKPreImageViewKey);
}

- (void)setPreImageView:(UIImageView *)preImageView
{
    objc_setAssociatedObject(self, WKPreImageViewKey, preImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)loadStatusImageView
{
    return objc_getAssociatedObject(self, WKloadStatusImageViewKey);
}

- (void)setLoadStatusImageView:(UIImageView *)loadStatusImageView
{
    objc_setAssociatedObject(self, WKloadStatusImageViewKey, loadStatusImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITextField *)loadStatusTextField
{
    return objc_getAssociatedObject(self, WKloadStatusTextLabelKey);
    
}

- (void)setLoadStatusTextField:(UITextField *)loadStatusTextField
{
    return objc_setAssociatedObject(self, WKloadStatusTextLabelKey, loadStatusTextField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)privateShowPregressView:(CGFloat)progress
{
    if (!self.progressView) {
        self.progressView = [[WKProgressView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.progressView.borderColor = [UIColor whiteColor];
        self.progressView.progressColor = [UIColor whiteColor];
        self.progressView.progressWidth = 10;
        
        [self addSubview:self.progressView];
    }
    self.progressView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    self.progressView.progress = progress;
}

- (void)showPregressView
{
    [self privateShowPregressView:0];
}

- (void)hideProgressView
{
    self.progressView.hidden = YES;
}

- (void)showLoadStatusImageViewWithStatus:(CGVideoStatus)status
{
    [self hideProgressView];
    if (!self.loadStatusImageView) {
        self.loadStatusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.loadStatusImageView.image = [UIImage imageNamed:@""];
        [self addSubview:self.loadStatusImageView];
    }
    
    switch (status) {
        case CGVideoStatusNotExist:
        case CGVideoStatusDownloadFaield: {
            self.loadStatusTextField.text = @"轻触载入";
            self.loadStatusTextField.frame = CGRectZero;
            
            self.loadStatusImageView.image = [UIImage imageNamed:@"sight_video_chatpage_play_button"];
            self.loadStatusImageView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
            break;
        }
       
        case CGVideoStatusUploadFaield: {
            if (!self.loadStatusTextField) {
                self.loadStatusTextField = [[UITextField alloc] init];
                self.loadStatusTextField.textColor = [UIColor whiteColor];
                self.loadStatusTextField.textAlignment = NSTextAlignmentCenter;
                self.loadStatusTextField.userInteractionEnabled = NO;
                
            }
            self.loadStatusTextField.text = @"发送失败";
            CGFloat selfW = CGRectGetWidth(self.frame);
            CGFloat selfH = CGRectGetHeight(self.frame);
            CGFloat loadStatusImageViewX = (selfW - kLoadStatusImageViewWH) / 2;
            CGFloat loadStatusImageViewY = (selfH - kLoadStatusImageViewWH - kLoadStatusTextFieldH - 5) / 2;
            self.loadStatusImageView.frame = CGRectMake(loadStatusImageViewX, loadStatusImageViewY, kLoadStatusImageViewWH, kLoadStatusImageViewWH);
            self.loadStatusImageView.image = [UIImage imageNamed:@"sight_video_chatpage_nosend_button"];
            
            CGFloat loadStatusTextFieldX = (selfW - kLoadStatusTextFieldW) / 2;
            CGFloat loadStatusTextFieldY = CGRectGetMaxY(self.loadStatusImageView.frame) + 5.f;
            self.loadStatusTextField.frame = CGRectMake(loadStatusTextFieldX, loadStatusTextFieldY, kLoadStatusTextFieldW, kLoadStatusTextFieldH);
            self.loadStatusTextField.hidden = NO;
            [self addSubview:self.loadStatusTextField];
            
            break;
        }
        
        default:{
            break;
        }
       
    }
    
    self.loadStatusImageView.hidden = NO;
    
}

- (void)hideLoadStatusView
{
    self.loadStatusImageView.hidden = YES;
    self.loadStatusTextField.hidden = YES;
}
/**
 *  设置视频状态UI
 *
 *  @param status 状态
 */
- (void)displayUploadFailed
{
    [self showLoadStatusImageViewWithStatus:CGVideoStatusUploadFaield];
}
- (void)displayDownloadFailed
{
    [self showLoadStatusImageViewWithStatus:CGVideoStatusDownloadFaield];
}
- (void)displayNotExist
{
    [self showLoadStatusImageViewWithStatus:CGVideoStatusNotExist];
}

@end
