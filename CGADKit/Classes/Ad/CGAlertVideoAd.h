//
//  CGAlertVideoAd.h
//  ADDemo
//
//  Created by 袁明洋 on 2023/10/27.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDK.h>
#import <GDTMobSDK/GDTUnifiedInterstitialAd.h>
#import "CGAdSingle.h"
NS_ASSUME_NONNULL_BEGIN
@class CGAlertVideoAd;

@protocol CGAlertVideoAdDelegate <NSObject>
/**创建插屏广告失败**/
-(void)cg_createAlertVideoAdFaild:(NSString *)msg;
/**拉取插屏广告成功**/
-(void)cg_AlertVideoAdLoadSuccess:(CGAlertVideoAd *)alertVideoAd;
/**拉取开插屏广告失败**/
-(void)cg_AlertVideoAddLoadFaild:(NSString *)msg;
/**插屏广告关闭**/
-(void)cg_AlertVideoAdDidClose:(CGAlertVideoAd *)alertVideoAd;
@end
@interface CGAlertVideoAd : NSObject
@property(nonatomic,strong)GDTUnifiedInterstitialAd *__nullable ylhAd;
@property(nonatomic,strong)BUNativeExpressFullscreenVideoAd *__nullable csjAd;
@property(nonatomic,assign)id<CGAlertVideoAdDelegate>delegate;

-(void)createAlertVideoAdWithDelegate:(id<CGAlertVideoAdDelegate>)delegate;
-(void)showAlertVideoWithRootViewController:(UIViewController *)rootViewController;

@end

NS_ASSUME_NONNULL_END
