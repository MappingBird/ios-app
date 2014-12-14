//
//  LoginResponse.h
//  MappingBird
//
//  Created by Hill on 2014/10/31.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import <RestKit/RestKit.h>

@interface LoginResponse : NSObject

@property (nonatomic) NSString* token;
@property (nonatomic) User* user;
@property (nonatomic) NSString* error;

+(RKObjectMapping*)defineLoginResponseMapping;

@end
