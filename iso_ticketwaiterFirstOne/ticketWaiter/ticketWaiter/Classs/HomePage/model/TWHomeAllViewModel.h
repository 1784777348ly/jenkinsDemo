//
//  TWHomeAllViewModel.h
//  ticketWaiter
//
//  Created by LY on 17/1/20.
//  Copyright © 2017年 hui10. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWHomeAllViewModel : NSObject

-(void)fetchMergentInfoWithToken:(NSString *)token returnBack:(void(^)(id result))block;


-(void)judgeZhiFuIsOk:(void(^)(id result))block andFailBlock:(void(^)(NSError *error))failBlock;

@end
