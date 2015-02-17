//
//  MBDetailMapVC.h
//  MappingBird
//
//  Created by Hill on 2015/2/15.
//  Copyright (c) 2015年 mitsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Location.h"
#import <CoreLocation/CoreLocation.h>

@interface MBDetailMapVC : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property(nonatomic) Location *locationData;
@end
