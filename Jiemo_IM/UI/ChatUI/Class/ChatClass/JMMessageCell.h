//
//  JMMessageCell.h
//  Jiemo_IM
//
//  Created by merrill on 2018/5/17.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMMessageContentButton.h"

@class JMMessageFrame;
@class JMMessageCell;
@protocol JMMessageCellDelegate <NSObject>
@optional
- (void)chatCell:(JMMessageCell *)cell headImageDidClick:(NSString *)userId;
@end


@interface JMMessageCell : UITableViewCell

@property (nonatomic, strong) JMMessageFrame *messageFrame;

@property (nonatomic, weak) id<JMMessageCellDelegate> delegate;

@end
