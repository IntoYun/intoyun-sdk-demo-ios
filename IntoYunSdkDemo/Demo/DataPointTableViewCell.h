//
//  DataPointTableViewCell.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/26.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatapointModel;

@interface DataPointTableViewCell : UITableViewCell

@property (nonatomic, strong)DatapointModel *datapointModel;

+ (instancetype)cellWithTable:(UITableView *)tableView;

@end
