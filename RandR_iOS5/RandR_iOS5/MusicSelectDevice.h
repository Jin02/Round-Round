//
//  MusicSelectDevice.h
//  ProJect
//
//  Created by roden on 10. 6. 2..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "MusicSelect.h"
#import "GlobalExtern.h"

@class MusicSelect;

@interface MusicSelectDevice : CCLayer {

	MusicSelect *_MusicSelect;
	
	CGPoint		_MusicSelectPos;
	BOOL		_Redundancy;
}

@property(readwrite)BOOL Redundancy;

-(id)initWithScene:(MusicSelect*)scene;
-(CGPoint)glPoint:(NSSet*)touches;
-(int)TwoPoint:(CGPoint)Point_1 Point_2:(CGPoint)Point_2;
-(BOOL)CircleCrashCheck:(CGPoint)touchPoint Circle:(CGPoint)Circle r:(float)r;

@end
