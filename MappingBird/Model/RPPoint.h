//
//  RPPoint.h
//  MappingBird
//
//  Created by Hill on 2014/12/12.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "RP_Location.h"

@interface RPPoint : NSObject

@property (nonatomic, copy) NSNumber * collection;
@property (nonatomic, copy) NSString * coordinates;
@property (nonatomic, copy) NSDate * create_time;
@property (nonatomic, copy) NSString * descr;
// 不能用 description 的原因是  NSObject 裡面已經有一個 description member
@property (nonatomic, copy) NSNumber * id;
@property (nonatomic, copy) NSString * place_address;
@property (nonatomic, copy) NSString * place_name;
@property (nonatomic, copy) NSString * place_phone;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSDate * update_time;
@property (nonatomic, copy) NSString * url;

@property (nonatomic, copy)  NSArray * images;
@property RP_Location *location;
@property (nonatomic, copy)  NSArray * tags;

+(RKObjectMapping*)defineResponseMapping;

@end
