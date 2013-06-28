//
//  TouchHandle.m
//  ProJect
//
//  Created by roden on 10. 5. 11..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DeviceHandle.h"
#import "Game.h"
#import "Enum.h"

#define POS CGPoint pos = [self glPoint:touches]

@implementation DeviceHandle

@synthesize m_TouchPoint;

-(id)initWithGame:(Game*)scene
{
	if( (self = [super init]) )
	{
		self.isTouchEnabled				= YES;
//		self.isAccelerometerEnabled		= YES;
		
		m_GameScene						= scene;
		
		m_TouchPoint					= ccp(0, 0);

	}
	
	return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	POS;
	
	NSLog(@"Begin Touch Pos %f %f", pos.x, pos.y);
	
	if( [self CircleCrashCheck:pos Circle:ccp(240,160) r:160] && ![self CircleCrashCheck:pos Circle:ccp(240,160) r:65] )
	{
		
		//왼쪽 터치가 되면 어떤 값을 왼쪽으로 바꾸고 무브나 엔디드에서 맞게 체크하나 확인해야 할듯 싶다.
		
		if(55 < pos.x && pos.x < 180)
			m_GameScene.m_TouchDirection = LEFT;
		else if(305 < pos.x && pos.x < 430)
			m_GameScene.m_TouchDirection = RIGHT;
		else if( 180 < pos.x && pos.x < 305 )
		{
			if( pos.y <= 120 ) m_GameScene.m_TouchDirection = ROUND;
		}
		else
			m_GameScene.m_TouchDirection = NOT;

		if(m_GameScene.m_TouchDirection != NOT)
			m_TouchPoint = pos;

	}
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	m_GameScene.m_TouchDirection = NOT;
	m_TouchPoint = ccp(0,0);
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	POS;
	static int  RoundDirCheck = NOT;

	//오른쪽 돌리기 터치가 잘 안됨
	
	if( m_GameScene.m_TouchDirection == LEFT )
	{
		if( m_TouchPoint.y > (pos.y + 35) )
			[m_GameScene NoteCheck:Note_LeftDown pos:pos];
		
		else if( m_TouchPoint.y < (pos.y - 35) )
			[m_GameScene NoteCheck:Note_LeftUp pos:pos];
		
	}
	
	else if ( m_GameScene.m_TouchDirection == RIGHT)
	{
		if( m_TouchPoint.y > (pos.y + 35) )
			[m_GameScene NoteCheck:Note_RightDown pos:pos];
		
		else if( m_TouchPoint.y < (pos.y - 35) )
			[m_GameScene NoteCheck:Note_RightUp pos:pos];
		
	}
	
	if ( m_GameScene.m_TouchDirection == ROUND )
	{
		if([self CircleCrashCheck:pos Circle:ccp(240,160) r:50])
			return;
		
		if( m_TouchPoint.y > (pos.y - 40) && RoundDirCheck == NOT)
		{
			if (m_TouchPoint.x < (pos.x) )				
			{
				NSLog(@"왼쪽");
				NSLog(@"터치 x %f, 무브 x %f",m_TouchPoint.x,pos.x);
				//어느쪽으로 갔느냐룰 정함
				RoundDirCheck = LEFT;
			}
			
			else if ( m_TouchPoint.x > (pos.x) )
			{
				NSLog(@"오른쪽");
				//어느쪽으로 갔느냐룰 정함
				RoundDirCheck = RIGHT;			
			}
		}
		
		if( RoundDirCheck != NOT )
		{			
			// y바꿈
			if (pos.y >= 240)
			{
				NSLog(@"으응?");
				
				NSInteger Note = Note_RightRound;
				
				if( RoundDirCheck == LEFT ) Note = Note_LeftRound;				
				[m_GameScene NoteCheck:Note pos:pos];

				RoundDirCheck = NOT;
			}
			
		}
			
		
	}


}

-(void)ccTouchesCancelles:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
}

-(CGPoint)glPoint:(NSSet*)touches
{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];

	return convertedLocation;
}

-(int)TwoPoint:(CGPoint)Point_1 Point_2:(CGPoint)Point_2
{
	return (int)sqrt( pow( (double)Point_1.x - Point_2.x, 2 )  + pow( (double)Point_1.y - Point_2.y, 2) );
}

-(BOOL)CircleCrashCheck:(CGPoint)touchPoint Circle:(CGPoint)Circle r:(float)r
{
	if( !(touchPoint.x > (Circle.x + r) ||  touchPoint.x < (Circle.x - r) || touchPoint.y > (Circle.y + r) || touchPoint.y < (Circle.y - r)) )
		return YES;
	
	return NO;
}

-(void)dealloc
{
	[super dealloc];
}

@end
