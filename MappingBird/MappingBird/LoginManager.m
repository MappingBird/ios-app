//
//  LoginManager.m
//  MappingBird
//
//  Created by Hill on 2014/10/31.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import "LoginManager.h"
#import "RKMIMETypeSerialization.h"
#import "RKLog.h"
#import "LoginRequest.h"
#import "Constants.h"
#import "Constants.h"
#import "JNKeychain.h"

@implementation LoginManager

-(void) saveToDB:(AppDelegate*)appDelegate withResponse:(LoginResponse*)response {
    
    User *user = (User*)[NSEntityDescription
                         insertNewObjectForEntityForName:@"User"
                         inManagedObjectContext:[appDelegate managedObjectContext]];
    
    user.id = response.user.id;
    user.email = response.user.email;
    user.token = response.token;
    
    if(DEBUG){
        NSLog(@"User id : %@", user.id);
        NSLog(@"User email : %@",  user.email);
        NSLog(@"User token : %@",  user.token);
    }
    

    // todo
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"User" inManagedObjectContext:[appDelegate managedObjectContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    BOOL unique = YES;
    NSError  *error;
    NSArray *items = [[appDelegate managedObjectContext] executeFetchRequest:request error:&error];
    if(items.count > DUPLICATE_COUNT){
        for(User *item in items){
            if(item.id == user.id){
                unique = NO;
            }
        }
    }
    if(unique){
        if (![appDelegate.m_managedObjectContext save:&error]) {
            NSLog(@"新增 user 遇到錯誤");
        }else {
            // TODO : store in keychain
            
            if ([JNKeychain saveValue:user.token forKey:MB_TOKEN]) {
                NSLog(@"Correctly saved value '%@' for key '%@'", user.token, MB_TOKEN);
            } else {
                NSLog(@"Failed to save!");
            }
            
            if ([JNKeychain saveValue:user.id forKey:MB_USER_ID]) {
                NSLog(@"Correctly saved value '%@' for key '%@'", user.token, MB_USER_ID);
            } else {
                NSLog(@"Failed to save!");
            }
            
        }
    }
    
}

-(void)LoginWithUserName:(NSString *)email password:(NSString*)password withCallback:(LoginSuccessCallback)callback withAppDelegate:(AppDelegate*)appDelegate{
    
    LoginRequest *dataObject = [[LoginRequest alloc] init];
    [dataObject setEmail:email];
    [dataObject setPassword:password];
    [dataObject setToken: @"1"];
    
    NSURL *baseURL = [NSURL URLWithString:MAPPING_BIRD_HOST];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:baseURL];

    //we want to work with JSON-Data
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class]
                               forMIMEType:@"application/json"];
    
    RKObjectMapping *requestMapping =  [[LoginRequest defineLoginRequestMapping] inverseMapping];
    
    [objectManager addRequestDescriptor: [RKRequestDescriptor
                                          requestDescriptorWithMapping:requestMapping
                                          objectClass:[LoginRequest class]
                                          rootKeyPath:nil
                                          method:RKRequestMethodPOST
                                          ]];

    // what to print
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("Restkit/Network", RKLogLevelDebug);
    
    RKObjectMapping *responseMapping = [LoginResponse defineLoginResponseMapping];
    
    [objectManager addResponseDescriptor:[RKResponseDescriptor
                                          responseDescriptorWithMapping:responseMapping
                                          method:RKRequestMethodAny
                                          pathPattern:nil
                                          keyPath:nil
                                          statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
                                          
                                          ]];
    
    
    [objectManager setRequestSerializationMIMEType: RKMIMETypeJSON];
    
    [objectManager postObject:dataObject path:@"/api/user/login"
                   parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

                       NSArray* statuses = [mappingResult array];
                       
                       LoginResponse *response = [statuses objectAtIndex:0];

                       // login fail
                       if(response.error != nil){
                           
                           if(DEBUG){NSLog(@"fail to login");}
                           
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                           message:@"Invalid email or password\nPlease try again"
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil];
                           [alert show];
                           return;
                       }
                       
                       [self saveToDB:appDelegate withResponse:response];

                       callback();
                       
//                     NSLog(@" token: %@", obj.token);
                       
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       
                       if(DEBUG){NSLog(@"fail to login, network");}
                       
                       NSLog(@"It Failed: %@", error);
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                       message:@"Invalid email or password\nPlease try again"
                                                                      delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil];
                       [alert show];
                       return ;
                   }];
    

    
}

@end