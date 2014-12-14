//
//  AppDelegate.m
//  Ch11_1
//
//  Created by Ho Mark on 12/4/16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@implementation AppDelegate

@synthesize  m_managedObjectContext;
@synthesize m_managedObjectModel;
@synthesize m_persistentStoreCoordinator;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Application's Documents directory

/**
 取得應用程式Documents目錄的子路徑.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSDocumentDirectory
             inDomains:NSUserDomainMask] lastObject];
}

/**
 傳回被初始化過的NSPersistentStoreCoordinator物件
 如果已經初始化過就直接傳回
 不然就開啟Documents下的iOS7.sqlite檔案
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // 如果已經初始化就直接傳回
    if (m_persistentStoreCoordinator != nil){
        return m_persistentStoreCoordinator;
    }
    // 從Documents目錄下指定物件的路徑
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"data.sqlite"];
    NSError *error = nil;

    // 初始化並傳回
    m_persistentStoreCoordinator =
    [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];

    if (![m_persistentStoreCoordinator
          addPersistentStoreWithType:NSSQLiteStoreType
          configuration:nil
          URL:storeURL
          options:nil
          error:&error])
    {
        
        NSLog(@"在存取資料庫時發生不可預期的錯誤 %@, %@", error, [error userInfo]);
        abort();
    }
    
    
    return m_persistentStoreCoordinator;
}

/**
 從Data Model檔中建立NSManagedObjectModel物件
 如果已經建立會直接回傳而不用再次讀取
 */
- (NSManagedObjectModel *)managedObjectModel
{
    //如果物件已經初始化過就直接回傳
    if (m_managedObjectModel != nil)
    {
        return m_managedObjectModel;
    }
    // 沒有的話就直接載入該檔案之後回傳，在 URLForResource 中傳入 CoreData 的檔名
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreData" withExtension:@"momd"];
    
    // 從Model檔案中實例化m_managedObjectModel
    m_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return m_managedObjectModel;
}

/**
 傳回這個應用程式的NSManagedObjectContext物件
 如果已經存在就直接回傳，不然就從sql-lite中
 藉由persistentStoreCoordinator中讀取
 */
- (NSManagedObjectContext *)managedObjectContext
{
    // 如果物件已經初始化就直接回傳
    if (m_managedObjectContext != nil) {
        return m_managedObjectContext;
    }

    // 不然就使用 persistentStoreCoordinator 從資料庫中讀取
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        m_managedObjectContext = [[NSManagedObjectContext alloc] init];
        [m_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return m_managedObjectContext;
}


// 將資料儲存進managedObjectContext中
- (void)saveContext
{
    NSError *error = nil;
    
    // 取得NSManagedObjectContext物件
    NSManagedObjectContext *managedObjectContext =  [self managedObjectContext];
    
    // 如果存在就進行儲存的動作
    if (managedObjectContext != nil)
    {
        // 如果資料有變更就進行儲存
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            // 資料儲存發生錯誤
            NSLog(@"Unresolved error %@, %@",
                  error, [error userInfo]);
            abort();
        }else{
            NSLog(@"saveContext");
        }
    }else{
        NSLog(@"null");
    }
}


@end
