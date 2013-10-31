//
//  TouchHandle.h
//  ProJect
//
//  Created by roden on 10. 5. 11..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@class Game;

@interface DeviceHandle : CCLayer {

	Game				*m_GameScene;
	CGPoint				m_TouchPoint;
	
}

@property(nonatomic, readwrite) CGPoint				m_TouchPoint;

-(id)initWithGame:(Game*)scene;
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)ccTouchesCancelles:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration;

-(CGPoint)glPoint:(NSSet*)touches;
-(int)TwoPoint:(CGPoint)Point_1 Point_2:(CGPoint)Point_2;
-(BOOL)CircleCrashCheck:(CGPoint)touchPoint Circle:(CGPoint)Circle r:(float)r;

@end
