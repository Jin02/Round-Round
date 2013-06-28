//
//  Interface.m
//  ProJect
//
//  Created by roden on 10. 5. 11..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Interface.h"
#import "Game.h"
#import "Enum.h"
#import "GlobalExtern.h"
#import "CCGrid.h"
#import "SimpleAudioEngine.h"

@implementation Interface

@synthesize m_Circle;
@synthesize life = _height;

#pragma mark init



-(id)initWithGame:(Game*)scene
{
	if( (self = [super init]) )
	{
		m_GameScene = scene;
		
		_height		= 280.0f;
		
		[self SpriteCreate];
		
		[self schedule:@selector(GageBarStep)];
		
		if( Net.isMulti ) [self schedule:@selector(MultiMessage) interval:1.0f];
	}
	
	return self;
}

-(void)MultiPosition
{
	CCSprite		*sprite = (CCSprite*)[self getChildByTag:tag_MultiPlayResult];
	[sprite setPosition:ccp(-200,280)];
}

-(void)MultiMessage
{
	static int count = 0;

	NSLog(@"Count %d", count);
	
	//[Net mySendData:[[NSString stringWithFormat:@"%d",m_GameScene.m_Score] dataUsingEncoding:NSASCIIStringEncoding]];
	
	if( (++count) >= 10 )
	{
		NSLog(@"Connected!");
		
		NSLog(@"Em %d", Net.m_Score);
		
		CCSprite		*sprite = (CCSprite*)[self getChildByTag:tag_MultiPlayResult];

		[sprite setTextureRect:CGRectMake(0, 
										  98*( (Net.m_Score > m_GameScene.m_Score) + ((Net.m_Score == m_GameScene.m_Score)*2) ), 
										  361, 
										  98)];
		
		
		[sprite runAction:
		 [CCSequence actions:
		 [CCMoveTo actionWithDuration:0.5f position:ccp(240,280)],
		  [CCDelayTime actionWithDuration:1.0f],
		  [CCMoveTo actionWithDuration:0.5f position:ccp(600,280)],
		  [CCCallFunc actionWithTarget:self selector:@selector(MultiPosition)],
		  nil]];		
		
		count = 0;
		Net.isReceive = NO;
		
		[[SimpleAudioEngine sharedEngine] playEffect:@"Multi.mp3"];
	}
}

-(void)GageBarStep
{
	static float Rytem		= 0.0f;
	static int	 RytemTemp	= 1;
	
	//	NSLog(@"%d",m_);
	
	if( Rytem == 10 )
		RytemTemp = -1;
	else if( Rytem == 0)
		RytemTemp = 1;
	
	Rytem+= RytemTemp;
	
	if( m_GameScene.life > _height )
		_height+=2;
	else if( m_GameScene.life < _height )
		_height-=2;
	else
	{}
	
	if( (Rytem + _height) >= 280 )
		return;
	
	[m_GageBar setTextureRect:CGRectMake(0, 0, 31, _height+Rytem)];
//	[m_GageBar setPosition:ccp(m_GageBar.position.x ,279 - (_height+Rytem))]; 뒤
//	[m_GageBar setTextureRect:CGRectMake(0, 279 - _height+Rytem , 31, 279)]; 뒤
//	[m_GageBar setPosition:ccp(m_GageBar.position.x, 160 - _height)];
//	[m_GageBar set
}

-(void)EffectRemove:(CCNode*)node Sprite:(CCSprite*)Sprite
{
	CCSpriteBatchNode *Sheet = (CCSpriteBatchNode*)[self getChildByTag:tag_Effect];
	[Sheet removeChild:Sprite cleanup:YES];
}

-(void)PlayEffect
{	
	CCSpriteBatchNode *Sheet = (CCSpriteBatchNode*)[self getChildByTag:tag_Effect];
	CCSprite      *Sprite = [CCSprite spriteWithTexture:Sheet.texture];
	
	[Sprite setPosition:ccp(240,47)];
	[Sprite setScale:0.4f];
	
	[Sheet addChild:Sprite z:tag_Effect tag:tag_Effect];
	
	id ScaleTo = [CCScaleTo actionWithDuration:0.15f scale:1.5f];
	id FadeIn = [CCFadeIn actionWithDuration:0.15];
	id FadeOut = [CCFadeOut actionWithDuration:0.1f];
	id CCC = [CCCallFuncND actionWithTarget:self selector:@selector(EffectRemove: Sprite:) data:(void*)Sprite];
	
	[Sprite runAction:
	 [CCSequence actions:
	  [CCSpawn actions:ScaleTo, FadeIn, nil],
	  FadeOut,CCC,nil
	  ]];
}

