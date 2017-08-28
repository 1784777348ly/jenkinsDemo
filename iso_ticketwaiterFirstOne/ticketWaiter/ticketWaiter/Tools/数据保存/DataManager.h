//
//  DataManager.h
//  HSDataManager
//
//  Created by hui10 on 16/8/4.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <Foundation/Foundation.h>
//暂时不用 默认存储在Document下面
//
//typedef NS_ENUM(NSUInteger, FileTypeEnum){
//    
//    HSFileTypeDocument = 0,
//    HSFileTypeLibrary,
//    HSFileTypeCache
//};

@interface DataManager : NSObject

+ (instancetype)manager;
/**
 *  根据名称来区分不同文件夹(不同用户的数据文件存放在Document->Users->"xxx"路径下)
 *  "xxx" 用户唯一标识符 e.g. UserOne UserTwo UserThr
 *  @param fileName 文件名字
 */
- (void)saveDataWithFilename:(NSString *)fileName;
/**
 *  对象写入文件
 *
 *  @param object   对象
 *  @param fixName  文件 名字
 *  @param fileName 父级 文件夹 名字
 *
 *  @return 是否写入成功
 */
- (BOOL)object:(id)object writeToFile:(NSString *)fixName superFile:(NSString *)fileName;

/**
 *  读取父级文件夹目录下对应的fixName文件
 *
 *  @param fixName  文件 名字
 *  @param fileName 父级 文件 夹名字
 *
 *  @return data
 */
- (NSData *)dataFromFile:(NSString *)fixName superFile:(NSString *)fileName;
/**
 *  删除对应路径下的所有文件
 *
 *  @param fileName 要删除的文件名 e.g. UserOne/UserTwo
 *
 *  @return 是否删除成功
 */
- (BOOL)deleteFile:(NSString *)fileName;
/**
 *  删除对应路径下文件名为fixName的文件
 *
 *  @param fixName 文件名 e.g. userName/userInfo
 *
 *  @return 是否删除成功
 */
- (BOOL)deleteSubFile:(NSString *)fixName ofSuperFile:(NSString *)fileName;
/**
 *  删除沙盒Document下所有用户文件
 *
 *  @return 是否删除成功
 */
- (BOOL)deleteAllFiles;
/**
 *  将原文件内容拷贝到新文件中
 *
 *  @param oldFileName 原文件名
 *  @param newFileName 新文件名
 */
- (BOOL)copyFileContentFromFile:(NSString *)oldFileName toFile:(NSString *)newFileName;

/*
 *  获得路径名
 */
- (NSString *)obtainfilePathWithFileName:(NSString *)fileName;

@end



























