//
//  Game.m
//  ProJect
//
//  Created by roden on 10. 5. 11..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Game.h"
#import "DeviceHandle.h"
#import "Interface.h"
#import "Enum.h"
#import <sys/time.h>
#import "Menu.h"
#import "SimpleAudioEngine.h"

@implementation Game

@synthesize m_TouchDirection;
@synthesize m_Score;
@synthesize m_Combo;
@synthesize life = m_life;

+(id) scene
{
	CCScene *scene = [CCScene node];
	Game *layer = [Game node];
	[scene addChild: layer];
	
	return scene;
}

#pragma mark Init

-(id)init
{
	if( (self = [super init]) )
	{
		m_Music = MusicName;
		
		NSLog(@"게임 %@",m_Music);
		
		//디바이스핸들을 생성하고 연결시켜 줍니다
		DeviceHandle *TempDevice = [[DeviceHandle alloc] initWithGame:self];
		m_DeviceHandle = TempDevice;
		[self addChild:m_DeviceHandle z:tag_Device tag:tag_Device];
		[TempDevice release];
				
		//인터페이스를 생성하고 연결시켜 줍니다
		Interface *TempInterface = [[Interface alloc] initWithGame:self];
		m_Interface = TempInterface;
		[self addChild:m_Interface z:tag_Interface tag:tag_Interface];
		[TempInterface release];
		
		m_SaveData = [[Data alloc] init];
				
		// 1, 2, 3
		m_Speed				= g_SpeedValue; // 1 배속
		
		NSLog(@"NOTE SPEED %d", m_Speed);
		
		m_NowNote			= 0;
		m_TouchDirection	= NOT;
		m_Combo				= 0;
		m_Score				= 0;
		m_Reverse			= g_ReverseValue;
		
		g_Cool				= 0;
		g_MaxCombo			= 0;
		g_Miss				= 0;
		g_Perfact			= 0;
		g_Score				= 0;
		
		m_life				= 280;
		
		isPlaying			= YES;
						
		NSLog(@"로딩 1");
		
		_BeforeData			= [m_SaveData DataLoadWithFilePath:m_Music];
		
		NSLog(@"Before Score %d", [[_BeforeData objectAtIndex:0] intValue]);
		
		[self NoteDataLoad:m_Music];
		[self CreateSprite];
		[[AudioPlayer sharedAudioPlayer] SoundLoad:m_Music Type:@"mp3" isLoop:NO];
		[self performSelector:@selector(Play) withObject:nil afterDelay:3.0f];

		
		NSLog(@"로딩 2");
	}
	
	return self;
}

-(void)onExit
{
	[super onExit];
	[self unschedule:@selector(Step)];
	[self netWorkDisconnect];
	
	[self removeAllChildrenWithCleanup:YES];
	[[AudioPlayer sharedAudioPlayer] stopBackGroundAudio];
}

-(void)CreateSprite
{
	m_BackGround = [CCSprite spriteWithFile:@"machine.png"];
	m_BackGround.position = ccp(240,160);
	
	[self addChild:m_BackGround z:tag_BackGround tag:tag_BackGround];
	
//	CCSpriteBatchNode *TempSheet = [CCSpriteBatchNode spriteSheetWithFile:@"note.png" capacity:20];
    CCSpriteBatchNode *TempSheet = [CCSpriteBatchNode batchNodeWithFile:@"note.png" capacity:20];
	
	[self addChild:TempSheet z:tag_NoteSheet tag:tag_NoteSheet];
}

-(void)netWorkDisconnect
{
	if ( Net.isMultiPlay )
	{
		NSLog(@"연결을 끊었습니다");
	
		[Net.m_Session disconnectFromAllPeers];
		Net.m_Session = nil;
		Net.isMultiPlay = NO;
	}
}


#pragma mark -

