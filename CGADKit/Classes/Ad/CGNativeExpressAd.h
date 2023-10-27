//
//  CGNativeExpressAd.h
//  ADDemo
//
//  Created by 袁明洋 on 2023/10/27.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDK.h>
#import <GDTMobSDK/GDTNativeExpressAdView.h>
#import <GDTMobSDK/GDTNativeExpressAd.h>
#import "CGAdSingle.h"

@class CGNativeExpressAd;
NS_ASSUME_NONNULL_BEGIN
@protocol CGNativeExpressAdDelegate <NSObject>
/**创建信息流广告失败**/
-(void)cg_createNativeExpressAdFaild:(NSString *)msg;
/**拉取信息流广告失败**/
-(void)cg_nativeExpressAdLoadFaild:(NSString *)msg;
/**拉取信息流广告成功**/
-(void)cg_nativeExpressAdLoadSuccessWithCsjViews:(NSArray<__kindof BUNativeExpressAdView *> * __nullable)csjViews ylhViews:(NSArray<__kindof GDTNativeExpressAdView *> * __nullable)ylhViews;
/**信息流广告渲染成功**/
-(void)cg_nativeExpressAdViewRenderSuccessWithCsjView:(BUNativeExpressAdView * __nullable)csjView ylhView:(GDTNativeExpressAdView * __nullable)ylhView;
/**信息流广告关闭**/
-(void)cg_nativeExpressAdViewDidCloseWithCsjView:(BUNativeExpressAdView * __nullable)csjView ylhView:(GDTNativeExpressAdView * __nullable)ylhView;
@end
@interface CGNativeExpressAd : NSObject
@property (nonatomic,strong) BUNativeExpressAdManager * __nullable csjNativeAd;
@property (nonatomic, strong) GDTNativeExpressAd * __nullable ylhNativeAd;
@property(nonatomic,assign)id<CGNativeExpressAdDelegate>delegate;
@property(nonatomic,assign)NSInteger page;//页面等级

//required
/*以下必须参数赋值之前不要调用createNativeExpressAdWithPage*/
@property(nonatomic,assign)CGSize AdSize;//广告尺寸
@property(nonatomic,assign)NSInteger adCount;//广告数量
@property(nonatomic,assign)BUProposalSize imgSize;//广告图片尺寸（穿山甲用）


-(void)createNativeExpressAdWithPage:(NSInteger) page delegate:(id<CGNativeExpressAdDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
