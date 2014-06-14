//
//  AKSwitchButton.h
//  AlkemyTest
//
//  Created by 齋間　和樹 on 2014/06/06.
//  Copyright (c) 2014年 Kazuki Saima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKSwitchButton : UIButton

// default: YES
@property (nonatomic, assign) BOOL switchAnimationEnabled;
// default: 0.3f
@property (nonatomic, assign) NSTimeInterval switchAnimationDuration;

// default: NO
@property (nonatomic, assign) BOOL isOn;

- (void)setOnImage:(UIImage *)onImage
          offImage:(UIImage *)offImage;

@end
