//
//  CGAlertVideoAd.m
//  ADDemo
//
//  Created by 袁明洋 on 2023/10/27.
//

#import "CGAlertVideoAd.h"
@interface CGAlertVideoAd()<BUNativeExpressFullscreenVideoAdDelegate,GDTUnifiedInterstitialAdDelegate>

@end
@implementation CGAlertVideoAd

- (void)createAlertVideoAdWithDelegate:(nonnull id<CGAlertVideoAdDelegate>)delegate {
    self.delegate = delegate;
    if ([CGAdSingle single].isInitSuccess) {
        [self checkAdConfig];
    }else{
        if ([self.delegate respondsToSelector:@selector(cg_createAlertVideoAdFaild:)]) {
            [self.delegate cg_createAlertVideoAdFaild:@"SDK未初始化"];
        }
    }
}

- (void)showAlertVideoWithRootViewController:(nonnull UIViewController *)rootViewController {
    if (self.csjAd) {
        [self.csjAd showAdFromRootViewController:rootViewController];
    }
    if (self.ylhAd) {
        [self.ylhAd presentAdFromRootViewController:rootViewController];
    }
}

-(void)createAlertVideoAd{
    NSString *first = [CGAdSingle single].platformOrders.firstObject;
    if ([first isEqualToString:@"1"]) {//优良汇
        [self createYlhAd];
    }else{//穿山甲
        [self createCsjAd];
    }
}
-(void)createCsjAd{
    CGAdInfoModel *csjAlertVideoInfo = [[CGAdSingle single] getAdInfoWithPlatform:@"2" advertisingTypeValue:2];
    if (csjAlertVideoInfo) {
        self.csjAd = [[BUNativeExpressFullscreenVideoAd alloc] initWithSlotID:csjAlertVideoInfo.advertisingSpaceId];
        self.csjAd.delegate = self;
        [self.csjAd loadAdData];
    }else{
        [self requestAdInfo];
    }
}
-(void)createYlhAd{
    CGAdInfoModel *ylhAlertVideoInfo = [[CGAdSingle single] getAdInfoWithPlatform:@"1" advertisingTypeValue:2];
    if (ylhAlertVideoInfo) {
        self.ylhAd = [[GDTUnifiedInterstitialAd alloc] initWithPlacementId:ylhAlertVideoInfo.advertisingSpaceId];
        self.ylhAd.delegate = self;
        [self.ylhAd loadAd];
    }else{
        [self requestAdInfo];
    }
}


/**检查广告配置**/
-(void)checkAdConfig{
    if ([CGAdSingle single].adConfig) {
        NSInteger currentDate = [[NSDate date] timeIntervalSince1970];//当前时间戳
        if (currentDate - [CGAdSingle single].adConfig.createDate >= [CGAdSingle single].adConfig.activationTime) {
            //已激活
            if (currentDate - [CGAdSingle single].adConfig.createDate < [CGAdSingle single].adConfig.validTime) {
                //有效期内
                if ([CGAdSingle single].adConfig.cpTime != -1) {
                    [self createAlertVideoAd];
                }else{
                    if ([self.delegate respondsToSelector:@selector(cg_createAlertVideoAdFaild:)]) {
                        [self.delegate cg_createAlertVideoAdFaild:@"激励视频未开启"];
                    }
                }
                
            }else{
                //配置已过期，重新拉取配置
                [self requestAdConfig];
            }
        }else{
            //未激活
            if ([self.delegate respondsToSelector:@selector(cg_createAlertVideoAdFaild:)]) {
                [self.delegate cg_createAlertVideoAdFaild:@"广告不在激活时间内"];
            }
        }
    }else{
        [self requestAdConfig];
    }
}



/**拉取广告配置**/
-(void)requestAdConfig{
    [[CGAdSingle single] getAdConfigWith:^{
        [self checkAdConfig];
    } faild:^(NSString * _Nonnull msg) {
        if ([self.delegate respondsToSelector:@selector(cg_createAlertVideoAdFaild:)]) {
            [self.delegate cg_createAlertVideoAdFaild:msg];
        }
    }];
}

/**拉取广告位信息**/
-(void)requestAdInfo{
    [[CGAdSingle single] getAdInfoWith:2 success:^{
        [self createAlertVideoAd];
    } faild:^(NSString * _Nonnull msg) {
        if ([self.delegate respondsToSelector:@selector(cg_createAlertVideoAdFaild:)]) {
            [self.delegate cg_createAlertVideoAdFaild:msg];
        }
    }];
}


#pragma mark -- BUNativeExpressFullscreenVideoAdDelegate
- (void)nativeExpressFullscreenVideoAdDidLoad:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    NSLog(@"CSJ插屏获取成功");
    if ([self.delegate respondsToSelector:@selector(cg_AlertVideoAdLoadSuccess:)]) {
        [self.delegate cg_AlertVideoAdLoadSuccess:self];
    }
}
- (void)nativeExpressFullscreenVideoAd:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error{
    NSLog(@"CSJ插屏拉取失败");
    self.csjAd = nil;
    NSString *last = [CGAdSingle single].platformOrders.lastObject;
    if ([last isEqualToString:@"2"]) {
        //穿山甲已经是第二个了
        if ([self.delegate respondsToSelector:@selector(cg_AlertVideoAddLoadFaild:)]) {
            [self.delegate cg_AlertVideoAddLoadFaild:error.localizedDescription];
        }
    }else{
        [self createYlhAd];
    }
}
- (void)nativeExpressFullscreenVideoAdViewRenderSuccess:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd{
    //渲染成功
}
- (void)nativeExpressFullscreenVideoAdViewRenderFail:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error{
    //渲染失败
}
- (void)nativeExpressFullscreenVideoAdDidDownLoadVideo:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    //视频缓存成功
}
- (void)nativeExpressFullscreenVideoAdDidClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    //关闭
    NSLog(@"CSJ插屏关闭");
    if ([self.delegate respondsToSelector:@selector(cg_AlertVideoAdDidClose:)]) {
        [self.delegate cg_AlertVideoAdDidClose:self];
    }
}

#pragma mark -- GDTUnifiedInterstitialAdDelegate
- (void)unifiedInterstitialSuccessToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    //获取成功
    NSLog(@"YLH插屏获取成功");
    if ([self.delegate respondsToSelector:@selector(cg_AlertVideoAdLoadSuccess:)]) {
        [self.delegate cg_AlertVideoAdLoadSuccess:self];
    }
}
- (void)unifiedInterstitialFailToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error{
    NSLog(@"YLH插屏拉取失败");
    self.ylhAd = nil;
    NSString *last = [CGAdSingle single].platformOrders.lastObject;
    if ([last isEqualToString:@"1"]) {
        //优量汇已经是第二个了
        if ([self.delegate respondsToSelector:@selector(cg_AlertVideoAddLoadFaild:)]) {
            [self.delegate cg_AlertVideoAddLoadFaild:error.localizedDescription];
        }
    }else{
        [self createCsjAd];
    }
}
- (void)unifiedInterstitialRenderSuccess:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    //渲染完成
}
- (void)unifiedInterstitialRenderFail:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error{
    //渲染失败
}
- (void)unifiedInterstitialDidDownloadVideo:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    //视频缓存完成
}
- (void)unifiedInterstitialAdDidDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial{
    //关闭
    NSLog(@"YLH插屏关闭");
    if ([self.delegate respondsToSelector:@selector(cg_AlertVideoAdDidClose:)]) {
        [self.delegate cg_AlertVideoAdDidClose:self];
    }
}
@end
