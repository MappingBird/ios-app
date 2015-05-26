//
//  PointDetailVC.h
//  MappingBird
//
//  Created by Hill on 2015/1/17.
//  Copyright (c) 2015年 mitsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointData.h"
#import "KIImagePager.h"

@interface PointDetailVC : UIViewController <KIImagePagerDataSource, KIImagePagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *pointTitle;
@property (weak, nonatomic) IBOutlet UILabel *pointDes;

@property(nonatomic) PointData* pointData;

@end
