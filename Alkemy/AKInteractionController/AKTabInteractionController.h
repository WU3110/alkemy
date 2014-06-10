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

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, assign) CGFloat requiredVelocity;
@property (nonatomic, assign) CGFloat requiredTranslationRate;

@property (nonatomic, weak) UITabBarController *tabBarController;
@property (nonatomic, weak) UIScrollView *scrollView;


- (id)initWithTabBarController:(UITabBarController *)tabBarController;

@end
