//
//  Location.h
//  MappingBird
//
//  Created by Hill on 2014/12/28.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * place_name;
@property (nonatomic, retain) NSString * place_address;
@property (nonatomic, retain) NSString * place_phone;
@property (nonatomic, retain) NSString * coordinates;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSDate * create_time;
@property (nonatomic, retain) NSDate * update_time;
@property (nonatomic, retain) NSNumber * point_id;

@end
