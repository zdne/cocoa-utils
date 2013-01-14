//
//  UITableView+Ext.h
//  coredump
//
//  Created by Zdenek Nemec on 1/14/13.
//  Copyright (c) 2013 zdne.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Ext)

// Hides UITableViewStylePlain separators for empty rows by adding empty footer view.
- (void)hideEmptySeparators;

// Performs UITableView updates specified in <updates> block. Calls <completion> after finish.
// <updates> are executed within beginUpdates / endUpdates block. 
- (void)performUpdates:(void(^)())updates completion:(void(^)(BOOL finished))completion animated:(BOOL)animated;

@end
