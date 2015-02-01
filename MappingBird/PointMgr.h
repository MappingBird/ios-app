//
//  PointMgr.h
//  MappingBird
//
//  Created by Hill on 2014/12/21.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface PointMgr : NSObject

-(void) UpdatePointByPid:(NSString*)pid token:(NSString*)token callback:(RPCallback) callback appDelegate:(AppDelegate*)appDelegate;

-(void) GetPointInfo:(NSString*)pid token:(NSString*)token callback:(RPCallback) callback;

@end
