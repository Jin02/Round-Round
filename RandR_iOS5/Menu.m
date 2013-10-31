//
//  Menu.m
//  ProJect
//
//  Created by roden on 10. 6. 8..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Menu.h"
#import "Enum.h"
#import "MusicSelect.h"
#import "GlobalExtern.h"
#import "MusicSelectString.h"
#import "Game.h"
#import "Help.h"
#import "Creator.h"

@implementation Menu

+(id) scene
{
	CCScene *scene = [CCScene node];
	Menu *layer = [Menu node];
	[scene addChild: layer];
	
	return scene;
}

-(id)init
{
	if( (self = [super init]) )
	{
		_BackGround = [CCSprite spriteWithFile:@"Default.png"];
		[_BackGround setRotation:270.0f];
		[_BackGround setPosition:ccp(240,160)];
		_BackGround.opacity = 0;
		
		[_BackGround runAction:[CCFadeIn actionWithDuration:0.4f]];
		
		_loading = [CCSprite spriteWithFile:@"loading.png"];
		_loading.position = ccp( 240, 420);
		
		_title = [[CCSprite alloc] initWithFile:@"Title.png"];
		[_title setPosition:ccp(240,420)];
		
		[_title runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(240,240)]];
		[self performSelector:@selector(titleActions) withObject:nil afterDelay:0.51f];
		
		_SinglePlay = [CCMenuItemImage itemFromNormalImage:@"sp.png" 
											 selectedImage:@"sp.png" 
													target:self 
												  selector:@selector(SinglePlay:)];
		
		_MultiPlay	= [CCMenuItemImage itemFromNormalImage:@"multi.png" 
											 selectedImage:@"multi.png"
												   target:self 
												 selector:@selector(MultiPlay:)];
		
		_Help		= [CCMenuItemImage itemFromNormalImage:@"help.png" 
											 selectedImage:@"help.png" 
											   target:self 
											 selector:@selector(Help:)];
		
		_Credit		= [CCMenuItemImage itemFromNormalImage:@"creator.png"
										  selectedImage:@"creator.png"
												 target:self
											   selector:@selector(Credit:)];
		
		
		_SinglePlay.anchorPoint	= ccp(0, 0.5f);
		_MultiPlay.anchorPoint	= ccp(0, 0.5f);
		_Help.anchorPoint		= ccp(1.0f,0.5f);
		_Credit.anchorPoint		= ccp(1.0f,0.5f);
		
		_SinglePlay.position	= ccp(-440, 130);
		_MultiPlay.position		= ccp(-440, 50);
		_Credit.position		= ccp(840, 130);
		_Help.position			= ccp(840, 50);
		
		[self ButtonInActions];
		_ButtonCheck = NO;
		
        CCMenu	*menu = [CCMenu menuWithItems:_SinglePlay, _MultiPlay, _Help, _Credit, nil];
        menu.anchorPoint = ccp(0, 0);
        menu.position = ccp(0, 0);

		[self addChild:_loading z:tag_BackGround+1 tag:tag_BackGround];
		[self addChild:menu z:tag_Interface + 10 tag:tag_Interface];
		[self addChild:_title  z:tag_BackGround+1 tag:tag_BackGround];
		[self addChild:_BackGround z:tag_BackGround tag:tag_BackGround];
		
		[self SoundNewLoadWithPath:@"01.mp3"];
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Hip Hop.mp3"];
	}
	
	return self;
}

-(void)titleActions
{
	[_title runAction:
	 [CCRepeatForever actionWithAction:
	  [CCSequence actions:
	   [CCScaleTo actionWithDuration:0.2f scale:1.1f],
	   [CCScaleTo actionWithDuration:0.2f scale:1.0f],nil]]];
}

-(void)ButtonInActions
{
	[_SinglePlay runAction:
	 [CCMoveTo actionWithDuration:0.5f position:ccp(0, 130)]];
	 
	[_MultiPlay runAction:
	 [CCMoveTo actionWithDuration:0.5f position:ccp(0, 50)]];
	  
	[_Credit runAction:
	   [CCMoveTo actionWithDuration:0.5f position:ccp(480,130)]];
	
	[_Help runAction:
	 [CCMoveTo actionWithDuration:0.5f position:ccp(480,50)]];
	
	_ButtonCheck = NO;
}

-(void)ButtonOutActions
{
	[_SinglePlay runAction:
	 [CCMoveTo actionWithDuration:0.3f position:ccp(-440,130)]];
	
	[_MultiPlay runAction:
	 [CCMoveTo actionWithDuration:0.3f position:ccp(-440,50)]];
	
	[_Credit runAction:
	 [CCMoveTo actionWithDuration:0.3f position:ccp(840,130)]];
	
	[_Help runAction:
	 [CCMoveTo actionWithDuration:0.3f position:ccp(840,50)]];
	
	_ButtonCheck = YES;
}

-(void)GameStart
{
	[[CCDirector sharedDirector] pushScene:[MusicSelect scene]];
}

-(void)LoadingActions
{
	[_title runAction:[CCMoveTo actionWithDuration:0.4f position:ccp(240,420)]];
	[_loading runAction:[CCMoveTo actionWithDuration:0.4f position:ccp(240,240)]];
}

-(void)SinglePlay:(id)sender
{
	[[SimpleAudioEngine sharedEngine] playEffect:@"01.mp3"];
	
	if( !_ButtonCheck )
	{
		[self ButtonOutActions];
		[self LoadingActions];
		[self performSelector:@selector(GameStart) withObject:nil afterDelay:0.5f];
		
		[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	}
}

-(void)MultiPlay:(id)sender
{	
	[[SimpleAudioEngine sharedEngine] playEffect:@"01.mp3"];
	
	if( !_ButtonCheck )
	{
		[self ButtonOutActions];
		_ButtonCheck = NO;
		
		Net = [[NetWork alloc] init];
		Net.isMulti = YES;

		//Net.m_isFirstReceive = YES;
		
		[self LoadingActions];
		[self performSelector:@selector(GameStart) withObject:nil afterDelay:0.5f];
		
		[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	}
	
}

-(void)Help:(id)sender
{
	[[SimpleAudioEngine sharedEngine] playEffect:@"01.mp3"];
	
	if( !_ButtonCheck )
	{
		[self ButtonOutActions];
		[[CCDirector sharedDirector] pushScene:[Help scene]];
	}
}

-(void)Credit:(id)sender
{
	[[SimpleAudioEngine sharedEngine] playEffect:@"01.mp3"];
	
	if( !_ButtonCheck )
	{
		[self ButtonOutActions];
		[[CCDirector sharedDirector] pushScene:[Creator scene]];
	}
}
 

-(void)SoundNewLoadWithPath:(NSString*)path
{
	ALuint EffectValue = [[SimpleAudioEngine sharedEngine] playEffect:path];
	[[SimpleAudioEngine sharedEngine] stopEffect:EffectValue];
}

-(void)dealloc
{
	[self removeChildByTag:tag_Interface cleanup:YES];
	[self removeChildByTag:tag_BackGround cleanup:YES];
	[super dealloc];
}

@end
