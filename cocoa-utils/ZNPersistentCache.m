//
//  ZNPersistentCache.m
//  cocoa-utils
//
//  Created by Zdenek Nemec on 1/4/13.
//  Copyright (c) 2013 zdne.org. All rights reserved.
//

#import "ZNPersistentCache.h"
#import "ZNPersistentCache+Private.h"
#import "ZNCoordinatedFileManager.h"
#import "NSString+NSHash.h"
#import "ZNLog.h"

static NSString * const PersistentCacheDirectoryName = @"org.zdne.persistent-cache";
static NSString * const PersistentCacheFileExtension = @"pcache";

@interface ZNPersistentCache ()

@property (copy, nonatomic) NSString *cachePath;
@property (strong, nonatomic) ZNCoordinatedFileManager *fileManager;

@end

@implementation ZNPersistentCache : NSCache

+ (ZNPersistentCache *)sharedCache
{
    static ZNPersistentCache *_sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCache = [[ZNPersistentCache alloc] init];
    });
    
    return _sharedCache;
}

- (id)init
{
    self = [super init];
    if (self) {
        _cachePath = [ZNPersistentCache cachePath];
        _fileManager = [[ZNCoordinatedFileManager alloc] init];
    }
    return self;
}

#pragma mark - Caching

- (void)cachedObjectForKey:(NSString *)key completion:(ZNPersistentCacheCompletionHandler)completionHandler
{
    if (![key length]) {
        if (completionHandler)
            completionHandler(nil);
        return;
    }
    
    NSString *keyHash = [key MD5];
    id object = [self objectForKey:keyHash];
    if (object) {
        if (completionHandler)
            completionHandler(object);
        return;
    }
    
    // retreive from persistent store if available
    __block ZNPersistentCache *blockSelf = self;
    [self retrieveObjectFromStoreForKeyHash:keyHash
                                 completion:^(id<NSCoding> object) {

                                     if (object)
                                         [blockSelf setObject:object forKey:keyHash]; // cache in self
                                     
                                     if (completionHandler)
                                         completionHandler(object);
                                 }];
}

- (void)cacheObject:(id<NSCoding>)object forKey:(NSString *)key
{
    if (!object || ![key length])
        return;
    
    NSString *keyHash = [key MD5];
    [self setObject:object forKey:keyHash];
    
    // update store
    [self storeObject:object forKeyHash:keyHash];

    return;
}

#pragma mark - Purge

- (void)purgeCacheWithMaximumAge:(NSTimeInterval)age
{
    __block ZNPersistentCache *blockSelf = self;
    [self.fileManager contentOfDirectoryAtURL:[NSURL fileURLWithPath:self.cachePath]
                                   completion:^(NSArray *content, NSError *error) {
                                       
                                       for (NSURL *url in content) {
                                           NSString *keyHash = [ZNPersistentCache keyHashForFileURL:url];
                                           if (![keyHash length])
                                               continue;
                                           
                                           [blockSelf removeObjectForKeyHash:keyHash
                                                                       atURL:url
                                                                  maximumAge:age];
                                       }
                                   }];
}

- (void)removeObjectForKeyHash:(NSString *)keyHash atURL:(NSURL *)url maximumAge:(NSTimeInterval)age
{
    if (age == 0) {
        [self.fileManager removeFileAtURL:url completion:nil];
        [self removeObjectForKey:keyHash];
        return;
    }
    
    NSDate *dateTreshold = [[NSDate date] dateByAddingTimeInterval:-age];
    __block ZNPersistentCache *blockSelf = self;
    [self.fileManager attributesOfItemAtURL:url
                                 completion:^(NSDictionary *attributes, NSError *error) {
                                     NSDate *modificationDate = attributes[NSFileModificationDate];
                                     if (error && !modificationDate)
                                         return;

                                     if ([modificationDate compare:dateTreshold] == NSOrderedAscending) {
                                         [blockSelf.fileManager removeFileAtURL:url completion:nil];
                                         [blockSelf removeObjectForKey:keyHash];
                                     }
                                     
                                 }];
}

+ (NSString *)keyHashForFileURL:(NSURL *)url
{
    if (![[url pathExtension] isEqualToString:PersistentCacheFileExtension])
        return nil;

    NSString *keyHash = [[url lastPathComponent] stringByDeletingPathExtension];
    return keyHash;
}

#pragma mark - Persistent Store

+ (NSString*)cachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = paths[0];
    cachePath = [cachePath stringByAppendingPathComponent:PersistentCacheDirectoryName];
    BOOL isDir = NO;
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDir] &&
        isDir == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
        if (error)
            ZNRLog(@"error setting cache path: %@", error);
    }

    return cachePath;
}

- (NSString*)pathForKeyHash:(NSString *)keyHash
{
    NSString* path = [self.cachePath stringByAppendingPathComponent:keyHash];
    path = [path stringByAppendingPathExtension:PersistentCacheFileExtension];    
    return path;
}

- (void)storeObject:(id<NSCoding>)object forKeyHash:(NSString *)keyHash
{
    NSURL *url = [NSURL fileURLWithPath:[self pathForKeyHash:keyHash]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    if (!data) {
        ZNRLog(@"no data to store");
        return;
    }

    [self.fileManager writeData:data
                          toURL:url
                     completion:^(NSError *error) {
                         if (error)
                             ZNRLog(@"error saving object to persistent store: %@", error);
                     }];
}

- (void)retrieveObjectFromStoreForKeyHash:(NSString *)keyHash completion:(ZNPersistentCacheCompletionHandler)completionHandler
{
    NSString *path = [self pathForKeyHash:keyHash];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        if (completionHandler)
            completionHandler(nil);
        return;
    }
    
    [self.fileManager readDataAtURL:url
                         completion:^(NSData *data, NSError *error) {
                             if (error) {
                                 ZNRLog(@"error reading object from persistent store: %@", error);
                                 if (completionHandler)
                                     completionHandler(nil);
                                 return;
                             }
                             
                             id<NSCoding> object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                             if (completionHandler)
                                 completionHandler(object);
                         }];
}


- (void)modificationDateForCachedObjectWithKey:(NSString *)key completion:(ZNPersistentCacheCompletionHandler)completionHandler
{
    if (![key length]) {
        if (completionHandler)
            completionHandler(nil);
        return;
    }
    
    NSString *keyHash = [key MD5];
    NSString *path = [self pathForKeyHash:keyHash];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        if (completionHandler)
            completionHandler(nil);
        return;
    }
    
    [self.fileManager attributesOfItemAtURL:url
                                 completion:^(NSDictionary *attributes, NSError *error) {
                                     NSDate *modificationDate = attributes[NSFileModificationDate];
                                     if (error && !modificationDate) {
                                         if (completionHandler)
                                             completionHandler(nil);
                                         
                                         return;
                                     }
                                     
                                     if (completionHandler)
                                         completionHandler(modificationDate);
                                 }];
}

@end