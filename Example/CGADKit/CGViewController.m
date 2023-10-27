//
//  CGViewController.m
//  CGADKit
//
//  Created by 302603448@qq.com on 10/26/2023.
//  Copyright (c) 2023 302603448@qq.com. All rights reserved.
//

#import "CGViewController.h"
#import <CGADKit/CGADKit.h>

@interface CGViewController ()<CGSplachAdDelegate,CGRewardVideoAdDelegate>
@property(nonatomic,strong)CGSplachAd *splachAd;
@property(nonatomic,strong)CGRewardVideoAd *videoAd;
@end

@implementation CGViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)splachClick:(id)sender {
    self.splachAd = [[CGSplachAd alloc] init];
    [self.splachAd createSplashAdWithSize:[UIScreen mainScreen].bounds.size delegate:self];
    
}
- (IBAction)videoAd:(id)sender {
    self.videoAd = [CGRewardVideoAd new];
    [self.videoAd createRewardVideoAdWithUserId:@"11" customString:@"hhh" delegate:self];
}



#pragma mark -- CGSplachAdDelegate

- (void)cg_createSplashAdFaild:(nonnull NSString *)msg { 
    NSLog(@"----->>>>>开屏广告创建失败：%@",msg);
}

- (void)cg_splashAdDidClose:(nonnull CGSplachAd *)splachAd { 
    NSLog(@"----->>>>>开屏广告关闭");
}

- (void)cg_splashAdLoadFaild:(nonnull NSString *)msg { 
    NSLog(@"----->>>>>开屏广告获取失败：%@",msg);
}

- (void)cg_splashAdLoadSuccess:(nonnull CGSplachAd *)splachAd { 
    [splachAd showSplashAdWithWindow:[UIApplication sharedApplication].delegate.window];
}

#pragma mark -- CGRewardVideoAdDelegate
- (void)cg_createRewardVideoAdFaild:(nonnull NSString *)msg {
    NSLog(@"激励视频广告创建失败：%@",msg);
}

- (void)cg_rewardVideoAdDidReward:(nonnull CGRewardVideoAd *)splachAd { 
    NSLog(@"激励视频广告已到达获取奖励条件");
}

- (void)cg_rewardVideoAdLoadSuccess:(nonnull CGRewardVideoAd *)splachAd { 
    [splachAd showRewardVideoWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController];
}

- (void)cg_rewardVideoAddLoadFaild:(nonnull NSString *)msg { 
    NSLog(@"激励视频广告加载失败：%@",msg);
}


@end
