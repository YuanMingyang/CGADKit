//
//  CGAdConfigModel.h
//  ADDemo
//
//  Created by 袁明洋 on 2023/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//广告配置信息
@interface CGAdConfigModel : NSObject

//广告配置的拉取时间
@property(nonatomic,assign)NSInteger createDate;

//激活时间，可控制渠道是否关闭
@property(nonatomic,assign)NSInteger activationTime;
//配置有效时间，有效时间内不再重复拉取配置
@property(nonatomic,assign)NSInteger validTime;
//控制激励视频，0 关闭 1 开启
@property(nonatomic,assign)NSInteger redPacket;
//插屏控制时间，-1 关闭，0 不限制展示，>=0 标识间隔多少`秒之后展示
@property(nonatomic,assign)NSInteger cpTime;
//首页信息流是否开启 0 关闭 1 开启
@property(nonatomic,assign)NSInteger firstPageOpen;
//二级页信息流是否开启 0 关闭 1 开启
@property(nonatomic,assign)NSInteger secondPageOpen;
//是否开启收集终端信息 0 默认 1 开启
@property(nonatomic,assign)NSInteger ttInfoOpen;
@end

NS_ASSUME_NONNULL_END
