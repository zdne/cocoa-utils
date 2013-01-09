//
//  ZNViewTools.m
//  cocoa-utils
//
//  Created by Zdenek Nemec on 1/4/13.
//  Copyright (c) 2013 zdne.org. All rights reserved.
//

#import "ZNViewTools.h"
#import <QuartzCore/QuartzCore.h>

@implementation ZNViewTools

+ (void)roundViewCorners:(UIView *)view radius:(CGFloat)radius border:(CGFloat)border borderColor:(UIColor *)borderColor
{
    CALayer* layer = view.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:radius];
    
    if (border > 0) {
        [layer setBorderWidth:border];
        [layer setBorderColor:[borderColor CGColor]];
    }
    else {
        [layer setBorderWidth:0];
    }
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize cornerRadius:(CGFloat)cornerRadius
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [[UIScreen mainScreen] scale]);
    
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height) cornerRadius:cornerRadius] addClip];
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return newImage;
}

@end
