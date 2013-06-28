//
//  Menu.m
//  ProJect
//
//  Created by roden on 10. 5. 17..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MusicSelect.h"
#import "Game.h"
#import "Result.h"
#import "Menu.h"

#import "Enum.h"

@implementation MusicSelect

@synthesize MusicString = _MusicString;

+(id) scene
{
	CCScene *scene = [CCScene node];
	MusicSelect *layer = [MusicSelect node];
	[scene addChild: layer];
	
	return scene;
}

-(id)init
{
	if( (self = [super init]) )
	{
		CCSprite *BackGround = [CCSprite spriteWithFile:@"bg.png"];
		BackGround.anchorPoint = CGPointZero;
		
		_SaveData = [[Data alloc] init];
		
		_MusicString = [[NSMutableArray alloc]init];
		
		[_MusicString addObject:@"Lupin"];
		[_MusicString addObject:@"Magic"];
		[_MusicString addObject:@"Tears"];
		[_MusicString addObject:@"Potato"];
		[_MusicString addObject:@"NU"];
		[_MusicString addObject:@"love"];
		[_MusicString addObject:@"Y2"];
		[_MusicString addObject:@"School"];
		[_MusicString addObject:@"moonlight"];
		[_MusicString addObject:@"Bang"];
		[_MusicString addObject:@"Virus"];
		[_MusicString addObject:@"Canon"];
		

		//뮤직코드는 각각 곡마다 다른가보다..
		//0혹은 1부터가 아닌 2천 넘게 나옴;
//		NSLog(@"Music Code %d", [[SimpleAudioEngine sharedEngine] playEffect:@"Canon_Short.mp3"]);
		
		//이 게임이 처음 시작되었을때 아래문구를 실행한다.
		if( [[_SaveData DataLoadWithFilePath:@"isFirst"] autorelease] == nil )
		{
			[_SaveData DataClearWithFilePath:@"isFirst"];
			
			NSLog(@"게임 처음 켯슴니다!");
			
			for( int i = 0; i < 12; i++ )
			{
				[_SaveData DataClearWithFilePath:[_MusicString objectAtIndex:i]];
				[_SaveData DataToSaveWithSaveFilePath:[_MusicString objectAtIndex:i] Context:@"0"];
			}
		}
		
		_HighScore = [[NSMutableArray alloc] init];
		
		for( int i = 0; i < 12; i++ )
		{
			NSMutableArray	*ScoreData	= [_SaveData DataLoadWithFilePath:[_MusicString objectAtIndex:i]];
			[self SoundLoadWithPath:[_MusicString objectAtIndex:i]];
			[_HighScore addObject:[ScoreData objectAtIndex:0]];
			[ScoreData release];
		}
		
		[self SoundNewLoadWithPath:@"Select_2.mp3"];
		[self SoundNewLoadWithPath:@"Select.mp3"];
		[self SoundNewLoadWithPath:@"Combo.mp3"];
		[self SoundNewLoadWithPath:@"Multi.mp3"];
		[self SoundNewLoadWithPath:@"Score.mp3"];
		
		_SelectNum		= 0;
		g_ReverseValue  = NO;
		g_SpeedValue	= 1;
		
		[self CreateSprite];
		
		[self LabelDataSetWithString:[_HighScore objectAtIndex:0]];
		
		//디바이스핸들을 생성하고 연결시켜 줍니다
		MusicSelectDevice *TempDevice = [[MusicSelectDevice alloc] initWithScene:self];
		_Device = TempDevice;
		[self addChild:_Device z:tag_Device tag:tag_Device];
		[TempDevice release];
		
		[self addChild:BackGround z:0 tag:tag_BackGround];		
		
		//현재 사운드 재생
		_MusicStopID = [[SimpleAudioEngine sharedEngine]playEffect:@"Lupin_Short.mp3"];
		
		isCheck = NO;
	}
	
	return self;
}

-(void)ShortMusicPlay:(NSString*)path
{
	[[SimpleAudioEngine sharedEngine] stopEffect:_MusicStopID];
	_MusicStopID = [[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"%@_Short.mp3",path]];
}

-(void)SoundNewLoadWithPath:(NSString*)path
{
	ALuint EffectValue = [[SimpleAudioEngine sharedEngine] playEffect:path];
	[[SimpleAudioEngine sharedEngine] stopEffect:EffectValue];
}

