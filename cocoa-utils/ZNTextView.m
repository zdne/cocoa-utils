//
//  ZNTextView.m
//  HelloCocoaUtils
//
//  Created by Zdenek Nemec on 1/12/13.
//  Copyright (c) 2013 zdne.org. All rights reserved.
//

#import "ZNTextView.h"

@interface ZNTextView ()

@property (assign, nonatomic) BOOL drawPlaceholder;

@end

const CGFloat ZNUITextViewInternalInset = 8.0f; // lumberjack - internal UITextView insets

@implementation ZNTextView

- (id)init
{
    self = [super init];
    if (self) {
        [self initDefaults];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initDefaults];
    }
    return self;
}

- (void)initDefaults
{
    self.drawPlaceholder = NO;
    self.placeholderColor = [UIColor lightGrayColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:self];
}

- (void)updatePlaceholder
{
    self.drawPlaceholder = ([self.placeholderText length] && ![self.text length]);
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (_drawPlaceholder) {
        CGRect placeholderTextRect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        placeholderTextRect = CGRectInset(placeholderTextRect, ZNUITextViewInternalInset, ZNUITextViewInternalInset);
        if (CGRectIntersectsRect(rect, placeholderTextRect)) {
            [_placeholderColor set];
            [_placeholderText drawInRect:placeholderTextRect withAttributes:@{NSFontAttributeName: self.font}];
        }
    }
}

#pragma mark - 

- (void)setPlaceholderText:(NSString *)placeholderText
{
    _placeholderText = [placeholderText copy];
    [self updatePlaceholder];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self updatePlaceholder];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

- (void)textViewTextDidChange:(NSNotification *)notification
{
    if (notification.object != self)
        return;
    
    [self updatePlaceholder];
}

@end
