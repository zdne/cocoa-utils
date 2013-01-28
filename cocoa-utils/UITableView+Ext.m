//
//  UITableView+Ext.m
//  coredump
//
//  Created by Zdenek Nemec on 1/14/13.
//  Copyright (c) 2013 zdne.org. All rights reserved.
//

#import "UITableView+Ext.h"

@implementation UITableView (Ext)

- (void)hideEmptySeparators
{
    if (self.style == UITableViewStylePlain) {
        
        // as per: http://stackoverflow.com/a/3204316/634940
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
        v.backgroundColor = [UIColor clearColor];
        [self setTableFooterView:v];
    }
}

- (void)performUpdates:(void(^)())updates completion:(void(^)(BOOL finished))completion animated:(BOOL)animated
{
    __block UITableView *blockSelf = self;
    [UIView animateWithDuration:0.0 animations:^{
        
        if (!animated)
            [UIView setAnimationsEnabled:NO];
        
        [blockSelf beginUpdates];
        
        if (updates)
            updates();
        
        [blockSelf endUpdates];
        
        if (!animated)
            [UIView setAnimationsEnabled:YES];
        
    } completion:^(BOOL finished) {
        
        if (completion)
            completion(finished);
    }];
}

@end
