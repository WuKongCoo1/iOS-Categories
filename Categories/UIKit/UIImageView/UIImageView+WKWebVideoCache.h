//
//  UIImageView+WKWebVideoCache.h
//  CenturyGuard
//
//  Created by 吴珂 on 16/8/3.
//  Copyright © 2016年 sjyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWebVideoManager.h"

@class WKProgressView;

@interface UIImageView (WKVideoCache)


@property (nonatomic, strong) WKProgressView *progressView;
@property (nonatomic, strong) UIImageView *preImageView;//动画
@property (nonatomic, strong) UIImageView *lastFrameImageView;//最后一帧
@property (nonatomic, strong) UIImageView *loadStatusImageView;
@property (nonatomic, strong) UIView *loadStatusBackgroundView;
@property (nonatomic, strong) UITextField *loadStatusTextField;

- (void)wk_setGifImageWithVideoURL:(NSURL *)url firstFrame:(NSURL *)firstFrame progress:(WKWebVideoProgressBlock)progressBlock completedBlock:(WKWebVideoCompletedBlock)completedBlock;
- (void)wk_setGifImageWithVideoURL:(NSURL *)url firstFrame:(NSURL *)firstFrame placeholderImage:(UIImage *)placeholder progress:(WKWebVideoProgressBlock)progressBlock completed:(WKWebVideoCompletedBlock)completedBlock;

- (void)wk_uploadWithVideoURL:(NSURL *)url previewImage:(UIImage *)previewImage progress:(WKWebVideoProgressBlock)progressBlock completed:(WKWebVideoCompletedBlock)completedBlock;
- (void)displayUploadFailed;
- (void)displayDownloadFailed;
- (void)displayNotExist;

@end
