//
//  CollectionMgr.m
//  MappingBird
//
//  Created by Hill on 2014/11/21.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import "CollectionMgr.h"
#import <RestKit/RestKit.h>
#import "RQToken.h"
#import "RPCollections.h"
#import "Constants.h"
#import "RKMIMETypeSerialization.h"
#import "RKLog.h"
#import "PointData.h"
#import "Collection.h"
#import "RPPoint.h"
#import "PointMgr.h"


@interface CollectionMgr ()

@property (nonatomic, strong) RKObjectManager *objectManager;
@property (nonatomic, strong) AFHTTPClient * client;


@end


@implementation CollectionMgr

-(void) UpdateCollectionsByUserId:(NSString*)userId token:(NSString*)token callback:(RPCallback) callback appDelegate:(AppDelegate*)appDelegate{
    
    
    RQToken *dataObject = [[RQToken alloc] init];
    
    NSURL *baseURL = [NSURL URLWithString:MAPPING_BIRD_HOST];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:baseURL];
    
    //we want to work with JSON-Data
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    [client setDefaultHeader:@"Authorization" value: [NSString stringWithFormat:@"Token %@", token]];
    
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class]
                               forMIMEType:@"application/json"];
    

    
    
    RKObjectMapping *topMapping = [RKObjectMapping mappingForClass:[RPCollection class]];
    
    [topMapping addAttributeMappingsFromArray:@[ @"id",
                                                 @"name",
                                                 @"user",
                                                 @"points",
                                                 @"create_time",
                                                 @"update_time"
                                                 ]];
    
    
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:topMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"collections" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    // 有 array 用這個，不然用 [objectManager addResponseDescriptor ...
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];


    [objectManager setRequestSerializationMIMEType: RKMIMETypeJSON];


    
    [objectManager getObject:dataObject path:[NSString stringWithFormat:@"/api/users/%@/collections", userId]
                   parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       
                       NSArray* statuses = [mappingResult array];
                       
                       RPCollections *response = [statuses objectAtIndex:0];
                       

                       if(response.error != nil){
                           
                           if(MP_DEBUG_INFO){NSLog(@"fail to get collections");}
                           
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                           message:@"Oops...\nplease try again later"
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil];
                           [alert show];
                           return;
                       }
                       
                       
                       [self saveCollectionArrayToDB:appDelegate withResponse:statuses];
                       
                       callback();
                       
                       
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       if(MP_DEBUG_INFO){NSLog(@"fail to get collections, network error");}

                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                       message:@"Oops...\nPlease try again later"
                                                                      delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil];
                       [alert show];
                       
                       return ;
                   }];

    
    
    
}

-(void) saveCollectionArrayToDB:(AppDelegate*)appDelegate withResponse:(NSArray*) data {
    
    for (RPCollection *rpCollection in data) {
        
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@", rpCollection.id];
        
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Collection" inManagedObjectContext:[appDelegate managedObjectContext]];

        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        [request setPredicate:predicate];

        
        BOOL unique = YES;

        NSError *error;
        NSArray *items = [[appDelegate managedObjectContext] executeFetchRequest:request error:&error];


        [self SavePointIdToDB:appDelegate collectionID:rpCollection.id points:rpCollection.points];

         if(items.count > DUPLICATE_COUNT){
            unique = NO;
        }

        if(unique){
            
            if(MP_DEBUG_INFO){
                NSLog(@"add collection...");
                NSLog(@"id : %@", rpCollection.id);
                NSLog(@"name : %@",  rpCollection.name);
            }
            
            
            NSManagedObject *collection;
            if(items.count >0){
                collection = (NSManagedObject *)[items objectAtIndex:0];
                
            }else{
                collection = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:appDelegate.managedObjectContext];
            }
            [collection setValue:rpCollection.id forKey:@"id"];
            [collection setValue:rpCollection.name forKey:@"name"];
            [collection setValue:rpCollection.user forKey:@"user"];
            
            
            if (![collection.managedObjectContext save:&error]) {
                NSLog(@"新增 point 遇到錯誤");
                continue;
            }
            
        }
        

    }
    
}


-(void) SavePointIdToDB:(AppDelegate*)appDelegate collectionID:(NSNumber*)cId points:(NSArray*) data {
    
    for (NSNumber *pointId in data) {
        
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@", pointId];
        
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"PointData" inManagedObjectContext:[appDelegate managedObjectContext]];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        [request setPredicate:predicate];
        
        
        BOOL unique = YES;
        
        NSError *error;
        NSArray *items = [[appDelegate managedObjectContext] executeFetchRequest:request error:&error];
        
        if(items.count > DUPLICATE_COUNT){
            unique = NO;
            continue;
        }
        
        if(unique){
            
            NSManagedObject *point;
            if(items.count >0){
                point = (NSManagedObject *)[items objectAtIndex:0];
                if(MP_DEBUG_INFO) NSLog(@"update point, id : %@", pointId);
            }else{
                point = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:appDelegate.managedObjectContext];
                if(MP_DEBUG_INFO) NSLog(@"add point, id : %@", pointId);
            }
            [point setValue:pointId forKey:@"id"];

            
            if (![point.managedObjectContext save:&error]) {
                NSLog(@"新增 point 遇到錯誤");
                continue;
            }
            
        }
    }
    
}



-(void) GetCollectionInfo:(NSString*)collectionId token:(NSString*)token callback:(RPCallback) callback{
    
}


@end
