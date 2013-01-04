//
//  ZNViewTools.h
//  HelloCocoaUtils
//
//  Created by Zdenek Nemec on 1/4/13.
//  Copyright (c) 2013 zdne.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNViewTools : NSObject

// Rounds view corners.
+ (void)roundViewCorners:(UIView *)view radius:(CGFloat)radius border:(CGFloat)border borderColor:(UIColor *)borderColor;

// Scales image (copy) and rounds its corners.
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize cornerRadius:(CGFloat)cornerRadius;

@end
