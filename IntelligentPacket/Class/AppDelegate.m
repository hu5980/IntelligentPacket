//
//  AppDelegate.m
//  IntelligentPacket
//
//  Created by Seth on 16/6/13.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "AppDelegate.h"
#import "UIManager.h"
#import "IntelligentPacket-Swift.h"
#import "ITPLanguageManager.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)refreshLanguge {
    
    if ([ITPUserManager ShareInstanceOne].userEmail != nil) {
        
        UITabBarController * mainView = (UITabBarController *)self.window.rootViewController;
        
        NSArray <UITabBarItem *>* items = mainView.tabBar.items;
        NSArray * tittles = @[@"Luggage and bags", @"Location", @"Introduce", @"Manage"];
        for (int i = 0; i < items.count; i++) {
            
            NSString * title = L(tittles[i]);
            UITabBarItem * item = items[i];
            item.title = title;
        }
        
    }else{ }
}

- (void)SetUpTheRootViewController {
    
    if ([ITPUserManager ShareInstanceOne].userEmail != nil) {

        UIStoryboard *mainTabBar = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        UITabBarController *mainView = mainTabBar.instantiateInitialViewController;
        
        self.window.rootViewController = mainView;
        
        [self refreshLanguge];
        
    }else{
        
        UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:[NSBundle mainBundle]];
        UINavigationController *loginVC = loginSB.instantiateInitialViewController;
        self.window.rootViewController = loginVC;
        
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [[UIManager shareInstance] configUI];
    [[ITPLanguageManager sharedInstance] config];
    
    [[ITPScoketManager shareInstance] startConnect];
    
//    [self SetUpTheRootViewController];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SetUpTheRootViewController) name:ITPacketAPPChangeStoreBoard object:nil];

    [RACObserve([ITPUserManager ShareInstanceOne], userEmail) subscribeNext:^(id x) {
        [[NSNotificationCenter defaultCenter]postNotificationName:ITPacketAPPChangeStoreBoard object:nil];
    }];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLanguge) name:refreshLangugeNotification object:nil];
    
    //激光推送
    //===========================================
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //       categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories    nil
        [JPUSHService registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge |
          UIRemoteNotificationTypeSound |
          UIRemoteNotificationTypeAlert)   categories:nil];
    }
    //Required
    //
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHKey
                                                           channel:@"App store"
                                                  apsForProduction:@"0"
                                             advertisingIdentifier:advertisingId];
    
    [self registerJpushNotice];
    //===========================================
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}



- (void)registerJpushNotice
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isLoginSuccess:) name:kJPFNetworkDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didRecieveData:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isRegisterSuccess:) name:kJPFNetworkDidRegisterNotification object:nil];
}

#pragma mark - JPUSH

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required -    DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

//这里接收通知（APNS）信息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    [self showAlter:userInfo[@"aps"]];
//    [[NSNotificationCenter defaultCenter]postNotificationName:reloadTableIndentifier object:nil];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
 
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark - jpush notice
- (void)isLoginSuccess:(NSNotification *)notification
{
    if ([ITPUserManager ShareInstanceOne].userEmail.length == 0) {
        return;
    }
    NSString * str = OCSTR(@"%@",[AppUtil getHexstring:[ITPUserManager ShareInstanceOne].userEmail]);
    NSSet *set = [[NSSet alloc]initWithObjects:str, nil];
    [JPUSHService setTags:set alias:str fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        if (iResCode) {
            NSLog(@"set success...");
        }
    }];
}

//推送的两种功
//这里接收自定义（非APNS）信息
- (void)didRecieveData:(NSNotification *)notification
{
    NSDictionary * dic = notification.userInfo;
    //    [self showAlter:dic];
}

- (void)isRegisterSuccess:(NSNotification *)notification
{
    
}

- (void)showAlter:(NSDictionary *)dic
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:dic[@"alert"]==nil?dic[@"content"]:dic[@"alert"]  message:dic[@"alert"]==nil?dic[@"content"]:dic[@"alert"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.detu.IntelligentPacket" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"IntelligentPacket" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"IntelligentPacket.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
