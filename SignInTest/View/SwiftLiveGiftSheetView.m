//
//  SwiftLiveGiftSheetView.m
//  SignInTest
//
//  Created by Victor on 16/3/25.
//  Copyright © 2016年 DotC_United. All rights reserved.
//

#import "SwiftLiveGiftSheetView.h"

@interface SwiftLiveGiftSheetView ()

@property (nonatomic, copy) NSArray<NSNumber *> *existenceArray;

@end

@implementation SwiftLiveGiftSheetView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _existenceArray = @[@0,@0,@0];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        _existenceArray = @[@0,@0,@0];
        
    }
    
    return self;
}

- (UIView *)creatGiftViewWithContent:(NSDictionary *)contentDict{
    UIView *giftView = [[UIView alloc]initWithFrame:CGRectMake(20, 500,
                                                               self.bounds.size.width * 0.67, 60)];
    giftView.backgroundColor = [UIColor redColor];
    
    UIImageView *avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    avatarView.center = CGPointMake(30, 30);
    avatarView.image = [UIImage imageNamed:@"Facebook_Headquarters_Menlo_Park.jpg"];
    avatarView.contentMode = UIViewContentModeScaleAspectFill;
    [giftView addSubview:avatarView];
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:avatarView.center radius:(CGRectGetHeight(avatarView.bounds)/2) startAngle:0.0 endAngle:2 * M_PI clockwise:YES];
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.path = circlePath.CGPath;
    circleLayer.frame = avatarView.bounds;
    
    avatarView.layer.mask = circleLayer;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:giftView.bounds cornerRadius:(CGRectGetHeight(giftView.bounds) / 2.0)];
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = maskPath.CGPath;
    pathLayer.frame = giftView.layer.bounds;
    
    giftView.layer.mask = pathLayer;

    return giftView;
}



@end
