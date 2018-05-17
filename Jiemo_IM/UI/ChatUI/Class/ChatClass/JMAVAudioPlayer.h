//
//  JMAVAudioPlayer.h
//  Jiemo_IM
//
//  Created by merrill on 2018/5/17.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@protocol JMAVAudioPlayerDelegate <NSObject>

- (void)JMAVAudioPlayerBeiginLoadVoice;

- (void)JMAVAudioPlayerBeiginPlay;

- (void)JMAVAudioPlayerDidFinishPlay;

@end

@interface JMAVAudioPlayer : NSObject

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, weak) id<JMAVAudioPlayerDelegate> delegate;

+ (instancetype)sharedInstance;

-(void)playSongWithUrl:(NSString *)songUrl;

-(void)playSongWithData:(NSData *)songData;

- (void)stopSound;

@end
