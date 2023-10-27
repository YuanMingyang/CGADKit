//
//  CGNativeExpressAd.m
//  ADDemo
//
//  Created by 袁明洋 on 2023/10/27.
//

#import "CGNativeExpressAd.h"
#import "CGNativeExpressAdTool.h"
@interface CGNativeExpressAd()<GDTNativeExpressAdDelegete,CGNativeExpressAdToolDelegate>

@end
@implementation CGNativeExpressAd
-(void)createNativeExpressAdWithPage:(NSInteger)page delegate:(id<CGNativeExpressAdDelegate>)delegate{
    self.page = page;
    self.delegate = delegate;
    if ([CGAdSingle single].isInitSuccess) {
        [self checkAdConfig];
    }else{
        if ([self.delegate respondsToSelector:@selector(cg_createNativeExpressAdFaild:)]) {
            [self.delegate cg_createNativeExpressAdFaild:@"SDK未初始化"];
        }
    }
}

-(void)createNativeExpressAd{
    NSString *first = [CGAdSingle single].platformOrders.firstObject;
    if ([first isEqualToString:@"1"]) {//优良汇
        [self createYlhNativeExpressAd];
    }else{//穿山甲
        [self createCsjNativeExpressAd];
    }
}
-(void)createYlhNativeExpressAd{
    CGAdInfoModel *ylhNativeExpressAdInfo = [[CGAdSingle single] getAdInfoWithPlatform:@"1" advertisingTypeValue:4];
    if (ylhNativeExpressAdInfo) {
        self.ylhNativeAd = [[GDTNativeExpressAd alloc] initWithPlacementId:ylhNativeExpressAdInfo.advertisingSpaceId adSize:self.AdSize];
        self.ylhNativeAd.delegate = self;
        [self.ylhNativeAd loadAd:self.adCount];
    }else{
        [self requestAdInfo];
    }
}
-(void)createCsjNativeExpressAd{
    CGAdInfoModel *csjNativeExpressAdInfo = [[CGAdSingle single] getAdInfoWithPlatform:@"2" advertisingTypeValue:4];
    if (csjNativeExpressAdInfo) {
        BUAdSlot *slot1 = [[BUAdSlot alloc] init];
        slot1.ID = csjNativeExpressAdInfo.advertisingSpaceId;
        slot1.AdType = BUAdSlotAdTypeFeed;
        slot1.position = BUAdSlotPositionFeed;
        slot1.imgSize = [BUSize sizeBy:self.imgSize];
        self.csjNativeAd = [[BUNativeExpressAdManager alloc] initWithSlot:slot1 adSize:self.AdSize];
        self.csjNativeAd.adslot = slot1;
        [CGNativeExpressAdTool share].delegate = self;
        self.csjNativeAd.delegate = [CGNativeExpressAdTool share];
        [self.csjNativeAd loadAdDataWithCount:self.adCount];
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
                if (self.page == 1) {//一级页面
                    if ([CGAdSingle single].adConfig.firstPageOpen == 1) {
                        [self createNativeExpressAd];
                    }else{
                        if ([self.delegate respondsToSelector:@selector(cg_createNativeExpressAdFaild:)]) {
                            [self.delegate cg_createNativeExpressAdFaild:@"首页信息流广告未开启"];
                        }
                    }
                }
                
                if (self.page == 2) {//二级页面
                    if ([CGAdSingle single].adConfig.secondPageOpen == 1) {
                        [self createNativeExpressAd];
                    }else{
                        if ([self.delegate respondsToSelector:@selector(cg_createNativeExpressAdFaild:)]) {
                            [self.delegate cg_createNativeExpressAdFaild:@"二级页面信息流广告未开启"];
                        }
                    }
                }
                
            }else{
                //配置已过期，重新拉取配置
                [self requestAdConfig];
            }
        }else{
            //未激活
            if ([self.delegate respondsToSelector:@selector(cg_createNativeExpressAdFaild:)]) {
                [self.delegate cg_createNativeExpressAdFaild:@"广告不在激活时间内"];
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
        if ([self.delegate respondsToSelector:@selector(cg_createNativeExpressAdFaild:)]) {
            [self.delegate cg_createNativeExpressAdFaild:msg];
        }
    }];
}

