//
//  CGRewardVideoAd.h
//  ADDemo
//
//  Created by 袁明洋 on 2023/10/26.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDK.h>
#import <GDTMobSDK/GDTRewardVideoAd.h>
#import "CGAdSingle.h"
NS_ASSUME_NONNULL_BEGIN
@class CGRewardVideoAd;
@protocol CGRewardVideoAdDelegate <NSObject>
/**创建激励视频广告失败**/
-(void)cg_createRewardVideoAdFaild:(NSString *)msg;
/**拉取激励视频广告成功**/
-(void)cg_rewardVideoAdLoadSuccess:(CGRewardVideoAd *)splachAd;
/**拉取激励视频广告失败**/
-(void)cg_rewardVideoAddLoadFaild:(NSString *)msg;
/**激励视频广告关闭**/
-(void)cg_rewardVideoAdDidReward:(CGRewardVideoAd *)splachAd;
@end
@interface CGRewardVideoAd : NSObject
@property (nonatomic,strong) BURewardedVideoAd * __nullable csjVideoAd;
@property (nonatomic, strong) GDTRewardVideoAd * __nullable ylhVideoAd;
@property(nonatomic,assign)id<CGRewardVideoAdDelegate>delegate;

@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *customString;
/**初始化**/
-(void)createRewardVideoAdWithUserId:(NSString *)userId customString:(NSString *)customString delegate:(id<CGRewardVideoAdDelegate>)delegate;

/**展示**/
-(void)showRewardVideoWithRootViewController:(UIViewController *)rootViewController;
@end

NS_ASSUME_NONNULL_END
