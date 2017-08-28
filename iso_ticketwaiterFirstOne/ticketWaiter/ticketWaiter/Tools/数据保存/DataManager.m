//
//  DataManager.m
//  HSDataManager
//
//  Created by hui10 on 16/8/4.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+ (instancetype)manager{
    
    return [DataManager new];
}

/**
 *  获取Document路径
 *
 *  @return path
 */
- (NSString *)getDocumentPath{
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *rootPath = [path stringByAppendingPathComponent:@"Users"];
    
    return rootPath;
}

-(NSString *)obtainfilePathWithFileName:(NSString *)fileName
{
    NSString *tmpstr = [self getDocumentPath];
    
    NSString *path   = [tmpstr stringByAppendingPathComponent:fileName];
    
    //获取路径数据 默认是personInfo里面
    return [path stringByAppendingPathComponent:@"LYDetailInfomation.plist"];
}

/**
 *  拼接文件路径
 *
 *  @param fixName  文件后缀名
 *
 *  @return 完整路径
 */
- (NSString *)appendFileType:(NSString *)fixName superFile:(NSString *)fileName{
    
    NSString *superPath = [[self getDocumentPath] stringByAppendingPathComponent:fileName];
    NSString *path      = [superPath stringByAppendingPathComponent:fixName];
    
    NSLog(@"__________   %@   ",path);
    
    return path;
}
/**
 *  对象写入文件
 *
 *  @param object  对象
 *  @param fixName 文件后缀名
 *
 *  @return 是否写入成功
 */
- (BOOL)object:(id)object writeToFile:(NSString *)fixName superFile:(NSString *)fileName{
    
    NSString *file = [self appendFileType:fixName superFile:fileName];
    
    if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSMutableArray class]]) {
        
        object = [NSKeyedArchiver archivedDataWithRootObject:object];
    }
    
    return [self objectWriteToFile:file object:object];
    
}
/**
 *  动态添加方法
 *
 *  @param self object
 *  @param _cmd 方法实现
 *  @param path 路径参数
 */
void addClassMethod(id self, SEL _cmd,id path)
{
    
    BOOL isSuccess = [self writeToFile:path atomically:YES];
    if (isSuccess) {
        NSLog(@"看起来是写入成功了...好嗨森");
    }else{
        NSLog(@"未知错误");
    }

}

- (BOOL)objectWriteToFile:(NSString *)path object:(id)object{
    
    NSError *error;
    
    if (![object respondsToSelector:@selector(writeToFile: atomically: encoding: error:)]) {
        
        SEL sel = @selector(classAddWriteMethod:);
        
        BOOL isAdd = class_addMethod([object class], sel, (IMP)addClassMethod, "v@:");
        
        [object performSelector:sel withObject:path];
        
        return isAdd;
        
    } else {
        
        return [object writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
}
/**
 *  用户个人信息文件夹
 *
 *  @param fileName 用户唯一标识符
 */
- (void)saveDataWithFilename:(NSString *)fileName{
    
    NSString *singleUser   = [[self getDocumentPath] stringByAppendingPathComponent:fileName];
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:singleUser]) {
        [manager createDirectoryAtPath:singleUser withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"路径已经存在! 请勿重复创建!");
    }
    
}





/**
 *  读取对应路径下的data
 *
 *  @param fixName 后缀名
 *
 *  @return data
 */
- (NSData *)dataFromFile:(NSString *)fixName superFile:(NSString *)fileName{
    
    NSString *filePath = [self appendFileType:fixName superFile:fileName];
    NSData *data       = [NSData dataWithContentsOfFile:filePath];
    
    return data;
}
/**
 *  删除对应路径下的所有文件
 *
 *  @param fileName 要删除的文件名 e.g. UserOne/UserTwo
 *
 *  @return 是否删除成功
 */
- (BOOL)deleteFile:(NSString *)fileName{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *deletePath   = [[self getDocumentPath] stringByAppendingPathComponent:fileName];
    
    if ([manager fileExistsAtPath:deletePath]) {
        
      return [manager removeItemAtPath:deletePath error:nil];
        
    } else {
        return NO;
    }

}
/**
 *  删除对应路径下文件名为fixName的文件
 *
 *  @param fixName 文件名 e.g. userName/userInfo
 *
 *  @return 是否删除成功
 */
- (BOOL)deleteSubFile:(NSString *)fixName ofSuperFile:(NSString *)fileName{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *deletePath   = [[self getDocumentPath] stringByAppendingPathComponent:fileName];
    NSString *subfilePath  = [deletePath stringByAppendingPathComponent:fixName];
    
    if ([manager fileExistsAtPath:subfilePath]) {
        
        return [manager removeItemAtPath:subfilePath error:nil];
        
    } else {
        
        return NO;
    }
}
/**
 *  删除沙盒Document下所有用户文件
 *
 *  @return 是否删除成功
 */
- (BOOL)deleteAllFiles{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *rootPath     = [self getDocumentPath];

    if ([manager fileExistsAtPath:rootPath]) {
        
        return [manager removeItemAtPath:rootPath error:nil];
        
    } else {
        
        return NO;
    }
}
/**
 *  将原文件内容拷贝到新文件中
 *
 *  @param oldFileName 原文件名
 *  @param newFileName 新文件名
 */
- (BOOL)copyFileContentFromFile:(NSString *)oldFileName toFile:(NSString *)newFileName{
    
    NSString *oldPath = [[self getDocumentPath] stringByAppendingPathComponent:oldFileName];
    NSString *newPath = [[self getDocumentPath] stringByAppendingPathComponent:newFileName];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isSuccess         = [manager copyItemAtPath:oldPath toPath:newPath error:nil];

    [self deleteFile:oldFileName];
    
    if (isSuccess) {
        
        return YES;
    }
    return NO;
}

@end








































