//
//  SLAssociatedDatePickerView.m
//  SLDatePickerDemo
//
//  Created by sl on 2018/8/10.
//  Copyright © 2018年 WSonglin. All rights reserved.
//

#import "SLAssociatedDatePickerView.h"
#import "NSDate+Category.h"

#define RGBA_COLOR(r, g, b, a) [UIColor colorWithRed:r / 255.f\
                                               green:g / 255.f\
                                                blue:b / 255.f\
                                               alpha:a]

@interface SLAssociatedDatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, copy) NSDate *defaultSelectedDate;
@property (nonatomic, copy) NSDate *maximumDate;
@property (nonatomic, copy) NSDate *minimumDate;
@property (nonatomic, assign) SLDatePickerMode datePickerMode;

@property (nonatomic, assign) NSInteger yearRows;
@property (nonatomic, assign) NSInteger monthRows;
@property (nonatomic, assign) NSInteger dayRows;

@property (nonatomic, assign) NSInteger selectedYear;
@property (nonatomic, assign) NSInteger selectedMonth;
@property (nonatomic, assign) NSInteger selectedDay;

/**
 用来设置已选中行的字体颜色；格式为@[@(selectedYearRow), @(selectedMonthRow), @(selectedDayRow)]
 */
@property (nonatomic, strong) NSMutableArray *selectedRows;

@end

@implementation SLAssociatedDatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        self.selectedRows = @[].mutableCopy;
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy-MM-dd";
        
        //默认选择日期为当前时间
        NSString *dateString = [NSDate stringFromDate:[NSDate date] dateFormat:self.dateFormatter.dateFormat];
        self.defaultSelectedDate = [NSDate dateFromString:dateString dateFormat:self.dateFormatter.dateFormat];
        
        self.datePickerMode = SLDatePickerModeDate;
        
        dateString = [NSDate stringFromDate:[NSDate distantFuture] dateFormat:self.dateFormatter.dateFormat];
        self.maximumDate = [NSDate dateFromString:dateString dateFormat:self.dateFormatter.dateFormat];
        self.minimumDate = [NSDate dateFromString:@"1970-01-01" dateFormat:self.dateFormatter.dateFormat];
        
        self.selectedYear = self.defaultSelectedDate.year;
        
        //若有月份则进行默认选择月的初始化
        if (self.datePickerMode == SLDatePickerModeDate
            || self.datePickerMode == SLDatePickerModeYearAndMonth) {
            self.selectedMonth = self.defaultSelectedDate.month;
        }
        
        //若有天的列则进行默认选择天的初始化
        if (self.datePickerMode == SLDatePickerModeDate) {
            self.selectedDay = self.defaultSelectedDate.day;
        }
    }
    
    return self;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (SLDatePickerModeYear == self.datePickerMode) {
        return 1;
    } else if (SLDatePickerModeYearAndMonth == self.datePickerMode) {
        return 2;
    }
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (0 == component) {
        return self.yearRows;
    } else if (1 == component) {
        return self.monthRows;
    }
    
    return self.dayRows;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *textString = @"";
    NSInteger index = 0;
    
    if (0 == component) {
        index = row % self.yearRows;
        textString = [NSString stringWithFormat:@"%ld", (long)(self.minimumDate.year + index)];
    } else if (1 == component) {
        index = row % self.monthRows;
        if (self.selectedYear == self.minimumDate.year) {
            textString = [NSString stringWithFormat:@"%02ld", (long)(self.minimumDate.month + index)];
        } else {
            textString = [NSString stringWithFormat:@"%02ld", (long)(index + 1)];
        }
    } else {
        index = row % self.dayRows;
        if ([self.maximumDate isSameYearAsDate:self.minimumDate]
            && [self.maximumDate isSameMonthAsDate:self.minimumDate]) {
            textString = [NSString stringWithFormat:@"%02ld", (long)(self.minimumDate.day + index)];
        } else if (self.selectedYear == self.minimumDate.year) {
            if (self.selectedMonth == self.minimumDate.month) {
                textString = [NSString stringWithFormat:@"%02ld", (long)(self.minimumDate.day + index)];
            } else {
                textString = [NSString stringWithFormat:@"%02ld", (long)(index + 1)];
            }
        } else {
            textString = [NSString stringWithFormat:@"%02ld", (long)(index + 1)];
        }
    }
    
    return textString;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];;
    
    if (self.selectedRows.count > 0 && component < self.selectedRows.count) {
        if (row == [self.selectedRows[component] integerValue]) {
            pickerLabel.textColor = RGBA_COLOR(48.f, 106.f, 184.f, 1.f);
        } else {
            pickerLabel.textColor = RGBA_COLOR(124.f, 124.f, 124.f, 1.f);
        }
    } else {
        pickerLabel.textColor = RGBA_COLOR(124.f, 124.f, 124.f, 1.f);
    }
    
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0: {
            self.selectedYear = row % self.yearRows + self.minimumDate.year;
            
            if (SLDatePickerModeYearAndMonth == self.datePickerMode
                || SLDatePickerModeDate == self.datePickerMode) {
                [self setSelectedMonth:self.selectedMonth];
                
                if (SLDatePickerModeDate == self.datePickerMode) {
                    [self setSelectedDay:self.selectedDay];
                }
            }
        }
            break;
            
        case 1: {
            if (self.selectedYear == self.minimumDate.year) {
                self.selectedMonth = row % self.monthRows + self.minimumDate.month;
            } else {
                self.selectedMonth = row % self.monthRows + 1;
            }
            
            if (SLDatePickerModeDate == self.datePickerMode) {
                [self setSelectedDay:self.selectedDay];
            }
        }
            break;
            
        case 2: {
            if ([self.maximumDate isSameYearAsDate:self.minimumDate]
                && [self.maximumDate isSameMonthAsDate:self.minimumDate]) {
                self.selectedDay = row % self.dayRows + self.minimumDate.day;
            } else if (self.selectedYear == self.minimumDate.year) {
                if (self.selectedMonth == self.minimumDate.month) {
                    self.selectedDay = row % self.dayRows + self.minimumDate.day;
                } else {
                    self.selectedDay = row % self.dayRows + 1;
                }
            } else {
                self.selectedDay = row % self.dayRows + 1;
            }
        }
            break;
    }
    
    [pickerView reloadAllComponents];
}

