//
//  RP_Image.h
//  MappingBird
//
//  Created by Hill on 2014/12/27.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface RP_Image : NSObject

@property (nonatomic, copy) NSNumber * id;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * thumb_path;
@property (nonatomic, copy) NSNumber * point;
@property (nonatomic, copy) NSDate * create_time;
@property (nonatomic, copy) NSDate * update_time;

+(RKObjectMapping*)defineResponseMapping;

@end
