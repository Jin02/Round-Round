//
//  Result.h
//  ProJect
//
//  Created by roden on 10. 5. 27..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "ResultScreenData.h"

#define Single	@"result4.png"
#define Multi	@"MultiResult.png"

enum {
	Res_Glass,
	Res_MusicalNote,
	Res_Check,
	Res_Interface,
	Res_Label,
	Res_Rank,
	Res_MultiRank,
	Res_Winlose
};

enum Rank {
	Rank_A,
	Rank_B,
	Rank_C,
	Rank_D
};

@interface Result : CCLayer {
	NSInteger		_Value;
	NSInteger		_Rank;
	
	NSInteger		_MultiValue;
	NSInteger		_MultiRank;
	CCSprite		*_isWin;
	
	BOOL			_SingleCheck;
	BOOL			_MultiCheck;
}

+(id) scene;
-(void)CreateSprite;
-(void)LabelCreate:(NSInteger)Value pos:(CGPoint)pos;
-(NSInteger)RankSet:(NSInteger)Score;

@end
