//
//  MBPointPin.m
//  MappingBird
//
//  Created by Hill on 2015/2/15.
//  Copyright (c) 2015年 mitsw. All rights reserved.
//

#import "MBPointPin.h"

@interface MBPointPin ()

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) NSString *placeName;
@property (nonatomic, assign) NSString *address;

@end


@implementation MBPointPin


-(id)initWithJSON:(id)json
{
    self.placeName = [json valueForKey:@"name"];
    self.latitude = [[json valueForKey:@"lat"] doubleValue];
    self.longitude = [[json valueForKey:@"lng"] doubleValue];
    self.address = [json valueForKey:@"address"] ;
    return self;
}


#pragma mark - MKAnnotation
// this will plot the marker to a correct place on map
- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate
{
    self.latitude = coordinate.latitude;
    self.longitude = coordinate.longitude;
}

// this will be shown as marker title
- (NSString *)title
{
    return self.placeName;
}

// this will be shown as marker subtitle
- (NSString *)subtitle
{
    if([self.address length] > 0){
        return self.address;
    }else {
        return nil; // 不顯示
    }
}



@end
