//
//  ZNTextView.h
//  HelloCocoaUtils
//
//  Created by Zdenek Nemec on 1/12/13.
//  Copyright (c) 2013 zdne.org. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat ZNUITextViewInternalInset;

@interface ZNTextView : UITextView

@property (copy, nonatomic) NSString *placeholderText;
@property (retain, nonatomic) UIColor *placeholderColor;

@end
