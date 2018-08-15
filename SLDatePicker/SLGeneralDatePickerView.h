//
//  SLGeneralDatePickerView.h
//  SLDatePickerDemo
//
//  Created by sl on 2018/8/13.
//  Copyright © 2018年 WSonglin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLGlobalDefinition.h"

@interface SLGeneralDatePickerView : UIPickerView

/**
 配置日期选择器
 
 @param selectedDate    默认选择日期（必须在最大日期和最小日期范围），若nil，则为当前时间
 @param dateFormatter   日期格式，若nil，则为yyyy-MM-dd
 @param datePickerMode  日期选择器组件类型，默认为SLDatePickerModeDate
 */
- (void)setupPickerViewDataWithDefaultSelectedDate:(NSDate *)selectedDate
                                     dateFormatter:(NSString *)dateFormatter
                                    datePickerMode:(SLDatePickerMode)datePickerMode;

@property (nonatomic, copy, readonly) NSDate *date;

@end
