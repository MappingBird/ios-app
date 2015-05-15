//
//  Constants.h
//  MappingBird
//
//  Created by Hill on 2014/11/21.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#ifndef MappingBird_Constants_h
#define MappingBird_Constants_h


#ifdef DEBUG
#define MAPPING_BIRD_HOST @"https://mappingbird.com"
#else
#define MAPPING_BIRD_HOST @"https://mappingbird.com"
#endif

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define MP_DEBUG_INFO  0
#define DUPLICATE_COUNT  1

#define MPB_TOKEN  @"MPB_TOKEN"
#define MPB_USER_ID  @"MPB_USER_ID"

#endif
