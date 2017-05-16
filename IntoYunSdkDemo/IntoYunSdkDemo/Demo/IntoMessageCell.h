//
//  IntoMessageCell.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/8.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntoMessageModel.h"

@interface IntoMessageCell : UITableViewCell


@property (nonatomic, strong) IntoMessageModel *messageModel;

@property (weak, nonatomic) IBOutlet UILabel *messageTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageContentLabel;

+ (instancetype)cellWithTable:(UITableView *)tableView Style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ;

@end
