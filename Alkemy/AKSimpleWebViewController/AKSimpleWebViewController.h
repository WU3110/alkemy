//
//  AKSimpleWebViewController.h
//  AlkemyTest
//
//  Created by 齋間　和樹 on 2014/06/06.
//  Copyright (c) 2014年 Kazuki Saima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKSimpleWebViewController : UIViewController
- (instancetype)initWithURLString:(NSString *)urlString;
- (instancetype)initWithURL:(NSURL *)url;
- (void)setupNavigationItems:(NSDictionary *)items;
// the arg 'items'
// 'Left' : LeftItem
// 'Title' : TitleString
// 'Right' : RightItem

@property (nonatomic, strong) NSURL *url;

@end
