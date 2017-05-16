//
//  IntoDatapointEnumView.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/12.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import "IntoDatapointEnumView.h"

@interface IntoDatapointEnumView ()

// 数据点名称
@property(nonatomic, weak) UILabel *datapointTitleLabel;

// 数据点value
@property(nonatomic, weak) UIButton *datapointValueButton;


@property(nonatomic, weak) UIView *boardView;

@end

@implementation IntoDatapointEnumView


- (instancetype)initWithFrame:(CGRect)frame datapoint:(DatapointModel *)datapointModel {
    if (self = [super initWithFrame:frame]) {
        _datapointModel = datapointModel;

        UIView *boardView = [[UIView alloc] init];
        self.boardView = boardView;
        [self addSubview:boardView];

        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.numberOfLines = 1;
        [titleLabel sizeToFit];
        self.datapointTitleLabel = titleLabel;
        [self addSubview:titleLabel];


        UIButton *valueButton = [[UIButton alloc] init];
        [valueButton setTitleColor:SetColor(0x00, 0xc6, 0xff, 1.0) forState:UIControlStateNormal];
        valueButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        valueButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.datapointValueButton = valueButton;
        [self addSubview:valueButton];

        [self setDatapointModel:datapointModel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.boardView.frame = CGRectMake(0, (CGRectGetHeight(self.frame) - self.frame.size.height) / 2 + 5, self.frame.size.width, self.frame.size.height - 10);
    //设置边框
    self.boardView.layer.borderWidth = 1;
    self.boardView.layer.borderColor = [DividerColor CGColor];

    //设置圆角
    self.boardView.layer.cornerRadius = 3;
    self.boardView.layer.masksToBounds = YES;

    self.datapointTitleLabel.frame = CGRectMake(10, CGRectGetHeight(self.frame) / 2 - 15, 100, 30);

    self.datapointValueButton.frame = CGRectMake(self.bounds.origin.x + CGRectGetWidth(self.bounds) - 120 - 10, CGRectGetHeight(self.frame) / 2 - 15, 120, 30);
}

- (void)setDatapointModel:(DatapointModel *)datapointModel {
    self.datapointTitleLabel.text = datapointModel.nameCn;
    [self.datapointValueButton setTitle:self.datapointModel.datapointEnum[0] forState:UIControlStateNormal];
    [self.datapointValueButton addTarget:self action:@selector(onValueChanged:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)receiveData:(id)data {
    int value = [[NSString stringWithFormat:@"%@", data] intValue];
    
    if (value < self.datapointModel.datapointEnum.count) {
        [self.datapointValueButton setTitle:self.datapointModel.datapointEnum[value] forState:UIControlStateNormal];
    }
}

- (void)onValueChanged:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
            initWithTitle:nil
                 delegate:self
        cancelButtonTitle:nil
   destructiveButtonTitle:nil
        otherButtonTitles:nil];
    for (NSString *item in self.datapointModel.datapointEnum) {
        [actionSheet addButtonWithTitle:item];
    }
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    [actionSheet showInView:self];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"action index: %ld", (long)buttonIndex);
    if (buttonIndex < self.datapointModel.datapointEnum.count) {
        [self.datapointValueButton setTitle:self.datapointModel.datapointEnum[buttonIndex] forState:UIControlStateNormal];
        if (self.delegete && [self.delegete respondsToSelector:@selector(sendData:datapoint:)]) {
            [self.delegete sendData:[NSNumber numberWithLong:buttonIndex] datapoint:self.datapointModel];
        }
    }
}


@end
