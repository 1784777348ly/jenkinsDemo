//
//  HGSaveNoticeTool.h
//  Hui10Game
//
//  Created by LY on 16/12/13.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGSaveNoticeTool : NSObject

//存用户基本数据
+(void)updatePersonInfodataWithKey:(NSString *)key andValue:(id )value;


//获取用户基本数据
+(id)obtainPersonInfoDataWithKey:(NSString *)key;

//清空用户的基本信息
+(void)clearUserInfoWithKey:(NSString *)key;


//存储缓存数据
+(void)updateCatheWithKey:(NSString *)key andValue:(id)value;

//清空某个缓存
+(void)clearCatheWithKey:(NSString *)key;


//获得缓存数组
+(NSArray *)obtainCatheArrayWithKey:(NSString *)key;

//获得缓存字典
+(NSDictionary *)obtainCatheDictionaryWithKey:(NSString *)key;


@end
