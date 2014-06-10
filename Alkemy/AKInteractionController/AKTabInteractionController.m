//
//  AKTabInteractionController.m
//  TabTest
//
//  Created by TomokiNakamaru on 6/9/14.
//  Copyright (c) 2014 TomokiNakamaru. All rights reserved.
//

#import "AKTabInteractionController.h"

@interface AKTabInteractionController ()

@property (nonatomic, assign) BOOL isGoingRight;

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
    NSLog(@"cancel transitioning to %ld", _tabBarController.selectedIndex);
    [super cancelInteractiveTransition];
    if (_scrollView)
    {
        _scrollView.panGestureRecognizer.enabled = YES;
    }
}

- (void)finishInteractiveTransition
{
    NSLog(@"finish transitioning to %ld", _tabBarController.selectedIndex);
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
            
            if (_scrollView)
            {
                _scrollView.panGestureRecognizer.enabled = NO;
            }
            
            CGFloat vel = [pgr velocityInView:_tabBarController.view].x;
            if (vel > 0)
            {
                _isGoingRight = YES;
                _tabBarController.selectedIndex--;
            }
            else if (vel < 0)
            {
                _isGoingRight = NO;
                _tabBarController.selectedIndex++;
            }
            else
            {
                self.isActive = NO;
            }
            
            
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if (self.isActive)
            {
                CGFloat translationX = [pgr translationInView:_tabBarController.view].x;
                CGFloat vel = [pgr velocityInView:_tabBarController.view].x;
                
                if (_isGoingRight)
                {
                    if (translationX < 0)
                    {
                        translationX = 0;
                    }
                }
                else
                {
                    if (translationX > 0)
                    {
                        translationX = 0;
                    }
                }
                
                CGFloat rate = fabs(translationX)/_tabBarController.view.frame.size.width;
                
                if (1.0 <= rate) rate = 0.99;
                if (rate <= 0) rate = 0.01;
                
                [self updateInteractiveTransition:rate];
                
                if (_isGoingRight)
                {
                    if (vel < 0)
                    {
                        vel = 0;
                    }
                }
                else
                {
                    if (0 < vel)
                    {
                        vel = 0;
                    }
                }
                
                self.shouldComplete
                = (rate > _requiredTranslationRate || fabs(vel) > _requiredVelocity);
                NSLog(@"r=%f  v=%f", rate, vel);
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
