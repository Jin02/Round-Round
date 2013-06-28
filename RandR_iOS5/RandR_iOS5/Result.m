//
//  Result.m
//  ProJect
//
//  Created by roden on 10. 5. 27..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Result.h"
#import "MusicSelect.h"
#import "Enum.h"
#import "GlobalExtern.h"
#import "Menu.h"

@implementation Result

+(id) scene
{
	CCScene *scene = [CCScene node];
	Result *layer = [Result node];
	[scene addChild: layer];
	
	return scene;
}

-(id)init
{
	if( (self = [super init]) )
	{
//		if( !Net.isMulti )

		_Rank = [self RankSet:g_Score];
		
		if( Net.isMulti )
			_MultiRank = [self RankSet:Net.m_Score];
		
		[self CreateSprite];
		
		if( !Net.isMulti )
		{
			[self LabelCreate:g_Perfact pos:ccp(100,120)];
			[self LabelCreate:g_Cool pos:ccp(100,80)];
			[self LabelCreate:g_Miss pos:ccp(100,40)];
			[self LabelCreate:g_MaxCombo pos:ccp(380,120)];
		}		

		Net.isMulti = YES;
		_Value  = 0;
		_MultiValue = 0;
		
		_SingleCheck = _MultiCheck = NO;
		
		[self schedule:@selector(ScoreLabel)];
		if( Net.isMulti )
		{
			[self schedule:@selector(MultiScoreLabel)];
			[self schedule:@selector(ResultScreen)];
		}
		//현재 스코어.
		//지금은 싱글 멀티 상관없이 그냥 일정위치에 점수만 띄우는것으로 되어있지만
		//멀티플레이시에는 살짝 바꾸던가 해야한다.
		
		//멀티플레이 시에는 스코어 라벨,
		//즉 위에것을 2개를 만들어서 한곳은 싱글, 한곳을 멀티 형식으로 바꿔야 할듯싶다.
		
		[[SimpleAudioEngine sharedEngine] playEffect:@"Score.mp3"];
 	}
	
	return self;
}

-(void)ResultScreen
{
	if(  _SingleCheck == YES && _MultiCheck == YES )
	{
		CCSprite *sprite = (CCSprite*)[self getChildByTag:Res_Winlose];
		
		sprite.visible = YES;
		
		[sprite runAction:
		 [CCSpawn actions:
		  [CCScaleTo actionWithDuration:0.5f scale:1.0f],
		  [CCFadeIn actionWithDuration:0.5f],
		  nil]];

		self.isTouchEnabled				= YES;
		[self unschedule:@selector(ResultScreen)];
	}
}

-(NSInteger)RankSet:(NSInteger)Score
{
	NSInteger TotalNote = (g_Perfact + g_Cool + g_Miss);
	
	if( !isPlaying )
		return Rank_D;
	
	if( ((TotalNote * 500) - 6000) <= Score ) // 올 퍼펙 시에 점수.
		return Rank_A;
	
	else if( ((TotalNote * 500) - 10000) <= Score )
		return Rank_B;
	
	else if( ((TotalNote * 500) - 20000) <= Score )
		return Rank_C;
	
	else
		return Rank_D;
}

