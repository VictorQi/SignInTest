//
//  ViewController.h
//  SignInTest
//
//  Created by Victor on 16/3/22.
//  Copyright © 2016年 DotC_United. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define Screen47Inch (kScreenWidth == 375)
#define Screen55Inch (kScreenWidth == 414)

#define ScreenWidthRatio kScreenWidth / 320.0
#define ScreenHeightRatio kScreenHeight / 568.0


typedef NS_OPTIONS(NSUInteger, SwiftLiveSignInType){
    SwiftLiveSignInTypeNone     = 0,
    SwiftLiveSignInTypeTwitter  = 1 << 0,
    SwiftLiveSignInTypeFacebook = 1 << 1,
    SwiftLiveSignInTypeGoogle   = 1 << 2
};

@interface ViewController : UIViewController
@property (nonatomic, assign) SwiftLiveSignInType signInType;
@end

