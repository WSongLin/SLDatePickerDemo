//
//  ViewController.m
//  SLDatePickerDemo
//
//  Created by sl on 2018/8/10.
//  Copyright © 2018年 WSonglin. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "SLDatePicker.h"
#import "UIColor+Category.h"

@interface ViewController ()

@property (nonatomic, weak) UIView *alphaBackgroundView;

@property (nonatomic, weak) SLAssociatedDatePickerView *associatedPickerView;
@property (nonatomic, weak) SLGeneralDatePickerView *pickerView;

@property (nonatomic, weak) UIView *topContainerView;
@property (nonatomic, weak) UIButton *doneButton;
@property (nonatomic, weak) UIButton *cancelButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:@"显示通用日期选择器" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:14.f];
    button1.layer.borderWidth = 0.8f;
    button1.layer.borderColor = [UIColor whiteColor].CGColor;
    [button1 addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"显示关联日期选择器" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:14.f];
    button2.layer.borderWidth = 0.8f;
    button2.layer.borderColor = [UIColor whiteColor].CGColor;
    [button2 addTarget:self action:@selector(button2Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(button2.mas_top).offset(-20.f);
        make.height.equalTo(@(40.f));
    }];
    
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(button1);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.associatedPickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.alphaBackgroundView);
        make.height.equalTo(@(260.f));
    }];
    
    [self.pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.alphaBackgroundView);
        make.height.equalTo(@(260.f));
    }];
    
    [self.topContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.alphaBackgroundView);
        make.bottom.equalTo(self.pickerView.mas_top);
        make.height.equalTo(@40.f);
    }];
    
    [self.doneButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.topContainerView);
        make.right.equalTo(self.topContainerView.mas_right);
        make.width.equalTo(@(60.f));
    }];
    
    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(self.doneButton);
        make.left.equalTo(self.topContainerView.mas_left);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

#pragma mark - Event response
- (void)button1Action:(id)sender {
    self.alphaBackgroundView.hidden = NO;
    self.associatedPickerView.hidden = YES;
    self.pickerView.hidden = NO;
    
    //如果只需要默认值，则屏蔽这行代码
    [self.pickerView setupPickerViewDataWithDefaultSelectedDate:[NSDate date] dateFormatter:@"yyyy-MM-dd" datePickerMode:SLDatePickerModeDate];
}

- (void)button2Action:(id)sender {
    self.alphaBackgroundView.hidden = NO;
    self.pickerView.hidden = YES;
    self.associatedPickerView.hidden = NO;
    
    [self.associatedPickerView setupPickerViewDataWithDefaultSelectedDate:[[NSDate date] dateBySubtractingYears:1]
                                                              maximumDate:[NSDate date]
                                                              minimumDate:[[NSDate date] dateBySubtractingYears:2]
                                                            dateFormatter:@"yyyy-MM"
                                                           datePickerMode:SLDatePickerModeYearAndMonth];
}

- (void)doneButtonTapped:(id)sender {
    self.alphaBackgroundView.hidden = YES;
    
    NSLog(@"g.date = %@, a.date = %@", self.pickerView.date, self.associatedPickerView.date);
    
}

- (void)cancelButtonTapped:(id)sender {
    self.alphaBackgroundView.hidden = YES;
}

#pragma mark - Getter
- (UIView *)alphaBackgroundView {
    if (!_alphaBackgroundView) {
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.28f];
        view.hidden = YES;
        [self.view addSubview:view];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonTapped:)];
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:recognizer];
        
        _alphaBackgroundView = view;
    }
    
    return _alphaBackgroundView;
}

- (SLAssociatedDatePickerView *)associatedPickerView {
    if (!_associatedPickerView) {
        SLAssociatedDatePickerView *view = [[SLAssociatedDatePickerView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.hidden = YES;
        [self.alphaBackgroundView addSubview:view];
        
        _associatedPickerView = view;
    }
    
    return _associatedPickerView;
}

- (SLGeneralDatePickerView *)pickerView {
    if (!_pickerView) {
        SLGeneralDatePickerView *view = [[SLGeneralDatePickerView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.hidden = YES;
        [self.alphaBackgroundView addSubview:view];
        
        _pickerView = view;
    }
    
    return _pickerView;
}

- (UIView *)topContainerView {
    if (!_topContainerView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHex:0x5CACEE];
        [self.alphaBackgroundView addSubview:view];
        
        _topContainerView = view;
    }
    
    return _topContainerView;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2f];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.topContainerView addSubview:button];
        
        _doneButton = button;
    }
    
    return _doneButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2f];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.topContainerView addSubview:button];
        
        _cancelButton = button;
    }
    
    return _cancelButton;
}

@end
