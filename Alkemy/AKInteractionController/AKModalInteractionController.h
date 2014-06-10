//
//  AKModalInteractionController.h
//  TabTest
//
//  Created by TomokiNakamaru on 6/9/14.
//  Copyright (c) 2014 TomokiNakamaru. All rights reserved.
//

#import "AKInteractionController.h"

@interface AKModalInteractionController : AKInteractionController

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, weak) UIViewController *viewController;

- (id)initWithViewController:(UIViewController *)viewController;

@end
