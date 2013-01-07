//
//  ZNJSONObject.m
//  cocoa-utils
//
//  Created by Zdenek Nemec on 1/7/13.
//  Copyright (c) 2013 zdne.org. All rights reserved.
//

#import "ZNJSONObject.h"
#import "NSDate+ISO8601.h"

NSDictionary *ZNNormalizeJSONDictionaryObject(id object)
{
    if ([object isKindOfClass:[NSDictionary class]])
        return object;
    
    return nil;
}

NSArray *ZNNormalizeJSONArrayObject(id object)
{
    if ([object isKindOfClass:[NSArray class]])
        return object;
    
    return nil;
}

NSString *ZNNormalizeJSONStringObject(id object)
{
    if ([object isKindOfClass:[NSString class]])
        return object;
    
    return nil;
}

NSDate *ZNDateFromJSONStringObject(id object)
{
    NSString *dateString = ZNNormalizeJSONStringObject(object);
    if (!dateString)
        return nil;
    
    NSDate *date = [NSDate dateWithISO86001String:dateString];
    return date;
}

NSNumber *ZNNormalizeJSONNumberObject(id object)
{
    if ([object isKindOfClass:[NSNumber class]])
        return object;
    
    return nil;
}