-(void)SpriteCreate
{	
	m_Circle = [[CCSprite alloc] initWithFile:@"Circle.png"];	
	[m_Circle setPosition:ccp(240,160)];
	
	m_Decision = [CCSprite spriteWithFile:@"decision.png"];
	m_Decision.position = ccp(240,47);
	
	m_GageBar = [[CCSprite alloc] initWithFile:@"gage.png"];
	m_GageBar.anchorPoint = CGPointZero;
	m_GageBar.position    = ccp(440,20);
//	m_GageBar.position    = ccp(456,160);
//	m_GageBar.position    = ccp(471,295);
//	[m_GageBar setRotation:180.0f];
	
	/*
	 게이지바를 정상적으로 움직이게 하려고 하는데
	 아까 전까지 해본 방법은 게이지바가 거꾸로 움직인다...
	 
	 이걸 약간 손보면 될거 같다.
	 */
	
	CCSprite *GageBack = [CCSprite spriteWithFile:@"gg.png"];
//	GageBack.anchorPoint = CGPointZero;
	GageBack.position	 = ccp(456,160);
	
	CCSpriteBatchNode *Sheet = [CCSpriteBatchNode batchNodeWithFile:@"combo.png" capacity: 10];
	CCSpriteBatchNode *Sheet2 = [CCSpriteBatchNode batchNodeWithFile:@"DecisionString.png" capacity:10];
	CCSpriteBatchNode *Sheet3 = [CCSpriteBatchNode batchNodeWithFile:@"efect1.png" capacity: 10];
	
	CCSprite	  *MultiResult = [CCSprite spriteWithFile:@"wls.png"];
	[MultiResult setPosition:ccp(-200,280)];
	
	_GameOver = [CCSprite spriteWithFile:@"GameOver.png"];
	_GameOver.visible = NO;
//	[_GameOver setPosition:ccp(240,200)];
	[_GameOver setPosition:ccp(240,400)];
	
	[m_GameScene addChild:_GameOver z:500 tag:tag_GameOver];
	[self addChild:MultiResult z:tag_Effect tag:tag_MultiPlayResult];
	[self addChild:GageBack z:tag_GageBar-1 tag:tag_GageBar];
	[self addChild:m_GageBar z:tag_GageBar tag:tag_GageBar];
	[self addChild:Sheet3 z:tag_Effect tag:tag_Effect];
	[self addChild:Sheet z:tag_ComboSpriteSheet tag:tag_ComboSpriteSheet];
	[self addChild:Sheet2 z:tag_DecisionString tag:tag_DecisionString];
	[self addChild:m_Circle		z:tag_Circle	tag:tag_Circle];
	[self addChild:m_Decision   z:tag_Circle+1  tag:tag_BackGround];

}

-(void)labelRemove:(CCNode*)node labelAtlas:(CCLabelAtlas*)label
{
	[self removeChild:label cleanup:YES];
}

-(void)DecisionDisPlayRemove:(CCNode*)node sprite:(CCSprite*)sprite
{
	CCSpriteBatchNode *Sheet = (CCSpriteBatchNode*)[self getChildByTag:tag_DecisionString];
	[Sheet removeChild:sprite cleanup:YES];
}

-(void)comboSpriteRemove:(CCNode*)node sprite:(CCSprite*)sprite
{
	CCSpriteBatchNode *Sheet = (CCSpriteBatchNode*)[self getChildByTag:tag_ComboSpriteSheet];
	[Sheet removeChild:sprite cleanup:YES];
}

