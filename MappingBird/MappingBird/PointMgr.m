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
 
    
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[RPPoint class]];
    [responseMapping addAttributeMappingsFromArray:@[ @"collection",
                                                 @"coordinates",
                                                 @"create_time",
                                                 @"descr",
                                                 @"id",
                                                 @"place_address",
                                                 @"place_name",
                                                 @"place_phone",
                                                 @"title",
                                                 @"type",
                                                 @"update_time",
                                                 @"url"
                                                 ]];
    
    
    
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
    
    if(DEBUG) NSLog(@"update, title : %@",data.title);

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
        
//    }
    
}


-(void) GetPointInfo:(NSNumber*)pid token:(NSString*)token callback:(RPCallback) callback{
    
}

@end
