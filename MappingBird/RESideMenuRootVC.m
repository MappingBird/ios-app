//
//  ViewController.m
//  MappingBird
//
//  Created by Hill on 2014/10/7.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import "RESideMenuRootVC.h"
#import "AppDelegate.h"
#import <RestKit/RestKit.h>
#import "CollectionMgr.h"
#import "User.h"
#import "JNKeychain.h"
#import "Constants.h"
#import "PointMgr.h"
#import "PointData.h"

@interface RESideMenuRootVC ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation RESideMenuRootVC

- (void)awakeFromNib
{
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];

    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];

//    self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];

    self.backgroundImage = [UIImage imageNamed:@"Stars"];

    self.delegate = self;
}

#pragma mark - Fetched results controller
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    // Create and configure a fetch request with the Book entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PointData" inManagedObjectContext:[_appDelegate managedObjectContext]];

    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    //    NSSortDescriptor *titleDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    
    NSArray *sortDescriptors = @[descriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Create and initialize the fetch results controller.
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[_appDelegate managedObjectContext] sectionNameKeyPath:@"id" cacheName:@"Root"];
    
    //delete the cache before set the new predicate:
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}



-(void)viewDidLoad{
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    RPCallback  callback = ^(void){
        
        RPCallback  pointCallback = ^(void){
            // nothing to do;
        };

        // get more details
            NSString *token = (NSString *)[JNKeychain loadValueForKey:MB_TOKEN];
        for (PointData *data in [[self fetchedResultsController] fetchedObjects]) {
        
            [[PointMgr alloc] UpdatePointByPid:[data.id stringValue] token:token callback:pointCallback appDelegate:_appDelegate];
            
            // 節省時間，第一次取得全部後，就用 break 跳開
            break; // Need to remove
        }
    };
    
    
    NSString *token = (NSString *)[JNKeychain loadValueForKey:MB_TOKEN];
    NSString *user_id = (NSString *)[JNKeychain loadValueForKey:MB_USER_ID];
    
    if((![token length] == 0) ){
        [[CollectionMgr alloc] UpdateCollectionsByUserId:user_id token:token callback:callback appDelegate:_appDelegate];
    }
    
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
}




-(NSString *) getToken {
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"User"
                                   inManagedObjectContext:[_appDelegate managedObjectContext]];
    [request setEntity:entity];
    NSError* error = nil;
    NSMutableArray* returnObjs = [[[_appDelegate managedObjectContext]
                                   executeFetchRequest:request error:&error]mutableCopy];
    
    for (User* user in returnObjs) {
        if([user.token length] != 0){
            return user.token;
        }
    }
    
    return @"";
}



#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
//    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
//    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
//    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
//    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}



@end
