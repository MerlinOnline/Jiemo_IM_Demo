//
//  JMKeyBoardView.m
//  Jiemo_IM
//
//  Created by merrill on 2018/5/17.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "JMKeyBoardView.h"
#import "JMTextView.h"
#import "JMMoreView.h"
#import "JMEmojiView.h"
#import "UIView+Helper.h"
#import "JMChatCategory.h"
#import "JMProgressHUD.h"
#import <AVFoundation/AVFoundation.h>

//状态栏和导航栏的总高度
#define StatusNav_Height (isIphoneX ? 88 : 64)
//判断是否是iPhoneX
#define isIphoneX (K_Width == 375.f && K_Height == 812.f ? YES : NO)
#define K_Width [UIScreen mainScreen].bounds.size.width
#define K_Height [UIScreen mainScreen].bounds.size.height

static float bottomHeight = 230.0f; //底部视图高度
static float viewMargin = 8.0f; //按钮距离上边距
static float viewHeight = 36.0f; //按钮视图高度
@interface JMKeyBoardView ()<UITextViewDelegate,AVAudioRecorderDelegate>

@property (nonatomic, assign) NSInteger playTime;
@property (nonatomic, strong) NSString *docmentFilePath;

@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIButton * emojiBtn;
@property (nonatomic, strong) UIButton * moreBtn;
@property (nonatomic, strong) UIButton * voiceBtn;
@property (nonatomic, strong) UIButton * voiceRecordBtn;
@property (nonatomic, strong) JMTextView *textView;
@property (nonatomic, strong) JMMoreView *moreView;
@property (nonatomic, strong) JMEmojiView *emojiView;

@property (nonatomic, assign) CGFloat totalYOffset;
@property (nonatomic, assign) float keyboardHeight; //键盘高度
@property (nonatomic, assign) double keyboardTime; //键盘动画时长
@property (nonatomic, assign) BOOL voiceClick;  // 点击语音按钮
@property (nonatomic, assign) BOOL emojiClick;  //点击表情按钮
@property (nonatomic, assign) BOOL moreClick;  //点击更多按钮

@property (nonatomic, strong) NSTimer *playTimer;
@property (nonatomic, strong) AVAudioRecorder *recorder;

@end

@implementation JMKeyBoardView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        
        //监听键盘出现、消失
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        //此通知主要是为了获取点击空白处回收键盘的处理
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:@"keyboardHide" object:nil];
        
        //创建视图
        [self creatView];
    }
    return self;
}

- (void)creatView {
    self.backView.frame = CGRectMake(0, 0, self.width, self.height);
    
    // 语音按钮
    self.voiceBtn.frame = CGRectMake(viewMargin, viewMargin, viewHeight, viewHeight);
    
    //加号按钮
    self.moreBtn.frame = CGRectMake(self.width - viewMargin - viewHeight, viewMargin, viewHeight, viewHeight);
    
    //表情按钮
    self.emojiBtn.frame = CGRectMake(self.moreBtn.left -  viewMargin - viewHeight, viewMargin, viewHeight, viewHeight);
    
    //输入视图
    self.textView.frame = CGRectMake(self.voiceBtn.right + viewMargin, viewMargin, self.emojiBtn.left - self.voiceBtn.right - viewMargin * 2, viewHeight);
    
    // 录音按钮
    self.voiceRecordBtn.frame = self.textView.frame;
}

#pragma mark ====== 语音按钮 ======

- (void)voiceBtnClick:(UIButton*)sender {
    self.voiceRecordBtn.hidden = !self.voiceRecordBtn.hidden;
    self.textView.hidden  = !self.textView.hidden;
    self.voiceClick = !self.voiceClick;
    if (self.voiceClick) {
        [self.voiceBtn setBackgroundImage:[UIImage imageWithName:@"chat_btn_keyboard"] forState:UIControlStateNormal];
        [self.textView resignFirstResponder];
    }else{
        [self.voiceBtn setBackgroundImage:[UIImage imageWithName:@"chat_btn_recod"] forState:UIControlStateNormal];
        [self.textView becomeFirstResponder];
    }
}

