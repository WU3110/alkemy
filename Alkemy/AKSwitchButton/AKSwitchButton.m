//
//  AKSwitchButton.m
//  AlkemyTest
//
//  Created by 齋間　和樹 on 2014/06/06.
//  Copyright (c) 2014年 Kazuki Saima. All rights reserved.
//


#import "AKSwitchButton.h"

#define ON_IMAGE_TAG 91127
#define OFF_IMAGE_TAG 91129

@interface AKSwitchButton ()

@property (nonatomic, assign) BOOL animating;

@end

@implementation AKSwitchButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self prepare];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self prepare];
    }
    return self;
}

- (void)prepare
{
    _isOn = NO;
    _animating = NO;
    _switchAnimationEnabled = YES;
    _switchAnimationDuration = 0.3f;
    
    [self addTarget:self
             action:@selector(toggle)
   forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setOnImage:(UIImage *)onImage
          offImage:(UIImage *)offImage
{
    UIImageView *on = [[UIImageView alloc] initWithImage:onImage];
    UIImageView *off = [[UIImageView alloc] initWithImage:offImage];
    
    on.tag = ON_IMAGE_TAG;
    off.tag = OFF_IMAGE_TAG;
    
    [self addSubview:on];
    [self addSubview:off];
}

- (void)toggle
{
    [self setIsOn:!_isOn];
}

- (void)setIsOn:(BOOL)isOn
{
    UIView *on = [self viewWithTag:ON_IMAGE_TAG];
    UIView *off = [self viewWithTag:OFF_IMAGE_TAG];
    
    if (_switchAnimationEnabled && _switchAnimationDuration > 0 && !_animating)
    {
        _animating = YES;
        on.alpha = (isOn)? 0 : 1;
        off.alpha = (isOn)? 1 : 0;
        
        [UIView animateWithDuration:_switchAnimationDuration
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             on.alpha = (isOn)? 1 : 0;
                             off.alpha = (isOn)? 0 : 1;
                             
                         } completion:^(BOOL finished) {
                             _isOn = isOn;
                             _animating = NO;
                         }];
    }
    else
    {
        on.alpha = (isOn)? 1 : 0;
        off.alpha = (isOn)? 0 : 1;
        _isOn = isOn;
    }
}

@end
