//
//  IntoMessageCell.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/8.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import "IntoMessageCell.h"
#import "IntoYunSDK.h"

@implementation IntoMessageCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)cellWithTable:(UITableView *)tableView Style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    
    IntoMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!messageCell) {
        messageCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([IntoMessageCell class]) owner:nil options:nil] lastObject];
    }
    return messageCell;
}

-(void)setMessageModel:(IntoMessageModel *)messageModel {
    _messageModel = messageModel;

    self.messageContentLabel.text = messageModel.content;
    NSString *createTime = [NSString stringWithFormat:@"%lli",messageModel.timestamp];
    self.messageTimeLabel.text = [createTime getDateTimeString];
}



@end
