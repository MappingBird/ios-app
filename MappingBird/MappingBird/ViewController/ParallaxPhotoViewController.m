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


@interface ParallaxPhotoViewController ()


@end

@implementation ParallaxPhotoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    SamplePhotoBrowserViewController *topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SamplePhotoBrowserViewController"];
    
    ((KIImagePager *)topViewController.view).slideshowTimeInterval = 0;
    
    SampleScrollViewController *bottomViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SampleScrollViewController"];
    
    [self setupWithTopViewController:topViewController andTopHeight:200
             andBottomViewController:bottomViewController];

    self.maxHeight = 200;
    
    self.delegate = self;
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
