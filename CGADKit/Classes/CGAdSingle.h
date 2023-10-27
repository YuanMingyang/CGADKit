//
//  CGAdSingle.h
//  ADDemo
//
//  Created by 袁明洋 on 2023/10/26.
//

#import <Foundation/Foundation.h>
#import "CGAdConfigModel.h"
#import "CGAdTool.h"
#import "CGAdInfoModel.h"


#define SDKVersion @"1.0.0"
#define SDKVersionCode @"100"
NS_ASSUME_NONNULL_BEGIN

@interface CGAdSingle : NSObject
+(instancetype)single;

//是否初始化成功
@property(nonatomic,assign)BOOL isInitSuccess;

/**广告配置**/
@property(nonatomic,strong)CGAdConfigModel *adConfig;
/**获取广告配置需要的渠道ID**/
@property(nonatomic,strong)NSString *placeId;
/**是否是新用户**/
@property(nonatomic,strong)NSString *isn;
/**合作方ID**/
@property(nonatomic,strong)NSString *partnerId;
/**穿山甲广告位**/
@property(nonatomic,strong)NSMutableArray *csjAds;
/**优良汇广告位**/
@property(nonatomic,strong)NSMutableArray *ylhAds;
/**穿山甲AppID**/
@property(nonatomic,strong)NSString *csjAppId;
/**优良汇AppID**/
@property(nonatomic,strong)NSString *ylhAppId;

/**csj和ylh的先后顺序**/
@property(nonatomic,strong)NSArray *platformOrders;

/**初始化SDK**/
-(void)initAdSdkWith:(NSString *)partnerId placeId:(NSString *)placeId success:(void(^)(void))success faild:(void(^)(NSString *msg))faild;
/**获取广告位
 广告位类型1 开屏，2插屏，3 banner，4 信息流，5激励视频
 **/
-(void)getAdInfoWith:(NSInteger)aps success:(void(^)(void))success faild:(void(^)(NSString *msg))faild;
/**获取广告配置**/
-(void)getAdConfigWith:(void(^)(void))success faild:(void(^)(NSString *msg))faild;


/**获取广告位
    platForm:1、优量汇  2、穿山甲
    advertisingTypeValue：广告位类型1 开屏，2插屏，3 banner，4 信息流，5激励视频
 **/
-(CGAdInfoModel *)getAdInfoWithPlatform:(NSString *)platForm advertisingTypeValue:(NSInteger)advertisingTypeValue;
@end

NS_ASSUME_NONNULL_END