#pragma mark - Interface method
- (void)setupPickerViewDataWithDefaultSelectedDate:(NSDate *)selectedDate
                                       maximumDate:(NSDate *)maximumDate
                                       minimumDate:(NSDate *)minimumDate
                                     dateFormatter:(NSString *)dateFormatter
                                    datePickerMode:(SLDatePickerMode)datePickerMode {
    self.defaultSelectedDate = selectedDate ? : self.defaultSelectedDate;
    self.maximumDate = maximumDate ? : self.maximumDate;
    self.minimumDate = minimumDate ? : self.minimumDate;
    self.dateFormatter.dateFormat = dateFormatter ? : self.dateFormatter.dateFormat;
    self.datePickerMode = datePickerMode;
    
    self.selectedYear = self.defaultSelectedDate.year;
    if (datePickerMode == SLDatePickerModeDate
        || datePickerMode == SLDatePickerModeYearAndMonth) {
        self.selectedMonth = self.defaultSelectedDate.month;
    }
    
    if (datePickerMode == SLDatePickerModeDate) {
        self.selectedDay = self.defaultSelectedDate.day;
    }
    
    [self reloadAllComponents];
}

#pragma mark - Setter
- (void)setSelectedYear:(NSInteger)selectedYear {
    self.yearRows = self.maximumDate.year - self.minimumDate.year + 1;
    
    selectedYear = (selectedYear > self.maximumDate.year) ? self.maximumDate.year : selectedYear;
    selectedYear = (selectedYear < self.minimumDate.year) ? self.minimumDate.year : selectedYear;
    
    _selectedYear = selectedYear;
    
    NSInteger selectedRow = (_selectedYear - self.minimumDate.year) % self.yearRows;
    if (self.selectedRows.count > 0) {
        [self.selectedRows replaceObjectAtIndex:0 withObject:@(selectedRow)];
    } else {
        [self.selectedRows addObject:@(selectedRow)];
    }
    
    [self reloadComponent:0];
    [self selectRow:selectedRow inComponent:0 animated:YES];
}

