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

@interface SampleScrollViewController (){

}


@property (weak, nonatomic) IBOutlet UILabel *pointTitle;
@property (weak, nonatomic) IBOutlet UILabel *pointDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnDirection;
@property (weak, nonatomic) IBOutlet UIImageView *imageMap;

@property (nonatomic, strong) NSNumber *pointID;
@property (nonatomic, strong) PointData *pointData;

@property (nonatomic, strong) AppDelegate *appDelegate;

@end



@implementation SampleScrollViewController




- (void)viewDidLoad{
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    self.pointTitle.text = _pointData.title;
    self.pointDescription.text = _pointData.descr;
    
    Location *location = [self getLocation:[NSNumber numberWithInt:_pointData.id]];

    if(location != nil){
        
        NSArray *coordinates = [location.coordinates componentsSeparatedByString:@","];
        NSString *latitude = [coordinates objectAtIndex:0];
        NSString *longitude = [coordinates objectAtIndex:1];
        
        NSString *staticMapUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?markers=color:red|%@,%@&%@&sensor=true",latitude,longitude , @"zoom=10&size=340x100"];
        NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:mapUrl]];
        _imageMap.image = image;
    }else{
        if(MP_DEBUG_INFO){
            NSLog(@"Location is nil");
        }
    }
//    self.btnDirection.layer.borderColor = [UIColor blackColor].CGColor;
//    
//    self.btnDirection.layer.borderWidth = 1.0;
//    
//    self.btnDirection.layer.cornerRadius = 10;
    
}


- (Location*) getLocation : (NSNumber*) pointID{
    
    if(_appDelegate != nil){
        
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"point_id == %@", pointID];
        
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:[_appDelegate managedObjectContext]];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        [request setPredicate:predicate];
        
        NSError *error;
        NSArray *items = [[_appDelegate managedObjectContext] executeFetchRequest:request error:&error];
        
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

@end
