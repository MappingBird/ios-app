//
//  Image.h
//  MappingBird
//
//  Created by Hill on 2014/12/27.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Image : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * thumb_path;
@property (nonatomic, retain) NSNumber * point;
@property (nonatomic, retain) NSDate * create_time;
@property (nonatomic, retain) NSDate * update_time;

@end
