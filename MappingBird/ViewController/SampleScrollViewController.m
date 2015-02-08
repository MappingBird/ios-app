//
//  SampleScrollViewController.m
//  QMBParallaxScrollView-Sample
//
//  Created by Toni Möckel on 02.11.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "SampleScrollViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SampleScrollViewController (){

}


@property (weak, nonatomic) IBOutlet UILabel *pointTitle;
@property (weak, nonatomic) IBOutlet UILabel *pointDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnDirection;

@property (nonatomic, strong) NSNumber *pointID;
@property (nonatomic, strong) PointData *pointData;

@end



@implementation SampleScrollViewController




- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.pointTitle.text = _pointData.title;
    self.pointDescription.text = _pointData.descr;
    

//    self.btnDirection.layer.borderColor = [UIColor blackColor].CGColor;
//    
//    self.btnDirection.layer.borderWidth = 1.0;
//    
//    self.btnDirection.layer.cornerRadius = 10;
    
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
