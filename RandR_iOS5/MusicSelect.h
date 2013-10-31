//
//  Menu.h
//  ProJect
//
//  Created by roden on 10. 5. 17..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import <GameKit/GameKit.h>

#import "MusicSelectDevice.h"
#import "Data.h"

#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"
#import "CocosDenshion.h"
#import "AudioPlayer.h"


@class MusicSelectDevice;

enum
{
	Mu_Sheet = 11,
	Mu_Circle,
	Mu_Speed,
	Mu_Reverse
};

@interface MusicSelect : CCLayer  {

	MusicSelectDevice		*_Device;
	
	CCSprite				*_LeftScreen;
	CCSprite				*_Circle;

	CCSprite				*_Reverse;
	CCSprite				*_Speed;
	
	CCMenuItem				*_BackBt;
	
	NSInteger				_SelectNum;
	
	NSMutableArray			*_MusicString;
	NSMutableArray			*_HighScore;
	Data					*_SaveData;
	
	NSInteger				_MusicStopID;
	
	BOOL					isCheck;
}

@property(nonatomic,retain)NSMutableArray			*MusicString;

+(id)scene;

-(void)albumUp;
-(void)albumDown;
-(void)CreateSprite;
-(void)albumSelect;
-(void)LabelDataSetWithString:(NSString*)str;
-(void)SoundLoadWithPath:(NSString*)path;
-(void)SoundNewLoadWithPath:(NSString*)path;
-(void)MessageBox:(NSString*)context;
-(void)netWorkDisconnect;

@end
