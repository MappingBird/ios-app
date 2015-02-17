//
//  SampleScrollViewController.m
//  QMBParallaxScrollView-Sample
//
//  Created by Toni Möckel on 02.11.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "SampleScrollViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "Location.h"
#import "Constants.h"
#import <MapKit/MapKit.h>
#import "MBDetailMapVC.h"

@interface SampleScrollViewController (){

}


@property (weak, nonatomic) IBOutlet UILabel *pointTitle;
@property (weak, nonatomic) IBOutlet UILabel *pointDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnDirection;
@property (weak, nonatomic) IBOutlet UIImageView *imageMap;

@property (nonatomic, strong) NSNumber *pointID;
@property (nonatomic, strong) PointData *pointData;

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) Location *location;

@end



@implementation SampleScrollViewController




- (void)viewDidLoad{
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    self.pointTitle.text = _pointData.title;
    self.pointDescription.text = _pointData.descr;
    
    _location = [self getLocation:(NSInteger)_pointData.id];

    if(_location != nil){
        
        NSArray *coordinates = [_location.coordinates componentsSeparatedByString:@","];
        NSString *latitude = [coordinates objectAtIndex:0];
        NSString *longitude = [coordinates objectAtIndex:1];
        
//        NSLog(@"_pointData is %@", _pointData.id);
//        NSLog(@"latitude is %@", latitude);
//        NSLog(@"longitude is %@", longitude);
        
        
        NSString *staticMapUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?markers=color:red|%@,%@&%@&sensor=true",latitude,longitude , @"zoom=17&size=680x200"];
        NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:mapUrl]];
        _imageMap.image = image;
    }else{
        if(MP_DEBUG_INFO){
            NSLog(@"Location is nil");
        }
    }
    
    [_btnDirection addTarget:self
                      action:@selector(handleButtonClicked:)
            forControlEvents:UIControlEventTouchUpInside
     ];
    
//    self.btnDirection.layer.borderColor = [UIColor blackColor].CGColor;
//    
//    self.btnDirection.layer.borderWidth = 1.0;
//    
//    self.btnDirection.layer.cornerRadius = 10;
    
}


- (Location*) getLocation : (NSInteger*) pointID{
    
    if(_appDelegate != nil){
        
//        NSLog(@"_pointData is %zd", pointID);
        
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"point_id == %@", pointID];
        
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:[_appDelegate managedObjectContext]];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        [request setPredicate:predicate];
        
        NSError *error;
        NSArray *items = [[_appDelegate managedObjectContext] executeFetchRequest:request error:&error];
        
//        NSLog(@"location matched : %lu", (unsigned long)items.count);

        
        if(items.count == 1){
            return (Location*)[items objectAtIndex : 0];;
        }else{
            return nil;
        }

    }else{
        return nil;
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

}

- (void) setPointData:(PointData *)pointData{
    _pointData = pointData;
}

- (void) setPointId:(NSNumber *)pointID{
    _pointID = pointID;
}

#pragma mark - QMBParallaxScrollViewHolder

- (UIScrollView *)scrollViewForParallaxController{

    return self.scrollView;
}

- (IBAction)closeButtonTouchUpInside:(id)sender{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void) handleButtonClicked:(id)sender {

    // 跳到 Apple Map，參考：
    // http://stackoverflow.com/questions/12504294/programmatically-open-maps-app-in-ios-6

    //    Class mapItemClass = [MKMapItem class];
//    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
//    {
//        // Create an MKMapItem to pass to the Maps app
//        CLLocationCoordinate2D coordinate =
//        CLLocationCoordinate2DMake(16.775, -3.009);
//        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
//                                                       addressDictionary:nil];
//        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
//        [mapItem setName:@"My Place"];
//        // Pass the map item to the Maps app
//        [mapItem openInMapsWithLaunchOptions:nil];
//    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toMapPage"]) {
        
        if([[segue destinationViewController] isKindOfClass:[MBDetailMapVC class]] ){
            MBDetailMapVC *destViewController = segue.destinationViewController;
            destViewController.locationData = _location;
            
        }
    }
}



@end
