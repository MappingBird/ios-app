//
//  DEMOLeftMenuViewController.m
//  RESideMenuStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOLeftMenuViewController.h"
#import "DEMOFirstViewController.h"
#import "DEMOSecondViewController.h"
#import "UIViewController+RESideMenu.h"
#import "DEMOThirdViewController.h"

@interface DEMOLeftMenuViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;
//@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation DEMOLeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 8) / 2.0f, self.view.frame.size.width, 54 * 8) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.scrollsToTop = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"thirdViewController"]]
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
}


//#pragma mark - Fetched results controller
//- (NSFetchedResultsController *)fetchedResultsController {
//    
//    if (_fetchedResultsController != nil) {
//        return _fetchedResultsController;
//    }
//    
//    // Create and configure a fetch request with the Book entity.
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Book" inManagedObjectContext:self.managedObjectContext];
//    [fetchRequest setEntity:entity];
//    
//    // Create the sort descriptors array.
//    NSSortDescriptor *authorDescriptor = [[NSSortDescriptor alloc] initWithKey:@"author" ascending:YES];
//    NSSortDescriptor *titleDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
//    NSArray *sortDescriptors = @[authorDescriptor, titleDescriptor];
//    [fetchRequest setSortDescriptors:sortDescriptors];
//    
//    // Create and initialize the fetch results controller.
//    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"author" cacheName:@"Root"];
//    _fetchedResultsController.delegate = self;
//    
//    return _fetchedResultsController;
//}


#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DEMOThirdViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"thirdViewController"];
    viewController.currentPageIndex = indexPath.row;
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:viewController]
                                                 animated:YES];
    
    
//    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"thirdViewController"]]
//                                                 animated:YES];
    
                                    
    [self.sideMenuViewController hideMenuViewController];
    
    
//    switch (indexPath.row) {
//        case 0:
//            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"firstViewController"]]
//                                                         animated:YES];
//            [self.sideMenuViewController hideMenuViewController];
//            break;
//        case 1:
//            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"secondViewController"]]
//                                                         animated:YES];
//            [self.sideMenuViewController hideMenuViewController];
//            break;
//            
//        case 2:
//            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"thirdViewController"]]
//                                                         animated:YES];
//            [self.sideMenuViewController hideMenuViewController];
//            break;
//        default:
//            break;
//    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    NSArray *fakeTitles = @[@"Taipei Restaurants(61)",
                            @"Taipei WIFI Cafe(4)",
                            @"Taipei Zakka(5)",
                            @"宜蘭景點(22)",
                            @"冬季北海道(64)",
                            @"冬季京阪神(2)",
                            @"東京(13)",
                            @"台灣美食(3)"];
    
    
    NSArray *titles = @[@"Home", @"Calendar", @"Profile", @"Settings", @"Log Out",
                        @"Log Out1", @"Log Out2", @"Log Out3"];
    NSArray *images = @[@"IconHome", @"IconCalendar", @"IconProfile", @"IconSettings", @"IconEmpty",
                        @"IconHome", @"IconHome", @"IconHome"];
    cell.textLabel.text = titles[indexPath.row];
    cell.textLabel.text = fakeTitles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
}

@end
