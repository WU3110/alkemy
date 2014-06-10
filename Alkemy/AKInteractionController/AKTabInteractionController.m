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
        
        self.panGestureRecognizer
        = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(onGestureRecognized:)];
        _panGestureRecognizer.delegate = self;

        [tabBarController.selectedViewController.view addGestureRecognizer:_panGestureRecognizer];
        
        [_tabBarController addObserver:self
                            forKeyPath:@"selectedViewController"
                               options:NSKeyValueObservingOptionNew
                               context:nil];
    }
    return self;
}

- (void)dealloc
{
    [_tabBarController removeObserver:self
                           forKeyPath:@"selectedViewController"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"selectedViewController"] )
    {
        [self replaceGestureRecognizer];
    }
}

- (void)replaceGestureRecognizer
{
    [_panGestureRecognizer.view removeGestureRecognizer:_panGestureRecognizer];    
    [_tabBarController.selectedViewController.view addGestureRecognizer:_panGestureRecognizer];
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
                    
                    self.shouldComplete = (rate > 0.3 || fabs(vel) > 500);
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

- (void)finishInteractiveTransition
{
    [super finishInteractiveTransition];
    [self replaceGestureRecognizer];
}

@end
