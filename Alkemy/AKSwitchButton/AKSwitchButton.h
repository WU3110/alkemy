//
//  AKSwitchButton.h
//  AlkemyTest
//
//  Created by 齋間　和樹 on 2014/06/06.
//  Copyright (c) 2014年 Kazuki Saima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKSwitchButton : UIButton

@property (nonatomic, copy) NSString *onStateImageName;
@property (nonatomic, copy) NSString *offStateImageName;

// default is YES
@property (nonatomic, assign) BOOL switchAnimationEnabled;
// default is 0.3f
@property (nonatomic, assign) NSTimeInterval switchAnimationDuration;

// default state is NO(off state)
@property (nonatomic, assign, readonly) BOOL isOn;

// Need to call either following two methods
- (void)setupWithInitialState:(BOOL)isOn;
- (void)setupWithOnStateImageName:(NSString *)onStateImageName
                offStateImageName:(NSString *)offStateImageName
                     initialState:(BOOL)isOn;
- (void)switchState:(BOOL)isOn;
@end
