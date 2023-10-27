//
//  CGSplachAd.h
//  ADDemo
//
//  Created by 袁明洋 on 2023/10/26.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDK.h>
#import <GDTMobSDK/GDTSplashAd.h>
#import "CGAdSingle.h"
@class CGSplachAd;

NS_ASSUME_NONNULL_BEGIN
@protocol CGSplachAdDelegate <NSObject>
/**创建开屏广告失败**/
-(void)cg_createSplashAdFaild:(NSString *)msg;
/**拉取开屏广告成功**/
-(void)cg_splashAdLoadSuccess:(CGSplachAd *)splachAd;
/**拉取开屏广告失败**/
-(void)cg_splashAdLoadFaild:(NSString *)msg;
/**开屏广告关闭**/
-(void)cg_splashAdDidClose:(CGSplachAd *)splachAd;
@end

@interface CGSplachAd : NSObject
/**广告大小**/
@property(nonatomic,assign)CGSize adSize;
@property(nonatomic,assign)id<CGSplachAdDelegate>delegate;

/**穿山甲开屏**/
@property(nonatomic, strong)BUSplashAd *__nullable csjSplashAd;
/**优量汇开屏**/
@property (nonatomic, strong)GDTSplashAd *__nullable ylhSplashAd;

/**初始化**/
-(void)createSplashAdWithSize:(CGSize)size delegate:(id<CGSplachAdDelegate>)delegate;
/**展示**/
-(void)showSplashAdWithWindow:(UIWindow *)window;
@end

NS_ASSUME_NONNULL_END
