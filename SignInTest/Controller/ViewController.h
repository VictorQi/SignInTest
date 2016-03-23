//
//  ViewController.h
//  SignInTest
//
//  Created by Victor on 16/3/22.
//  Copyright © 2016年 DotC_United. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, SwiftLiveSignInType){
    SwiftLiveSignInTypeNone     = 0,
    SwiftLiveSignInTypeTwitter  = 1 << 0,
    SwiftLiveSignInTypeFacebook = 1 << 1,
    SwiftLiveSignInTypeGoogle   = 1 << 2
};

@interface ViewController : UIViewController
@property (nonatomic, assign) SwiftLiveSignInType signInType;
@end

