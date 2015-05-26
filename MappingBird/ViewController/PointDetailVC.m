//
//  PointDetailVC.m
//  MappingBird
//
//  Created by Hill on 2015/1/17.
//  Copyright (c) 2015年 mitsw. All rights reserved.
//
#import "AppDelegate.h"
#import "PointDetailVC.h"
#import "Image.h"

#define MAX_CHAR 8


@interface PointDetailVC ()
@property (weak, nonatomic) IBOutlet KIImagePager *imagePager;

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation PointDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    _appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    self.navigationController.navigationBar.topItem.title = NSLocalizedStringFromTable(@"navi_btn_back", @"common", nil);
    self.navigationItem.title = NSLocalizedStringFromTable(@"point_info", @"common", nil);
    [self getImages:_pointData.id];

    
    _pointTitle.text = _pointData.title;    
    _pointDes.text = _pointData.descr;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
