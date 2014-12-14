//
//  PRCollections.h
//  MappingBird
//
//  Created by Hill on 2014/11/29.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKObjectMapping.h"
#import <RestKit/RestKit.h>
#import "RPCollection.h"

@interface RPCollections : NSObject

@property (nonatomic, retain) NSArray *rows;
@property (nonatomic) NSString* error;


+(RKObjectMapping*)defineRequestMapping;

+(RKObjectMapping*)defineResponseMapping;

@end
