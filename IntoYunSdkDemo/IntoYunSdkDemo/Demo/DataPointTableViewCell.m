//
//  DataPointTableViewCell.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/26.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import "DataPointTableViewCell.h"
#import "DatapointModel.h"
#import "Macros.h"
#import "View+MASAdditions.h"

@interface DataPointTableViewCell ()

@property(nonatomic, weak) UILabel *nameLabel;

@end


@implementation DataPointTableViewCell


- (instancetype)init {
    if (self = [super init]) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        self.nameLabel = label;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        self.nameLabel = label;
    }
    return self;
}

/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        self.nameLabel = label;
    }
    return self;
}


+ (instancetype)cellWithTable:(UITableView *)tableView {
    static NSString *identifier = @"dataPointTableCell";
    // 1.缓存中取
    DataPointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[DataPointTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDatapointModel:(DatapointModel *)datapointModel {
    _datapointModel = datapointModel;
    self.nameLabel.backgroundColor = PrimaryColor;
    self.nameLabel.text = datapointModel.nameCn;
}


+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}


- (void)updateConstraints {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.centerY.mas_equalTo(self.nameLabel.superview.mas_centerY).offset(0);
        maker.left.mas_equalTo(self.nameLabel.superview.mas_left).offset(10);
        maker.right.mas_equalTo(self.nameLabel.superview.mas_right).offset(-10);
        maker.top.mas_equalTo(self.nameLabel.superview.mas_top).offset(5);
        maker.bottom.mas_equalTo(self.nameLabel.superview.mas_bottom).offset(-5);
    }];

    [super updateConstraints];
}


@end
