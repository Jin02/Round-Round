//
//  Menu.h
//  ProJect
//
//  Created by roden on 10. 6. 8..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
//#import "SimpleAudioEngine.h"
//#import "CDAudioManager.h"
//#import "CocosDenshion.h"

//현재 멀티플레이 버튼을 눌러주면 넷을 생성시켜주고 있는데
//뒤로가기 버튼을 누른다면 다시 해제되도록 구현을 해줘야한다.

@interface Menu : CCScene  {

	CCSprite			*_BackGround;
	CCSprite			*_title;
	CCSprite			*_loading;
	
	CCMenuItem			*_SinglePlay;
	CCMenuItem			*_MultiPlay;
	CCMenuItem			*_Help;
	CCMenuItem			*_Credit;
		
	BOOL				_ButtonCheck;
}


+(id) scene;
-(void)ButtonInActions;
-(void)SoundNewLoadWithPath:(NSString*)path;

@end