- (void)changeVoiceBtnState {
    self.voiceClick = NO;
    self.voiceRecordBtn.hidden = YES;
    self.textView.hidden  = NO;
    [self.voiceBtn setBackgroundImage:[UIImage imageWithName:@"chat_btn_recod"] forState:UIControlStateNormal];
}

#pragma mark ====== 表情按钮 ======
- (void)emojiBtn:(UIButton *)btn {
    [self changeVoiceBtnState];
    
    self.moreClick = NO;
    if (self.emojiClick == NO) {
        self.emojiClick = YES;
        [self.textView resignFirstResponder];
        [self.moreView removeFromSuperview];
        self.moreView = nil;
        [self addSubview:self.emojiView];
        [UIView animateWithDuration:0.25 animations:^{
            self.emojiView.frame = CGRectMake(0, self.backView.height, K_Width, bottomHeight);
            self.frame = CGRectMake(0, K_Height - StatusNav_Height - self.backView.height - bottomHeight, K_Width, self.backView.height + bottomHeight);
            [self changeTableViewFrame];
        }];
    } else {
        [self.textView becomeFirstResponder];
    }
}

#pragma mark ====== 加号按钮 ======
- (void)moreBtn:(UIButton *)btn {
    [self changeVoiceBtnState];
    
    self.emojiClick = NO; //主要是设置表情按钮为未点击状态
    if (self.moreClick == NO) {
        self.moreClick = YES;
        //回收键盘
        [self.textView resignFirstResponder];
        [self.emojiView removeFromSuperview];
        self.emojiView = nil;
        [self addSubview:self.moreView];
        //改变更多、self的frame
        [UIView animateWithDuration:0.25 animations:^{
            self.moreView.frame = CGRectMake(0, self.backView.height, K_Width, bottomHeight);
            self.frame = CGRectMake(0, K_Height - StatusNav_Height - self.backView.height - bottomHeight, K_Width, self.backView.height + bottomHeight);
            [self changeTableViewFrame];
        }];
    } else { //再次点击更多按钮
        //键盘弹起
        [self.textView becomeFirstResponder];
    }
}

#pragma mark ====== 改变输入框大小 ======
- (void)changeFrame:(CGFloat)height {
    CGRect frame = self.textView.frame;
    frame.size.height = height;
    self.textView.frame = frame; //改变输入框的frame
    //当输入框大小改变时，改变backView的frame
    self.backView.frame = CGRectMake(0, 0, K_Width, height + (viewMargin * 2));
    self.frame = CGRectMake(0, K_Height - StatusNav_Height - self.backView.height - _keyboardHeight, K_Width, self.backView.height);
   
    //改变更多按钮、表情按钮的位置
    self.voiceBtn.bottom = self.backView.bottom - viewMargin;
    self.moreBtn.bottom = self.backView.bottom - viewMargin;
    self.emojiBtn.bottom = self.backView.bottom - viewMargin;
    
    //主要是为了改变VC的tableView的frame
    [self changeTableViewFrame];
}

- (void)changeBackViewFrame {
    if (self.voiceClick) {
        self.backView.height = self.voiceRecordBtn.bottom + viewMargin;
    }else {
        self.backView.height = self.textView.bottom + viewMargin;
    }
    //改变更多按钮、表情按钮的位置
    self.voiceBtn.bottom = self.backView.bottom - viewMargin;
    self.moreBtn.bottom = self.backView.bottom - viewMargin;
    self.emojiBtn.bottom = self.backView.bottom - viewMargin;
}

#pragma mark ====== 点击空白处，键盘收起时，移动self至底部 ======
- (void)keyboardHide {
    //收起键盘
    [self.textView resignFirstResponder];
    [self removeBottomViewFromSupview];
    [UIView animateWithDuration:0.25 animations:^{
        //设置self的frame到最底部
        [self changeBackViewFrame];
        self.frame = CGRectMake(0, K_Height - StatusNav_Height - self.backView.height, K_Width, self.backView.height);
        [self changeTableViewFrame];
    }];
}

