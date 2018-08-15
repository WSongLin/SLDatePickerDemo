//
//  SLGlobalDefinition.h
//  SLDatePickerDemo
//
//  Created by sl on 2018/8/13.
//  Copyright © 2018年 WSonglin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 日期选择器组件类型
 */
typedef NS_ENUM(NSInteger, SLDatePickerMode) {
    SLDatePickerModeDate = 0,       //显示年、月、日，如2100-12-31
    SLDatePickerModeYear,           //显示年，如2100
    SLDatePickerModeYearAndMonth    //显示年、月，如2100-12
};

@interface SLGlobalDefinition : NSObject

@end
