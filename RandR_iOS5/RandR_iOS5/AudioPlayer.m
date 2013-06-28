//
//  AudioPlayer.m
//  GameDemo
//
//  Created by cmpak on 2/27/10.
//  Copyright 2010 GTekna Corporation. All rights reserved.
//

#import "AudioPlayer.h"

@implementation AudioPlayer

@synthesize backgroundAudioPlayer, nullAudioPlayer;


static AudioPlayer *_sharedAudioPlayer = nil;

+ (AudioPlayer *) sharedAudioPlayer {
	@synchronized([AudioPlayer class]) {
		if (!_sharedAudioPlayer)
			[[self alloc] init];
		
		return _sharedAudioPlayer;
	}
    
	return nil;
}

+ (id) alloc{
	@synchronized([AudioPlayer class]) {
		_sharedAudioPlayer = [super alloc];
		return _sharedAudioPlayer;
	}
    
	return nil;
}

- (AVAudioPlayer*) createAudioPlayer:(NSString*)fileName fileType:(NSString*)fileType volumn:(CGFloat)volumn {
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    AVAudioPlayer *tmpAudionPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audioPath] error:NULL];
    
    tmpAudionPlayer.numberOfLoops = 0;
    tmpAudionPlayer.volume = volumn;
	tmpAudionPlayer.meteringEnabled = YES;
    [tmpAudionPlayer setDelegate:self];
    [tmpAudionPlayer prepareToPlay];
    
    [tmpAudionPlayer autorelease];
    
    return tmpAudionPlayer;
}

-(void) SoundLoad:(NSString*)Path Type:(NSString*)Type isLoop:(BOOL)isLoop
{
	self.backgroundAudioPlayer = [self createAudioPlayer:Path fileType:Type volumn:0.7];
	self.backgroundAudioPlayer.numberOfLoops = -isLoop;
}

- (void) playBackGroundAudio
{    
	[self.backgroundAudioPlayer play];
//	[self.backgroundAudioPlayer set];
}

- (void) stopBackGroundAudio {
    if( self.backgroundAudioPlayer != nil) {
        [self.backgroundAudioPlayer stop];
        self.backgroundAudioPlayer.currentTime = 0;
	}
}

-(BOOL) GetisBackGroundisPlaying
{
	return [self.backgroundAudioPlayer isPlaying];
}

-(float) GetaveragePowerForChannel:(NSInteger)channel
{	
	[self.backgroundAudioPlayer updateMeters];
	return [self.backgroundAudioPlayer averagePowerForChannel:channel];
}

-(NSTimeInterval)GetBackGroundMusicDuration
{
//	NSLog(@"%f", (float)backgroundAudioPlayer.duration);
	
	return backgroundAudioPlayer.duration;
}

- (AVAudioPlayer*)GetBackGroundMusic
{
	return self.backgroundAudioPlayer;
}

-(void)backgroundRelese
{
	if(self.backgroundAudioPlayer != nil) {
        [self stopBackGroundAudio];
        [backgroundAudioPlayer release];
    }	
}

- (void) dealloc {
    if(self.backgroundAudioPlayer != nil) {
        [self stopBackGroundAudio];
        [backgroundAudioPlayer release];
    }
    
    if(self.nullAudioPlayer != nil) {
        [self stopBackGroundAudio];
        [nullAudioPlayer release];
    }
    
    [super dealloc];
}

@end
