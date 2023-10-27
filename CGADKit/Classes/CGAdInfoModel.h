//
//  CGAdInfoModel.h
//  ADDemo
//
//  Created by 袁明洋 on 2023/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGAdInfoModel : NSObject
//广告位ID
@property(nonatomic,strong)NSString *advertisingSpaceId;
//广告位类型1 开屏，2插屏，3 banner，4 信息流，5激励视频
@property(nonatomic,assign)NSInteger advertisingTypeValue;
@end

NS_ASSUME_NONNULL_END
