//
//  SLGeneralDatePickerView.m
//  SLDatePickerDemo
//
//  Created by sl on 2018/8/13.
//  Copyright © 2018年 WSonglin. All rights reserved.
//

#import "SLGeneralDatePickerView.h"
#import "NSDate+Category.h"

#define RGBA_COLOR(r, g, b, a) [UIColor colorWithRed:r / 255.f\
                                               green:g / 255.f\
                                                blue:b / 255.f\
                                               alpha:a]

static NSInteger const kMaxNumberOfRows = 1000;

@interface SLGeneralDatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

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

@property (nonatomic, strong) NSMutableArray *selectedRows;

@end

@implementation SLGeneralDatePickerView

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
    return kMaxNumberOfRows;
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
        textString = [NSString stringWithFormat:@"%02ld", (long)(index + 1)];
    } else {
        index = row % self.dayRows;
        textString = [NSString stringWithFormat:@"%02ld", (long)(index + 1)];
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
            self.selectedMonth = row % self.monthRows + 1;
            
            if (SLDatePickerModeDate == self.datePickerMode) {
                [self setSelectedDay:self.selectedDay];
            }
        }
            break;
            
        case 2: {
            self.selectedDay = row % self.dayRows + 1;
        }
            break;
    }
    
    [pickerView reloadAllComponents];
}

#pragma mark - Interface method
- (void)setupPickerViewDataWithDefaultSelectedDate:(NSDate *)selectedDate
                                     dateFormatter:(NSString *)dateFormatter
                                    datePickerMode:(SLDatePickerMode)datePickerMode {
    self.defaultSelectedDate = selectedDate ? : self.defaultSelectedDate;
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
    
    //每次选择都在中间位置附近，保证看似无限滚动的效果
    NSInteger selectedRow = ((kMaxNumberOfRows / 2) / self.yearRows) * self.yearRows + _selectedYear - self.minimumDate.year;
    
    if (self.selectedRows.count > 0) {
        [self.selectedRows replaceObjectAtIndex:0 withObject:@(selectedRow)];
    } else {
        [self.selectedRows addObject:@(selectedRow)];
    }
    
    [self reloadComponent:0];
    [self selectRow:selectedRow inComponent:0 animated:NO];
}

- (void)setSelectedMonth:(NSInteger)selectedMonth {
    _selectedMonth = selectedMonth;
    
    self.monthRows = 12;
    
    //每次选择都在中间位置附近，保证看似无限滚动的效果
    NSInteger selectedRow = ((kMaxNumberOfRows / 2) / self.monthRows) * self.monthRows + _selectedMonth - 1;
    
    if (self.selectedRows.count > 1) {
        [self.selectedRows replaceObjectAtIndex:1 withObject:@(selectedRow)];
    } else {
        [self.selectedRows addObject:@(selectedRow)];
    }
    
    [self reloadComponent:1];
    [self selectRow:selectedRow inComponent:1 animated:NO];
}

- (void)setSelectedDay:(NSInteger)selectedDay {
    self.dayRows = [NSDate getDaysWithYear:self.selectedYear month:self.selectedMonth];
    
    _selectedDay = (selectedDay > self.dayRows) ? self.dayRows : selectedDay;
    
    //每次选择都在中间位置附近，保证看似无限滚动的效果
    NSInteger selectedRow = ((kMaxNumberOfRows / 2) / self.dayRows) * self.dayRows  + _selectedDay - 1;
    
    if (self.selectedRows.count > 2) {
        [self.selectedRows replaceObjectAtIndex:2 withObject:@(selectedRow)];
    } else {
        [self.selectedRows addObject:@(selectedRow)];
    }
    
    [self reloadComponent:2];
    [self selectRow:selectedRow inComponent:2 animated:NO];
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
