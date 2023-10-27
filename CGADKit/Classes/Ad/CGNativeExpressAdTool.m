//
//  CGNativeExpressAdTool.m
//  ADDemo
//
//  Created by 袁明洋 on 2023/10/27.
//

#import "CGNativeExpressAdTool.h"

@implementation CGNativeExpressAdTool

static CGNativeExpressAdTool *tool;
+(instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [CGNativeExpressAdTool new];
    });
    return  tool;
}


#pragma mark -- BUNativeExpressAdViewDelegate
- (void)nativeExpressAdSuccessToLoad:(BUNativeExpressAdManager *)nativeExpressAdManager views:(NSArray<__kindof BUNativeExpressAdView *> *)views{
    [self.delegate cg_nativeExpressAdSuccessToLoad:nativeExpressAdManager views:views];

}
- (void)nativeExpressAdFailToLoad:(BUNativeExpressAdManager *)nativeExpressAdManager error:(NSError *_Nullable)error{
    [self.delegate cg_nativeExpressAdFailToLoad:nativeExpressAdManager error:error];
}
- (void)nativeExpressAdViewRenderSuccess:(BUNativeExpressAdView *)nativeExpressAdView{
    [self.delegate cg_nativeExpressAdViewRenderSuccess:nativeExpressAdView];
    
}
- (void)nativeExpressAdViewDidRemoved:(BUNativeExpressAdView *)nativeExpressAdView{
    [self.delegate cg_nativeExpressAdViewDidRemoved:nativeExpressAdView];
    
}
@end
