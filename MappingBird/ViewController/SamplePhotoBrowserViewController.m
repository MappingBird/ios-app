//
//  SamplePhotoBrowserViewController.m
//  QMBParallaxScrollView-Sample
//
//  Created by Toni Möckel on 06.11.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "SamplePhotoBrowserViewController.h"
#import "AppDelegate.h"
#import "Image.h"

@interface SamplePhotoBrowserViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) PointData *pointData;
@property (nonatomic, strong) NSNumber *pointID;
@property BOOL issetup;
@end

@implementation SamplePhotoBrowserViewController

- (void) setPointData:(PointData *)data{
    _pointData = data;
}

- (void) setPointId:(NSNumber *)pointId{
    _pointID = pointId;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    _appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];

    [self getImages:_pointID];

    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *imgURL = @"http://blogs-images.forbes.com/antonyleather/files/2014/09/iphone-6-camera.jpg";
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
//        
//        //set your image on main thread.
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.photos addObject:[UIImage imageWithData:data]];
//        });
//    });
    
}


- (void) getImages : (NSNumber*) pointID
{
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"point == %@", pointID];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Image" inManagedObjectContext:[_appDelegate managedObjectContext]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    
    
    NSError *error;
    NSArray *items = [[_appDelegate managedObjectContext] executeFetchRequest:request error:&error];
    
//    NSLog(@" image in this point : %lu", (unsigned long)items.count);
    
    self.photos = [NSMutableArray array];
    for(Image *image in items){
//        NSLog(@" show image %@", image.url);
        [self.photos addObject:image.url];
        //break; // Need to remove
    }
    
}


- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager*)pager
{
    return UIViewContentModeScaleAspectFill;
}

- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    return self.photos;
}

@end
