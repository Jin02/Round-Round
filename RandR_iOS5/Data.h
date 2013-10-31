//
//  RankingData.h
//  WishBubble
//
//  Created by imac07 on 10. 03. 15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Data : NSObject {
	
}

-(NSMutableArray*)DataLoadWithFilePath:(NSString*)Path;
-(void)DataBySaveWithFilePath:(NSString*)Path Context:(NSString*)Context;
-(void)DataToSaveWithSaveFilePath:(NSString*)Path Context:(NSString*)Context;
-(void)DataClearWithFilePath:(NSString*)Path;


@end