-(void)DecisionDisPlay:(NSInteger)tag
{
	CCSpriteBatchNode	*Sheet = (CCSpriteBatchNode*)[self getChildByTag:tag_DecisionString];
	CCSprite		*Sprite = [CCSprite spriteWithTexture:Sheet.texture rect:CGRectMake(tag*90, 0, 90, 42)];
	[Sprite setPosition:ccp(240,90)];
	
	[Sheet addChild:Sprite z:tag_DecisionString tag:tag_DecisionString];
	
	id ScaleUp = [CCScaleTo actionWithDuration:0.3f scale:1.8f];
	id ScaleDown = [CCScaleTo actionWithDuration:0.3f scale:0.0f];
	
	[Sprite runAction:[CCSequence actions:ScaleUp,ScaleDown,
					   [CCCallFuncND actionWithTarget:self selector:@selector(DecisionDisPlayRemove:sprite:) data:(void*)Sprite],nil]];
}

-(void)ComboDisPlay:(NSInteger)Combo
{
	int ComboSelect = 0 ;
	
	if(Combo < 90)
		ComboSelect = Combo/30;
	else {
		ComboSelect = 2;
	}
	
	if( (Combo % 30) == 0 )
		[[SimpleAudioEngine sharedEngine] playEffect:@"Combo.mp3"];
	
	if(Combo <= 1)
		return;
	
	//스프라이트에서 직접 파일에서 가져오는거보다
	//시트에서 가져오는거 차라리 이득일거같아서 이짓거리 했음여
	
	CCSpriteBatchNode *Sheet = (CCSpriteBatchNode*)[self getChildByTag:tag_ComboSpriteSheet];	
	CCSprite *Sprite = [CCSprite spriteWithTexture:Sheet.texture rect:CGRectMake(0, 50*ComboSelect, 90, 50)];
 	Sprite.position = ccp(240,190);
	
	[Sheet addChild:Sprite z:tag_ComboSprite tag:tag_ComboSprite];

	id ScaleUp = [CCScaleTo actionWithDuration:0.3f scale:1.5f];
	id ScaleDown = [CCScaleTo actionWithDuration:0.3f scale:0.0f];
	
	[Sprite runAction:[CCSequence actions:ScaleUp,ScaleDown,
					   [CCCallFuncND actionWithTarget:self selector:@selector(comboSpriteRemove:sprite:) data:(void*)Sprite],nil]];
	
	NSString *str = [NSString stringWithFormat:@"%d",Combo];
    
    CCLabelAtlas *comboLabel = [CCLabelAtlas labelWithString:str charMapFile:@"number.png" itemWidth:30 itemHeight:60 startCharMap:'0'];
	
	comboLabel.position = ccp(225 - (10*(Combo >= 10)) - (15*((Combo >= 100))),100);
	[self addChild:comboLabel z:tag_ComboNumberAtlas tag:tag_ComboNumberAtlas];
	
	[comboLabel runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.6f scale:1.0f],
						   [CCCallFuncND actionWithTarget:self selector:@selector(labelRemove:labelAtlas:) data:(void*)comboLabel],
						   nil]];
}

-(void)GameOverActions
{
	_GameOver.visible = YES;
	[_GameOver runAction:
	 [CCMoveTo actionWithDuration:1.0f position:ccp(240,230)]];
}

-(void)YourScoreDisPlay:(NSInteger)Score
{	
/*	NSString *str = [NSString stringWithFormat:@"%d",Score];
	[m_YourScore setString:str];*/
}

#pragma mark -

-(void)dealloc
{
/*
	[self removeChildByTag:tag_DecisionString cleanup:YES];
	[self removeChildByTag:tag_ComboSpriteSheet cleanup:YES];
	[self removeChildByTag:tag_Effect cleanup:YES];
	[self removeChildByTag:tag_GageBar cleanup:YES];
	[self removeChildByTag:tag_Circle cleanup:YES];
	[self removeChildByTag:tag_BackGround cleanup:YES];
	[self removeChildByTag:tag_Fade cleanup:YES];
 */
	
	[self removeAllChildrenWithCleanup:YES];
//	[m_MyScore release];
	//[m_Decision release];
	//[m_GageBar release];

//	if( Net.m_isMultiPlay )
//		[m_YourScore release];

//	[m_Circle release];
	
	[super dealloc];
}

@end
