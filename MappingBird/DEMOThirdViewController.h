//
//  DEMOThirdViewController.h
//  RESideMenuStoryboardsExample
//
//  Created by Hill on 2014/9/22.
//  Copyright (c) 2014年 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "JPBFloatingTextViewController.h"
#import <MapKit/MapKit.h>
#import "PointDetailVC.h"

@interface DEMOThirdViewController : JPBFloatingTextViewController

- (IBAction)pushViewController:(id)sender;

@property (nonatomic, strong) MKMapView *_mapView;
@property(nonatomic) NSInteger currentPageIndex;
@property(nonatomic) NSString *currentTitle;

@end
