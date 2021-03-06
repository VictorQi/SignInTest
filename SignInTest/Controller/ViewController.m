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
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <Accounts/Accounts.h>
#import "SwiftLiveOullinedLabel.h"

@import SafariServices;

@interface ViewController () <GIDSignInUIDelegate,GIDSignInDelegate,SFSafariViewControllerDelegate,FBSDKSharingDelegate>

@property (nonatomic, strong) FBSDKLoginManager *fbLogin;
@property (nonatomic, strong) SwiftLiveOullinedLabel *label;
@property (nonatomic, assign) BOOL              twitterValidate;
@property (nonatomic, strong) CADisplayLink *timer;
@property (nonatomic, assign) NSUInteger totalCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.totalCount = 20;
    
    self.twitterValidate = NO;
    
    [self getTwitterAccountInformation];
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    UIButton *fbButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    fbButton.center = CGPointMake(self.view.center.x, 100);
    [fbButton setImage:[UIImage imageNamed:@"FB-f-Logo__blue"] forState:UIControlStateNormal];
    [fbButton setContentMode:UIViewContentModeCenter];
    [fbButton addTarget:self action:@selector(logInWithFacebook) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fbButton];
    
    UIButton *twitterButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 48, 48)];
    twitterButton.center = CGPointMake(self.view.center.x, 150);
    [twitterButton setImage:[UIImage imageNamed:@"google+"] forState:UIControlStateNormal];
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
    [signOutButton setBackgroundColor:[UIColor darkGrayColor]];
    [signOutButton setTitle:@"SignOut"
                   forState:UIControlStateNormal];
    [signOutButton addTarget:self
                      action:@selector(AccountSignOut)
            forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signOutButton];
    
    UIButton *shareToGoogleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    shareToGoogleButton.frame = CGRectMake(0, 0, 120, 30);
    shareToGoogleButton.center = CGPointMake(self.view.center.x, 350);
    [shareToGoogleButton setBackgroundColor:[UIColor redColor]];
    [shareToGoogleButton setTitle:@"shareToGoogle"
                         forState:UIControlStateNormal];
    [shareToGoogleButton addTarget:self
                            action:@selector(shareToGoogle)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareToGoogleButton];
    
    
    
    UIButton *shareToFacebookButton = [UIButton buttonWithType:UIButtonTypeSystem];
    shareToFacebookButton.frame = CGRectMake(0, 0, 150, 30);
    shareToFacebookButton.center = CGPointMake(self.view.center.x, 400);
    [shareToFacebookButton setBackgroundColor:[UIColor blueColor]];
    [shareToFacebookButton setTitle:@"shareToFacebook"
                         forState:UIControlStateNormal];
    [shareToFacebookButton addTarget:self
                            action:@selector(shareToFacebook)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareToFacebookButton];
    
    UIButton *shareToTwitterButton = [UIButton buttonWithType:UIButtonTypeSystem];
    shareToTwitterButton.frame = CGRectMake(0, 0, 150, 30);
    shareToTwitterButton.center = CGPointMake(self.view.center.x, 450);
    [shareToTwitterButton setBackgroundColor:[UIColor lightTextColor]];
    [shareToTwitterButton setTitle:@"shareToTwitter"
                           forState:UIControlStateNormal];
    [shareToTwitterButton addTarget:self
                              action:@selector(shareToTwitter)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareToTwitterButton];
    
    
    UIView *giftView = [[UIView alloc]initWithFrame:CGRectMake(20, 500,
                                                               224, 26.5)];
    giftView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    
    UIImageView *avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5 * ScreenHeightRatio, 26, 26)];
    avatarView.image = [UIImage imageNamed:@"Facebook_Headquarters_Menlo_Park.jpg"];
    avatarView.contentMode = UIViewContentModeScaleAspectFill;
    [giftView addSubview:avatarView];
    
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:avatarView.frame];
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.path = ovalPath.CGPath;
    circleLayer.frame = avatarView.bounds;
    
    avatarView.layer.mask = circleLayer;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:giftView.bounds cornerRadius:(CGRectGetHeight(giftView.bounds) / 2.0)];
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = maskPath.CGPath;
    pathLayer.frame = giftView.layer.bounds;
    giftView.layer.mask = pathLayer;
    
    
    [self.view addSubview:giftView];
    
    UILabel *userNameLabel = [[UILabel alloc]
                              initWithFrame:CGRectMake(CGRectGetMaxX(avatarView.frame) + 8.5 * ScreenWidthRatio,
                                                       3 * ScreenHeightRatio,
                                                       80 * ScreenWidthRatio,
                                                       10.5 * ScreenHeightRatio)];
    userNameLabel.text = @"USER NAME";
    userNameLabel.font = [UIFont systemFontOfSize:9];
    userNameLabel.textColor = RGBA(236, 0, 61, 1.0);
    userNameLabel.textAlignment = kCTTextAlignmentLeft;
    userNameLabel.backgroundColor = [UIColor greenColor];
    [giftView addSubview:userNameLabel];
    
    UILabel *label = [[UILabel alloc]
                      initWithFrame:CGRectMake(CGRectGetMinX(userNameLabel.frame),
                                               CGRectGetMaxY(userNameLabel.frame) + 0 * ScreenHeightRatio,
                                               51 * ScreenWidthRatio,
                                               10.5 * ScreenHeightRatio)];
    label.text = @"Gift is";
    label.font = [UIFont systemFontOfSize:9];
    label.textAlignment = kCTTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    [giftView addSubview:label];
    
 
    self.label = [[SwiftLiveOullinedLabel alloc]initWithFrame:CGRectMake(0, 0, 57.5, 20.5)];
    self.label.layer.anchorPoint = CGPointMake(0.67, 0.5);
    self.label.center = CGPointMake(CGRectGetMaxX(giftView.frame), CGRectGetMidY(giftView.frame));
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.giftsCount = 168;
    self.label.font = [UIFont italicSystemFontOfSize:25];
    self.label.strokeWidth = 2.0f;
    self.label.strokeColor = [UIColor orangeColor];
    self.label.fillColor = [UIColor yellowColor];
    self.label.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.label];
    
    UIView *temp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 56, 56)];
    temp.backgroundColor = [UIColor redColor];
    temp.layer.anchorPoint = CGPointMake(0.5, 0.5);
    temp.center = CGPointMake(CGRectGetMinX(self.label.frame) - 32, CGRectGetMidY(giftView.frame));
    [self.view addSubview:temp];
    
    NSLog(@"%f, %f",CGRectGetMaxX(self.label.frame),CGRectGetMinX(giftView.frame));
    NSLog(@"%f, %f",CGRectGetMinY(temp.frame),CGRectGetMaxY(temp.frame));
}

