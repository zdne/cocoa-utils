//
//  ZNBlockActionSheet.m
//  cocoa-utils
//
//  Created by Zdenek Nemec on 9/3/12.
//  Copyright (c) 2012 zdne.org. All rights reserved.
//

#import "ZNBlockActionSheet.h"

@implementation ZNBlockActionSheet

- (id)initWithTitle:(NSString *)title
      actionButtons:(NSArray *)actionButtons
  destructiveButton:(NSString *)destructiveButton
       cancelButton:(NSString *)cancelButton
        actionBlock:(void (^)(NSInteger buttonIndex))actionBlock
   destructiveBlock:(void (^)())destructiveBlock
        cancelBlock:(void (^)())cancelBlock
{
    
    self = [super initWithTitle:title
                       delegate:self
              cancelButtonTitle:nil
         destructiveButtonTitle:nil
              otherButtonTitles:nil];
    if (self) {
        NSInteger buttonCount = 0;
        if ([actionButtons count] > 0) {
            for (NSString *title in actionButtons) {
                [self addButtonWithTitle:title];
                buttonCount++;
            }
            _actionBlock = [actionBlock copy];
        }
        
        if (destructiveButton) {
            [self addButtonWithTitle:destructiveButton];
            [self setDestructiveButtonIndex:buttonCount];
            buttonCount++;
            _destructiveBlock = [destructiveBlock copy];
        }
        
        if (cancelButton) {
            [self addButtonWithTitle:cancelButton];
            [self setCancelButtonIndex:buttonCount];
            buttonCount++;
            _cancelBlock = [cancelBlock copy];
        }
    }
    
    return self;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSAssert(actionSheet == self, @"action sheet missmatch");
    if (buttonIndex == [self cancelButtonIndex]) {
        if (self.cancelBlock)
            self.cancelBlock();
    }
    else if (buttonIndex == [self destructiveButtonIndex]) {
        if (self.destructiveBlock)
            self.destructiveBlock();
    }
    else {
        if (self.actionBlock)
            self.actionBlock(buttonIndex);
    }
}
@end
