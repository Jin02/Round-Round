//
//  Game.h
//  ProJect
//
//  Created by roden on 10. 5. 11..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
//#import "SimpleAudioEngine.h"
//#import "CDAudioManager.h"
//#import "CocosDenshion.h"
#import "AudioPlayer.h"

#import "Data.h"

#import <GameKit/GameKit.h>
#import "GlobalExtern.h"
#import "ResultScreenData.h"
#import "Result.h"

@class DeviceHandle;
@class Interface;

struct GameNoteData {
	int CreateTime;
	int Value;
	int Count;
};

@interface Game : CCScene {
	
	DeviceHandle				*m_DeviceHandle;
	Interface					*m_Interface;
	Data						*m_SaveData;
struct	GameNoteData			*m_NoteData;
	
	CCSprite					*m_BackGround;
	
	NSString					*m_Music;
		
	unsigned long				 m_StartTime;

	BOOL						 m_Reverse;
	
	int							 m_MaxNote;	
	int							 m_Speed;
	
	int							 m_NowNote;
	
	int							 m_TouchDirection;
	
	int							 m_life;
	
	NSInteger					 m_Combo;
	NSInteger					 m_Score;
	
	NSMutableArray				 *_BeforeData;
}

@property(nonatomic, readwrite) int m_TouchDirection;
@property(nonatomic, readwrite) NSInteger m_Score;
@property(readonly)NSInteger m_Combo;
@property(readwrite) int	life;

+(id)scene;
-(void)NoteDataLoad:(NSString*)context;
-(void)Step;
-(unsigned long)timeGetTime;
-(void)Play;

-(void)NextScene;

-(void)SoundLoadPath:(NSString*)path;
-(void)MessageBox:(NSString*)context;

-(void)NoteCreateValue:(NSInteger)Value;
-(void)CreateSprite;

-(void)NoteDelete:(CCSprite*)Sprite;
-(void)NoteCheck:(NSInteger)tag pos:(CGPoint)pos;

-(void)LifeUp:(NSInteger)Value;
-(void)LifeDown:(NSInteger)Value;

-(void)netWorkDisconnect;

@end
