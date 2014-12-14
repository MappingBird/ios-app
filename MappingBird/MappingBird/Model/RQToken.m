//
//  RQToken.m
//  MappingBird
//
//  Created by Hill on 2014/11/27.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import "RQToken.h"

@implementation RQToken

@synthesize token;

+(RKObjectMapping*)defineRequestMapping   {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RQToken class]];
    
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"Authorization":   @"token",
                                                  }];
    
    
    return mapping;
    
}

@end
