//
//  PointMgr.m
//  MappingBird
//
//  Created by Hill on 2014/12/21.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import "PointMgr.h"
#import <RestKit/RestKit.h>
#import "RQToken.h"
#import "RPPoint.h"
#import "Constants.h"
#import "PointData.h"
#import "RP_Image.h"

@implementation PointMgr


-(void) UpdatePointByPid:(NSNumber*)pid token:(NSString*)token callback:(RPCallback) callback appDelegate:(AppDelegate*)appDelegate{
    
    
    if(MP_DEBUG_INFO){
        RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
        RKLogConfigureByName("Restkit/Network", RKLogLevelDebug);
    }
    
    RQToken *dataObject = [[RQToken alloc] init];
    
    NSURL *baseURL = [NSURL URLWithString:MAPPING_BIRD_HOST];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:baseURL];
    
    //we want to work with JSON-Data
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    [client setDefaultHeader:@"Authorization" value: [NSString stringWithFormat:@"Token %@", token]];
    
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class]
                               forMIMEType:@"application/json"];
 
 
    
    RKObjectMapping *responseMapping = [RPPoint defineResponseMapping];
    
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:responseMapping
                                                method:RKRequestMethodAny
                                                pathPattern:nil
                                                keyPath:nil
                                                statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

    [objectManager addResponseDescriptor:responseDescriptor];
    
    [objectManager setRequestSerializationMIMEType: RKMIMETypeJSON];
    
    
    
    [objectManager getObject:dataObject path:[NSString stringWithFormat:@"/api/points/%@", pid]
                  parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                      
                      NSArray* statuses = [mappingResult array];
                      
                      [self savePointToDB:appDelegate withResponse:statuses];
                      
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


-(void) savePointToDB:(AppDelegate*)appDelegate withResponse:(NSArray*) response {
    
    NSError *error;
    
//    for (RPPoint *data in response) {

    
    RPPoint *data = [response objectAtIndex:0];
    
    
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@", data.id];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"PointData" inManagedObjectContext:[appDelegate managedObjectContext]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    
    
    NSArray *items = [[appDelegate managedObjectContext] executeFetchRequest:request error:&error];
    
    if(MP_DEBUG_INFO) NSLog(@"update, title : %@",data.title);

    NSManagedObject *updateData = (NSManagedObject *)[items objectAtIndex:0];
    [updateData setValue:data.title forKey:@"title"];
    [updateData setValue:data.collection forKey:@"collection"];
    [updateData setValue:data.coordinates forKey:@"coordinates"];
    [updateData setValue:data.create_time forKey:@"create_time"];
    [updateData setValue:data.descr forKey:@"descr"];
    [updateData setValue:data.place_address forKey:@"place_address"];
    [updateData setValue:data.place_name forKey:@"place_name"];
    [updateData setValue:data.place_phone forKey:@"place_phone"];
    [updateData setValue:data.type forKey:@"type"];
    [updateData setValue:data.update_time forKey:@"update_time"];
    [updateData setValue:data.url forKey:@"url"];

    
    [updateData.managedObjectContext save:&error];

    [self SavePointImages:appDelegate images:data.images];

    [self SavePointLocation:appDelegate pointID:data.id location:data.location];
    

//    }
    
}


-(void) SavePointImages:(AppDelegate*)appDelegate images:(NSArray*)images {

     for (RP_Image *data in images) {

         
         NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@", data.id];
         
         NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Image" inManagedObjectContext:[appDelegate managedObjectContext]];
         
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
             
             if(MP_DEBUG_INFO){
                 NSLog(@"add collection...");
                 NSLog(@"id : %@", data.id);
                 NSLog(@"url : %@",  data.url);
             }
             
             
             NSManagedObject *image;
             if(items.count > 0){
                 image = (NSManagedObject *)[items objectAtIndex:0];
                 
             }else{
                 image = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:appDelegate.managedObjectContext];
             }
             [image setValue:data.id forKey:@"id"];
             [image setValue:data.url forKey:@"url"];
             [image setValue:data.thumb_path forKey:@"thumb_path"];
             [image setValue:data.point forKey:@"point"];
             [image setValue:data.create_time forKey:@"create_time"];
             [image setValue:data.update_time forKey:@"update_time"];
             
             if (![image.managedObjectContext save:&error]) {
                 NSLog(@"新增 image 遇到錯誤");
                 continue;
             }
             
         }
     }
    
}


-(void) SavePointLocation:(AppDelegate*)appDelegate pointID:(NSNumber*)pointId location:(RP_Location*)location {

    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@", location.id];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:[appDelegate managedObjectContext]];
    
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
        
        if(MP_DEBUG_INFO){
            NSLog(@"add collection...");
            NSLog(@"id : %@", location.id);
            NSLog(@"url : %@",  location.place_name);
        }
        
        
        NSManagedObject *data;
        if(items.count > 0){
            data = (NSManagedObject *)[items objectAtIndex:0];
            
        }else{
            data = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:appDelegate.managedObjectContext];
        }

        [data setValue:location.id forKey:@"id"];
        [data setValue:location.place_name forKey:@"place_name"];
        [data setValue:location.place_address forKey:@"place_address"];
        [data setValue:location.place_phone forKey:@"place_phone"];
        [data setValue:location.coordinates forKey:@"coordinates"];
        [data setValue:location.category forKey:@"category"];
        [data setValue:location.create_time forKey:@"create_time"];
        [data setValue:location.update_time forKey:@"update_time"];

        [data setValue:pointId forKey:@"point_id"];
        
        
        if (![data.managedObjectContext save:&error]) {
            NSLog(@"新增 image 遇到錯誤");
        }
        
    }

}


-(void) GetPointInfo:(NSNumber*)pid token:(NSString*)token callback:(RPCallback) callback{
    
}

@end
