/*
 *  Enum.h
 *  ProJect
 *
 *  Created by roden on 10. 5. 11..
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

enum tag
{
	tag_Device,
	tag_BackGround,
	tag_SpaceBackGround,
	tag_Interface,
	tag_Song,
	tag_Circle,
	tag_NoteSheet,
	tag_ComboSpriteSheet,
	tag_ComboSprite,
	tag_ComboNumberAtlas,
	tag_DecisionString,
	tag_Note,
	tag_Label,
	tag_Fade,
	tag_GageBar,
	tag_GameOver,
	tag_MultiPlayResult,
	tag_Effect = 500
};

enum Decision {
	tag_Perfact,
	tag_Cool,
	tag_Bad,
	tag_Miss
};

enum NoteEnum
{
	Note_LeftUp,
	Note_LeftDown,
	Note_RightUp,
	Note_RightDown,
	Note_LeftRound,
	Note_RightRound
};

enum TouchDirection
{
	NOT,
	ROUND,
	LEFT,
	RIGHT
};