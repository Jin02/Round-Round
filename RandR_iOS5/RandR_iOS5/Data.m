//
//  RankingData.m
//  WishBubble
//
//  Created by imac07 on 10. 03. 15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Data.h"

@implementation Data

-(id)init
{
	if( (self = [super init]) )
	{

	}
	
	return self;
}

-(NSMutableArray*)DataLoadWithFilePath:(NSString*)Path
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fullFileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory,Path];
	
	NSLog(@"FullFilePath %@", fullFileName);
	
//	fullFileName = [fullFileName stringByAppendingString:Path];
	
	NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:fullFileName];
	
	return array;
}

-(void)DataBySaveWithFilePath:(NSString*)Path Context:(NSString*)Context
{
	NSArray			*paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString		*documentsDirectory = [paths objectAtIndex:0];
	NSString		*fullFileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory,Path];
	NSString		*FilePathTemp = [[NSString alloc] initWithString:[fullFileName stringByAppendingString:fullFileName]];

	NSMutableArray	*LoadData = [self DataLoadWithFilePath:FilePathTemp];
	
	[LoadData addObject:Context];
	
	[LoadData writeToFile:fullFileName atomically:NO];
	
	[LoadData release];
	[FilePathTemp release];
}

-(void)DataToSaveWithSaveFilePath:(NSString*)Path Context:(NSString*)Context
{
	//앞에 있는 저장된 파일이 있어도 새로만듭니다.
	//각 노래의 최고 점수 나타낼때 쓰입니다.
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];

	NSString *fullFileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory,Path];		
	NSMutableArray *array = [[NSMutableArray alloc] init];
	
	[array addObject:Context];
	[array writeToFile:fullFileName atomically:NO];
	[array release];
}

-(void)DataClearWithFilePath:(NSString*)Path
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *fullFileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory,Path];
	NSMutableArray *array = [[NSMutableArray alloc] init];

//	[array addObject:@"0"];
	
	[array writeToFile:fullFileName atomically:NO];
	[array release];
}

-(void)dealloc
{
	[super dealloc];
}

@end
