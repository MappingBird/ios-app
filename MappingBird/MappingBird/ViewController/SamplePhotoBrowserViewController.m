//
//  SamplePhotoBrowserViewController.m
//  QMBParallaxScrollView-Sample
//
//  Created by Toni Möckel on 06.11.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "SamplePhotoBrowserViewController.h"

@interface SamplePhotoBrowserViewController ()

@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation SamplePhotoBrowserViewController



- (void)viewDidLoad
{
//    self.photos = [NSMutableArray array];
//    [self.photos addObject:[UIImage imageNamed:@"NGC6559.jpg"]];
//    [self.photos addObject:[UIImage imageNamed:@"1.jpg"]];
//    [self.photos addObject:[UIImage imageNamed:@"2.jpg"]];
//    [self.photos addObject:[UIImage imageNamed:@"3.jpg"]];
//    [self.photos addObject:[UIImage imageNamed:@"4.jpg"]];


    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *imgURL = @"http://blogs-images.forbes.com/antonyleather/files/2014/09/iphone-6-camera.jpg";
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
//        
//        //set your image on main thread.
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.photos addObject:[UIImage imageWithData:data]];
//        });
//    });
    
    
    [super viewDidLoad];
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager*)pager
{
    return UIViewContentModeScaleAspectFill;
}

- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    
    self.photos = [NSMutableArray array];
    [self.photos addObject:[UIImage imageNamed:@"NGC6559.jpg"]];
    [self.photos addObject:[UIImage imageNamed:@"1.jpg"]];
    [self.photos addObject:[UIImage imageNamed:@"2.jpg"]];
    [self.photos addObject:[UIImage imageNamed:@"3.jpg"]];
    [self.photos addObject:[UIImage imageNamed:@"4.jpg"]];
    return self.photos;
    
//    return @[
//             @"https://raw.github.com/kimar/tapebooth/master/Screenshots/Screen1.png",
//             @"https://raw.github.com/kimar/tapebooth/master/Screenshots/Screen2.png",
//             @"https://raw.github.com/kimar/tapebooth/master/Screenshots/Screen3.png"
//             ];

}

//
//- (NSArray *) arrayWithImages
//{
//    return self.photos;
//}

//- (UIViewContentMode) contentModeForImage:(NSUInteger)image
//{
//    return UIViewContentModeScaleAspectFill;
//}

@end
