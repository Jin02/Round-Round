//
//  Interface.h
//  ProJect
//
//  Created by roden on 10. 5. 11..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@class Game;

@interface Interface : CCLayer {

	Game				*m_GameScene;

	CCSprite			*m_Circle;	//화면에 놓일 원판
	CCSprite			*m_Decision;
	CCSprite			*m_GageBar;
	
	CCSprite			*_GameOver;

	CCSprite			*m_ComboSprite;
	
	float				_height;
	
//	CCLabel				*m_MyScore;
//	CCLabel				*m_YourScore;
}

@property(nonatomic, retain)CCSprite			*m_Circle;	//화면에 놓일 원판
@property(readwrite)float life;

-(id)initWithGame:(Game*)scene;

-(void)SpriteCreate;
-(void)ComboDisPlay:(NSInteger)Combo;
-(void)PlayEffect;
-(void)DecisionDisPlay:(NSInteger)tag;
-(void)GageBarStep;
-(void)MultiMessage;
-(void)GameOverActions;

@end