-(void)SoundLoadWithPath:(NSString*)path
{
	ALuint EffectValue = [[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"%@_Short.mp3",path]];
	[[SimpleAudioEngine sharedEngine] stopEffect:EffectValue];
}

-(void)LabelDelete
{	[_LeftScreen removeChildByTag:tag_Label cleanup:YES];	}

-(void)LabelDataSetWithString:(NSString*)str
{
	int labelPos = [str intValue];
	
	CCLabelAtlas *Label = [CCLabelAtlas labelWithString:str
												 charMapFile:@"Resultnumber.png"
												   itemWidth:15
												  itemHeight:30
												startCharMap:'0'];
	
	Label.anchorPoint = CGPointZero;
	[Label setPosition:ccp(20+( 15*(labelPos<100) + 15*(labelPos<10000)) ,65)];
	
	[_LeftScreen addChild:Label z:tag_Interface+1 tag:tag_Label];
}

-(void)MusicNameSetWithNum
{
	CCSprite *leftsprite = (CCSprite*)[self getChildByTag:tag_Song];
	CCSpriteBatchNode *sheet = (CCSpriteBatchNode*)[leftsprite getChildByTag:tag_Song];
	
	for( CCSprite *sprite in [sheet children] )
	{
		if( sprite.tag != _SelectNum )
			sprite.visible = NO;
		else
			sprite.visible = YES;
	}
}

-(void)ReverseSet:(id)sender
{		
	if(Net.isMulti) return;
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"01.mp3"];
	
	CCSpriteBatchNode	*sheet = (CCSpriteBatchNode*)[self getChildByTag:Mu_Reverse];
	
	for( CCSprite *sprite in [sheet children] )
	{
		if( sprite.tag == !g_ReverseValue )
			sprite.visible = NO;
		else
			sprite.visible = YES;
	}
	
	g_ReverseValue = !g_ReverseValue;
	
}

-(void)SpeedSet:(id)sender
{	
	if(Net.isMulti) return;
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"01.mp3"];
	
	CCSpriteBatchNode	*sheet = (CCSpriteBatchNode*)[self getChildByTag:Mu_Speed];
	
	if(++g_SpeedValue == 4)
		g_SpeedValue = 1;
	
	for( CCSprite *sprite in [sheet children] )
	{
		if( sprite.tag == g_SpeedValue-1 )
			sprite.visible = YES;
		else {
			sprite.visible = NO;
		}
		
	}
	
}

-(void)RedundancySet
{	_Device.Redundancy = NO;  }

-(void)albumUp
{	
	CCSpriteBatchNode	*sheet = (CCSpriteBatchNode*)[self getChildByTag:Mu_Sheet];	
		
	//redundancySet을 조금만 불러도 되는데 더부르고 있음.
	
	for(CCSprite* sprite in [sheet children])
	{	
		[sprite runAction:
		 [CCSequence actions:
		  [CCRotateBy actionWithDuration:0.5f angle:-30],
		  [CCCallFunc actionWithTarget:self selector:@selector(RedundancySet)],nil]];
	}	
	
	if(_SelectNum++ == 11)
		_SelectNum = 0;
	
	[self LabelDelete];
	[self LabelDataSetWithString:[_HighScore objectAtIndex:_SelectNum]];
	[self ShortMusicPlay:[_MusicString objectAtIndex:_SelectNum]];
	[self MusicNameSetWithNum];
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"Select_2.mp3"];
}

-(void)albumDown
{
	CCSpriteBatchNode	*sheet = (CCSpriteBatchNode*)[self getChildByTag:Mu_Sheet];	
		
	for(CCSprite* sprite in [sheet children])
	{			
		[sprite runAction:
		 [CCSequence actions:
		  [CCRotateBy actionWithDuration:0.5f angle:30],
		  [CCCallFunc actionWithTarget:self selector:@selector(RedundancySet)],nil]];
	}	

	_SelectNum--;
	
	if(_SelectNum == -1)
		_SelectNum = 11;
	
	[self LabelDelete];
	[self LabelDataSetWithString:[_HighScore objectAtIndex:_SelectNum]];
	[self ShortMusicPlay:[_MusicString objectAtIndex:_SelectNum]];
	[self MusicNameSetWithNum];
	[[SimpleAudioEngine sharedEngine] playEffect:@"Select_2.mp3"];
}

-(void)NextScene
{
	MusicName = [_MusicString objectAtIndex:_SelectNum];
	[[CCDirector sharedDirector] pushScene:[Game scene]];
	isPause = NO;
}

