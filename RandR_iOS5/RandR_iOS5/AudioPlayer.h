//
//  AudioPlayer.h
//  GameDemo
//
//  Created by cmpak on 2/27/10.
//  Copyright 2010 GTekna Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface AudioPlayer : NSObject <AVAudioPlayerDelegate> {
    AVAudioPlayer *backgroundAudioPlayer;
    AVAudioPlayer *nullAudioPlayer;
}

@property (nonatomic, retain) AVAudioPlayer *backgroundAudioPlayer;
@property (nonatomic, retain) AVAudioPlayer *nullAudioPlayer;


+ (AudioPlayer *)sharedAudioPlayer;

- (AVAudioPlayer*) createAudioPlayer:(NSString*)fileName fileType:(NSString*)fileType volumn:(CGFloat)volumn;

- (void) SoundLoad:(NSString*)Path Type:(NSString*)Type isLoop:(BOOL)isLoop;
- (void) playBackGroundAudio;
- (void) stopBackGroundAudio;

- (float) GetaveragePowerForChannel:(NSInteger)channel;
- (BOOL) GetisBackGroundisPlaying;
- (AVAudioPlayer*)GetBackGroundMusic;
- (void)backgroundRelese;
- (NSTimeInterval)GetBackGroundMusicDuration;

@end
