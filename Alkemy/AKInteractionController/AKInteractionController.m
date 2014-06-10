//
//  AKInteractionController.m
//  TabTest
//
//  Created by TomokiNakamaru on 6/8/14.
//  Copyright (c) 2014 TomokiNakamaru. All rights reserved.
//

#import "AKInteractionController.h"

@interface AKInteractionController ()
@end

@implementation AKInteractionController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.isEnabled = YES;
    }
    return self;
}

- (AKInteractionController *)activeInteractionController
{
    return (_isActive)? self : nil;
}


@end

