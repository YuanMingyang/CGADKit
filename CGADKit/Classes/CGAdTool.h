//
//  CGAdTool.h
//  ADDemo
//
//  Created by 袁明洋 on 2023/10/26.
//

#import <Foundation/Foundation.h>
#import "CGAdConfigModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGAdTool : NSObject


/**获取手机型号**/
+(NSString *)getDeviceName;
/**获取当前网络状态**/
+(NSString *)getNetworkType;

/*获取当前App的包名信息*/
+ (NSString *)getAppBundleId;

/*获取当前App的名称信息*/
+ (NSString *)getAppDisplayName;

/*获取当前App的版本号信息*/
+ (NSString *)getAppVersion;

/**转JSON**/
+ (NSString *)dataTojsonString:(id)object;
@end

NS_ASSUME_NONNULL_END
