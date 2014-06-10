//
//  AKInteractionController.h
//  TabTest
//
//  Created by TomokiNakamaru on 6/8/14.
//  Copyright (c) 2014 TomokiNakamaru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKInteractionController : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL shouldComplete;

- (AKInteractionController *)activeInteractionController;

@end
