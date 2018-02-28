//
//  AppDelegate.m
//  ContractInfo
//
//  Created by csm on 2017/12/7.
//  Copyright © 2017年 YiJu. All rights reserved.
//

#import "AppDelegate.h"
#import <AddressBook/AddressBook.h>
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window.backgroundColor = [UIColor whiteColor];
    
    [self requestAuthorizationAdressBook];
    
    return YES;
}

-(void)requestAuthorizationAdressBook{
    
    CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    
    if (systemVersion < 9.0) {
        //判断是否授权
        ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
        
        if (authorizationStatus == kABAuthorizationStatusNotDetermined) {
            //请求授权
            ABAddressBookRef addressBookRef = ABAddressBookCreate();
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    NSLog(@"授权成功");
                }else{
                    NSLog(@"授权失败");
                }
            });
        }
    }else{
        
        CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (authorizationStatus == CNAuthorizationStatusNotDetermined) {
            CNContactStore * contractStore = [[CNContactStore alloc] init];
            [contractStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    NSLog(@"授权成功");
                }else{
                    NSLog(@"授权失败, error ----- %@",error);
                }
            }];
        }
        
    }

    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
