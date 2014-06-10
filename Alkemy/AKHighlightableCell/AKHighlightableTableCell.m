//
//  AKHighlightableTableCell.m
//  AlkemyTest
//
//  Created by 齋間　和樹 on 2014/06/06.
//  Copyright (c) 2014年 Kazuki Saima. All rights reserved.
//

#import "AKHighlightableTableCell.h"

@interface AKHighlightableTableCell ()
@property (nonatomic, strong) UIView *highlightenView;
@end

@implementation AKHighlightableTableCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.highlightenView = [[UIView alloc] initWithFrame:self.bounds];
        _highlightenView.alpha = 0.f;
        _highlightenView.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:_highlightenView];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted)
    {
        [UIView animateWithDuration:0.1f
                         animations:^{
                             _highlightenView.alpha = 0.4f;
                         }];
    }
    else
    {
        [UIView animateWithDuration:0.2f
                         animations:^{
                             _highlightenView.alpha = 0.f;
                         }];
    }
}

@end
