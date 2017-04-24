//
//  IntoDatapointStringView.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/12.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import "IntoDatapointStringView.h"
#import "Macros.h"

@interface IntoDatapointStringView()

// 数据点名称
@property (nonatomic, weak) UILabel *datapointTitleLabel;

// 数据点value
@property (nonatomic, weak) UILabel *datapointValue;

//输入框
@property (nonatomic, weak) UITextField *datapointInput;

//发送按钮
@property (nonatomic, weak) UIButton *datapointSend;

//边框
@property (nonatomic, weak) UIView *boardView;

@end

@implementation IntoDatapointStringView


- (instancetype)initWithFrame:(CGRect)frame datapoint:(DatapointModel *)datapointModel {
    if (self = [super initWithFrame:frame]){
        _datapointModel = datapointModel;
        //边框
        UIView *boardView = [[UIView alloc] init];
        self.boardView = boardView;
        [self addSubview:boardView];

        //title
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.numberOfLines = 1;
        [titleLabel sizeToFit];
        self.datapointTitleLabel = titleLabel;
        [self addSubview:titleLabel];

        if (datapointModel.direction == DIRECTION_DATA) {
            UILabel *contentLabel = [[UILabel alloc] init];
            contentLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = [UIFont systemFontOfSize:14];
            [titleLabel sizeToFit];
            self.datapointValue = contentLabel;
            [self addSubview:contentLabel];
        } else {
            UIButton *sendButton = [[UIButton alloc] init];
            [sendButton setTitle:NSLocalizedString(@"send", nil) forState:UIControlStateNormal];
            [sendButton setTitleColor:SetColor(0x00, 0xc6, 0xff, 1) forState:UIControlStateNormal];
            [sendButton setTitleColor:SetColor(0x00, 0xaa, 0xff, 1) forState:UIControlStateSelected];
            sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
            sendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            self.datapointSend = sendButton;
            [self addSubview:sendButton];

            UITextField *inputField = [[UITextField alloc] init];
            inputField.placeholder = NSLocalizedString(@"send_data", nil);
            inputField.borderStyle = UITextBorderStyleRoundedRect;
            inputField.font = [UIFont systemFontOfSize:14];
            self.datapointInput = inputField;
            [self addSubview:inputField];
        }

        [self setDatapointModel:datapointModel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.boardView.frame = CGRectMake(0, (CGRectGetHeight(self.frame) - self.frame.size.height)/2 + 5, self.frame.size.width, self.frame.size.height - 10);
    //设置边框
    self.boardView.layer.borderWidth = 1;
    self.boardView.layer.borderColor = [DividerColor CGColor];

    //设置圆角
    self.boardView.layer.cornerRadius = 3;
    self.boardView.layer.masksToBounds = YES;

    self.datapointTitleLabel.frame = CGRectMake(10, 10, 100, 30);

    if (_datapointModel.direction == DIRECTION_DATA) {
        self.datapointValue.frame = CGRectMake(10, CGRectGetHeight(self.frame) - 30 - 10, CGRectGetWidth(self.frame) - 20, 30);
    } else {
        self.datapointSend.frame = CGRectMake(self.bounds.origin.x + CGRectGetWidth(self.bounds) - 50 - 10, 10, 50, 30);
        self.datapointInput.frame = CGRectMake(10, CGRectGetHeight(self.frame) - 30 - 10, CGRectGetWidth(self.frame) - 20, 30);

        [self.datapointSend addTarget:self action:@selector(onValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)setDatapointModel:(DatapointModel *)datapointModel {
    self.datapointTitleLabel.text = datapointModel.nameCn;
}

-(void)receiveData:(NSDictionary *)data{
    NSString *value = [NSString stringWithFormat:@"%@", data];
    if (_datapointModel.direction == DIRECTION_DATA) {
        self.datapointValue.text = value;
    } else{
        self.datapointInput.text = value;
    }
}

-(void)onValueChanged:(id)sender {
    NSString *value = self.datapointInput.text;
    NSLog(@"change value: %@", value);
    if (self.delegete && [self.delegete respondsToSelector:@selector(sendData:datapoint:)]){
        [self.delegete sendData:value datapoint:self.datapointModel];
    }
}

@end
