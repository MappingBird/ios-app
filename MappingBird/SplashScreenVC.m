//
//  SplashScreenVC.m
//  MappingBird
//
//  Created by Hill on 2014/10/7.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import "SplashScreenVC.h"
#import "LoginVC.h"
#import <RestKit/RestKit.h>
#import "User.h"
#import "AppDelegate.h"
#import "JNKeychain.h"
#import "Constants.h"

@interface SplashScreenVC ()

@property (nonatomic, strong) AppDelegate *appDelegate;

@end


@implementation SplashScreenVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    

    // 移除程式，不會把 Keychain 的資料移除，所以這邊不能用
    // 不然就是要自己清空
    //NSString *token = (NSString *)[JNKeychain loadValueForKey:MB_TOKEN];

    NSString *token = [self getToken];

    if([token length] == 0){
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self selector:@selector(changeVC:) userInfo:nil repeats:false];
        
    }else{
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self selector:@selector(ToMainScreen:) userInfo:nil repeats:false];
    }
    
    
  
}


-(void) changeVC:(NSTimer*)timer {
    [self performSegueWithIdentifier:@"toLogin" sender:nil];
}

-(void) ToMainScreen:(NSTimer*)timer {
    [self performSegueWithIdentifier:@"toMain" sender:nil];
}


-(NSString *) getToken {
    // 設定從Core Data框架中取出Beverage的Entity
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"User"
                                   inManagedObjectContext:[_appDelegate managedObjectContext]];
    [request setEntity:entity];
    NSError* error = nil;
    //執行存取的指令並且將資料載入returnObjs
    NSMutableArray* returnObjs = [[[_appDelegate managedObjectContext]
                                   executeFetchRequest:request error:&error]mutableCopy];
    
    for (User* user in returnObjs) {
        if([user.token length] !=0 )
            return user.token;
    }

    
    return @"";

    
}

@end