-(void)albumSelectActions
{
	CCSpriteBatchNode	*sheet = (CCSpriteBatchNode*)[self getChildByTag:Mu_Sheet];	
	
	for(CCSprite* sprite in [sheet children])
	{
		if( sprite.tag == _SelectNum )
		{
			sprite.anchorPoint = ccp(0.5, 0.5);
			sprite.position = ccp(360,160);
			
			[sprite runAction:
			 [CCSpawn actions:
			  [CCRotateTo actionWithDuration:1.2f angle:2000],
			  [CCScaleTo actionWithDuration:1.0f scale:3.0f],
			  [CCFadeOut actionWithDuration:1.0f],nil]];
			
			return;
		}
	}
	
}

-(void)netWorkDisconnect
{
	
	if( Net.isMultiPlay )
	{
		NSLog(@"디바이스 연결을 끊었습니다");
		
		[Net.m_Session disconnectFromAllPeers];
		Net.m_Session = nil;
		Net.isMultiPlay = NO;
	}
}

-(void)ConnectCheck
{	
	if( Net.isPause )
	{
		_Device.Redundancy = NO;
		Net.isPause = NO;
	}	
	
	if( Net.isMultiPlay && !isCheck )
	{
		NSLog(@"adfasdfafsdfasfasf!");
		
		[Net mySendData:[[_MusicString objectAtIndex:_SelectNum] dataUsingEncoding:NSASCIIStringEncoding]];
		isCheck = YES;
		
		return;
	}
	
	if( !Net.m_isFirstReceive && Net.isReceive )
	{
		[self unschedule:@selector(ConnectCheck)];

		if( strcmp([[_MusicString objectAtIndex:_SelectNum] UTF8String], [MusicName2 UTF8String]) != 0 )
		{
			[self MessageBox:@"The device is not the same song"];
			[self netWorkDisconnect];
			_Device.Redundancy = NO;
			Net.m_isFirstReceive = YES;
			isCheck = NO;
			return;
		}
		
		[self albumSelectActions];
		[self performSelector:@selector(NextScene) withObject:nil afterDelay:1.0f];
	}
}

-(void)albumSelect
{	
	[[SimpleAudioEngine sharedEngine] stopEffect:_MusicStopID];
	[[SimpleAudioEngine sharedEngine] playEffect:@"Select.mp3"];
	
	if( !Net.isMulti )
	{
		[self performSelector:@selector(NextScene) withObject:nil afterDelay:1.0f];
		[self albumSelectActions];
	}
	else
	{
		[Net FindButton];
		[self schedule:@selector(ConnectCheck)];
	}
	
}

-(void)BackScene
{
	Net.isMulti = NO;
	[[SimpleAudioEngine sharedEngine] stopEffect:_MusicStopID];
	[[CCDirector sharedDirector] pushScene:[Menu scene]];
}

-(void)Back:(id)sender
{
	[[SimpleAudioEngine sharedEngine] playEffect:@"01.mp3"];
	
	[_BackBt runAction:
	 [CCSequence actions:
	  [CCMoveBy actionWithDuration:0.3f position:ccp(100,0)],
	  [CCCallFunc actionWithTarget:self selector:@selector(BackScene)],
	  nil]];
}

