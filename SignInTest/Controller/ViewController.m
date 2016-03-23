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

@interface ViewController () <GIDSignInUIDelegate,GIDSignInDelegate>
@property (nonatomic, strong) FBSDKLoginManager *fbLogin;
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
    
    
    [GIDSignIn sharedInstance].delegate = self;
    
    GIDSignInButton *googleButton = [[GIDSignInButton alloc]init];
    googleButton.style = kGIDSignInButtonStyleIconOnly;
    googleButton.center = CGPointMake(self.view.center.x, 200);
    [self.view addSubview:googleButton];
    
    UIButton *signOutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    signOutButton.frame = CGRectMake(0, 0, 80, 50);
    signOutButton.center = CGPointMake(self.view.center.x, 300);
    [signOutButton setBackgroundColor:[UIColor redColor]];
    [signOutButton setTitle:@"SignOut" forState:UIControlStateNormal];
    [signOutButton addTarget:self action:@selector(AccountSignOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signOutButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logInWithFacebook{
    FBSDKLoginManager *login = self.fbLogin;
    if (!login) {
        login = [[FBSDKLoginManager alloc] init];
        self.fbLogin = login;
    }
    __weak typeof(self) weakSelf = self;
    [login logInWithReadPermissions: @[@"public_profile",@"email",@"user_friends"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
                                    NSLog(@"Process error");
                                } else if (result.isCancelled) {
                                    NSLog(@"Cancelled");
                                } else {
                                    weakSelf.signInType = SwiftLiveSignInTypeFacebook;
                                    
                                    //@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}
                                    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"id,name,link,email,friends"}];
                                    [request startWithCompletionHandler:
                                     ^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                         if (error != nil) {
                                             NSLog(@"Error Getting Info %@",error);
                                         }
                                         NSLog(@"user email is %@",[result valueForKey:@"email"]);
                                         NSLog(@"user facebook id is %@",[result valueForKey:@"id"]);
                                         NSLog(@"user facebook name is %@",[result valueForKey:@"name"]);
                                         NSLog(@"user facebook link is %@",[result valueForKey:@"link"]);
                                         NSLog(@"user friends %@",[result valueForKey:@"friends"]);
                                     }];
                                }
                            }];
}

- (void)logInWithTwitter{
    __weak typeof(self) weakSelf = self;
    
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            weakSelf.signInType = SwiftLiveSignInTypeTwitter;
            
            NSLog(@"signed in as %@", [session userName]);
            NSLog(@"twitter user id is %@",[session userID]);
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error{
    if (error != nil) {
        NSLog(@"we have an error:%@",error);
    }else{
        self.signInType = SwiftLiveSignInTypeGoogle;
        
        NSString *userId = user.userID;                  // For client-side use only!
        NSString *idToken = user.authentication.idToken; // Safe to send to the server
        NSString *name = user.profile.name;
        NSString *email = user.profile.email;
        NSLog(@"success sign in with google: %@, %@, %@",userId,name,email);
    }
}

- (void)AccountSignOut{
    switch (self.signInType) {
        case SwiftLiveSignInTypeFacebook:
            [self.fbLogin logOut];
            self.signInType = SwiftLiveSignInTypeNone;
            NSLog(@"twitter account signs out successfully");
            break;
        case SwiftLiveSignInTypeTwitter:
            self.signInType = SwiftLiveSignInTypeNone;
            [[Twitter sharedInstance] logOut];
            NSLog(@"twitter account signs out successfully");
            break;
        case SwiftLiveSignInTypeGoogle:
            self.signInType = SwiftLiveSignInTypeNone;
            [[GIDSignIn sharedInstance] signOut];
            NSLog(@"google account signs out successfully");
            break;
        default:
            NSLog(@"No Accounts Signing In");
            break;
    }
}
@end
