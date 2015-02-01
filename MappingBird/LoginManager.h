//
//  LoginManager.h
//  MappingBird
//
//  Created by Hill on 2014/10/31.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKObjectManager.h"
#import "LoginResponse.h"
#import "LoginRequest.h"
#import "LoginVC.h"
#import "AppDelegate.h"

@interface LoginManager : NSObject

@property (nonatomic, strong) LoginRequest *dataObject;
@property (nonatomic, strong) RKObjectManager *objectManager;
@property (nonatomic, strong) AFHTTPClient * client;

-(void)LoginWithUserName:(NSString *)username password:(NSString*)password withCallback:(LoginSuccessCallback)callback withAppDelegate:(AppDelegate*)appDelegate;

@end