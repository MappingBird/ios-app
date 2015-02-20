//
//  MBDetailMapVC.m
//  MappingBird
//
//  Created by Hill on 2015/2/15.
//  Copyright (c) 2015年 mitsw. All rights reserved.
//

#import "MBDetailMapVC.h"
#import "MBPointPin.h"


@interface MBDetailMapVC ()

@property (strong, nonatomic)  CLLocationManager *locationManager;

@end

@implementation MBDetailMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;

    self.locationManager = [[CLLocationManager alloc] init];
    // Set a delegate to receive location callbacks
    self.locationManager.delegate = self;

    // Start the location manager
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }

    // 設定之後，會不斷更新目前位置
//    [self.locationManager startUpdatingLocation];

    self.mapView.showsUserLocation = YES;
    
    
    NSString *latitude;
    NSString *longitude;
    
    if(_locationData != nil){
        NSArray *coordinates = [_locationData.coordinates componentsSeparatedByString:@","];
        latitude = [coordinates objectAtIndex:0];
        longitude = [coordinates objectAtIndex:1];
        
        [self setTitle:_locationData.place_name];
    }
    
    MBPointPin *place1 = [[MBPointPin alloc] initWithJSON:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           _locationData.place_name, @"name",
                                                           _locationData.place_address, @"address",
                                                           latitude, @"lat",
                                                           longitude, @"lng",
                                                           nil]];
    
    
    NSArray *places = @[place1];
    
    // centered the region
    MKCoordinateRegion region = [self regionForAnnotations:places];
    [self.mapView setRegion:region animated:YES];
    
    // NOTE: if doesn't call this method, no marker will be shown
    [self.mapView addAnnotations:places];


    // 設定之後，callout 就固定在螢幕上，不會消失
//    if(places.count == 1){
//        [self.mapView selectAnnotation:[places lastObject] animated:YES];
//    }
    
    
    // Do any additional setup after loading the view.
    
//    ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//        [self.locationManager requestAlwaysAuthorization];
//    }
}

- (MKCoordinateRegion)regionForAnnotations:(NSArray *)annotations
{
    MKCoordinateRegion region;
    
    if ([annotations count] == 0) {
        region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 1000, 1000);
        
    } else if ([annotations count] == 1) {
        id <MKAnnotation> annotation = [annotations lastObject];

        region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000);
        
    } else {
        CLLocationCoordinate2D topLeftCoord;
        topLeftCoord.latitude = -90;
        topLeftCoord.longitude = 180;
        
        CLLocationCoordinate2D bottomRightCoord;
        bottomRightCoord.latitude = 90;
        bottomRightCoord.longitude = -180;
        
        for (id <MKAnnotation> annotation in annotations)
        {
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        }
        
        const double extraSpace = 1.1;
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2.0;
        region.center.longitude = topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2.0;
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace;
        region.span.longitudeDelta = fabs(topLeftCoord.longitude - bottomRightCoord.longitude) * extraSpace;
    }
    
    return [self.mapView regionThatFits:region];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateLocations, %@", [locations lastObject]);
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
 
    
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = userLocation.title;
//    point.subtitle = @"I'm here!!!";
    
    [self.mapView addAnnotation:point];
}

@end
