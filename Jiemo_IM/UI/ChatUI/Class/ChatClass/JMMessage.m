//
//  JMMessage.m
//  Jiemo_IM
//
//  Created by merrill on 2018/5/17.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "JMMessage.h"
#import "NSDate+Helper.h"

@implementation JMMessage
- (void)setWithDict:(NSDictionary *)dict{
    
    self.msgId = dict[@"msgId"];       //消息ID
    self.msgType = [dict[@"msgType"] integerValue];
    self.chatType = [dict[@"chatType"] integerValue];
    self.toUserId = dict[@"toUserId"];
    self.toUserName = dict[@"toUserName"];
    self.toUserHeadImgUrl = dict[@"toUserHeadImgUrl"];
    self.fromUserId = dict[@"fromUserId"];
    self.fromUserName = dict[@"fromUserName"];
    self.fromUserHeadImgUrl = dict[@"fromUserHeadImgUrl"];
    self.groupId = dict[@"groupId"];   // 群组ID
    self.groupName = dict[@"groupName"];   // 群组名称

    self.msgTime = [self changeTheDateString:dict[@"msgTime"]];
    
    switch ([dict[@"msgType"] integerValue]) {
            
        case 1:
            self.msgType = JMMessageTypeText;
            self.msg = dict[@"msg"];
            break;
            
        case 2:
            self.msgType = JMMessageTypePicture;
            self.picture = dict[@"picture"];
            break;
            
        case 3:
            self.msgType = JMMessageTypeVoice;
            self.voice = dict[@"voice"];
            self.voiceTime = dict[@"voiceTime"];
            break;
            
        default:
            break;
    }
}

//"08-10 晚上08:09:41.0" ->
//"昨天 上午10:09"或者"2012-08-10 凌晨07:09"
- (NSString *)changeTheDateString:(NSString *)Str
{
    NSString *subString = [Str substringWithRange:NSMakeRange(0, 19)];
    NSDate *lastDate = [NSDate dateFromString:subString withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:lastDate];
    lastDate = [lastDate dateByAddingTimeInterval:interval];
    
    NSString *dateStr;  //年月日
    NSString *period;   //时间段
    NSString *hour;     //时
    
    if ([lastDate year]==[[NSDate date] year]) {
        NSInteger days = [NSDate daysOffsetBetweenStartDate:lastDate endDate:[NSDate date]];
        if (days <= 2) {
            dateStr = [lastDate stringYearMonthDayCompareToday];
        }else{
            dateStr = [lastDate stringMonthDay];
        }
    }else{
        dateStr = [lastDate stringYearMonthDay];
    }
    
    
    if ([lastDate hour]>=5 && [lastDate hour]<12) {
        period = @"上午";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
    }else if ([lastDate hour]>=12 && [lastDate hour]<=18){
        period = @"下午";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
    }else if ([lastDate hour]>18 && [lastDate hour]<=23){
        period = @"晚上";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
    } else {
        period = @"早上";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
    }
    return [NSString stringWithFormat:@"%@ %@ %@:%02d",dateStr,period,hour,(int)[lastDate minute]];
}

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end
{
    if (!start) {
        self.showDateLabel = YES;
        return;
    }
    
    NSString *subStart = [start substringWithRange:NSMakeRange(0, 19)];
    NSDate *startDate = [NSDate dateFromString:subStart withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *subEnd = [end substringWithRange:NSMakeRange(0, 19)];
    NSDate *endDate = [NSDate dateFromString:subEnd withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //这个是相隔的秒数
    NSTimeInterval timeInterval = [startDate timeIntervalSinceDate:endDate];
    
    //相距5分钟显示时间Label
    if (fabs (timeInterval) > 5*60) {
        self.showDateLabel = YES;
    }else{
        self.showDateLabel = NO;
    }
    
}
@end
