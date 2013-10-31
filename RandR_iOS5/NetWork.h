//
//  NetWork.h
//  ProJect
//
//  Created by roden on 10. 5. 17..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

#import "MusicSelectString.h"

@interface NetWork : NSObject<GKSessionDelegate, GKPeerPickerControllerDelegate> {

	GKSession				*m_Session;
	BOOL					m_isMultiPlay;	

	BOOL					m_isReceive;

	BOOL					m_isFirstReceive;
	NSInteger				m_Score;
	
	BOOL					m_isMulti;
	BOOL					m_isPause;
}

@property(readwrite)BOOL	isMultiPlay;
@property(nonatomic, retain)GKSession *m_Session;
@property(nonatomic,readwrite)BOOL isReceive;
@property(readonly)NSInteger m_Score;
@property(readwrite)BOOL m_isFirstReceive;
@property(readwrite)BOOL isPause;
@property(readwrite)BOOL isMulti;

-(void)FindButton;
-(void)mySendData:(NSData*)data;

@end
