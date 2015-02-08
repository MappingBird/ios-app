//
//  ParallaxPhotoViewController.m
//  QMBParallaxScrollView-Sample
//
//  Created by Toni Möckel on 07.11.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "ParallaxPhotoViewController.h"
#import "SamplePhotoBrowserViewController.h"
#import "SampleScrollViewController.h"
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <RestKit/RestKit.h>
#import "PointData.h"

@interface ParallaxPhotoViewController (){
        AppDelegate *appDelegate;
}


@end

@implementation ParallaxPhotoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    PointData *data = [self getPointData :[NSNumber numberWithInt:11]];

    [self setTitle:data.title];
    
    SamplePhotoBrowserViewController *topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SamplePhotoBrowserViewController"];
    [topViewController setPointId:data.id];
    
    ((KIImagePager *)topViewController.view).slideshowTimeInterval = 0;
    
    SampleScrollViewController *bottomViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SampleScrollViewController"];
    [bottomViewController setPointId:data.id];
    [bottomViewController setPointData:data];
    
    
    [self setupWithTopViewController:topViewController andTopHeight:200
             andBottomViewController:bottomViewController];
    
    self.maxHeight = 200;
    
    self.delegate = self;
}


- (PointData*) getPointData : (NSNumber*) pointID{
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@", pointID];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"PointData" inManagedObjectContext:[appDelegate managedObjectContext]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *items = [[appDelegate managedObjectContext] executeFetchRequest:request error:&error];
    
    if(items.count == 1){
        return (PointData*)[items objectAtIndex : 0];;
    }else{
        return nil;
    }
    

}

- (IBAction) dismiss:(id)sender{
//    [self dismissViewControllerAnimated:YES completion:nil];
}

//#pragma mark - QMBParallaxScrollViewControllerDelegate
//
//- (void)parallaxScrollViewController:(QMBParallaxScrollViewController *)controller didChangeState:(QMBParallaxState)state{
//
//    
//    if (self.state == QMBParallaxStateFullSize){
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//    }else {
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }
//    
//}


@end
