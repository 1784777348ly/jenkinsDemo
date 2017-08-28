//
//  HGSaveNoticeTool.m
//  Hui10Game
//
//  Created by LY on 16/12/13.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "HGSaveNoticeTool.h"
#import "DataManager.h"


@implementation HGSaveNoticeTool


/*******************************用户数据存储**********************************/

//存用户基本数据
+(void)updatePersonInfodataWithKey:(NSString *)key andValue:(id )value
{
    DataManager *manger = [DataManager manager];

    NSString *filepath = [manger obtainfilePathWithFileName:LYAccount];

    NSMutableDictionary *datalist= [[[NSMutableDictionary alloc]initWithContentsOfFile:filepath]mutableCopy];
    
    NSMutableDictionary *personInfoDic = datalist[@"mergentInfoDic"];

    [personInfoDic setValue:value forKey:key];
    
    if ([datalist writeToFile:filepath atomically:YES]) {
        
       //  NSLog(@"用户基本数据存储成功");
        
    }

    
}

//获取用户基本数据
+(id)obtainPersonInfoDataWithKey:(NSString *)key
{
    DataManager *manger = [DataManager manager];
    
    NSString *filepath = [manger obtainfilePathWithFileName:LYAccount];
    //读取文件
    NSMutableDictionary *datalist = [[NSMutableDictionary alloc] initWithContentsOfFile:filepath];
    
     NSMutableDictionary *personInfoDic = datalist[@"mergentInfoDic"];

    return [personInfoDic objectForKey:key];
    
}


//清空用户的基本信息
+(void)clearUserInfoWithKey:(NSString *)key
{
    DataManager *manger = [DataManager manager];
    
    NSString *filepath = [manger obtainfilePathWithFileName:LYAccount];
    
    NSMutableDictionary *datalist= [[[NSMutableDictionary alloc]initWithContentsOfFile:filepath]mutableCopy];
    
    NSMutableArray *keyArr = [[datalist objectForKey:key] mutableCopy];
    
    [keyArr removeAllObjects];
    
    
    if (keyArr == nil) {
        
        return;
        
    }
    
    [datalist setObject:keyArr forKey:key];
    
    if ([datalist writeToFile:filepath atomically:YES]) {
        
       // NSLog(@"用户数据清理成功");
    }
    
    
    
}




/*********************存储缓存数据 以data数据类型存储***********************************/

+(void)updateCatheWithKey:(NSString *)key andValue:(id)value
{
    DataManager *manger = [DataManager manager];
    [manger saveDataWithFilename:LYAccount];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
    [manger object:data writeToFile:key superFile:LYAccount];
}

//清除某个缓存
+(void)clearCatheWithKey:(NSString *)key
{
    DataManager *manger = [DataManager manager];
    
    [manger deleteSubFile:key ofSuperFile:LYAccount];

}



//获得缓存数组
+(NSArray *)obtainCatheArrayWithKey:(NSString *)key
{
    DataManager *manager = [DataManager manager];
    NSData *data = [manager dataFromFile:key superFile:LYAccount];
    
    if (!data) {
        return nil;
    }
    
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return [arr mutableCopy];

}

//获得缓存字典
+(NSDictionary *)obtainCatheDictionaryWithKey:(NSString *)key
{
    DataManager *manager = [DataManager manager];
    NSData *data = [manager dataFromFile:key superFile:LYAccount];
    
    if (!data) {
        return nil;
    }
    
    NSDictionary *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return [arr mutableCopy];
    
}























@end