#pragma mark ====== 键盘将要出现 ======
- (void)keyboardWillShow:(NSNotification *)notification {
    [self removeBottomViewFromSupview];
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //获取键盘的高度
    self.keyboardHeight = endFrame.size.height;
    
    //键盘的动画时长
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration delay:0 options:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] animations:^{
        [self changeBackViewFrame];
        self.frame = CGRectMake(0, endFrame.origin.y - self.backView.height - StatusNav_Height, K_Width, self.backView.height);
        [self changeTableViewFrame];
    } completion:nil];
}

#pragma mark ====== 键盘将要消失 ======
- (void)keyboardWillHide:(NSNotification *)notification {
    //如果是弹出了底部视图时
    if (self.moreClick || self.emojiClick) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self changeBackViewFrame];
        self.frame = CGRectMake(0, K_Height - StatusNav_Height - self.backView.height, K_Width, self.backView.height);
        [self changeTableViewFrame];
    }];
}

#pragma mark ====== 改变tableView的frame ======
- (void)changeTableViewFrame {
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardChangeFrameWithMinY:)]) {
        [self.delegate keyboardChangeFrameWithMinY:self.top];
    }
}

#pragma mark ====== 移除底部视图 ======
- (void)removeBottomViewFromSupview {
    [self.moreView removeFromSuperview];
    [self.emojiView removeFromSuperview];
    self.moreView = nil;
    self.emojiView = nil;
    self.moreClick = NO;
    self.emojiClick = NO;
}

#pragma mark ====== 点击发送按钮 ======
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //判断输入的字是否是回车，即按下return
    if ([text isEqualToString:@"\n"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(JMKeyBoardView:sendMessage:)]) {
            [self.delegate JMKeyBoardView:self sendMessage:textView.text];
        }
        [self changeFrame:viewHeight];
        textView.text = @"";
        /*这里返回NO，就代表return键值失效，即页面上按下return，
         不会出现换行，如果为yes，则输入页面会换行*/
        return NO;
    }
    return YES;
}

#pragma mark ====== init ======
// 輸入框背景
- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.layer.borderWidth = 1;
        _backView.layer.borderColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.89 alpha:1.00].CGColor;
        [self addSubview:_backView];
    }
    return _backView;
}

//表情按钮
- (UIButton *)emojiBtn {
    if (!_emojiBtn) {
        _emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emojiBtn setBackgroundImage:[UIImage imageWithName:@"chat_btn_face"] forState:UIControlStateNormal];
        [_emojiBtn addTarget:self action:@selector(emojiBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_emojiBtn];
    }
    return _emojiBtn;
}

//更多按钮
- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setBackgroundImage:[UIImage imageWithName:@"chat_btn_add"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_moreBtn];
    }
    return _moreBtn;
}

// 語音按鈕
- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceBtn setBackgroundImage:[UIImage imageWithName:@"chat_btn_recod"] forState:UIControlStateNormal];
        [_voiceBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_voiceBtn];
    }
    return _voiceBtn;
}

