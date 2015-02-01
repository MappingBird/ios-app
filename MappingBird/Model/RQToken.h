//
//  RQToken.h
//  MappingBird
//
//  Created by Hill on 2014/11/27.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKObjectMapping.h"

@interface RQToken : NSObject

@property (nonatomic, strong) NSString* token;

+(RKObjectMapping*)defineRequestMapping;

@end
