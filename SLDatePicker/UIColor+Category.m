//
//  UIColor+Category.m
//  SLDatePickerDemo
//
//  Created by sl on 2018/8/10.
//  Copyright © 2018年 WSonglin. All rights reserved.
//

#import "UIColor+Category.h"

@implementation UIColor (Category)

+ (UIColor *)colorWithHex:(long)hexValue {
    return [UIColor colorWithRed:((hexValue & 0xff0000) >> 16) / 255.f
                           green:((hexValue & 0x00FF00) >> 8) / 255.f
                            blue:(hexValue & 0x0000FF) / 255.f
                           alpha:1.f
            ];
}

@end