// 录音按鈕
- (UIButton *)voiceRecordBtn {
    if (!_voiceRecordBtn) {
        _voiceRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceRecordBtn.hidden = YES;
        [_voiceRecordBtn setBackgroundImage:[UIImage imageWithName:@"chat_message_back"] forState:UIControlStateNormal];
        [_voiceRecordBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_voiceRecordBtn setTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [_voiceRecordBtn setTitle:@"按钮 说话" forState:UIControlStateNormal];
        [_voiceRecordBtn setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        [_voiceRecordBtn addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        [_voiceRecordBtn addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        [_voiceRecordBtn addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [_voiceRecordBtn addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [_voiceRecordBtn addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        
        [self.backView addSubview:_voiceRecordBtn];
    }
    return _voiceRecordBtn;
}

// 輸入框
- (JMTextView *)textView {
    if (!_textView) {
        _textView = [[JMTextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:16];
        [_textView textValueDidChanged:^(CGFloat textHeight) {
            [self changeFrame:textHeight];
        }];
        _textView.maxNumberOfLines = 5;
        _textView.layer.cornerRadius = 4;
        _textView.layer.borderWidth = 1;
        _textView.layer.borderColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.89 alpha:1.00].CGColor;
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeySend;
        [self.backView addSubview:_textView];
    }
    return _textView;
}

//更多视图
- (JMMoreView *)moreView {
    if (!_moreView) {
        _moreView = [[JMMoreView alloc] init];
        _moreView.frame = CGRectMake(0, K_Height, K_Width, bottomHeight);
    }
    return _moreView;
}

//表情视图
- (JMEmojiView *)emojiView {
    if (!_emojiView) {
        _emojiView = [[JMEmojiView alloc] init];
        _emojiView.frame = CGRectMake(0, K_Height, K_Width, bottomHeight);
    }
    return _emojiView;
}

#pragma mark - 录音touch事件
- (void)beginRecordVoice:(UIButton *)button
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryRecord error:&err];
    if (err) {
        NSLog(@"audioSession: %@ %zd %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    [audioSession setActive:YES error:&err];
    if (err) {
        NSLog(@"audioSession: %@ %zd %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    
    
    NSDictionary *recordSetting = @{
                                    AVEncoderAudioQualityKey : [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderBitRateKey : [NSNumber numberWithInt:16],
                                    AVFormatIDKey : [NSNumber numberWithInt:kAudioFormatLinearPCM],
                                    AVNumberOfChannelsKey : @2,
                                    AVLinearPCMBitDepthKey : @8
                                    };
    NSError *error = nil;
    //    NSString *docments = [NSHomeDirectory() stringByAppendingString:@"Documents"];
    NSString *docments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    _docmentFilePath = [NSString stringWithFormat:@"%@/%@",docments,@"123"];
    
    NSURL *pathURL = [NSURL fileURLWithPath:_docmentFilePath];
    _recorder = [[AVAudioRecorder alloc] initWithURL:pathURL settings:recordSetting error:&error];
    if (error || !_recorder) {
        NSLog(@"recorder: %@ %zd %@", [error domain], [error code], [[error userInfo] description]);
        return;
    }
    _recorder.delegate = self;
    [_recorder prepareToRecord];
    _recorder.meteringEnabled = YES;
    
    if (!audioSession.inputIsAvailable) {
        
        return;
    }
    
    
    [_recorder record];
    _playTime = 0;
    _playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
    [JMProgressHUD show];
}

- (void)endRecordVoice:(UIButton *)button
{
    [_recorder stop];
    [_playTimer invalidate];
    _playTimer = nil;
}

- (void)cancelRecordVoice:(UIButton *)button
{
    if (_playTimer) {
        [_recorder stop];
        [_recorder deleteRecording];
        [_playTimer invalidate];
        _playTimer = nil;
    }
    [JMProgressHUD dismissWithError:@"Cancel"];
}

- (void)RemindDragExit:(UIButton *)button
{
    [JMProgressHUD changeSubTitle:@"Release to cancel"];
}

- (void)RemindDragEnter:(UIButton *)button
{
    [JMProgressHUD changeSubTitle:@"Slide up to cancel"];
}


- (void)countVoiceTime
{
    _playTime ++;
    if (_playTime>=60) {
        [self endRecordVoice:nil];
    }
}

#pragma mark - Mp3RecorderDelegate

//回调录音资料
- (void)endConvertWithData:(NSData *)voiceData
{
    [self.delegate JMKeyBoardView:self sendVoice:voiceData time:_playTime+1];
    [JMProgressHUD dismissWithSuccess:@"Success"];
    
    //缓冲消失时间 (最好有block回调消失完成)
    self.voiceRecordBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.voiceRecordBtn.enabled = YES;
    });
}

- (void)failRecord
{
    [JMProgressHUD dismissWithSuccess:@"Too short"];
    
    //缓冲消失时间 (最好有block回调消失完成)
    self.voiceRecordBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.voiceRecordBtn.enabled = YES;
    });
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSURL *url = [NSURL fileURLWithPath:_docmentFilePath];
    NSError *err = nil;
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options:0 error:&err];
    if (audioData) {
        [self endConvertWithData:audioData];
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    
}

#pragma mark ====== 移除监听 ======
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
