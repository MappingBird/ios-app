//
//  SamplePhotoBrowserViewController.h
//  QMBParallaxScrollView-Sample
//
//  Created by Toni Möckel on 06.11.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "KIImagePager.h"
#import "PointData.h"

@interface SamplePhotoBrowserViewController : UIViewController<KIImagePagerDataSource, KIImagePagerDelegate>

- (void) setPointData:(PointData*)data;
- (void) setPointId:(NSNumber*) pointID;


@end
