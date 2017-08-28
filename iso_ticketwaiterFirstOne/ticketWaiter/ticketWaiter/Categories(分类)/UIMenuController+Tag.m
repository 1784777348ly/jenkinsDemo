//
//  UIMenuController+Tag.m
//  HuiShiApp
//
//  Created by hui10 on 16/7/21.
//  Copyright © 2016年 hui10. All rights reserved.
//

#import "UIMenuController+Tag.h"

static const void *tagKey = &tagKey;

@implementation UIMenuController (Tag)

- (NSString *)tag {
    return objc_getAssociatedObject(self, tagKey);
}

- (void)setTag:(NSString *)tag {
    objc_setAssociatedObject(self, tagKey, tag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
