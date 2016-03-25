//
//  SwiftLiveAnimationView.m
//  SignInTest
//
//  Created by Victor on 16/3/23.
//  Copyright © 2016年 DotC_United. All rights reserved.
//

#import "SwiftLiveAnimationView.h"

@implementation SwiftLiveAnimationView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setPopHeartView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setPopHeartView];
    }
    
    return self;
}


- (void)setPopHeartView{
    
}

- (void)setGiftView{
    
}
@end
