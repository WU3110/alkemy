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
    UIEdgeInsets insets = scrollView.contentInset;
    UIEdgeInsets newInsets
    = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom+100, insets.right);
    [scrollView setContentInset:newInsets];
    
    [indicator setCenter:CGPointMake(scrollView.contentSize.width/2,
                                     scrollView.contentSize.height+50)];
    indicator.tag = INDICATOR_TAG;
    [scrollView addSubview:indicator];
}

+ (void)hideLoadingViewOnBottom:(UIScrollView *)scrollView
{
    UIView *v = [scrollView viewWithTag:INDICATOR_TAG];
    [v removeFromSuperview];
    
    UIEdgeInsets insets = scrollView.contentInset;
    UIEdgeInsets newInsets
    = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom-100, insets.right);
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [scrollView setContentInset:newInsets];
                     }
                     completion:nil];
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
        void (^watcher_and_original_code)(id, UIScrollView *) = ^(id self, UIScrollView *scrollView) {
            [self performSelector:@selector(akdl_watcher:) withObject:scrollView];
            [self performSelector:@selector(__akdl_original_scrollViewDidScroll:) withObject:scrollView];
        };
        // enable dynamic load
        void (^enable_dynamic_code)(id, UIScrollView *) = ^(id self, UIScrollView *scrollView) {
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
        //  1. replace method if scrollViewDelegate does NOT have the method
        //  2. add method if scrollViewDelegate does NOT have the method
        if ([scrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
        {
            // replace methods

            // svd.scrollViewDelegate -> svd.original_scrollViewDidScroll
            Method original = class_getInstanceMethod([scrollViewDelegate class],
                                                      @selector(scrollViewDidScroll:));
            class_addMethod([scrollViewDelegate class],
                            NSSelectorFromString(@"__akdl_original_scrollViewDidScroll:"),
                            method_getImplementation(original),
                            method_getTypeEncoding(original));

            // akdl.akdl_watcher -> svd.akdl_watcher
            Method watcher = class_getInstanceMethod([self class],
                                                     @selector(akdl_watcher:));
            class_addMethod([scrollViewDelegate class],
                            NSSelectorFromString(@"akdl_watcher:"),
                            watcher_imp,
                            method_getTypeEncoding(watcher));

            
            // akdl.akdl_watcher_and_original_method -> svd.scrollViewDelegate
            Method binded = class_getInstanceMethod([self class],
                                                    @selector(akdl_watcher_and_original_method:));
            class_replaceMethod([scrollViewDelegate class],
                                NSSelectorFromString(@"scrollViewDidScroll:"),
                                watcher_and_original_imp,
                                method_getTypeEncoding(binded));
        }
        else
        {
            // akdl.akdl_watcher -> svd.akdl_watcher
            Method watcher = class_getInstanceMethod([self class],
                                                     @selector(akdl_watcher:));
            class_addMethod([scrollViewDelegate class],
                            NSSelectorFromString(@"scrollViewDidScroll:"),
                            watcher_imp,
                            method_getTypeEncoding(watcher));
        }
        
        
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
        Method binded = class_getInstanceMethod([self class],
                                                @selector(akdl_enableDynamicLoad));
        class_replaceMethod([dynamicLoadDelegate class],
                            NSSelectorFromString(@"enableDynamicLoad"),
                            enable_dynamic_imp,
                            method_getTypeEncoding(binded));

    }
}


//// watcher code
//- (void)akdl_watcher:(UIScrollView *)scrollView
//{
//    CGFloat visibleBottom
//    = scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.size.height;
//
//    BOOL enabled = [objc_getAssociatedObject(self, "__akdl_enabled") boolValue];
//    CGFloat ignitionHeight = [objc_getAssociatedObject(self, "__akdl_ignition_height") floatValue];
//    
//    if (enabled
//        && visibleBottom < ignitionHeight
//        && 0 < scrollView.contentSize.height)
//    {
//        id <AKDynamicLoadDelegate> delegate
//        = objc_getAssociatedObject(self, "__akdl_dynamic_load_delegate");
//
//        [delegate didReachIgnitionHeight];
//        objc_setAssociatedObject(self,
//                                 "__akdl_enabled",
//                                 @NO,
//                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//}
//
//- (void)akdl_watcher_and_original_method:(UIScrollView *)scrollView
//{
//    [self performSelector:@selector(akdl_watcher:) withObject:scrollView];
//    [self performSelector:@selector(__akdl_original_scrollViewDidScroll:) withObject:scrollView];
//}
//
//// enable code
//- (void)akdl_enableDynamicLoad
//{
//    id <AKDynamicLoadDelegate> scrollViewDelegate
//    = objc_getAssociatedObject(self, "__akdl_scroll_view_delegate");
//
//    objc_setAssociatedObject(scrollViewDelegate,
//                             "__akdl_enabled",
//                             @YES,
//                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self performSelector:@selector(__akdl_original_enableDynamicLoad)];
//}


// dummy for escaping compiler warning
- (void)akdl_enableDynamicLoad{}
- (void)akdl_watcher_and_original_method:(UIScrollView *)scrollView{}
- (void)akdl_watcher:(UIScrollView *)scrollView{}
- (void)__akdl_original_scrollViewDidScroll:(UIScrollView *)scrollView{}
- (void)__akdl_original_enableDynamicLoad{}

@end
