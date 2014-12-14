//
//  LoginRequest.m
//  MappingBird
//
//  Created by Hill on 2014/10/31.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import "LoginRequest.h"
#import "RKObjectManager.h"

@implementation LoginRequest
@synthesize email;
@synthesize password;
@synthesize token;

+(RKObjectMapping*)defineLoginRequestMapping   {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[LoginRequest class]];
    
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"email":   @"email",
                                                  @"password":   @"password",
                                                  @"token":   @"token",
                                                  }];
    
    
    return mapping;
    
}


@end
