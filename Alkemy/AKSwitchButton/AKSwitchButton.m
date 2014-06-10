//
//  AKSwitchButton.m
//  AlkemyTest
//
//  Created by 齋間　和樹 on 2014/06/06.
//  Copyright (c) 2014年 Kazuki Saima. All rights reserved.
//


#import "AKSwitchButton.h"

NS_ENUM(NSUInteger, ImageViewTag) {
    kOnStateImageViewTag = 1000,
    kOffStateImageViewTag
};

@implementation AKSwitchButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setDefaultValues];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setDefaultValues];
    }
    return self;
}

- (void)_setDefaultValues
{
    _isOn = NO;
    _switchAnimationEnabled = YES;
    _switchAnimationDuration = 0.3f;
}

- (void)setupWithInitialState:(BOOL)isOn
{
    _isOn = isOn;
    
    [self _setup];
}


- (void)setupWithOnStateImageName:(NSString *)onStateImageName
                offStateImageName:(NSString *)offStateImageName
                     initialState:(BOOL)isOn
{
    self.onStateImageName = onStateImageName;
    self.offStateImageName = offStateImageName;
    _isOn = isOn;
    
    [self _setup];
}

- (void)_setup
{
    [self addTarget:self
             action:@selector(startSwitching:)
   forControlEvents:UIControlEventTouchUpInside];

    UIImageView *onImageView
    = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_onStateImageName]];
    onImageView.tag = kOnStateImageViewTag;
    UIImageView *offImageView
    = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_offStateImageName]];
    offImageView.tag = kOffStateImageViewTag;
    
    [self addSubview:offImageView];
    [self addSubview:onImageView];
    if (!_isOn) onImageView.alpha = 0.f;
}

- (void)startSwitching:(AKSwitchButton *)button
{
    CGFloat alpha = _isOn ? 0.f : 1.f;
    UIImageView *onImageView = (UIImageView *)[self viewWithTag:kOnStateImageViewTag];
    if (_switchAnimationDuration)
    {
        [UIView animateWithDuration:_switchAnimationDuration
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             onImageView.alpha = alpha;
                         } completion:^(BOOL finished) {
                             _isOn = !_isOn;
                         }];

    }
    else
    {
        onImageView.alpha = 0.f;
        _isOn = !_isOn;
    }
}

@end
