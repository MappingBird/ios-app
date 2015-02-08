//
//  ParallaxMapViewController.m
//  QMBParallaxScrollView-Sample
//
//  Created by Toni Möckel on 06.11.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "ParallaxMapViewController.h"
#import "SamplePhotoBrowserViewController.h"
#import "SampleScrollViewController.h"

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <RestKit/RestKit.h>

@interface ParallaxMapViewController (){
    AppDelegate *appDelegate;
}

@property (nonatomic, strong) NSNumber *mPointID;

@end

@implementation ParallaxMapViewController


- (void) setPointId:(NSNumber *)pointID{
    _mPointID = pointID;
}

- (void)viewDidLoad{
    
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    [super viewDidLoad];
    UIViewController *sampleMapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    SampleScrollViewController *sampleBottomViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SampleScrollViewController"];
    [sampleBottomViewController setPointId:[NSNumber numberWithInt:11]];
    
    [self setupWithTopViewController:sampleMapViewController andTopHeight:200 andBottomViewController:sampleBottomViewController];

    
//    [self getPointData :[NSNumber numberWithInt:11]];
    
    self.maxHeight = self.view.frame.size.height-50.0f;
}

- (void) getPointData : (NSNumber*) pointID{
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@", pointID];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"PointData" inManagedObjectContext:[appDelegate managedObjectContext]];

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    
    
    NSError *error;
    NSArray *items = [[appDelegate managedObjectContext] executeFetchRequest:request error:&error];
    
    NSLog(@" heloowooo");
    NSLog(@" size : %lud", (unsigned long)items.count);
    
//
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:entityDescription];
//    [request setPredicate:predicate];
}



- (IBAction) dismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
