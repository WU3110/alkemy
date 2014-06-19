//
//  AKDynamicLoader.m
//  FIND
//
//  Created by TomokiNakamaru on 6/6/14.
//  Copyright (c) 2014 Kazuki Saima. All rights reserved.
//

#import "AKDynamicLoadHelper.h"

#import <objc/runtime.h>

#define INDICATOR_TAG 138113

@implementation AKDynamicLoadHelper

# pragma mark visible change
+ (void)showLoadingViewOnBottom:(UIScrollView *)scrollView
                      indicator:(UIView *)indicator
{
    
    [indicator setCenter:CGPointMake(scrollView.contentSize.width/2,
                                     scrollView.contentSize.height+50)];
    indicator.tag = INDICATOR_TAG;
    [scrollView addSubview:indicator];
    
    
    UIEdgeInsets insets = scrollView.contentInset;
    UIEdgeInsets newInsets
    = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom+100, insets.right);
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [scrollView setContentInset:newInsets];
                     }
                     completion:^(BOOL finished) {
                     }];
    
}

+ (void)hideLoadingViewOnBottom:(UIScrollView *)scrollView
                     completion:(void (^)(BOOL))completion
{
    UIEdgeInsets insets = scrollView.contentInset;
    UIEdgeInsets newInsets
    = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom-100, insets.right);
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [scrollView setContentInset:newInsets];
                     }
                     completion:^(BOOL finished) {
                         UIView *v = [scrollView viewWithTag:INDICATOR_TAG];
                         [v removeFromSuperview];
                         
                         completion(finished);
                     }];
}

# pragma mark dynamic load system
+ (void)makeDynamicWithScrollViewDelegate:(id<UIScrollViewDelegate>)scrollViewDelegate
                                 delegate:(id<AKDynamicLoadDelegate>)dynamicLoadDelegate
                           ignitionHeight:(CGFloat)ignitionHeight
{
    if (scrollViewDelegate != nil && dynamicLoadDelegate != nil)
    {
        // blocks for method imp
        // watcher code
        void (^watcher_code)(id, UIScrollView *) = ^(id self, UIScrollView *scrollView) {
            CGFloat visibleBottom
            = scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.size.height;
            
            BOOL enabled = [objc_getAssociatedObject(self, "__akdl_enabled") boolValue];
            CGFloat ignitionHeight = [objc_getAssociatedObject(self, "__akdl_ignition_height") floatValue];
            
            if (enabled
                && visibleBottom < ignitionHeight
                && 0 < scrollView.contentSize.height)
            {
                id <AKDynamicLoadDelegate> delegate
                = objc_getAssociatedObject(self, "__akdl_dynamic_load_delegate");
                
                objc_setAssociatedObject(self,
                                         "__akdl_enabled",
                                         @NO,
                                         OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [delegate didReachIgnitionHeight];
            }
        };
        // watcher with original scrollViewDidScroll
        void (^watcher_and_original_code)(id, UIScrollView *, BOOL) = ^(id self, UIScrollView *scrollView, BOOL willDecelerate) {
            [self performSelector:@selector(akdl_watcher:willDecelerate:) withObject:scrollView];
            [self performSelector:@selector(__akdl_original_scrollViewDidEndDragging:willDecelerate:) withObject:scrollView];
        };
        // enable dynamic load
        void (^enable_dynamic_code)(id) = ^(id self) {
            id <AKDynamicLoadDelegate> scrollViewDelegate
            = objc_getAssociatedObject(self, "__akdl_scroll_view_delegate");
            
            [self performSelector:@selector(__akdl_original_enableDynamicLoad)];
            objc_setAssociatedObject(scrollViewDelegate,
                                     "__akdl_enabled",
                                     @YES,
                                     OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        };
        
        IMP watcher_imp = imp_implementationWithBlock(watcher_code);
        IMP watcher_and_original_imp = imp_implementationWithBlock(watcher_and_original_code);
        IMP enable_dynamic_imp = imp_implementationWithBlock(enable_dynamic_code);
        
        // add property to scrollViewDelegate
        // - dynamic load delegate
        objc_setAssociatedObject(scrollViewDelegate,
                                 "__akdl_dynamic_load_delegate",
                                 dynamicLoadDelegate,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        // - ignition height
        objc_setAssociatedObject(scrollViewDelegate,
                                 "__akdl_ignition_height",
                                 @(ignitionHeight),
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        // - flag for avoiding repeating call of 'didReachIgnitionHeight'
        objc_setAssociatedObject(scrollViewDelegate,
                                 "__akdl_enabled",
                                 @YES,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        
        // inject watcher code into scrollViewDelegate.scrollVoewDidScroll
        NSAssert([scrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)],
                 @"Please implement - (void)scrollViewDidEndDragging:willDecelerate:");
        
        // replace methods
        
        // svd.scrollViewDelegate -> svd.original_scrollViewDidScroll
        Method original = class_getInstanceMethod([scrollViewDelegate class],
                                                  @selector(scrollViewDidEndDragging:willDecelerate:));
        class_addMethod([scrollViewDelegate class],
                        NSSelectorFromString(@"__akdl_original_scrollViewDidEndDragging:willDecelerate:"),
                        method_getImplementation(original),
                        method_getTypeEncoding(original));
        
        // akdl.akdl_watcher -> svd.akdl_watcher
        Method watcher = class_getInstanceMethod([self class],
                                                 @selector(akdl_watcher:willDecelerate:));
        class_addMethod([scrollViewDelegate class],
                        NSSelectorFromString(@"akdl_watcher:willDecelerate:"),
                        watcher_imp,
                        method_getTypeEncoding(watcher));
        
        
        // akdl.akdl_watcher_and_original_method -> svd.scrollViewDelegate
        Method binded_scrollview_did_scroll = class_getInstanceMethod([self class],
                                                                      @selector(akdl_watcher_and_original_method:));
        class_replaceMethod([scrollViewDelegate class],
                            NSSelectorFromString(@"scrollViewDidEndDragging:willDecelerate:"),
                            watcher_and_original_imp,
                            method_getTypeEncoding(binded_scrollview_did_scroll));
        
        // replace dynamicLoadDelegate.enableDynamicLoad
        // - make it possible to set enable = YES from user
        
        // add property
        objc_setAssociatedObject(dynamicLoadDelegate,
                                 "__akdl_scroll_view_delegate",
                                 scrollViewDelegate,
                                 OBJC_ASSOCIATION_ASSIGN);
        
        // move method
        Method originalEnableDL = class_getInstanceMethod([dynamicLoadDelegate class],
                                                          @selector(enableDynamicLoad));
        class_addMethod([dynamicLoadDelegate class],
                        NSSelectorFromString(@"__akdl_original_enableDynamicLoad"),
                        method_getImplementation(originalEnableDL),
                        method_getTypeEncoding(originalEnableDL));
        
        // replace method
        Method binded_enable_dynamicload = class_getInstanceMethod([self class],
                                                                   @selector(akdl_enableDynamicLoad));
        class_replaceMethod([dynamicLoadDelegate class],
                            NSSelectorFromString(@"enableDynamicLoad"),
                            enable_dynamic_imp,
                            method_getTypeEncoding(binded_enable_dynamicload));
        
    }
}


// dummy for escaping compiler warning
- (void)akdl_enableDynamicLoad{}
- (void)akdl_watcher_and_original_method:(UIScrollView *)scrollView{}
- (void)akdl_watcher:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{}

- (void)__akdl_original_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{}
- (void)__akdl_original_enableDynamicLoad{}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{}
//
@end
