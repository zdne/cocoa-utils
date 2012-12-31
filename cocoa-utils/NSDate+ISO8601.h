//
//  NSDate+ISO8601.h
//  cocoa-utils
//
//  Created by Zdenek Nemec on 8/6/12.
//  Copyright (c) 2012 zdne.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ISO8601)

// Creates new instance of NSDate from given ISO 8601 encoded string.
// (RFC 822 format (-0X00) and ZZZ)
+ (NSDate *)dateWithISO86001String:(NSString *)isoString;

// Returns ISO 8601 formatted string representing the date set.
- (NSString *)iso8601Date;

@end
