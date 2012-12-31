//
//  NSDate+ISO8601.m
//  cocoa-utils
//
//  Created by Zdenek Nemec on 8/6/12.
//  Copyright (c) 2012 zdne.org. All rights reserved.
//

#import "NSDate+ISO8601.h"

@implementation NSDate (ISO8601)

+ (NSDate *)dateWithISO86001String:(NSString *)isoString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    return [dateFormatter dateFromString:isoString];
}

- (NSString *)iso8601Date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    return [dateFormatter stringFromDate:self];
}

@end
