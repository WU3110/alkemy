//
//  AKTabInteractionController.h
//  TabTest
//
//  Created by TomokiNakamaru on 6/9/14.
//  Copyright (c) 2014 TomokiNakamaru. All rights reserved.
//

#import "AKInteractionController.h"

@interface AKTabInteractionController : AKInteractionController
<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, weak) UITabBarController *tabBarController;

- (id)initWithTabBarController:(UITabBarController *)tabBarController;

@end
