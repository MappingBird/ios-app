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
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];


    [objectManager setRequestSerializationMIMEType: RKMIMETypeJSON];


    
    [objectManager getObject:dataObject path:[NSString stringWithFormat:@"/api/users/%@/collections", userId]
                   parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       
                       NSArray* statuses = [mappingResult array];
                       
                       RPCollections *response = [statuses objectAtIndex:0];
                       

                       if(response.error != nil){
                           
                           if(DEBUG){NSLog(@"fail to get collections");}
                           
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
                       if(DEBUG){NSLog(@"fail to get collections, network error");}

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
        
        
        Collection *collection = (Collection*)[NSEntityDescription
                                               insertNewObjectForEntityForName:@"Collection"
                                               inManagedObjectContext:[appDelegate managedObjectContext]];
        
        collection.id = rpCollection.id;
        collection.name = rpCollection.name;
        collection.user = rpCollection.user;
        
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
            
            if(DEBUG){
                NSLog(@"add collection...");
                NSLog(@"id : %@", collection.id);
                NSLog(@"name : %@",  collection.name);
            }
            
            
            if (![appDelegate.m_managedObjectContext save:&error]) {
                NSLog(@"新增 collection 遇到錯誤");
            }
        }
        
        
    }
    
}


-(void) SavePointIdToDB:(AppDelegate*)appDelegate collectionID:(NSNumber*)cId points:(NSArray*) data {

//    if(DEBUG) NSLog(@"point # : %lu", (unsigned long)data.count);
    
    for (NSNumber *pointId in data) {
        
//        if(DEBUG) NSLog(@"point id : %@", pointId);

        PointData *point = (PointData*)[NSEntityDescription
                                               insertNewObjectForEntityForName:@"PointData"
                                               inManagedObjectContext:[appDelegate managedObjectContext]];
        
        point.id = pointId;
        
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
        }
        
        if(unique){
            
//            if(DEBUG) NSLog(@"add point, id : %@", pointId);
            
            
            if (![appDelegate.m_managedObjectContext save:&error]) {
                NSLog(@"新增 point 遇到錯誤");
            }
        }
    }
}



-(void) GetCollectionInfo:(NSString*)collectionId token:(NSString*)token callback:(RPCallback) callback{
    
}


@end
