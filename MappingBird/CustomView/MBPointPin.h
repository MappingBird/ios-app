//
//  MBPointPin.h
//  MappingBird
//
//  Created by Hill on 2015/2/15.
//  Copyright (c) 2015年 mitsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MBPointPin : NSObject <MKAnnotation>

- (id)initWithJSON:(id)json;

// must implement this if want to make the Pin draggable
- (void)setCoordinate:(CLLocationCoordinate2D)coordinate;

@end