-(void)Step
{
	if( isPause )
	{		
		if(!Net.isMulti)
		{
			[self MessageBox:@"게임이 일시정지 되었습니다. \n 게임을 다시 시작합니다 \n 약간의 패널티가 주어 집니다."];
			m_NowNote = 0;
			[[AudioPlayer sharedAudioPlayer] stopBackGroundAudio];
			[self unschedule:@selector(Step)];
			[self performSelector:@selector(Play) withObject:nil afterDelay:3.0f];
			m_Score		= 0;
			g_Perfact	= 0;
			g_Cool		= 0;
			g_Miss		= 0;
			m_Combo		= 0;
			g_MaxCombo	= 0;
		}
		else {
			[self MessageBox:@"게임이 일시정지 되었습니다. \n 상대방 플레이어와 연결이 끊겼습니다. \n 게임을 종료합니다."];
			[self unschedule:@selector(Step)];
			[self netWorkDisconnect];
			[[AudioPlayer sharedAudioPlayer] stopBackGroundAudio];
			[[CCDirector sharedDirector] pushScene:[Menu scene]];
		}
		
		isPause = NO;
		return;
	}
	
	if( m_Interface.life <= 0 && isPlaying)
	{
		[m_Interface GameOverActions];
		
		[self performSelector:@selector(NextScene) withObject:nil afterDelay:3.0f];		 
		isPlaying = NO;
		return;
	}
	
//	NSTimeInterval s = [[AudioPlayer sharedAudioPlayer] GetBackGroundMusicDuration];
		
	if( ((m_NoteData[m_NowNote].CreateTime) <= (([self timeGetTime] - m_StartTime)/10+350)) && (m_NowNote < m_MaxNote) )
		[self NoteCreateValue:m_NoteData[m_NowNote++].Value];
	
//	if( ((m_NoteData[m_NowNote].CreateTime) <= [[AudioPlayer sharedAudioPlayer] GetBackGroundMusicDuration]) && (m_NowNote < m_MaxNote) )
//		[self NoteCreateValue:m_NoteData[m_NowNote++].Value];

	CCSpriteBatchNode *Sheet = (CCSpriteBatchNode*)[self getChildByTag:tag_NoteSheet];
	
	for(CCSprite *sprite in [Sheet children])
	{
		if( (sprite.rotation == 210) || (sprite.rotation == -210) )
		{
			[Sheet removeChild:sprite cleanup:YES];
			m_Combo = 0;
			g_Miss++;
			[self LifeDown:12.0f];
			[m_Interface DecisionDisPlay:tag_Miss];
//			NSLog(@"Miss");
		}
	}
	
/*	if( Net.m_isReceive )
	{
		[m_Interface YourScoreDisPlay:Net.m_Score];		
		Net.m_isReceive = NO;
	}*/
	
	if( ![[AudioPlayer sharedAudioPlayer] GetisBackGroundisPlaying] )
	{
		NSString *Context = [NSString stringWithFormat:@"%d",m_Score];
		
		[self netWorkDisconnect];
		Net.m_isFirstReceive = YES;
				
		if( [[_BeforeData objectAtIndex:0] intValue] <= m_Score )
			[m_SaveData DataToSaveWithSaveFilePath:m_Music Context:Context];
		
		[self unschedule:@selector(Step)];
		g_Score = m_Score;

		[self NextScene];
	}
	
}

-(unsigned long)timeGetTime
{
	static struct timeval tv;
	static unsigned long time;
	gettimeofday(&tv, nil);
	
	time = (tv.tv_sec * 1000) + (tv.tv_usec / 1000);
	return time;
}

-(void)Play
{
	[[AudioPlayer sharedAudioPlayer] playBackGroundAudio];
	
	m_life = 292.0f;;
	[self schedule:@selector(Step)];
	m_StartTime = [self timeGetTime];
}

#pragma mark Note

-(NSInteger)NoteReverse:(NSInteger)Value
{
	if( ((Value+1) % 2) == 0 )
		return Value-1;
	else
		return Value+1;
}

-(void)NoteDataLoad:(NSString*)context
{
	FILE	*fp;
	int		MaxNote = 0;
	
	NSString* fullFileName = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], context];
	fullFileName = [fullFileName stringByAppendingFormat:@".txt"];
	const char* Dir = [fullFileName UTF8String];
	
	fp = fopen(Dir, "r");
	
	fscanf(fp, "%d", &MaxNote);
//	NSLog(@"%d",MaxNote);
	
	m_MaxNote = MaxNote;	
	m_NoteData = (struct GameNoteData*)calloc(MaxNote, sizeof(struct GameNoteData));
	
	for(int loop = 0; loop < MaxNote; loop++)
	{
		fscanf(fp, "%d", &m_NoteData[loop].CreateTime);
		fscanf(fp, "%d", &m_NoteData[loop].Value);
		
		if (m_Reverse)
			m_NoteData[loop].Value = [self NoteReverse:m_NoteData[loop].Value];
		
	}
	
	fclose(fp);
}

-(void)NoteDelete:(CCSprite*)Sprite
{	
	CCSpriteBatchNode *sheet = (CCSpriteBatchNode*)[self getChildByTag:tag_NoteSheet];

	[Sprite stopAllActions];
	[sheet removeChild:Sprite cleanup:YES];
}

-(void)NoteCreateValue:(NSInteger)Value
{	
	CCSpriteBatchNode	*sheet = (CCSpriteBatchNode*)[self getChildByTag:tag_NoteSheet];
	CGRect			imageRect = CGRectMake(60*Value, 0.0f, 60.0f, 60.0f);
	int				Dir;
	
	CCSprite		*sprite = [CCSprite spriteWithTexture:sheet.texture rect:imageRect];
	sprite.anchorPoint		= ccp(0.5,-1.4);
	[sprite setOpacity:0];
	[sprite setPosition:ccp(240,160)];

	if( Value == Note_RightUp || Value == Note_RightDown || Value == Note_LeftRound )
		Dir = 1;
	else
		Dir = -1;
	
	id FadeIn		=  [CCFadeIn actionWithDuration:0.3f];
	id Rotate		=  [CCRotateTo actionWithDuration:(3/m_Speed) angle:180 * Dir];
	id FadeOut		=  [CCFadeOut actionWithDuration:0.5f];
	
	id FastRotate	=  [CCRotateBy actionWithDuration:0.5f angle:30*Dir];

	[sprite runAction:[CCSequence actions:
					   [CCSpawn actions:FadeIn, Rotate,nil],
					   [CCSpawn actions:FadeOut,FastRotate,nil]
					   ,nil]];
	
	[sheet addChild:sprite z:tag_Note+(m_MaxNote-m_NowNote) tag:Value];
}

