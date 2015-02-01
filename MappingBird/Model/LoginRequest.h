//
//  LoginRequest.h
//  MappingBird
//
//  Created by Hill on 2014/10/31.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKObjectMapping.h"

@interface LoginRequest : NSObject
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) NSString* token;

+(RKObjectMapping*)defineLoginRequestMapping;
@end