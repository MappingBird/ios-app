//
//  CollectionMgr.h
//  MappingBird
//
//  Created by Hill on 2014/11/21.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKObjectManager.h"
#import "AppDelegate.h"

@interface CollectionMgr : NSObject




-(void) UpdateCollectionsByUserId:(NSString*)userId token:(NSString*)token callback:(MPBCallback) callback appDelegate:(AppDelegate*)appDelegate;

-(void) GetCollectionInfo:(NSString*)collectionId token:(NSString*)token callback:(MPBCallback) callback;

@end
