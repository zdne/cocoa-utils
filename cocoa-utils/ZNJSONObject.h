//
//  ZNJSONObject.h
//  cocoa-utils
//
//  Created by Zdenek Nemec on 7/27/12.
//  Copyright (c) 2012 zdne.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZNJSONObject <NSObject>

// Initializes and sets default values for required parameters.
- (id)init;

// Initializes object with a JSON object.
- (id)initWithJSONObject:(id)object;

// Serializes as a JSON object.
- (id)JSONObject;

@optional

// Sets a JSON object
- (void)setJSONObject:(id)object;

// Merges self with a JSON object.
// Returns YES if some data were merged NO otherwise.
- (BOOL)mergeJSONObject:(id)object;

@end

// Normalizes JSON object (dictionary) returns NSDictionary or nil.
NSDictionary *ZNNormalizeJSONDictionaryObject(id object);

// Normalizes JSON array object returns NSArray or nil.
NSArray *ZNNormalizeJSONArrayObject(id object);

// Normalizes JSON string object into either NSString or nil.
NSString *ZNNormalizeJSONStringObject(id object);

// Normalizes JSON string and converts it from ISO8601 format to NSDate.
NSDate *ZNDateFromJSONStringObject(id object);

// Normalizes JSON number object into either NSNumber or nil.
NSNumber *ZNNormalizeJSONNumberObject(id object);
