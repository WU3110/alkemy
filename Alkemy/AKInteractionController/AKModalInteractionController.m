//
//  AKModalInteractionController.m
//  TabTest
//
//  Created by TomokiNakamaru on 6/9/14.
//  Copyright (c) 2014 TomokiNakamaru. All rights reserved.
//

#import "AKModalInteractionController.h"

@interface AKModalInteractionController ()

@property (nonatomic, assign) CGFloat lastTranslationX;

@end

@implementation AKModalInteractionController

- (id)initWithViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self)
    {
        self.viewController = viewController;
        
        self.requiredTranslationRate = 0.5;
        self.requiredVelocity = 500;
        
        _panGestureRecognizer
        = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(onGestureRecognized:)];
        _panGestureRecognizer.delegate = self;
        _panGestureRecognizer.maximumNumberOfTouches = 1;
        [viewController.view addGestureRecognizer:_panGestureRecognizer];
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
    if (!self.isEnabled) return NO;

    if ([gestureRecognizer isEqual:_panGestureRecognizer])
    {
        if (gestureRecognizer.numberOfTouches == 0) return NO;
        
        CGPoint v = [_panGestureRecognizer velocityInView:_viewController.view];
        
        if (_scrollView)
        {
            if (_scrollView.contentOffset.y <= FLT_EPSILON)
            {
                return fabs(v.y) > fabs(v.x) && v.y > 0;
            }
        }
        else
        {
            return fabs(v.y) > fabs(v.x) && v.y > 0;
        }
    }
    
    return NO;
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
            
            [_viewController dismissViewControllerAnimated:YES
                                                completion:nil];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if (self.isActive)
            {
                CGFloat translationX = [pgr translationInView:_viewController.view].y;
                CGFloat rate = translationX/_viewController.view.frame.size.height;
                CGFloat vel = [pgr velocityInView:_viewController.view].y;
                
                if (rate >= 1.0) rate = 0.99;
                if (rate < 0) rate = 0;
                
                [self updateInteractiveTransition:rate];
                self.shouldComplete
                = (rate > _requiredTranslationRate || vel > _requiredVelocity);
            }
            else
            {
                self.isActive = YES;
                [_viewController dismissViewControllerAnimated:YES
                                                    completion:nil];
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