- (void)setSelectedMonth:(NSInteger)selectedMonth {
    NSInteger selectedRow = selectedMonth - 1;
    
    if ([self.maximumDate isSameYearAsDate:self.minimumDate]) {
        self.monthRows = self.maximumDate.month - self.minimumDate.month + 1;
        selectedMonth = (selectedMonth > self.maximumDate.month) ? self.maximumDate.month : selectedMonth;
        selectedRow = (selectedMonth - self.minimumDate.month) % self.monthRows;
    } else if (self.selectedYear == self.maximumDate.year) {
        self.monthRows = self.maximumDate.month;
        selectedMonth = (selectedMonth > self.monthRows) ? self.monthRows : selectedMonth;
        selectedRow = (selectedMonth - 1) % self.monthRows;
    } else if (self.selectedYear == self.minimumDate.year) {
        self.monthRows = 12 - self.minimumDate.month + 1;
        selectedMonth = (selectedMonth < self.minimumDate.month) ? self.minimumDate.month : selectedMonth;
        selectedRow = (selectedMonth - self.minimumDate.month) % self.monthRows;
    } else {
        self.monthRows = 12;
    }
    
    _selectedMonth = selectedMonth;
    
    if (self.selectedRows.count > 1) {
        [self.selectedRows replaceObjectAtIndex:1 withObject:@(selectedRow)];
    } else {
        [self.selectedRows addObject:@(selectedRow)];
    }
    
    [self reloadComponent:1];
    [self selectRow:selectedRow inComponent:1 animated:YES];
}

- (void)setSelectedDay:(NSInteger)selectedDay {
    NSInteger selectedRow = 0;
    
    if ([self.maximumDate isSameYearAsDate:self.minimumDate]
        && [self.maximumDate isSameMonthAsDate:self.minimumDate]) {
        self.dayRows = self.maximumDate.day - self.minimumDate.day + 1;
        selectedDay = (selectedDay > self.maximumDate.day) ? self.maximumDate.day : selectedDay;
        selectedRow = (selectedDay - self.minimumDate.day) % self.dayRows;
    } else if (self.selectedYear == self.maximumDate.year) {
        if (self.selectedMonth == self.maximumDate.month) {
            self.dayRows = self.maximumDate.day;
        } else {
            self.dayRows = [NSDate getDaysWithYear:self.selectedYear month:self.selectedMonth];
        }
        
        selectedDay = (selectedDay > self.dayRows) ? self.dayRows : selectedDay;
        selectedRow = (selectedDay - 1) % self.dayRows;
    } else if (self.selectedYear == self.minimumDate.year) {
        //当前选择年、月下的天数
        NSInteger days = [NSDate getDaysWithYear:self.selectedYear month:self.selectedMonth];
        if (self.selectedMonth == self.minimumDate.month) {
            //需要显示天的行数：（选择月所有天数的和 - 指定最小日期的天数 + 1）。
            //例：8月份有31天，若最小天为13号，则该显示的行数为：31 - 13 + 1 = 19行（从13到31）
            self.dayRows = days - self.minimumDate.day + 1;
            if (selectedDay > days) {//如果选中天数大于当月最大天数
                selectedDay = days;
            }
            
            selectedDay = (selectedDay < self.minimumDate.day) ? self.minimumDate.day : selectedDay;
            selectedRow = (selectedDay - self.minimumDate.day) % self.dayRows;
        } else {
            self.dayRows = days;
            selectedDay = (selectedDay > self.dayRows) ? self.dayRows : selectedDay;
            selectedRow = (selectedDay - 1) % self.dayRows;
        }
    } else {
        self.dayRows = [NSDate getDaysWithYear:self.selectedYear month:self.selectedMonth];
        selectedDay = (selectedDay > self.dayRows) ? self.dayRows : selectedDay;
        selectedRow = (selectedDay - 1) % self.dayRows;
    }
    
    _selectedDay = selectedDay;
    
    if (self.selectedRows.count > 2) {
        [self.selectedRows replaceObjectAtIndex:2 withObject:@(selectedRow)];
    } else {
        [self.selectedRows addObject:@(selectedRow)];
    }
    
    [self reloadComponent:2];
    [self selectRow:selectedRow inComponent:2 animated:YES];
}

#pragma mark - Getter
- (NSDate *)date {
    NSString *dateString = [NSString stringWithFormat:@"%04ld-%02ld-%02ld", self.selectedYear, self.selectedMonth, self.selectedDay];
    
    if (SLDatePickerModeYearAndMonth == self.datePickerMode) {
        dateString = [NSString stringWithFormat:@"%04ld-%02ld", self.selectedYear, self.selectedMonth];
    } else if (SLDatePickerModeYear == self.datePickerMode) {
        dateString = [NSString stringWithFormat:@"%04ld", self.selectedYear];
    }
    
    return [self.dateFormatter dateFromString:dateString];
}

@end
