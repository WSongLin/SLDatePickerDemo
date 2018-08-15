//
//  SLAssociatedDatePickerView.h
//  SLDatePickerDemo
//
//  Created by sl on 2018/8/10.
//  Copyright © 2018年 WSonglin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLGlobalDefinition.h"

@interface SLAssociatedDatePickerView : UIPickerView

/**
 配置日期选择器

 @param selectedDate    默认选择日期（必须在最大日期和最小日期范围），若nil，则为当前时间
 @param maximumDate     最大日期，若nil，则为[NSDate distantFuture]
 @param minimumDate     最小日期，若nil，则为1970-01-01
 @param dateFormatter   日期格式，若nil，则为yyyy-MM-dd
 @param datePickerMode  日期选择器组件类型，默认为SLDatePickerModeDate
 */
- (void)setupPickerViewDataWithDefaultSelectedDate:(NSDate *)selectedDate
                                       maximumDate:(NSDate *)maximumDate
                                       minimumDate:(NSDate *)minimumDate
                                     dateFormatter:(NSString *)dateFormatter
                                    datePickerMode:(SLDatePickerMode)datePickerMode;

@property (nonatomic, copy, readonly) NSDate *date;

@end