-(void)Reset:(NSInteger)tag
{
	if( tag == Note_RightUp || tag == Note_RightDown )
		m_TouchDirection = RIGHT;
	else if( tag == Note_LeftUp || tag == Note_LeftDown )
		m_TouchDirection = LEFT;
	else if( tag == Note_LeftRound || tag == Note_RightRound )
		m_TouchDirection = ROUND;
	else
		m_TouchDirection = NOT;
}

-(void)ScoreSend
{
	if( Net.m_Session == nil )
	{
//		NSLog(@"없어 이거");
		return;
	}
	
	NSData *data = [[NSString stringWithFormat:@"%d",m_Score] dataUsingEncoding:NSASCIIStringEncoding];
	[Net mySendData:data];
}

-(void)NoteCheck:(NSInteger)tag pos:(CGPoint)pos
{
	NSInteger		DecisionTag;
	CCSpriteBatchNode*	sheet = (CCSpriteBatchNode*)[self getChildByTag:tag_NoteSheet];
	BOOL			isNote = NO;
	int				Score  = 0;
	
	for(CCSprite *Sprite in [sheet children])
	{
		if( 175 <= fabs((double)Sprite.rotation) && fabs((double)Sprite.rotation) <= 185 )
		{
			if( Sprite.tag == tag )
			{
//				NSLog(@"Perfact");
				[self NoteDelete:Sprite];
				isNote = YES;
				Score = 500;
				DecisionTag = tag_Perfact;
				g_Perfact++;
				[self LifeUp:10.0f];
				
				break;
			}
		}
		
		if( 170 <= fabs((double)Sprite.rotation) && fabs((double)Sprite.rotation) <= 190 )
		{
			if( Sprite.tag == tag )
			{
				NSLog(@"Cool");
				[self NoteDelete:Sprite];
				isNote = YES;
				Score = 300;
				DecisionTag = tag_Cool;
				g_Cool++;
				[self LifeUp:6.0f];
				
				break;
			}
		}
	
	}
	
	if(isNote)
	{
		NSInteger rotate = -60;
		
		[self Reset:tag];
		
		if( !(tag == Note_LeftRound || tag == Note_RightRound) )
			m_DeviceHandle.m_TouchPoint = pos;
		
		if( tag == Note_LeftUp || tag == Note_RightDown )
			rotate = -rotate;
		else if (tag == Note_LeftRound)
			rotate = rotate*6;
		else if (tag == Note_RightRound)
			rotate = -rotate*6;
		
		[m_Interface.m_Circle runAction:[CCRotateBy actionWithDuration:0.5f angle:rotate]];
		
		if(g_MaxCombo < m_Combo++)
			g_MaxCombo = m_Combo;
		
		m_Score += Score + (200*(m_Combo*0.05)) ;
		
		
		if( Net.isMulti )
		{
			[Net mySendData:[[NSString stringWithFormat:@"%d",m_Score] dataUsingEncoding:NSASCIIStringEncoding]];
			NSLog(@"유ㅓㅋ웤웤ㅇ!");
		}
		[m_Interface ComboDisPlay:m_Combo];
		[m_Interface PlayEffect];
		[m_Interface DecisionDisPlay:DecisionTag];
	}
}


#pragma mark -

#pragma mark etc

-(void)LifeUp:(NSInteger)Value
{
	if (m_life+Value < 280)
		m_life+=Value;
	else
		m_life = 280;
}

-(void)LifeDown:(NSInteger)Value
{
	if(m_life+Value > 0)
		m_life-=Value;
	else
		m_life = 0;
}

-(void)SoundLoadPath:(NSString*)path
{
	path = [path stringByAppendingFormat:@".mp3"];
	
	NSInteger EffectValue = [[SimpleAudioEngine sharedEngine] playEffect:path];
	[[SimpleAudioEngine sharedEngine] stopEffect:EffectValue];
}

-(void)MessageBox:(NSString*)context
{
	UIAlertView *alert	= [[UIAlertView alloc] initWithTitle:[NSString stringWithString:context] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
	
    [alert show];
	[alert release];	
}

-(void)NextScene
{
	[self netWorkDisconnect];
	[[CCDirector sharedDirector] pushScene:[Result scene]];
}
		  
#pragma mark -

-(void)dealloc
{
	NSLog(@"해제");
		
	[m_SaveData release];
	[_BeforeData release];
	
	[self removeAllChildrenWithCleanup:YES];
		
	//노트 데이터 해제
	free(m_NoteData);
	
	[super dealloc];
}

@end
