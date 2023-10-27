//
//  CGRewardVideoAd.m
//  ADDemo
//
//  Created by 袁明洋 on 2023/10/26.
//

#import "CGRewardVideoAd.h"
@interface CGRewardVideoAd()<GDTRewardedVideoAdDelegate,BURewardedVideoAdDelegate>

@end
@implementation CGRewardVideoAd
-(void)createRewardVideoAdWithUserId:(NSString *)userId customString:(NSString *)customString delegate:(id<CGRewardVideoAdDelegate>)delegate{
    self.userId = userId;
    self.customString = customString;
    self.delegate = delegate;
    if ([CGAdSingle single].isInitSuccess) {
        [self checkAdConfig];
    }else{
        if ([self.delegate respondsToSelector:@selector(cg_createRewardVideoAdFaild:)]) {
            [self.delegate cg_createRewardVideoAdFaild:@"SDK未初始化"];
        }
    }
}
-(void)showRewardVideoWithRootViewController:(UIViewController *)rootViewController{
    if (self.csjVideoAd) {
        [self.csjVideoAd showAdFromRootViewController:rootViewController];
    }else{
        [self.ylhVideoAd showAdFromRootViewController:rootViewController];
    }
}

-(void)createRewardVideoAd{
    NSString *first = [CGAdSingle single].platformOrders.firstObject;
    if ([first isEqualToString:@"1"]) {//优良汇
        [self createYlhRewardVideoAd];
    }else{//穿山甲
        [self createCsjRewardVideoAd];
    }
}
-(void)createYlhRewardVideoAd{
    CGAdInfoModel *ylhRewardVideoInfo = [[CGAdSingle single] getAdInfoWithPlatform:@"1" advertisingTypeValue:5];
    if (ylhRewardVideoInfo) {
        self.ylhVideoAd = [[GDTRewardVideoAd alloc] initWithPlacementId:ylhRewardVideoInfo.advertisingSpaceId];
        self.ylhVideoAd.delegate = self;
        GDTServerSideVerificationOptions *ssv = [[GDTServerSideVerificationOptions alloc] init];
        ssv.userIdentifier = self.userId;
        ssv.customRewardString = self.customString;
        self.ylhVideoAd.serverSideVerificationOptions = ssv;
        [self.ylhVideoAd loadAd];
    }else{
        [self requestAdInfo];
    }
}
-(void)createCsjRewardVideoAd{
    CGAdInfoModel *csjRewardVideoInfo = [[CGAdSingle single] getAdInfoWithPlatform:@"2" advertisingTypeValue:5];
    if (csjRewardVideoInfo) {
        BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
        model.userId = self.userId;
        model.extra = self.customString;
        self.csjVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:csjRewardVideoInfo.advertisingSpaceId rewardedVideoModel:model];
        self.csjVideoAd.delegate = self;
        [self.csjVideoAd loadAdData];
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
                if ([CGAdSingle single].adConfig.redPacket == 1) {
                    [self createRewardVideoAd];
                }else{
                    if ([self.delegate respondsToSelector:@selector(cg_createRewardVideoAdFaild:)]) {
                        [self.delegate cg_createRewardVideoAdFaild:@"激励视频未开启"];
                    }
                }
                
            }else{
                //配置已过期，重新拉取配置
                [self requestAdConfig];
            }
        }else{
            //未激活
            if ([self.delegate respondsToSelector:@selector(cg_createRewardVideoAdFaild:)]) {
                [self.delegate cg_createRewardVideoAdFaild:@"广告不在激活时间内"];
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
        if ([self.delegate respondsToSelector:@selector(cg_createRewardVideoAdFaild:)]) {
            [self.delegate cg_createRewardVideoAdFaild:msg];
        }
    }];
}

/**拉取广告位信息**/
-(void)requestAdInfo{
    [[CGAdSingle single] getAdInfoWith:5 success:^{
        [self createRewardVideoAd];
    } faild:^(NSString * _Nonnull msg) {
        if ([self.delegate respondsToSelector:@selector(cg_createRewardVideoAdFaild:)]) {
            [self.delegate cg_createRewardVideoAdFaild:msg];
        }
    }];
}


#pragma mark -- GDTRewardedVideoAdDelegate

- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd{
    NSLog(@"YLH激励视频拉取成功");
    if ([self.delegate respondsToSelector:@selector(cg_rewardVideoAdLoadSuccess:)]) {
        [self.delegate cg_rewardVideoAdLoadSuccess:self];
    }
    
}
- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error{
    NSLog(@"YLH激励视频拉取失败");
    self.ylhVideoAd = nil;
    NSString *last = [CGAdSingle single].platformOrders.lastObject;
    if ([last isEqualToString:@"1"]) {
        //优量汇已经是第二个了
        if ([self.delegate respondsToSelector:@selector(cg_rewardVideoAddLoadFaild:)]) {
            [self.delegate cg_rewardVideoAddLoadFaild:error.localizedDescription];
        }
    }else{
        [self createCsjRewardVideoAd];
    }
}
- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd info:(NSDictionary *)info{
    NSLog(@"YLH激励视频达到奖励条件");
    if ([self.delegate respondsToSelector:@selector(cg_rewardVideoAdDidReward:)]) {
        [self.delegate cg_rewardVideoAdDidReward:self];
    }
}

#pragma mark - 视频
- (void)rewardedVideoAdDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    if ([self.delegate respondsToSelector:@selector(cg_rewardVideoAdLoadSuccess:)]) {
        [self.delegate cg_rewardVideoAdLoadSuccess:self];
    }
    NSLog(@"CSJ激励视频拉取成功");
}

- (void)rewardedVideoAd:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    NSLog(@"CSJ激励视频拉取失败");
    self.csjVideoAd = nil;
    NSString *last = [CGAdSingle single].platformOrders.lastObject;
    if ([last isEqualToString:@"2"]) {
        //穿山甲已经是第二个了
        if ([self.delegate respondsToSelector:@selector(cg_rewardVideoAddLoadFaild:)]) {
            [self.delegate cg_rewardVideoAddLoadFaild:error.localizedDescription];
        }
    }else{
        [self createYlhRewardVideoAd];
    }
}
- (void)rewardedVideoAdDidPlayFinish:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error{
    NSLog(@"CSJ激励视频达到奖励条件");
    if ([self.delegate respondsToSelector:@selector(cg_rewardVideoAdDidReward:)]) {
        [self.delegate cg_rewardVideoAdDidReward:self];
    }
}
- (void)rewardedVideoAdServerRewardDidSucceed:(BURewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify{
    NSLog(@"CSJ激励视频异步服务器验证成功:%@",rewardedVideoAd.rewardedVideoModel.userId);
}

- (void)rewardedVideoAdServerRewardDidFail:(BURewardedVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error{
    NSLog(@"CSJ激励视频异步服务器验证失败");
}
@end
