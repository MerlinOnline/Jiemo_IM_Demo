//
//  JMMessageCell.m
//  Jiemo_IM
//
//  Created by merrill on 2018/5/17.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "JMMessageCell.h"
#import "JMMessage.h"
#import "JMMessageFrame.h"
#import "JMAVAudioPlayer.h"
#import "JMImageAvatarBrowser.h"
#import "JMChatCategory.h"

@interface JMMessageCell ()<JMAVAudioPlayerDelegate>
{
    NSString *_voiceURL;
    NSData *_songData;
    
    JMAVAudioPlayer *_audio;
    
    UIView *_headImageBackView;
    BOOL _contentVoiceIsPlaying;
}

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *namelabel;
@property (nonatomic, strong) UIButton *headImageButton;

@property (nonatomic, strong) JMMessageContentButton *btnContent;

@end

@implementation JMMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 1、创建时间
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.textColor = [UIColor grayColor];
        self.dateLabel.font = ChatTimeFont;
        [self.contentView addSubview:self.dateLabel];
        
        // 2、创建头像
        _headImageBackView = [[UIView alloc]init];
        _headImageBackView.layer.cornerRadius = 22;
        _headImageBackView.layer.masksToBounds = YES;
        _headImageBackView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [self.contentView addSubview:_headImageBackView];
        self.headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headImageButton.layer.cornerRadius = 20;
        self.headImageButton.layer.masksToBounds = YES;
        [self.headImageButton addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
        [_headImageBackView addSubview:self.headImageButton];
        
        // 3、创建头像下标
        self.namelabel = [[UILabel alloc] init];
        self.namelabel.textColor = [UIColor grayColor];
        self.namelabel.textAlignment = NSTextAlignmentCenter;
        self.namelabel.font = ChatTimeFont;
        self.namelabel.numberOfLines = 0;
        [self.contentView addSubview:self.namelabel];
        
        // 4、创建内容
        self.btnContent = [JMMessageContentButton buttonWithType:UIButtonTypeCustom];
        [self.btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnContent.titleLabel.font = ChatContentFont;
        self.btnContent.titleLabel.numberOfLines = 0;
        [self.btnContent addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnContent];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UUAVAudioPlayerDidFinishPlay) name:@"VoicePlayHasInterrupt" object:nil];
        
        //红外线感应监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:)
                                                     name:UIDeviceProximityStateDidChangeNotification
                                                   object:nil];
        _contentVoiceIsPlaying = NO;
        
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
}

//头像点击
- (void)btnHeadImageClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(chatCell:headImageDidClick:)])  {
        [self.delegate chatCell:self headImageDidClick:self.messageFrame.message.strId];
    }
}

- (void)btnContentClick{
    //play audio
    if (self.messageFrame.message.type == JMMessageTypeVoice) {
        if(!_contentVoiceIsPlaying){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VoicePlayHasInterrupt" object:nil];
            _contentVoiceIsPlaying = YES;
            _audio = [JMAVAudioPlayer sharedInstance];
            _audio.delegate = self;
            //        [_audio playSongWithUrl:_voiceURL];
            [_audio playSongWithData:_songData];
        }else{
            [self JMAVAudioPlayerDidFinishPlay];
        }
    }
    //show the picture
    else if (self.messageFrame.message.type == JMMessageTypePicture)
    {
        if (self.btnContent.backImageView) {
            [JMImageAvatarBrowser showImage:self.btnContent.backImageView];
        }
        if ([self.delegate isKindOfClass:[UIViewController class]]) {
            [[(UIViewController *)self.delegate view] endEditing:YES];
        }
    }
    // show text and gonna copy that
    else if (self.messageFrame.message.type == JMMessageTypeText)
    {
        [self.btnContent becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.btnContent.frame inView:self.btnContent.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void)JMAVAudioPlayerBeiginLoadVoice
{
    [self.btnContent benginLoadVoice];
}

- (void)JMAVAudioPlayerBeiginPlay
{
    //开启红外线感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [self.btnContent didLoadVoice];
}

- (void)JMAVAudioPlayerDidFinishPlay
{
    //关闭红外线感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    _contentVoiceIsPlaying = NO;
    [self.btnContent stopPlay];
    [[JMAVAudioPlayer sharedInstance]stopSound];
}

//内容及Frame设置
- (void)setMessageFrame:(JMMessageFrame *)messageFrame
{
    _messageFrame = messageFrame;
    JMMessage *message = messageFrame.message;
    
    // 1、设置时间
    self.dateLabel.text = message.strTime;
    self.dateLabel.frame = messageFrame.timeF;
    
    // 2、设置头像
    _headImageBackView.frame = messageFrame.iconF;
    self.headImageButton.frame = CGRectMake(2, 2, ChatIconWH-4, ChatIconWH-4);
    [self.headImageButton setBackgroundImage:[UIImage imageWithName:@"headImage.jpeg"] forState:UIControlStateNormal];
    
    // 3、设置下标
    self.namelabel.text = message.strName;
    self.namelabel.frame = messageFrame.nameF;
    
    // 4、设置内容
    [self.btnContent setTitle:@"" forState:UIControlStateNormal];
    self.btnContent.voiceBackView.hidden = YES;
    self.btnContent.backImageView.hidden = YES;
    
    self.btnContent.frame = messageFrame.contentF;
    
    if (message.from == JMMessageFromMe) {
        self.btnContent.isMyMessage = YES;
        [self.btnContent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btnContent.titleEdgeInsets = UIEdgeInsetsMake(ChatContentTopBottom, ChatContentSmaller, ChatContentTopBottom, ChatContentBiger);
    } else {
        self.btnContent.isMyMessage = NO;
        [self.btnContent setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.btnContent.titleEdgeInsets = UIEdgeInsetsMake(ChatContentTopBottom, ChatContentBiger, ChatContentTopBottom, ChatContentSmaller);
    }
    
    //背景气泡图
    UIImage *normal;
    if (message.from == JMMessageFromMe) {
        normal = [UIImage imageWithName:@"chatto_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
    }
    else{
        normal = [UIImage imageWithName:@"chatfrom_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
    }
    [self.btnContent setBackgroundImage:normal forState:UIControlStateNormal];
    [self.btnContent setBackgroundImage:normal forState:UIControlStateHighlighted];
    
    switch (message.type) {
        case JMMessageTypeText:
            [self.btnContent setTitle:message.strContent forState:UIControlStateNormal];
            break;
        case JMMessageTypePicture:
        {
            self.btnContent.backImageView.hidden = NO;
            self.btnContent.backImageView.image = message.picture;
            self.btnContent.backImageView.frame = CGRectMake(0, 0, self.btnContent.frame.size.width, self.btnContent.frame.size.height);
            [self makeMaskView:self.btnContent.backImageView withImage:normal];
        }
            break;
        case JMMessageTypeVoice:
        {
            self.btnContent.voiceBackView.hidden = NO;
            self.btnContent.second.text = [NSString stringWithFormat:@"%@'s Voice",message.strVoiceTime];
            _songData = message.voice;
            //            _voiceURL = [NSString stringWithFormat:@"%@%@",RESOURCE_URL_HOST,message.strVoice];
        }
            break;
            
        default:
            break;
    }
}

- (void)makeMaskView:(UIView *)view withImage:(UIImage *)image
{
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(view.frame, 0.0f, 0.0f);
    view.layer.mask = imageViewMask.layer;
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    if ([[UIDevice currentDevice] proximityState] == YES){
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else{
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

@end
