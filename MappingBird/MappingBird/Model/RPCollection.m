//
//  RPCollection.m
//  MappingBird
//
//  Created by Hill on 2014/11/26.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import "RPCollection.h"
#import "Collection.h"
#import "PointData.h"

@implementation RPCollection

+(RKObjectMapping*)defineRequestMapping   {
    
    // Define the relationship mapping
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[RPCollection class] ];
    
    RKObjectMapping* collectionMapping = [RKObjectMapping mappingForClass:[Collection class]];
    [collectionMapping addAttributeMappingsFromArray:@[ @"id",
                                                        @"name",
                                                        @"user",
//                                                        @"points",
                                                        @"create_time",
                                                        @"update_time"
                                                        ]];
    

    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"collections"
                                                                            toKeyPath:@"collections"
                                                                          withMapping:collectionMapping]];
    
    
    return mapping;
}

@end
