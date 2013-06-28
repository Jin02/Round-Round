//
//  NetWork.m
//  ProJect
//
//  Created by roden on 10. 5. 17..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NetWork.h"


@implementation NetWork

@synthesize isMultiPlay = m_isMultiPlay,m_Session,isReceive = m_isReceive,m_Score,m_isFirstReceive;
@synthesize isPause = m_isPause;
@synthesize isMulti = m_isMulti;

-(id)init
{
	if( (self = [super init]) )
	{
		m_isFirstReceive = YES;
		m_isPause = NO;
		m_isMulti = NO;
	}
	
	return self;
}


-(void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
	NSString * str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	NSLog(@"리시브 옴");
	
	if( m_isFirstReceive )
	{
		NSLog(@"MUSIC NAME %@", str);
//		MusicName2 = [NSString stringWithString:str];
		MusicName2 = [[NSString alloc] initWithString:str];
		
		m_isFirstReceive = NO;
	}
	else
		m_Score = [str intValue];
	
	m_isReceive = YES;
	
	[str release];
}

-(void)FindButton
{
	GKPeerPickerController *picker = [[GKPeerPickerController alloc] init];
	picker.delegate = self;
	picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;

	[picker show];
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *) session
{
	NSLog(@"여기 들어옴 여기 들어옴 여기 들어옴");
	
	m_Session = session;
	m_Session.delegate = self;
	[m_Session retain];
	
	[session setDataReceiveHandler:self withContext:nil];
//	picker.delegate = nil;
	
	[picker dismiss];
	picker.delegate = nil;
	[picker autorelease];
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
	NSLog(@"캔슬");
	m_isMultiPlay = NO;
	m_isPause = YES;
	
	picker.delegate = nil;
	[picker autorelease];
	
}

-(void)mySendData:(NSData*)data
{
	[m_Session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
	NSLog(@"연결상태");
	
	switch (state) {
		case GKPeerStateConnected:
			NSLog(@"연결완료");
			m_isMultiPlay = YES;
			break;
		case GKPeerStateDisconnected:
			NSLog(@"연결이 해제 되었습니다");
			break;

		default:
			break;
	}
}

-(void)dealloc
{
	[super dealloc];
}

@end
