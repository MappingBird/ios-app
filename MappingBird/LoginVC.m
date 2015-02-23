//
//  LoginVC.m
//  MappingBird
//
//  Created by Hill on 2014/10/8.
//  Copyright (c) 2014年 mitsw. All rights reserved.
//

#import "LoginVC.h"
#import <RestKit/RestKit.h>
#import "LoginResponse.h"
#import "LoginManager.h"
#import "AppDelegate.h"
#import "User.h"

@interface LoginVC () <UITextFieldDelegate>


@property (nonatomic, strong) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UITextField *tf_Email;
@property (weak, nonatomic) IBOutlet UITextField *tf_Password;

@property (nonatomic, copy) NSNumber *userEmail;
@property (nonatomic, copy) NSString *userPassword;



- (BOOL) validateEmailWithString:(NSString*)email;

@end



@implementation LoginVC


- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


-(void)viewDidLoad{
    
    _appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    [self loadData];
}



- (IBAction)login:(id)sender {

    _tf_Password.text = @"671117";

    NSString *email = _tf_Email.text;
    NSString *password = _tf_Password.text;
    BOOL isInvalid = false;
    
    if ( ![self validateEmailWithString:email] ){
        isInvalid = true;
    }else if (password.length == 0){
        isInvalid = true;
    }
    

    LoginSuccessCallback  callback = ^(void){
        
        [self performSegueWithIdentifier:@"toMainView" sender:nil];

    };
    
    
    
    if (isInvalid){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Invalid email or password\nPlease try again"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    [[LoginManager alloc] LoginWithUserName:email password:password withCallback:callback withAppDelegate:_appDelegate];
    
    
}



-(void) changeVC {
    [self performSegueWithIdentifier:@"toMainView" sender:nil];
}



-(void) loadData {
    // 設定從Core Data框架中取出Beverage的Entity
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"User"
                                   inManagedObjectContext:[_appDelegate managedObjectContext]];
    [request setEntity:entity];
    NSError* error = nil;
    //執行存取的指令並且將資料載入returnObjs
    NSMutableArray* returnObjs = [[[_appDelegate managedObjectContext] executeFetchRequest:request error:&error]mutableCopy];

    NSLog(@"loadData : %lu", (unsigned long)[returnObjs count]);
    // 將資料倒入表格的資料來源之中
    for (User* user in returnObjs) {
        NSLog(@"user id : %@", [user.id stringValue]);
    }
    // 將表格的資料重新載入
    
}



@end
