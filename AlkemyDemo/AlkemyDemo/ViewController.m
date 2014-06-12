//
//  ViewController.m
//  AlkemyDemo
//
//  Created by TomokiNakamaru on 6/10/14.
//  Copyright (c) 2014 TomokiNakamaru. All rights reserved.
//

#import "ViewController.h"

#import "AKSimpleWebViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *donebutton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)action:(id)sender
{
    AKSimpleWebViewController *vc = [[AKSimpleWebViewController alloc] initWithURLString:@"http://www.heartlay-studio.co.jp"];
    [vc setupNavigationItems:@{@"Left": _donebutton,
                               @"Title": @"Web"}];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav
                       animated:YES completion:nil];
}

- (IBAction)actionClose:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}
@end
