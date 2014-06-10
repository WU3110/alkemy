//
//  AKTabInteractionController.m
//  TabTest
//
//  Created by TomokiNakamaru on 6/9/14.
//  Copyright (c) 2014 TomokiNakamaru. All rights reserved.
//

#import "AKTabInteractionController.h"

@interface AKTabInteractionController ()

@property (nonatomic, assign) CGFloat lastTranslationX;

@property (nonatomic, assign) NSInteger selectedIndexOnBegin;

@end

@implementation AKTabInteractionController

- (id)initWithTabBarController:(UITabBarController *)tabBarController
{
    self = [super init];
    if (self)
    {
        self.tabBarController = tabBarController;
        
        self.requiredTranslationRate = 0.5;
        self.requiredVelocity = 500;

        _panGestureRecognizer
        = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(onGestureRecognized:)];
        _panGestureRecognizer.delegate = self;
        _panGestureRecognizer.maximumNumberOfTouches = 1;
    }
    return self;
}

- (void)cancelInteractiveTransition
{
    [super cancelInteractiveTransition];
    if (_scrollView)
    {
        _scrollView.panGestureRecognizer.enabled = YES;
    }
}

- (void)finishInteractiveTransition
{
    [super finishInteractiveTransition];
    if (_scrollView)
    {
        _scrollView.panGestureRecognizer.enabled = YES;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isEqual:_panGestureRecognizer])
    {
        if (gestureRecognizer.numberOfTouches == 0) return NO;
        
        CGPoint translation = [_panGestureRecognizer velocityInView:_tabBarController.view];
        return fabs(translation.x) > fabs(translation.y);
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)onGestureRecognized:(UIGestureRecognizer *)recognizer
{
    UIPanGestureRecognizer *pgr = (UIPanGestureRecognizer *)recognizer;

    switch (pgr.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.isActive = YES;
            _lastTranslationX = 0;
            _selectedIndexOnBegin = _tabBarController.selectedIndex;
            
            if (_scrollView)
            {
                _scrollView.panGestureRecognizer.enabled = NO;
            }

            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if (self.isActive)
            {
                CGFloat translationX = [pgr translationInView:_tabBarController.view].x;
                
                if (translationX * _lastTranslationX > 0)
                {
                    CGFloat rate = fabs(translationX)/_tabBarController.view.frame.size.width;
                    CGFloat vel = [pgr velocityInView:_tabBarController.view].x;
                    
                    if (rate >= 1.0) rate = 0.99;

                    [self updateInteractiveTransition:rate];
                    
                    self.shouldComplete
                    = (rate > _requiredTranslationRate || fabs(vel) > _requiredVelocity);
                }
                else
                {
                    [self cancelInteractiveTransition];
                    if (translationX > 0)
                    {
                        _tabBarController.selectedIndex = _selectedIndexOnBegin - 1;
                    }
                    else
                    {
                        _tabBarController.selectedIndex = _selectedIndexOnBegin + 1;
                    }
                }
                
                _lastTranslationX = translationX;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            if (self.isActive)
            {
                self.isActive = NO;
                if (self.shouldComplete)
                {
                    [self finishInteractiveTransition];
                }
                else
                {
                    [self cancelInteractiveTransition];
                }
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        {
            if (self.isActive)
            {
                self.isActive = NO;
                [self cancelInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
    
}

@end
