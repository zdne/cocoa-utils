//
//  ZNPersistentCache.h
//  cocoa-utils
//
//  Created by Zdenek Nemec on 1/4/13.
//  Copyright (c) 2013 zdne.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNPersistentCache : NSCache

typedef void (^ZNPersistentCacheCompletionHandler)(id<NSCoding> object);

// Returns the singleton instance.
+ (ZNPersistentCache *)sharedCache;

// Retrieves an object from cache or backing persistent cache if exists.
- (void)cachedObjectForKey:(NSString *)key completion:(ZNPersistentCacheCompletionHandler)completionHandler;

// Adds an object to cache with optional time to live.
// Replaces existing object for the same key if exists.
- (void)cacheObject:(id<NSCoding>)object forKey:(NSString *)key;

@end