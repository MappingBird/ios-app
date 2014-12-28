//
//  RP_Location.h
//  MappingBird
//
//  Created by Hill on 2014/12/28.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RP_Location : NSObject

@property (nonatomic, copy) NSNumber * id;
@property (nonatomic, copy) NSString * place_name;
@property (nonatomic, copy) NSString * place_address;
@property (nonatomic, copy) NSString * place_phone;
@property (nonatomic, copy) NSString * coordinates;
@property (nonatomic, copy) NSString * category;
@property (nonatomic, copy) NSDate * create_time;
@property (nonatomic, copy) NSDate * update_time;

@end
