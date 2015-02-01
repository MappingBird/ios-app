//
//  RP_Image.m
//  MappingBird
//
//  Created by Hill on 2014/12/27.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import "RP_Image.h"

@implementation RP_Image

+(RKObjectMapping*)defineResponseMapping{
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RP_Image class]];
    
    [mapping addAttributeMappingsFromArray:@[ @"id",
                                              @"url",
                                              @"thumb_path",
                                              @"point",
                                              @"create_time",
                                              @"update_time"
                                              ]];
    
    
    return mapping;
    
}

@end
