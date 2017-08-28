//
//  LotteryManagerPlugin.h
//  BetSiteBindUser
//
//  Created by tao6 on 2017/1/16.
//  Copyright © 2017年 tao6. All rights reserved.
//

#import <UIKit/UIKit.h>

// 需要自定义等待视图
@protocol lotteryManagerDelegate <NSObject>

/**
 开始使用等待视图
 */
- (void)startShowLoadingView;

/**
 结束使用等待视图
 */
- (void)endShowLoadingView;

@end


@interface LotteryManagerPlugin : NSObject


/**
 代理（自定义等待视图）
 */
@property (nonatomic, weak) id<lotteryManagerDelegate> delegate;


/**
 单例，获取当前实例
 
 @return 返回当前对象
 */
+ (instancetype)shareManager;


/**
 绑定用户
 验证用户输入的支付密码，验证通过后记录用户与投注站绑定关系。
 

 @param param 参数字典。 请求参数包括：
                             channelID          渠道商ID
                             stationNo          投注站编号
                             stationProvince    投注站省份编码
                             channelToken       操作令牌
                             userPhoneNo        用户手机号
 
 @param completedBlock 结果回调。
 
                       opreatResult         0,    // 操作成功
                                            1,    // 操作失败
                                            2,    // 操作取消
 
                        betPwd              待投注支付密码
                        resultMsg           提示语
 @return 插件是否成功启动 （成功／失败）
 */
- (BOOL)startBindUser:(NSDictionary *)param
          resultBlock:(void (^)(NSInteger opreatResult, NSString *betPwd, NSString *resultMsg))completedBlock;

@end
