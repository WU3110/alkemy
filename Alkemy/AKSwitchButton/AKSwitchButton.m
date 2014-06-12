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

@interface AKSwitchButton ()
@property (nonatomic, strong) UIImageView *onImageView;
@property (nonatomic, strong) UIImageView *offImageView;
@end

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

    self.onImageView
    = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_onStateImageName]];
    _onImageView.tag = kOnStateImageViewTag;
    self.offImageView
    = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_offStateImageName]];
    _offImageView.tag = kOffStateImageViewTag;
    
    [self addSubview:_offImageView];
    [self addSubview:_onImageView];
    
    _onImageView.alpha = self.isOn ? 1.f : 0.f;
    _offImageView.alpha = self.isOn ? 0.f : 1.f;
}

- (void)startSwitching:(AKSwitchButton *)button
{
    if (_switchAnimationEnabled)
    {
        [UIView animateWithDuration:_switchAnimationDuration
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _onImageView.alpha = self.isOn ? 0.f : 1.f;
                             _offImageView.alpha = self.isOn ? 1.f : 0.f;                         } completion:^(BOOL finished) {
                             _isOn = !_isOn;
                         }];

    }
    else
    {
        _onImageView.alpha = self.isOn ? 0.f : 1.f;
        _offImageView.alpha = self.isOn ? 1.f : 0.f;
        _isOn = !_isOn;
    }
}

- (void)switchState:(BOOL)isOn
{
    _onImageView.alpha = self.isOn ? 0.f : 1.f;
    _offImageView.alpha = self.isOn ? 1.f : 0.f;
    _isOn = !_isOn;
}
@end
