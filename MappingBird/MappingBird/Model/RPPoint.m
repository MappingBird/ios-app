//
//  RPPoint.m
//  MappingBird
//
//  Created by Hill on 2014/12/12.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import "RPPoint.h"
#import "RP_Image.h"
#import "RP_Location.h"

@implementation RPPoint

+(RKObjectMapping*)defineResponseMapping   {
    
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RPPoint class]];

    
    [mapping addAttributeMappingsFromArray:@[ @"collection",
                                              @"coordinates",
                                              @"create_time",
                                              @"descr",
                                              @"id",
                                              @"place_address",
                                              @"place_name",
                                              @"place_phone",
                                              @"title",
                                              @"type",
                                              @"update_time",
                                              @"url"
                                              //@"images"
                                              ]];
    
    
    
    
    RKObjectMapping* image = [RKObjectMapping mappingForClass:[RP_Image class] ];
    [image addAttributeMappingsFromArray:@[ @"id",
                                            @"url",
                                            @"thumb_path",
                                            @"point",
                                            @"create_time",
                                            @"update_time"
                                            ]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"images" toKeyPath:@"images" withMapping:image]];
    
    
    RKObjectMapping* location = [RKObjectMapping mappingForClass:[RP_Location class] ];
    [location addAttributeMappingsFromArray:@[ @"id",
                                            @"place_name",
                                            @"place_address",
                                            @"place_phone",
                                            @"coordinates",
                                            @"category",
                                            @"create_time",
                                            @"update_time"
                                            ]];
    

    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"location" toKeyPath:@"location" withMapping:location]];

    
    return mapping;
}

@end
