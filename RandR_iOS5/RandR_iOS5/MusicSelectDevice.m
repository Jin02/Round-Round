//
//  MusicSelectDevice.m
//  ProJect
//
//  Created by roden on 10. 6. 2..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MusicSelectDevice.h"
#import "MusicSelect.h"

#define POS CGPoint pos = [self glPoint:touches]

@implementation MusicSelectDevice

@synthesize Redundancy = _Redundancy;

-(id)initWithScene:(MusicSelect*)scene
{
	if( (self = [super init]) )
	{
		_MusicSelect = scene;
		
		_Redundancy		= NO;
		_MusicSelectPos = CGPointZero;
		
		
		NSLog(@"터치 초기화 됨");
		
		[self performSelector:@selector(StartTouch) withObject:nil afterDelay:1.5f];
	}
	
	return self;
}

-(void)StartTouch
{
	self.isTouchEnabled				= YES;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	POS;
	
	NSLog(@"Begin Touch Pos %f %f", pos.x, pos.y);
	
	_MusicSelectPos = pos;
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	POS;
	
	if( ((75 <= pos.y && pos.y <= 240) && (280 <= pos.x && pos.x <= 440)) && (_Redundancy == NO))
	{
		[_MusicSelect albumSelect];
		_Redundancy = YES;
	}
		
	
	_MusicSelectPos = CGPointZero;
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	POS;
	
	if( pos.y-30 > _MusicSelectPos.y && _Redundancy == NO)
	{
		_Redundancy = YES;
		[_MusicSelect albumDown];
		_MusicSelectPos = pos;
	}
	
	else if( pos.y+30 < _MusicSelectPos.y && _Redundancy == NO)
	{
		_Redundancy = YES;
		[_MusicSelect albumUp];
		_MusicSelectPos = pos;
	}
	
	
}

-(void)ccTouchesCancelles:(NSSet *)touches withEvent:(UIEvent *)event
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
