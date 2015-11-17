//
//  AppDelegate.m
//  Semm
//
//  Created by 郭洪军 on 11/2/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "AppDelegate.h"
#import "IpaynowPluginApi.h"
#import "Umeng/MobClick.h"
#import "CommonDefine.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [MobClick startWithAppkey:UMENG_KEY reportPolicy:BATCH   channelId:UMENG_CHANNEL];
    
    int isActive = [[[NSUserDefaults standardUserDefaults]valueForKey:ACTIVE_KEY] intValue];
    
    if (1 != isActive) {
    
        //发送激活请求
        // 1.将网址初始化成一个OC字符串对象
        NSString *urlStr = ACTIVE_URL_STRING;
        // 如果网址中存在中文,进行URLEncode
        NSString *newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        // 2.构建网络URL对象, NSURL
        NSURL *url = [NSURL URLWithString:newUrlStr];
        // 3.创建网络请求
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
        NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
        [conn start];
    
        
        [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithInt:1] forKey:ACTIVE_KEY];
    }
    
    [NSThread sleepForTimeInterval:2.0];
  
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
    
    [IpaynowPluginApi willEnterForeground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