- (void)step:(CADisplayLink *)timer{
    if (self.label.giftsCount >= self.totalCount) {
        [self stopDisplayLink];
    }else{
        self.label.giftsCount ++;
    }
}

- (void)stopDisplayLink
{
    [self.timer invalidate];
    self.timer = nil;
    self.label.giftsCount = 0;
}

- (IBAction)startAnimate:(id)sender {
    self.timer = [CADisplayLink displayLinkWithTarget:self
                                             selector:@selector(step:)];
    [self.timer addToRunLoop:[NSRunLoop mainRunLoop]
                     forMode:NSDefaultRunLoopMode];
    
    self.timer.frameInterval = 45;
}

- (void)createView:(CGRect)frame{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Sign In With Facebook

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

#pragma mark - Sign In With Twitter

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

#pragma mark - Sign In With Google

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

#pragma mark - Sign Out Method

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
            [[GIDSignIn sharedInstance] disconnect];
            break;
        default:
            NSLog(@"No Accounts Signing In");
            break;
    }
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    if (error != nil) {
        NSLog(@"Disconnect Google");
    }else{
        self.signInType = SwiftLiveSignInTypeNone;
        [[GIDSignIn sharedInstance] signOut]; // Do signout stuff
        NSLog(@"google account signs out successfully");
    }
}