-(void)CreateSprite
{		
	CCSpriteBatchNode	*sheet		= [CCSpriteBatchNode batchNodeWithFile:@"album.png" capacity:10];
	
	for( int i = 0; i < 12; i++)
	{
		CCSprite		*sprite		= [CCSprite spriteWithTexture:sheet.texture rect:CGRectMake(156 * (i%3), 156*(i/3), 156, 156)];
		sprite.anchorPoint = ccp(3,0.5);
		sprite.position = ccp(750, 160);		
		sprite.rotation = i*30;
		[sheet addChild:sprite z:1 tag:i];
	}
	
	_LeftScreen = [[CCSprite alloc] initWithFile:@"MusicSelect_Left.png"];
	_LeftScreen.anchorPoint = ccp(0.0,0.5);
	_LeftScreen.position = ccp(0,160);
	
	CCMenuItem	*Speed = [CCMenuItemImage itemFromNormalImage:@"MusicSelect_Speed.png" selectedImage:@"MusicSelect_Speed.png" 
													  target:self selector:@selector(SpeedSet:)];
	
	CCMenuItem *Reverse = [CCMenuItemImage itemFromNormalImage:@"MusicSelect_Reverse.png" selectedImage:@"MusicSelect_Reverse.png" 
														target:self selector:@selector(ReverseSet:)];
	
	_BackBt = [CCMenuItemImage itemFromNormalImage:@"back.png" 
								   selectedImage:@"back.png" 
										  target:self 
										selector:@selector(Back:)];
	
	CCMenu		*menu = [CCMenu menuWithItems:Speed,Reverse,_BackBt,nil];
	[menu alignItemsHorizontally];
	
	Reverse.anchorPoint = Speed.anchorPoint = ccp(0.5,0);
	_BackBt.anchorPoint = ccp(1,1);
	
	[Speed setPosition:ccp(30,-160)];
	[Reverse setPosition:ccp(-60,-160)];
	[_BackBt setPosition:ccp(240,160)];
	
	
	CCSprite *sprite = [CCSprite spriteWithFile:@"MusicSelect_light.png"];
	sprite.position = ccp(365,160);
	
	[sprite runAction:
	 [CCRepeatForever actionWithAction:
	  [CCSequence actions:
	   [CCScaleTo actionWithDuration:0.25f scale:1.5f],
	   [CCScaleTo actionWithDuration:0.25f scale:0.7f],
	   nil]]];
	
	CCSpriteBatchNode	*Speedsheet = [CCSpriteBatchNode batchNodeWithFile:@"speed.png" capacity:3];
	
	for( int i = 0 ; i < 3; i++ )
	{
		CCSprite *sprite = [[CCSprite alloc] initWithTexture:Speedsheet.texture 
														rect:CGRectMake(27*i, 0, 27, 26)];
		
		sprite.anchorPoint = ccp(0.5, 0);
		sprite.position = ccp(273,0);
		if( i != 0 )sprite.visible = NO;
		[Speedsheet addChild: sprite z: i tag: i];
		
		[sprite release];
	}
	
	CCSpriteBatchNode	*ReverseSheet = [CCSpriteBatchNode batchNodeWithFile:@"reverse.png" capacity:2];
	
	for( int i = 0 ; i < 2; i++ )
	{
		CCSprite *sprite = [[CCSprite alloc] initWithTexture:ReverseSheet.texture rect:
							CGRectMake(22*i, 0, 22, 27)];
		
		sprite.anchorPoint	= ccp(0.5f,0.0f);
		sprite.position		= ccp(180,0);
		if( i == 0 ) sprite.visible = NO;
		[ReverseSheet addChild:sprite z:i tag:i];
		
		[sprite release];
	}
	
	CCSpriteBatchNode	*SongSheet = [CCSpriteBatchNode batchNodeWithFile:@"song.png" capacity:12];
	
	for( int i = 0; i < 12; i++ )
	{
		CCSprite *sprite = [[CCSprite alloc] initWithTexture:SongSheet.texture rect: CGRectMake(0, 38*i, 139, 38)];
		
		if( i != 0 ) sprite.visible = NO;
		sprite.anchorPoint = CGPointZero;
		[sprite setPosition:ccp(20,160)];
		[SongSheet addChild:sprite z:i tag:i];

		[sprite release];
	}
			
	[self addChild:menu z:Mu_Sheet+1 tag:tag_Interface];
	[self addChild:sprite z:tag_Interface tag:tag_Interface];
	[self addChild:_LeftScreen z:tag_Interface tag:tag_Song];
	[_LeftScreen addChild:SongSheet z:tag_Interface tag:tag_Song];
	[self addChild:sheet z:Mu_Sheet tag:Mu_Sheet];	
	[self addChild:Speedsheet z:Mu_Speed tag:Mu_Speed];
	[self addChild:ReverseSheet z:Mu_Reverse tag:Mu_Reverse];
}

-(void)MessageBox:(NSString*)context
{
	UIAlertView *alert	= [[UIAlertView alloc] initWithTitle:[NSString stringWithString:context] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
	[alert show];
	[alert release];	
}

-(void)dealloc
{
	[self removeChildByTag:tag_Song cleanup:YES];
	[self removeChildByTag:Mu_Sheet cleanup:YES];
	[self removeChildByTag:tag_Interface cleanup:YES];
	[self removeChildByTag:tag_BackGround cleanup:YES];
	[self removeChildByTag:tag_Label cleanup:YES];
	[_MusicString release];
	[_HighScore release];
	[_SaveData release];
	[super dealloc];
}

@end

