//
//  ViewController.m
//  SignInTest
//
//  Created by Victor on 16/3/22.
//  Copyright © 2016年 DotC_United. All rights reserved.
//

#import "ViewController.h"
#import <TwitterKit/TwitterKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleSignIn/GoogleSignIn.h>


@interface ViewController () <GIDSignInUIDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    UIButton *fbButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    fbButton.center = CGPointMake(self.view.center.x, 100);
    [fbButton setImage:[UIImage imageNamed:@"FB-f-Logo__blue"] forState:UIControlStateNormal];
    [fbButton setContentMode:UIViewContentModeCenter];
    [fbButton addTarget:self action:@selector(logInWithFacebook) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fbButton];
    
    UIButton *twitterButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    twitterButton.center = CGPointMake(self.view.center.x, 150);
    [twitterButton setImage:[UIImage imageNamed:@"twtr-icn-logo"] forState:UIControlStateNormal];
    [twitterButton setContentMode:UIViewContentModeCenter];
    [twitterButton addTarget:self action:@selector(logInWithTwitter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twitterButton];

    GIDSignInButton *googleButton = [[GIDSignInButton alloc]init];
    googleButton.style = kGIDSignInButtonStyleIconOnly;
    googleButton.center = CGPointMake(self.view.center.x, 200);
    [self.view addSubview:googleButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logInWithFacebook{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
                                    NSLog(@"Process error");
                                } else if (result.isCancelled) {
                                    NSLog(@"Cancelled");
                                } else {
                                    NSLog(@"Logged in");
                                }
                            }];
}

- (void)logInWithTwitter{
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}


@end
