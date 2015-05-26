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
#import "MBPointPin.h"
#import "Location.h"

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
    
    
    NSString *latitude;
    NSString *longitude;

    NSMutableArray *places = [[NSMutableArray alloc] init];

    for(PointData *point in _pointList){
        if(point != nil){
            
            Location *location = [self getLocation:(NSInteger)point.id];
            
            if(location != nil){
                
                NSString *coordinate = location.coordinates;
                
                if(coordinate.length > 0){
                    NSArray *coordinates = [coordinate componentsSeparatedByString:@","];
                    latitude = [coordinates objectAtIndex:0];
                    longitude = [coordinates objectAtIndex:1];
                    
                    MBPointPin *place = [[MBPointPin alloc] initWithJSON:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                          point.place_name, @"name",
                                                                          point.place_address, @"address",
                                                                          latitude, @"lat",
                                                                          longitude, @"lng",
                                                                          nil]];
                    [places addObject:place];
                }
            }
            
        }
    }
    

    if(places.count > 0){
        
        // centered the region
        MKCoordinateRegion region = [self regionForAnnotations:places];
        [self._mapView setRegion:region animated:YES];
        
        // NOTE: if doesn't call this method, no marker will be shown
        [self._mapView addAnnotations:places];
    }
    
}

- (Location*) getLocation : (NSInteger) pointID{
    
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


- (MKCoordinateRegion)regionForAnnotations:(NSArray *)annotations
{
    MKCoordinateRegion region;
    
    if ([annotations count] == 0) {
        region = MKCoordinateRegionMakeWithDistance(self._mapView.userLocation.coordinate, 1000, 1000);
        
    } else if ([annotations count] == 1) {
        id <MKAnnotation> annotation = [annotations lastObject];
        
        region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000);
        
    } else {
        CLLocationCoordinate2D topLeftCoord;
        topLeftCoord.latitude = -90;
        topLeftCoord.longitude = 180;
        
        CLLocationCoordinate2D bottomRightCoord;
        bottomRightCoord.latitude = 90;
        bottomRightCoord.longitude = -180;
        
        for (id <MKAnnotation> annotation in annotations)
        {
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        }
        
        const double extraSpace = 1.1;
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2.0;
        region.center.longitude = topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2.0;
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace;
        region.span.longitudeDelta = fabs(topLeftCoord.longitude - bottomRightCoord.longitude) * extraSpace;
    }
    
    return [self._mapView regionThatFits:region];
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