/**拉取广告位信息**/
-(void)requestAdInfo{
    [[CGAdSingle single] getAdInfoWith:4 success:^{
        [self createNativeExpressAd];
    } faild:^(NSString * _Nonnull msg) {
        if ([self.delegate respondsToSelector:@selector(cg_createNativeExpressAdFaild:)]) {
            [self.delegate cg_createNativeExpressAdFaild:msg];
        }
    }];
}


#pragma mark - GDTNativeExpressAdDelegete

- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views{
    NSLog(@"YLH信息流广告拉取成功");
    if ([self.delegate respondsToSelector:@selector(cg_nativeExpressAdLoadSuccessWithCsjViews:ylhViews:)]) {
        [self.delegate cg_nativeExpressAdLoadSuccessWithCsjViews:nil ylhViews:views];
    }
}

- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error{
    NSLog(@"YLH信息流广告拉取失败");
    self.ylhNativeAd = nil;
    NSString *last = [CGAdSingle single].platformOrders.lastObject;
    if ([last isEqualToString:@"1"]) {
        //优量汇已经是第二个了
        if ([self.delegate respondsToSelector:@selector(cg_nativeExpressAdLoadFaild:)]) {
            [self.delegate cg_nativeExpressAdLoadFaild:error.localizedDescription];
        }
    }else{
        [self createCsjNativeExpressAd];
    }
    
}
- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView{
    NSLog(@"YLH信息流广告渲染成功");
    if ([self.delegate respondsToSelector:@selector(cg_nativeExpressAdViewRenderSuccessWithCsjView:ylhView:)]) {
        [self.delegate cg_nativeExpressAdViewRenderSuccessWithCsjView:nil ylhView:nativeExpressAdView];
    }
    
}
- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView{
    NSLog(@"YLH信息流广告被关闭");
    if ([self.delegate respondsToSelector:@selector(cg_nativeExpressAdViewDidCloseWithCsjView:ylhView:)]) {
        [self.delegate cg_nativeExpressAdViewDidCloseWithCsjView:nil ylhView:nativeExpressAdView];
    }
}

#pragma mark -- CGNativeExpressAdToolDelegate
- (void)cg_nativeExpressAdFailToLoad:(nonnull BUNativeExpressAdManager *)nativeExpressAdManager error:(NSError * _Nullable)error {
    self.csjNativeAd = nil;
    NSString *last = [CGAdSingle single].platformOrders.lastObject;
    if ([last isEqualToString:@"2"]) {
        //穿山甲已经是第二个了
        if ([self.delegate respondsToSelector:@selector(cg_nativeExpressAdLoadFaild:)]) {
            [self.delegate cg_nativeExpressAdLoadFaild:error.localizedDescription];
        }
    }else{
        [self createYlhNativeExpressAd];
    }
    NSLog(@"CSJ信息流广告拉取失败");
    
}

- (void)cg_nativeExpressAdSuccessToLoad:(nonnull BUNativeExpressAdManager *)nativeExpressAdManager views:(nonnull NSArray<__kindof BUNativeExpressAdView *> *)views {
    NSLog(@"CSJ信息流广告拉取成功");
    if ([self.delegate respondsToSelector:@selector(cg_nativeExpressAdLoadSuccessWithCsjViews:ylhViews:)]) {
        [self.delegate cg_nativeExpressAdLoadSuccessWithCsjViews:views ylhViews:nil];
    }
}

- (void)cg_nativeExpressAdViewDidRemoved:(nonnull BUNativeExpressAdView *)nativeExpressAdView { 
    NSLog(@"CSJ信息流广告被关闭");
    if ([self.delegate respondsToSelector:@selector(cg_nativeExpressAdViewDidCloseWithCsjView:ylhView:)]) {
        [self.delegate cg_nativeExpressAdViewDidCloseWithCsjView:nativeExpressAdView ylhView:nil];
    }
}

- (void)cg_nativeExpressAdViewRenderSuccess:(nonnull BUNativeExpressAdView *)nativeExpressAdView { 
    NSLog(@"CSJ信息流广告渲染成功");
    if ([self.delegate respondsToSelector:@selector(cg_nativeExpressAdViewRenderSuccessWithCsjView:ylhView:)]) {
        [self.delegate cg_nativeExpressAdViewRenderSuccessWithCsjView:nativeExpressAdView ylhView:nil];
    }
}

@end