#pragma mark - Show Alert

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message{
    
    NSLog(@"title is %@",title);
    NSLog(@"message is %@",message);
}

#pragma mark - Share To Google Plus

- (void)shareToGoogle{
    NSURL *url = [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Facebook_Headquarters_Menlo_Park.jpg/2880px-Facebook_Headquarters_Menlo_Park.jpg"];
    [self showGooglePlusShare:url];
}

- (void)showGooglePlusShare:(NSURL*)shareURL {
    
    // Construct the Google+ share URL
    NSURLComponents* urlComponents = [[NSURLComponents alloc]
                                      initWithString:@"https://plus.google.com/share"];
    urlComponents.queryItems = @[[[NSURLQueryItem alloc]
                                  initWithName:@"url"
                                  value:[shareURL absoluteString]]];
    NSURL* url = [urlComponents URL];
    
    if ([SFSafariViewController class]) {
        // Open the URL in SFSafariViewController (iOS 9+)
        SFSafariViewController* controller = [[SFSafariViewController alloc]
                                              initWithURL:url];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        // Open the URL in the device's browser
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - Share To Facebook

- (void)shareToFacebook{
    if (![FBSDKAccessToken currentAccessToken]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                       message:@"no facebook account signing in"
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSURL *contentURL = [[NSURL alloc]
                         initWithString:@"https://github.com"];
    NSURL *imageURL = [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Facebook_Headquarters_Menlo_Park.jpg/2880px-Facebook_Headquarters_Menlo_Park.jpg"];
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc]init];
    content.contentURL = contentURL;
    content.contentTitle = @"My Share Title";
    content.contentDescription = @"For Facebook Share Testing";
    content.imageURL = imageURL;
    content.ref = @"myRefId";
    
    FBSDKShareDialog *shareDialog = [[FBSDKShareDialog alloc]init];
    shareDialog.shareContent = content;
    shareDialog.delegate = self;
    shareDialog.fromViewController = self;
    NSError *error = nil;
    BOOL validation = [shareDialog validateWithError:&error];
    if (!validation) {
        NSLog(@"Error in sharing to facebook: %@",error);
    }else{
       [shareDialog show];
    }
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    [self showAlertWithTitle:@"Share Succeed" message:(NSString *)[results allValues]];
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    [self showAlertWithTitle:@"Share Failed" message:[NSString stringWithFormat:@"Error: %@",error]];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    [self showAlertWithTitle:@"Share Canceled" message:nil];
}

#pragma mark - Share To Twitter

- (void)getTwitterAccountInformation
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(granted) {
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            if ([accountsArray count] > 0) {
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                NSLog(@"%@",twitterAccount.username);
                NSLog(@"%@",twitterAccount.accountType);
                
                self.twitterValidate = YES;
            }
        }
    }];
}

- (void)shareToTwitter{
    if (!self.twitterValidate) {
        NSLog(@"twitter account invalidate");
        return;
    }
    
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    
    [composer setText:@"just testing"];
    [composer setURL:[NSURL URLWithString:@"https://github.com"]];
    [composer setImage:[UIImage imageWithContentsOfFile:
                        [[NSBundle mainBundle]pathForResource:@"Facebook_Headquarters_Menlo_Park"
                                                       ofType:@"jpg"]]];
    
    // Called from a UIViewController
    [composer showFromViewController:self completion:^(TWTRComposerResult result) {
        if (result == TWTRComposerResultCancelled) {
            NSLog(@"Tweet composition cancelled");
        }
        else {
            NSLog(@"Sending Tweet!");
        }
    }];
}

@end
