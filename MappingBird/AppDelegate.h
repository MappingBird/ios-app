//
//  AppDelegate.h
//  MappingBird
//
//  Created by Hill on 2014/10/7.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    // 增加Core Data的成員變數
    NSManagedObjectContext *m_managedObjectContext;
    NSManagedObjectModel *m_managedObjectModel;
    NSPersistentStoreCoordinator *m_persistentStoreCoordinator;
}


typedef void (^MPBCallback) (void);
//typedef void (^MpbCallback) (void);

// 增加Core Data的成員變數property定義
@property (nonatomic, retain) NSManagedObjectContext *m_managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel *m_managedObjectModel;
@property (nonatomic, retain) NSPersistentStoreCoordinator *m_persistentStoreCoordinator;

@property (strong, nonatomic) UIWindow *window;

// 將物件同步進Core Data
- (void)saveContext;

// 傳回這個應用程式目錄底下的Documents子目錄
- (NSURL *)applicationDocumentsDirectory;

// 傳回這個應用程式中管理資料庫的Persistent Store Coordinator物件
- (NSPersistentStoreCoordinator *) persistentStoreCoordinator;

// 傳回這個應用程式中的物件模型管理員，負責讀取data model
- (NSManagedObjectModel*) managedObjectModel;

// 傳回這個應用程式的物件本文管理員，用來作物件的同步
- (NSManagedObjectContext*) managedObjectContext;

@end
