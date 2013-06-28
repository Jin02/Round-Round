//
//  Creator.m
//  ProJect
//
//  Created by roden on 10. 6. 15..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Creator.h"
#import "Menu.h"
#import "Enum.h"


@implementation Creator

+(id) scene
{
	CCScene *scene = [CCScene node];
	Creator *layer = [Creator node];
	[scene addChild: layer];
	
	return scene;
}

-(id)init
{
	if( (self = [super init]) )
	{
		CCSprite *BackGround = [CCSprite spriteWithFile:@"Creator1.png"];
		BackGround.anchorPoint = CGPointZero;
		BackGround.position = CGPointZero;
		BackGround.opacity = 0;
		[BackGround runAction:[CCFadeIn actionWithDuration:0.5f]];
		
		[self addChild:BackGround z:tag_BackGround tag:tag_BackGround];
		
		self.isTouchEnabled = YES;
	}
	
	return self;
}

-(void)NextScene
{
	[[CCDirector sharedDirector] pushScene:[Menu scene]];
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.isTouchEnabled = NO;
	
	id FadeOut = [CCFadeOut actionWithDuration:0.5f];
	
	CCSprite *sprite = (CCSprite*)[self getChildByTag:tag_BackGround];
	[sprite runAction:[CCSequence actions:FadeOut
					   ,[CCCallFunc actionWithTarget:self selector:@selector(NextScene)],nil]];
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"01.mp3"];
}

-(void)dealloc
{
	[self removeAllChildrenWithCleanup:YES];
	[super dealloc];
}

@end