-(void)CreateSprite
{
	//싱글 랭크이다.
	//멀티 플레이시를 대비해서 변수하나를 더 만들어 둬야한다.
	
	NSString *str;
	
	if( !Net.isMulti )
		str = Single;
	else
		str = Multi;
	
	CCSprite *Rank						= [CCSprite spriteWithFile:@"rank.png"
												 rect:CGRectMake( 42*_Rank, 0, 42, 58)];
	
	if( Net.isMulti )
	{
		CCSprite *MultiRank				= [CCSprite spriteWithTexture:Rank.texture rect:
										   CGRectMake(42*_MultiRank, 0, 42, 58)];
		
		MultiRank.position				= ccp(425,135);
		[MultiRank setScale:1.5f];
		[MultiRank setOpacity:0];
		
		[MultiRank runAction:
		 [CCSpawn actions:
		  [CCFadeIn  actionWithDuration:0.5f],
		  [CCScaleTo actionWithDuration:0.5f scale:1.0f],
		  nil]];
		
		[self addChild:MultiRank z:Res_MultiRank tag:Res_MultiRank];
		
		CCSprite *isWin					= [CCSprite spriteWithFile:@"wl.png" rect:
										   CGRectMake(0, 185 * (g_Score < Net.m_Score), 280, 185)];
		
		[isWin setPosition:ccp(240, 160)];

		isWin.visible = NO;
		isWin.opacity = 0;
		[isWin setScale:1.5f];
		//그림이 커서 프레임 하락
		
//		[isWin runAction:
//		 [CCSpawn actions:
//		  [CCScaleTo actionWithDuration:0.5f scale:1.0f],
//		  [CCFadeIn actionWithDuration:0.5f],nil]];
		
		[self addChild:isWin z:Res_Winlose tag:Res_Winlose];
	}
	
	CCSprite *BackGroundSprite			= [CCSprite spriteWithFile:@"result2.png"];
	CCSprite *CheckBackSprite           = [CCSprite spriteWithFile:@"result1.png"];
	CCSprite *MusicalNote               = [CCSprite spriteWithFile:@"result3.png"];

	
	CCSprite *ResultInterface           = [CCSprite spriteWithFile:str];
	
	CCSprite *Speaker					= [CCSprite spriteWithFile:@"result5.png"];
	CCSprite *LightEffect				= [CCSprite spriteWithFile:@"light.png"];
	
	BackGroundSprite.anchorPoint	= CGPointZero;
	CheckBackSprite.anchorPoint		= CGPointZero;
	
	BackGroundSprite.position		= ccp(0,0);
	CheckBackSprite.position		= ccp(0,0);
	ResultInterface.position		= ccp(240,160);
	Speaker.position				= ccp(240,130);
	LightEffect.position			= ccp(240,232);
	
	Rank.position					= ccp(107,175);

	if( Net.isMulti )
		Rank.position				= ccp(107,135);
	
	/*
	 현재 싱클랭크로 되어있다.
	 멀티랭크도 따로 만들어서 좌표를 설정을 해주던가 해야한다.
	 멀티플시엔 물론 싱글랭크도 바꿔야 한다.
	 */
	
	MusicalNote.position  = ccp(0,320);

	[MusicalNote runAction:
	 [CCRepeatForever actionWithAction:
	  [CCSequence actions:
	  [CCJumpBy actionWithDuration:10 position:ccp(480,-320) height:50 jumps:5],
	   [CCJumpBy actionWithDuration:10 position:ccp(-480, 320) height:50 jumps:5],
	   nil]]
	 ];
	
	[Rank setScale:1.5f];
	[Rank setOpacity:0];

	[Rank runAction:
	 [CCSpawn actions:
	  [CCFadeIn  actionWithDuration:0.5f],
	  [CCScaleTo actionWithDuration:0.5f scale:1.0f],
	  nil]];
	
	[Speaker runAction:
	 [CCRepeatForever actionWithAction:
	  [CCSequence actions:
	   [CCScaleTo actionWithDuration:0.2f scale:1.1f],
	   [CCScaleTo actionWithDuration:0.2f scale:1.0f],nil]]];
	
	[LightEffect runAction:
	 [CCRepeatForever actionWithAction:
	  [CCSequence actions:
	   [CCScaleTo actionWithDuration:0.3f scale:2.5f],
	   [CCScaleTo actionWithDuration:0.3f scale:1.0f],
	   nil]]];

	//태그가 싱글랭크로 되어있다.
	//멀티 랭크 태그도 만들어줘야 할것이다.
	[self addChild:Rank z:Res_Rank tag:Res_Rank];
	
	[self addChild:LightEffect z:Res_Interface tag:Res_Interface];
	[self addChild:ResultInterface z:Res_Interface tag:Res_Interface];
	[self addChild:Speaker z:Res_Interface+1 tag:Res_Interface];
	[self addChild:BackGroundSprite z:Res_Glass       tag:Res_Glass];
	[self addChild:CheckBackSprite z:Res_Check       tag:Res_Check];
	[self addChild:MusicalNote z:Res_MusicalNote tag:Res_MusicalNote];	
}

