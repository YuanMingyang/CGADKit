//
//  CGSplachAd.m
//  ADDemo
//
//  Created by 袁明洋 on 2023/10/26.
//

#import "CGSplachAd.h"

@interface CGSplachAd ()<BUSplashAdDelegate,GDTSplashAdDelegate>

@end

@implementation CGSplachAd

-(void)createSplashAdWithSize:(CGSize)size delegate:(id<CGSplachAdDelegate>)delegate{
    self.adSize = size;
    self.delegate = delegate;
    if ([CGAdSingle single].isInitSuccess) {
        [self checkAdConfig];
    }else{
        if ([self.delegate respondsToSelector:@selector(cg_createSplashAdFaild:)]) {
            [self.delegate cg_createSplashAdFaild:@"SDK未初始化"];
        }
    }
    
}

-(void)showSplashAdWithWindow:(UIWindow *)window{
    if (self.csjSplashAd) {
        [self.csjSplashAd showSplashViewInRootViewController:window.rootViewController];
    }else{
        [self.ylhSplashAd showFullScreenAdInWindow:window withLogoImage:nil skipView:nil];
    }
}

/**创建优量汇开屏**/
-(void)createYlhSplashAd{
    CGAdInfoModel *ylhSplashInfo = [[CGAdSingle single] getAdInfoWithPlatform:@"1" advertisingTypeValue:1];
    if (ylhSplashInfo) {
        self.ylhSplashAd = [[GDTSplashAd alloc] initWithPlacementId:@"4027520102965399"];
        self.ylhSplashAd.delegate = self;
        [self.ylhSplashAd loadFullScreenAd];
    }else{
        [self requestAdInfo];
    }
}
/**创建穿山甲开屏**/
-(void)createCsjSplashAd{
    CGAdInfoModel *csjSplashInfo = [[CGAdSingle single] getAdInfoWithPlatform:@"2" advertisingTypeValue:1];
    if (csjSplashInfo) {
        self.csjSplashAd = [[BUSplashAd alloc] initWithSlotID:csjSplashInfo.advertisingSpaceId adSize:self.adSize];
        self.csjSplashAd.delegate = self;
        [self.csjSplashAd loadAdData];
    }else{
        [self requestAdInfo];
    }
}

-(void)createSplashAd{
    NSString *first = [CGAdSingle single].platformOrders.firstObject;
    if ([first isEqualToString:@"1"]) {//优良汇
        [self createYlhSplashAd];
    }else{//穿山甲
        [self createCsjSplashAd];
    }
}

/**拉取广告位信息**/
-(void)requestAdInfo{
    [[CGAdSingle single] getAdInfoWith:1 success:^{
        [self createSplashAd];
    } faild:^(NSString * _Nonnull msg) {
        if ([self.delegate respondsToSelector:@selector(cg_createSplashAdFaild:)]) {
            [self.delegate cg_createSplashAdFaild:msg];
        }
    }];
}

/**检查广告配置**/
-(void)checkAdConfig{
    if ([CGAdSingle single].adConfig) {
        NSInteger currentDate = [[NSDate date] timeIntervalSince1970];//当前时间戳
        if (currentDate - [CGAdSingle single].adConfig.createDate >= [CGAdSingle single].adConfig.activationTime) {
            //已激活
            if (currentDate - [CGAdSingle single].adConfig.createDate < [CGAdSingle single].adConfig.validTime) {
                //有效期内
                [self createSplashAd];
            }else{
                //配置已过期，重新拉取配置
                [self requestAdConfig];
            }
        }else{
            //未激活
            if ([self.delegate respondsToSelector:@selector(cg_createSplashAdFaild:)]) {
                [self.delegate cg_createSplashAdFaild:@"广告位不在激活时间内"];
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
        if ([self.delegate respondsToSelector:@selector(cg_createSplashAdFaild:)]) {
            [self.delegate cg_createSplashAdFaild:msg];
        }
    }];
}


#pragma mark -- BUSplashAdDelegate
- (void)splashAdLoadSuccess:(BUSplashAd *)splashAd{
    NSLog(@"CSJ开屏广告拉取成功");
    if ([self.delegate respondsToSelector:@selector(cg_splashAdLoadSuccess:)]) {
        [self.delegate cg_splashAdLoadSuccess:self];
    }
}

- (void)splashAdLoadFail:(BUSplashAd *)splashAd error:(BUAdError *_Nullable)error{
    NSLog(@"CSJ开屏广告拉取失败");
    self.csjSplashAd = nil;
    NSString *last = [CGAdSingle single].platformOrders.lastObject;
    if ([last isEqualToString:@"2"]) {
        //穿山甲已经是第二个了
        if ([self.delegate respondsToSelector:@selector(cg_splashAdLoadFaild:)]) {
            [self.delegate cg_splashAdLoadFaild:error.localizedDescription];
        }
    }else{
        [self createYlhSplashAd];
    }
    
}
- (void)splashAdDidClose:(BUSplashAd *)splashAd closeType:(BUSplashAdCloseType)closeType{
    if ([self.delegate respondsToSelector:@selector(cg_splashAdDidClose:)]) {
        [self.delegate cg_splashAdDidClose:self];
    }
}

#pragma mark -- GDTSplashAdDelegate
- (void)splashAdDidLoad:(GDTSplashAd *)splashAd{
    NSLog(@"YLH开屏广告拉取成功");
    if ([self.delegate respondsToSelector:@selector(cg_splashAdLoadSuccess:)]) {
        [self.delegate cg_splashAdLoadSuccess:self];
    }
}

- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error{
    NSLog(@"YLH开屏广告拉取失败");
    self.ylhSplashAd = nil;
    NSString *last = [CGAdSingle single].platformOrders.lastObject;
    if ([last isEqualToString:@"1"]) {
        //优量汇已经是第二个了
        if ([self.delegate respondsToSelector:@selector(cg_splashAdLoadFaild:)]) {
            [self.delegate cg_splashAdLoadFaild:error.localizedDescription];
        }
    }else{
        [self createCsjSplashAd];
    }
}
- (void)splashAdWillClosed:(GDTSplashAd *)splashAd{
    if ([self.delegate respondsToSelector:@selector(cg_splashAdDidClose:)]) {
        [self.delegate cg_splashAdDidClose:self];
    }
}
@end
