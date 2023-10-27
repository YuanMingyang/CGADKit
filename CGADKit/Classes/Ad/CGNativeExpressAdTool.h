//
//  CGNativeExpressAdTool.h
//  ADDemo
//
//  Created by 袁明洋 on 2023/10/27.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDK.h>
NS_ASSUME_NONNULL_BEGIN
@protocol CGNativeExpressAdToolDelegate <NSObject>
- (void)cg_nativeExpressAdSuccessToLoad:(BUNativeExpressAdManager *)nativeExpressAdManager views:(NSArray<__kindof BUNativeExpressAdView *> *)views;
- (void)cg_nativeExpressAdFailToLoad:(BUNativeExpressAdManager *)nativeExpressAdManager error:(NSError *_Nullable)error;
- (void)cg_nativeExpressAdViewRenderSuccess:(BUNativeExpressAdView *)nativeExpressAdView;
- (void)cg_nativeExpressAdViewDidRemoved:(BUNativeExpressAdView *)nativeExpressAdView;

@end
@interface CGNativeExpressAdTool : NSObject<BUNativeExpressAdViewDelegate>
+(instancetype)share;
@property(nonatomic,assign)id<CGNativeExpressAdToolDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
