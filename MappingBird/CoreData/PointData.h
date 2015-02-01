//
//  PointData.h
//  MappingBird
//
//  Created by Hill on 2014/12/4.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PointData : NSManagedObject

@property (nonatomic, retain) NSNumber * collection;
@property (nonatomic, retain) NSString * coordinates;
@property (nonatomic, retain) NSDate * create_time;
@property (nonatomic, retain) NSString * descr;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * place_address;
@property (nonatomic, retain) NSString * place_name;
@property (nonatomic, retain) NSString * place_phone;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * update_time;
@property (nonatomic, retain) NSString * url;

@end
