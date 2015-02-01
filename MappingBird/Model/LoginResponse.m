//
//  LoginResponse.m
//  MappingBird
//
//  Created by Hill on 2014/10/31.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import "LoginResponse.h"
//#import <RestKit/RestKit.h>
#import "LoginUser.h"

@implementation LoginResponse

@synthesize token;
@synthesize user;

+(RKObjectMapping*)defineLoginResponseMapping   {
    

    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[LoginResponse class]];

    // Define the relationship mapping
    RKObjectMapping* userMapping = [RKObjectMapping mappingForClass:[LoginUser class] ];
    [userMapping addAttributeMappingsFromArray:@[ @"email", @"id", @"token"]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                                   toKeyPath:@"user"
                                                                                 withMapping:userMapping]];
    
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"token":   @"token",
//                                                  @"user":   @"user",
                                                  @"error":   @"error",
                                                  }];
    
    
    return mapping;
    
}

@end
