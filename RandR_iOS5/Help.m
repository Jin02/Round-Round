//
//  Help.m
//  ProJect
//
//  Created by roden on 10. 6. 21..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Help.h"
#import "Menu.h"

@implementation Help

+(id) scene
{
	CCScene *scene = [CCScene node];
	Help *layer = [Help node];
	[scene addChild: layer];
	
	return scene;
}

-(id)init
{
	if( (self = [super init]) )
	{
		self.isTouchEnabled = YES;
		
		_index = 0;
		
		CCSprite *sprite = [CCSprite spriteWithFile:@"help1.png"];
		sprite.anchorPoint = CGPointZero;
		[sprite setOpacity:0];
		[self addChild:sprite z:0 tag:0];
		
		CCSprite *sprite2 = [CCSprite spriteWithFile:@"help2.png"];
		sprite2.anchorPoint = CGPointZero;
		sprite2.visible = NO;
		[self addChild:sprite2 z:0 tag:1];
		
		CCSprite *sprite3 = [CCSprite spriteWithFile:@"help3.png"];
		sprite3.anchorPoint = CGPointZero;
		sprite3.visible = NO;
		[self addChild:sprite3 z:0 tag:2];
		
		CCSprite *sprite4 = [CCSprite spriteWithFile:@"help4.png"];
		sprite4.anchorPoint = CGPointZero;
		sprite4.visible = NO;
		[self addChild:sprite4 z:0 tag:3];
		
		CCSprite *sprite5 = [CCSprite spriteWithFile:@"help5.png"];
		sprite5.anchorPoint = CGPointZero;
		sprite5.visible = NO;
		[self addChild:sprite5 z:0 tag:4];

		CCSprite *sprite6 = [CCSprite spriteWithFile:@"help6.png"];
		sprite6.anchorPoint = CGPointZero;
		sprite6.visible = NO;
		[self addChild:sprite6 z:0 tag:5];
		
		[sprite runAction:
		 [CCFadeIn actionWithDuration:1.0f]];
	}
	
	return self;
}

-(void)NextScreen
{
	CCSprite *nowSprite = (CCSprite*)[self getChildByTag:_index++];
	CCSprite *nextSprite = (CCSprite*)[self getChildByTag:_index];
	
	nowSprite.visible = NO;
	nextSprite.visible = YES;
	
	[nextSprite runAction:
	 [CCFadeIn actionWithDuration:1.0f]];
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[[SimpleAudioEngine sharedEngine] playEffect:@"01.mp3"];
	
	if( _index == 5 )
		[[CCDirector sharedDirector] pushScene:[Menu scene]];
	
	[self NextScreen];
}

-(void)dealloc
{
	[self removeAllChildrenWithCleanup:YES];
	[super dealloc];
}

@end
