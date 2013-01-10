//
//  ZNBlockActionSheet.h
//  cocoa-utils
//
//  Created by Zdenek Nemec on 9/3/12.
//  Copyright (c) 2012 zdne.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNBlockActionSheet : UIActionSheet <UIActionSheetDelegate>

@property (copy) void (^actionBlock)(NSInteger buttonIndex);
@property (copy) void (^cancelBlock)();
@property (copy) void (^destructiveBlock)();

- (id)initWithTitle:(NSString *)title
      actionButtons:(NSArray *)buttons
  destructiveButton:(NSString *)destructiveButton
       cancelButton:(NSString *)cancelButton
        actionBlock:(void (^)(NSInteger buttonIndex))actionBlock
   destructiveBlock:(void (^)())destructiveBlock
        cancelBlock:(void (^)())cancelBlock;


@end
