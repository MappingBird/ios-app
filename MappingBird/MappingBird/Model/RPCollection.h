//
//  RPCollection.h
//  MappingBird
//
//  Created by Hill on 2014/11/26.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKObjectMapping.h"
#import <RestKit/RestKit.h>

@interface RPCollection : NSObject

@property (nonatomic, copy)  NSNumber * id;
@property (nonatomic, copy)  NSString * name;
@property (nonatomic, copy)  NSNumber * user;
@property (nonatomic, copy)  NSArray * points;

@property (nonatomic, copy)  NSDate * create_time;
@property (nonatomic, copy)  NSDate * update_time;


@property (nonatomic) NSString* error;

+(RKObjectMapping*)defineRequestMapping;

@end
