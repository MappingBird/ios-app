//
//  PRCollections.m
//  MappingBird
//
//  Created by Hill on 2014/11/29.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import "RPCollections.h"
#import "Collection.h"

@implementation RPCollections


+(RKObjectMapping*)defineRequestMapping   {
    

    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[RPCollections class] ];

    // Define the relationship mapping
    RKObjectMapping* collectionMapping = [RKObjectMapping mappingForClass:[RPCollection class] ];
    [collectionMapping addAttributeMappingsFromArray:@[ @"id",
                                                        @"name",
                                                        @"user",
                                                        //@"points",
                                                        @"create_time",
                                                        @"update_time"
                                                        ]];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"collections"
                                                                            toKeyPath:@"collections"
                                                                          withMapping:collectionMapping]];
    
    
    
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"detail":   @"error",
                                                  }];
    
    return mapping;
}


+(RKObjectMapping*)defineResponseMapping   {
    
    
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[RPCollections class] ];
    
    
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"detail":   @"error",
                                                  }];
    
    return mapping;
}



@end