-(void)labelRemove:(CCNode*)node labelAtlas:(CCLabelAtlas*)label
{
	[self removeChild:label cleanup:YES];
}

-(void)LabelCreate:(NSInteger)Value pos:(CGPoint)pos
{
	NSString *str	= [NSString stringWithFormat:@"%d", Value];
	
	CCLabelAtlas *Label = [CCLabelAtlas labelWithString:str 
												 charMapFile:@"Resultnumber.png" 
												   itemWidth:15 
												  itemHeight:30 
												startCharMap:'0'];
	
	Label.anchorPoint = CGPointZero;
	
	[Label setPosition:pos];
	
	[self addChild:Label z:Res_Interface+2 tag:Res_Label];
}

-(void)ScoreLabel
{		
	if( (_Value+=8321) >= g_Score )
	{
		_Value = g_Score;
		[self unschedule:@selector(ScoreLabel)];
		
		if( Net.isMulti )
			_SingleCheck = YES;
		
		else
			self.isTouchEnabled	= YES;
	}
	
	NSString *str	= [NSString stringWithFormat:@"%d", _Value];
	
	CCLabelAtlas *Label = [CCLabelAtlas labelWithString:str 
												 charMapFile:@"Resultnumber.png" 
												   itemWidth:15 
												  itemHeight:30 
												startCharMap:'0'];
	
	Label.anchorPoint = CGPointZero;
	
	[Label setPosition:ccp(360,30)];
	
	if( Net.isMulti )
		[Label setPosition:ccp(30,30)];

	[self addChild:Label z:Res_Interface+2 tag:Res_Label];

	if( g_Score != _Value )
	[Label runAction:
	 [CCSequence actions:
	  [CCDelayTime actionWithDuration:0.01f],
	 [CCCallFuncND actionWithTarget:self selector:@selector(labelRemove:labelAtlas:) data:(void*)Label]
	  ,nil]];
}

-(void)MultiScoreLabel
{		
	if( (_MultiValue+=8321) >= Net.m_Score )
	{
		NSLog(@"뭥욍무엉잉");
		
		_MultiValue = Net.m_Score;
		[self unschedule:@selector(MultiScoreLabel)];
		_MultiCheck = YES;
	}
	
	NSString *str	= [NSString stringWithFormat:@"%d", _MultiValue];
	
	CCLabelAtlas *Label = [CCLabelAtlas labelWithString:str 
												 charMapFile:@"Resultnumber.png" 
												   itemWidth:15 
												  itemHeight:30 
												startCharMap:'0'];
	
	Label.anchorPoint = CGPointZero;
	
	[Label setPosition:ccp(360,30)];
		
	[self addChild:Label z:Res_Interface+2 tag:Res_Label];
	
	if( Net.m_Score != _MultiValue )
		[Label runAction:
		 [CCSequence actions:
		  [CCDelayTime actionWithDuration:0.01f],
		  [CCCallFuncND actionWithTarget:self selector:@selector(labelRemove:labelAtlas:) data:(void*)Label]
		  ,nil]];
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[[SimpleAudioEngine sharedEngine] playEffect:@"01.mp3"];
	
	if( Net.isMulti )
		[[CCDirector sharedDirector] pushScene:[Menu scene]];
	else
	[[CCDirector sharedDirector] pushScene:[MusicSelect scene]];
}

-(void)dealloc
{
	[self removeChildByTag:Res_Rank cleanup:YES];
	[self removeChildByTag:Res_Label cleanup:YES];
	[self removeChildByTag:Res_Interface cleanup:YES];
	[self removeChildByTag:Res_Check cleanup:YES];
	[self removeChildByTag:Res_Glass cleanup:YES];
	[self removeChildByTag:Res_MusicalNote cleanup:YES];
	[self removeChildByTag:Res_Winlose cleanup:YES];
	
	if( Net.isMulti ){
		[self removeChildByTag:Res_MultiRank cleanup:YES];
		Net.isMulti = NO;
	}
	
	[super dealloc];
}


@end
