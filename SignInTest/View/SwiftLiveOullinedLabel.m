//
//  SwiftOullinedLabel.m
//  SignInTest
//
//  Created by Victor on 16/3/29.
//  Copyright © 2016年 DotC_United. All rights reserved.
//

#import "SwiftLiveOullinedLabel.h"

static NSString *const kSwiftLiveGiftsCountString = @"× ";

@implementation SwiftLiveOullinedLabel

@synthesize giftsCount = _giftsCount;

- (void)drawTextInRect:(CGRect)rect{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, self.strokeWidth);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = self.strokeColor;
    [super drawTextInRect:rect];
    self.textColor = self.fillColor;
    CGContextSetTextDrawingMode(c, kCGTextFill);
    [super drawTextInRect:rect];
}

- (NSUInteger)giftsCount{
    return _giftsCount;
}

- (void)setGiftsCount:(NSUInteger)aGiftsCount{
    _giftsCount = aGiftsCount;
    self.text = [NSString stringWithFormat:@"%@%lu",kSwiftLiveGiftsCountString,(unsigned long)_giftsCount];

    [self addAnimationForOutlinedLabel];
}

- (void)addAnimationForOutlinedLabel{
    CAKeyframeAnimation *anim_key = [CAKeyframeAnimation animation];
    anim_key.keyPath = @"transform.scale";
    anim_key.values = @[@1.0,@2.0,@3.0,@1.8,@1.2,@0.7,@0.8,@0.9,@1.0, @1.1,@1.0];
    anim_key.duration = 0.5;
    [self.layer addAnimation:anim_key forKey:@"AnimatedOutlinedLabel"];
}
@end
