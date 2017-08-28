//
//  NSDate+Methods.h
//  HuiShiApp
//
//  Created by hui10 on 16/8/19.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Methods)

- (nullable NSDate *)dateByMinusYears:(NSInteger)years;

- (nullable NSDate *)dateByMinusMonths:(NSInteger)months;

- (nullable NSDate *)dateByMinusWeeks:(NSInteger)weeks;

- (nullable NSDate *)dateByMinusDays:(NSInteger)days; //前一天

- (nullable NSDate *)dateByMinusHours:(NSInteger)hours;

- (nullable NSDate *)dateByMinusMinutes:(NSInteger)minutes;

- (nullable NSDate *)dateByMinusSeconds:(NSInteger)seconds;

@end































