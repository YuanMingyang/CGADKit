//
//  CGAdSingle.m
//  ADDemo
//
//  Created by 袁明洋 on 2023/10/26.
//

#import "CGAdSingle.h"
#import <UIKit/UIKit.h>
#import <BU_AFHTTPSessionManager.h>
#import <BUAdSDK/BUAdSDK.h>
#import <GDTMobSDK/GDTSDKConfig.h>

@implementation CGAdSingle
static CGAdSingle *single;
+(instancetype)single{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [CGAdSingle new];
        single.isn = @"1";
    });
    return single;
}

-(void)initAdSdkWith:(NSString *)partnerId placeId:(NSString *)placeId success:(void(^)(void))success2 faild:(void(^)(NSString *msg))faild{
    self.partnerId = partnerId;
    self.placeId = placeId;
    [self getAdInfoWith:1 success:^{
        BUAdSDKConfiguration *configuration = [BUAdSDKConfiguration configuration];
        configuration.appID = self.csjAppId;//除appid外，其他参数配置按照项目实际需求配置即可。
        [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
            if (success) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    BOOL result = [GDTSDKConfig registerAppId:self.ylhAppId];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (result) {
                            self.isInitSuccess = YES;
                            success2();
                        }else{
                            faild(@"优量汇SDK初始化失败");
                        }
                    });
                });
            }else{
                faild([NSString stringWithFormat:@"穿山甲SDK获取失败:%@",error.localizedDescription]);
            }
        }];
    } faild:^(NSString * _Nonnull msg) {
        faild(@"AppId获取失败");
    }];
}


-(void)getAdInfoWith:(NSInteger )aps success:(void (^)(void))success faild:(void (^)(NSString * _Nonnull))faild{
    NSString *url = @"http://111.229.53.10:8081/advertisement/info";
    NSMutableDictionary *dic = [self commonParam];
    dic[@"aps"] = @(aps);
    dic[@"placeId"] = self.placeId;
    dic[@"partnerId"] = self.partnerId;
    [[BU_AFHTTPSessionManager manager] POST:url parameters:@{@"data":[CGAdTool dataTojsonString:dic]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            NSDictionary *data = responseObject[@"data"];
            NSString *platformOrder = data[@"platformOrder"];
            self.platformOrders = [platformOrder componentsSeparatedByString:@"#"];
            
            //赋值穿山甲appID
            NSDictionary *csjInfo = data[@"csjInfo"];
            self.csjAppId = csjInfo[@"appId"];
            NSArray *csjInfos = csjInfo[@"csjInfos"];
            CGAdInfoModel *csjInfoModel = [CGAdInfoModel new];
            [csjInfoModel setValuesForKeysWithDictionary:csjInfos.firstObject];
            [self.csjAds addObject:csjInfoModel];
            //赋值优量汇appID
            NSDictionary *gdtInfo = data[@"gdtInfo"];
            self.ylhAppId = gdtInfo[@"appId"];
            NSArray *gdtInfos = gdtInfo[@"gdtInfos"];
            CGAdInfoModel *gdtInfoModel = [CGAdInfoModel new];
            [gdtInfoModel setValuesForKeysWithDictionary:gdtInfos.firstObject];
            [self.ylhAds addObject:gdtInfoModel];
            
            success();
        }else{
            faild(responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        faild(error.localizedDescription);
    }];
}


-(void)getAdConfigWith:(void (^)(void))success faild:(void (^)(NSString * _Nonnull))faild{
    NSString *url = @"http://111.229.53.10:8081/advertisement/config";
    NSMutableDictionary *dic = [self commonParam];
    dic[@"placeId"] = self.placeId;
    dic[@"partnerId"] = self.partnerId;
    [[BU_AFHTTPSessionManager manager] POST:url parameters:@{@"data":[CGAdTool dataTojsonString:dic]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            CGAdConfigModel *config = [CGAdConfigModel new];
            [config setValuesForKeysWithDictionary:responseObject[@"data"]];
            config.createDate = [[NSDate date] timeIntervalSince1970];
            self.adConfig = config;
            success();
        }else{
            faild(responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        faild(error.localizedDescription);
    }];
}

/**获取广告位
    platForm:1、优量汇  2、穿山甲
 **/
-(CGAdInfoModel *)getAdInfoWithPlatform:(NSString *)platForm advertisingTypeValue:(NSInteger)advertisingTypeValue{
    if ([platForm isEqualToString:@"1"]) {
        for (CGAdInfoModel *adInfo in self.ylhAds) {
            if (adInfo.advertisingTypeValue == advertisingTypeValue) {
                return  adInfo;
            }
        }
    }else{
        for (CGAdInfoModel *adInfo in self.csjAds) {
            if (adInfo.advertisingTypeValue == advertisingTypeValue) {
                return  adInfo;
            }
        }
    }
    return  nil;
}

/**懒加载**/
-(NSMutableArray *)csjAds{
    if (_csjAds == nil) {
        _csjAds = [NSMutableArray array];
    }
    return _csjAds;
}
-(NSMutableArray *)ylhAds{
    if (_ylhAds == nil) {
        _ylhAds = [NSMutableArray array];
    }
    return _ylhAds;
}
-(NSMutableDictionary *)commonParam{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"hm"] = @"apple";
    dic[@"ht"] = [CGAdTool getDeviceName];
    dic[@"ov"] = [[UIDevice currentDevice] systemVersion];
    dic[@"nt"] = @(3);//[CGAdTool getNetworkType];
    dic[@"partnerId"] = [CGAdSingle single].partnerId;
    dic[@"placeId"] = [CGAdSingle single].placeId;
    dic[@"ch"] = @"ch";
    dic[@"isn"] = @(0);//[CGAdSingle single].isn;
    dic[@"appName"] = [CGAdTool getAppDisplayName];
    dic[@"packageName"] = [CGAdTool getAppBundleId];
    dic[@"apkVersion"] = [CGAdTool getAppVersion];
    dic[@"sdkVersion"] = SDKVersion;
    dic[@"sdkVersionCode"] = SDKVersionCode;
    return  dic;
}
@end
