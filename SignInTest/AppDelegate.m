//
//  AppDelegate.m
//  SignInTest
//
//  Created by Victor on 16/3/22.
//  Copyright © 2016年 DotC_United. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface AppDelegate () <GIDSignInDelegate>

@end

@implementation AppDelegate

static NSString * const kClientID =
@"762422706082-l99p1vdu7l8f6vtb664h70a1leo1r6jh.apps.googleusercontent.com";

static NSString * const kConsumerKey =
@"rOnxWhQNrgZCwLa8mqIu3wj90";

static NSString * const kConsumerSecret =
@"GLUgfYQwo2aB5eIkHL8lUrsF1ZXf5BFeqX9PNvS4vYqleAX40W";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[Twitter sharedInstance] startWithConsumerKey:kConsumerKey
                                    consumerSecret:kConsumerSecret];
    [Fabric with:@[[Twitter class]]];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    
    [GIDSignIn sharedInstance].clientID = kClientID;
    [GIDSignIn sharedInstance].delegate = self;
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
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSString *URLString = [url absoluteString];
    if ([[URLString substringToIndex:2] isEqualToString:@"fb"]) {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }else{
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation];
    }
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error{
    if (error != nil) {
        NSLog(@"we have an error:%@",error);
    }else{
        NSString *userId = user.userID;                  // For client-side use only!
        NSString *idToken = user.authentication.idToken; // Safe to send to the server
        NSString *name = user.profile.name;
        NSString *email = user.profile.email;
        NSLog(@"success sign in with google: %@ , %@ , %@ , %@",userId,idToken,name,email);
    }
    
}


@end
