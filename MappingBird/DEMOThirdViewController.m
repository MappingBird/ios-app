//
//  DEMOThirdViewController.m
//  RESideMenuStoryboardsExample
//
//  Created by Hill on 2014/9/22.
//  Copyright (c) 2014年 Roman Efimov. All rights reserved.
//

#import "DEMOThirdViewController.h"
#import "MBPointTableViewCell.h"
#import <RestKit/RestKit.h>
#import "AppDelegate.h"
#import "PointData.h"
#import "ParallaxPhotoViewController.h"

@interface DEMOThirdViewController()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSArray *pointList;
@property (nonatomic) NSInteger selectedItem;


@end


static CGRect MapOriginalFrame;


@implementation DEMOThirdViewController 

- (IBAction)pushViewController:(id)sender{
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.title = @"Pushed Controller";
    viewController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_pointList.count != 0){
        return _pointList.count;
    }else{
        return 0;
    }
    
    
}

- (CGFloat)horizontalOffset{
    return 50.0f;
}

- (void)didTapHeaderImageView:(UIImageView *)imageView
{
    NSLog(@"The header imageview was tapped: %@", imageView.description);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];

    _pointList = [self getPointList : _collectionId];

    // Do any additional setup after loading the view, typically from a nib.
    //[self setHeaderImage:[UIImage imageNamed:@"meatballs.jpeg"]];
    [self setTitleText:_currentTitle];

    //    [self setSubtitleText:@"subtitle"];
    [self setLabelBackgroundGradientColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f]];
    
    
    [self.navigationItem setTitle:_currentTitle];
    
    MapOriginalFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2);
//    CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    self._mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self._mapView = [[MKMapView alloc] initWithFrame:MapOriginalFrame];
    [self.view insertSubview:self._mapView aboveSubview:self.tableView];
    
//    NSLog(@"currentPageIndex : %d", _currentPageIndex);
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    _selectedItem = (NSInteger)indexPath.row;

//    [self performSegueWithIdentifier:@"toPointView2" sender:self];
    [self performSegueWithIdentifier:@"toPointDetail" sender:self];
    
    
//    PointDetailVC *secondViewController = [[PointDetailVC alloc] init];
//    secondViewController.data = _label.text;
//    secondViewController.delegate = self;
//    [self.navigationController pushViewController:secondViewController animated:YES];
    //        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ParallaxPhotoViewController"];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toPointDetail"]) {

        if([[segue destinationViewController] isKindOfClass:[PointDetailVC class]] ){
            PointDetailVC *destViewController = segue.destinationViewController;
            destViewController.pointData = [_pointList objectAtIndex:_selectedItem];
        }
    }else if ([[segue identifier] isEqualToString:@"toPointView2"]) {

        if([[segue destinationViewController] isKindOfClass:[ParallaxPhotoViewController class]] ){
            
            ParallaxPhotoViewController *destViewController = segue.destinationViewController;
            destViewController.pointData = [_pointList objectAtIndex:_selectedItem];
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MBPointCell";
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    MBPointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:@"MBPointCellView" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:@"MBPointCell"];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    cell.textLabel.textColor = [UIColor blackColor];
    
    
    
    PointData *point = [_pointList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = point.title;
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *imgURL = @"http://blogs-images.forbes.com/antonyleather/files/2014/09/iphone-6-camera.jpg";
        
        // 這邊的 URL 是 這個地點的網址，不是 圖片的 URL, 顯示不出來
        NSString *imgURL = point.url;
        //NSLog(@"imgURL : %@", imgURL);
        imgURL = @"";
        
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
        
        //set your image on main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.cellImage setImage:[UIImage imageWithData:data]];
        });    
    });
    
    return cell;
}




- (NSArray*) getPointList : (NSInteger) collectionId{
    
    
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"collection == %@", [NSString stringWithFormat: @"%ld", (long)collectionId]];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"PointData" inManagedObjectContext:[_appDelegate managedObjectContext]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *items = [[_appDelegate managedObjectContext] executeFetchRequest:request error:&error];
    
    return items;
    
}


@end
