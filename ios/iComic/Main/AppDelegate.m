//
//  AppDelegate.m
//  iComic
//
//  Created by Steven on 15/9/11.
//  Copyright © 2015年 Neva. All rights reserved.
//

#import "AppDelegate.h"

@import AFNetworking;
@import NSObjectExtend;
@import BlocksKit;

/// 更新版本URL
#define CHECK_NEW_VERSION_URL @"https://github.com/qzs21/iComic/raw/master/config/version.json"
/// 更新检测间隔
#define CHECK_NEW_VERSION_DATE 3600

@interface AppDelegate ()
{
    __strong AFHTTPRequestOperationManager * _operationManager;
}

@property (nonatomic, strong, readonly) AFHTTPRequestOperationManager * operationManager;

@property (nonatomic, strong) NSDate * lastUpdateDate;

@end

@implementation AppDelegate

- (AFHTTPRequestOperationManager *)operationManager
{
    if (_operationManager == nil)
    {
        _operationManager = [AFHTTPRequestOperationManager manager];
        _operationManager.responseSerializer = [AFHTTPResponseSerializer serializer]; // 更换默认的JSON解析器
    }
    return _operationManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
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
    
    // 检测更新
    if ([[NSDate date] timeIntervalSince1970] - [self.lastUpdateDate timeIntervalSince1970] > CHECK_NEW_VERSION_DATE)
    {
        self.lastUpdateDate = [NSDate date];
        
        [self.operationManager GET:CHECK_NEW_VERSION_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary * data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            if ([data isKindOfClass:NSDictionary.class])
            {
                
                NSString * build = data[@"base"][@"build"];
                NSString * version = data[@"base"][@"version"];
                NSString * info = data[@"base"][@"info"];
                NSString * url = data[@"base"][@"url"];
                
                NSLog(@"[UIDevice appBuildVersion]: %@", [UIDevice appBuildVersion]);
                NSUInteger currentBuild = [[UIDevice appBuildVersion] integerValue];
                NSUInteger newBuild = [build integerValue];
                if (newBuild > currentBuild && url.length)
                {
                    [[UIAlertView bk_showAlertViewWithTitle:@"有新版本更新哦！"
                                                    message:[NSString stringWithFormat:@"版本:%@(build_%@)\n更新内容:\n%@", version, build, info]
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@[@"更新"]
                                                    handler:^(UIAlertView *alertView, NSInteger buttonIndex)
                      {
                          if (buttonIndex)
                          {
                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                          }
                      }] show];
                }
            }
        } failure:nil];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
