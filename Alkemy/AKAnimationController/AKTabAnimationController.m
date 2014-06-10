//
//  AKTabAnimationController.m
//  TabTest
//
//  Created by TomokiNakamaru on 6/8/14.
//  Copyright (c) 2014 TomokiNakamaru. All rights reserved.
//

#import "AKTabAnimationController.h"

@implementation AKTabAnimationController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                   fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC
                 fromView:(UIView *)fromView
                   toView:(UIView *)toView
            containerView:(UIView *)containerView
{
    if (_isDirectionRight)
    {
        [self animateDirectionRight:transitionContext
                             fromVC:fromVC
                               toVC:toVC
                           fromView:fromView
                             toView:toView
                      containerView:containerView];
    }
    else
    {
        [self animateDirectionLeft:transitionContext
                            fromVC:fromVC
                              toVC:toVC
                          fromView:fromView
                            toView:toView
                     containerView:containerView];
    }
}

- (void)animateDirectionRight:(id<UIViewControllerContextTransitioning>)transitionContext
                       fromVC:(UIViewController *)fromVC
                         toVC:(UIViewController *)toVC
                     fromView:(UIView *)fromView
                       toView:(UIView *)toView
                containerView:(UIView *)containerView
{
    // add toView out of screen
    toView.transform = CGAffineTransformMakeTranslation(self.displaySize.width, 0);
    [containerView addSubview:toView];
    
    // animate
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         
                         // toView
                         toView.transform = CGAffineTransformIdentity;
                         
                         // fromView
                         CGAffineTransform scale
                         = CGAffineTransformMakeScale(0.90f, 0.90f);
                         CGAffineTransform translate
                         = CGAffineTransformMakeTranslation(-self.displaySize.width/5, 0);
                         fromView.transform = CGAffineTransformConcat(scale, translate);
                         fromView.alpha = 0.5;
                         
                     }
                     completion:^(BOOL finished) {
                         
                         fromView.transform = CGAffineTransformIdentity;
                         toView.transform = CGAffineTransformIdentity;
                         fromView.alpha = 1.0;
                         
                         BOOL cancelled = [transitionContext transitionWasCancelled];
                         
                         if (cancelled) [toView removeFromSuperview];
                         else [fromView removeFromSuperview];
                         
                         [transitionContext completeTransition:!cancelled];
                     }];
    
}

- (void)animateDirectionLeft:(id<UIViewControllerContextTransitioning>)transitionContext
                      fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC
                    fromView:(UIView *)fromView
                      toView:(UIView *)toView
               containerView:(UIView *)containerView
{
    // add toView out of screen
    toView.transform = CGAffineTransformMakeTranslation(-toView.frame.size.width*0.9, 0);
    [containerView addSubview:toView];
    
    // send toView to back
    [containerView sendSubviewToBack:toView];
    CGAffineTransform scale
    = CGAffineTransformMakeScale(0.90f, 0.90f);
    CGAffineTransform translate
    = CGAffineTransformMakeTranslation(-self.displaySize.width/5, 0);
    toView.transform = CGAffineTransformConcat(scale, translate);
    toView.alpha = 0.5;
    
    // animate
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         
                         // toView
                         toView.transform = CGAffineTransformIdentity;
                         toView.alpha = 1.0;
                         
                         // fromView
                         fromView.transform = CGAffineTransformMakeTranslation(self.displaySize.width, 0);
                     }
                     completion:^(BOOL finished) {
                         
                         fromView.transform = CGAffineTransformIdentity;
                         toView.transform = CGAffineTransformIdentity;
                         toView.alpha = 1.0;
                         
                         BOOL cancelled = [transitionContext transitionWasCancelled];
                         
                         if (cancelled) [toView removeFromSuperview];
                         else [fromView removeFromSuperview];
                         
                         [transitionContext completeTransition:!cancelled];
                     }];
    
}

- (void)setDirection:(UITabBarController *)tabBarController
              fromVC:(UIViewController *)fromVC
                toVC:(UIViewController *)toVC
{
    NSUInteger fromVCIndex = [tabBarController.viewControllers indexOfObject:fromVC];
    NSUInteger toVCIndex = [tabBarController.viewControllers indexOfObject:toVC];
    self.isDirectionRight = fromVCIndex < toVCIndex;
}

@end
