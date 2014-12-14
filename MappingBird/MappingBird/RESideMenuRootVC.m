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


@interface RESideMenuRootVC (){
    AppDelegate *appDelegate;
}

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

    self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];

    self.backgroundImage = [UIImage imageNamed:@"Stars"];

    self.delegate = self;
}



-(void)viewDidLoad{
    [super viewDidLoad];
    
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    RPCallback  callback = ^(void){
    };
    
    
    NSString *token = (NSString *)[JNKeychain loadValueForKey:MB_TOKEN];
    NSString *user_id = (NSString *)[JNKeychain loadValueForKey:MB_USER_ID];
    
    if((![token length] == 0) ){
        [[CollectionMgr alloc] UpdateCollectionsByUserId:user_id token:token callback:callback appDelegate:appDelegate];
    }
}




-(NSString *) getToken {
    // 設定從Core Data框架中取出Beverage的Entity
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"User"
                                   inManagedObjectContext:[appDelegate managedObjectContext]];
    [request setEntity:entity];
    NSError* error = nil;
    //執行存取的指令並且將資料載入returnObjs
    NSMutableArray* returnObjs = [[[appDelegate managedObjectContext]
                                   executeFetchRequest:request error:&error]mutableCopy];
    
    for (User* user in returnObjs) {
        if([user.token length] !=0 )
            return user.token;
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
