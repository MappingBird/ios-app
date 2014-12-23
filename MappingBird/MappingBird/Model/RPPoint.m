//
//  RPPoint.m
//  MappingBird
//
//  Created by Hill on 2014/12/12.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import "RPPoint.h"


@implementation RPPoint

+(RKObjectMapping*)defineResponseMapping   {
    
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RPPoint class]];

    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"id":   @"pid",

                                                  }];
    
    
    return mapping;
}

@end
