//
//  ZNPersistentCacheTests.m
//  HelloCocoaUtils
//
//  Created by Zdenek Nemec on 1/4/13.
//  Copyright (c) 2013 zdne.org. All rights reserved.
//

#import "ZNPersistentCacheTests.h"
#import "ZNPersistentCache.h"
#import "ZNPersistentCache+Private.h"
#import "NSString+NSHash.h"

static NSString * TestObject = @"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...";
static NSString * TestObjectKey = @"org.zdne.testobject";
static NSString * TestObjectKey2 = @"org.zdne.testobject2";
static NSString * TestObjectKey3 = @"org.zdne.testobject3";

@implementation ZNPersistentCacheTests

void WaitForSemaphore(dispatch_semaphore_t semaphore, dispatch_time_t wait)
{
    //dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // blocks so we need to use while loop bellow
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }    
}

void Wait(dispatch_time_t wait)
{
    dispatch_time_t elapsedTime = 0;
    while (elapsedTime < wait) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        elapsedTime++;
    }
}

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testInit
{
    STAssertNotNil([ZNPersistentCache sharedCache], @"shared cache instance must exist");
}

- (void)testCache
{
    [self persistenceCheck]; // must be run as part of only test case
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[ZNPersistentCache sharedCache] cachedObjectForKey:@"nonexistent.key"
                                             completion:^(id<NSCoding> object) {
                                                 STAssertNil(object, @"key shouldn't exist");
                                                 
                                                 dispatch_semaphore_signal(semaphore);
                                             }];
    
    WaitForSemaphore(semaphore, DISPATCH_TIME_FOREVER);
    
    STAssertNoThrow([[ZNPersistentCache sharedCache] cacheObject:TestObject forKey:TestObjectKey],
                    @"adding object %@ must not throw", TestObjectKey);
    
    Wait(2); // an arbitrary wait to finish any file ops

    semaphore = dispatch_semaphore_create(0);
    [[ZNPersistentCache sharedCache] cachedObjectForKey:TestObjectKey
                                             completion:^(id<NSCoding> object) {
                                                 STAssertNotNil(object,
                                                                @"object %@ should exist", TestObjectKey);
                                                 STAssertTrue([(NSString *)object isEqualToString:TestObject],
                                                              @"retrieved object is different to stored one");
                                                 
                                                 dispatch_semaphore_signal(semaphore);
                                             }];
    
    WaitForSemaphore(semaphore, DISPATCH_TIME_FOREVER);
}

- (void)persistenceCheck
{
    // Only in subsequent runs, using private ZNPersistentCache API
    NSString *keyHash = [TestObjectKey MD5];

    NSString *path = [[ZNPersistentCache sharedCache] pathForKeyHash:keyHash];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        return;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[ZNPersistentCache sharedCache] cachedObjectForKey:TestObjectKey
                                             completion:^(id<NSCoding> object) {
                                                 STAssertNotNil(object,
                                                                @"object %@ should exist", TestObjectKey);
                                                 STAssertTrue([(NSString *)object isEqualToString:TestObject],
                                                              @"retrieved object is different to stored one");
                                                 
                                                 dispatch_semaphore_signal(semaphore);
                                             }];
    
    WaitForSemaphore(semaphore, DISPATCH_TIME_FOREVER);
}

- (void)testPurgeCache
{
    STAssertNoThrow([[ZNPersistentCache sharedCache] cacheObject:TestObject forKey:TestObjectKey2],
                    @"adding object %@ must not throw", TestObjectKey2);
    
    Wait(2);
    
    STAssertNoThrow([[ZNPersistentCache sharedCache] purgeCacheWithMaximumAge:0],
                    @"purgeCacheWithMaximumAge: must not throw");
    
    Wait(5);
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[ZNPersistentCache sharedCache] cachedObjectForKey:TestObjectKey2
                                             completion:^(id<NSCoding> object) {
                                                 STAssertNil(object, @"key shouldn't exist");
                                                 
                                                 dispatch_semaphore_signal(semaphore);
                                             }];
    
    WaitForSemaphore(semaphore, DISPATCH_TIME_FOREVER);
}

- (void)testPurgeCacheWithMaximumAge
{
    // 'old' object
    STAssertNoThrow([[ZNPersistentCache sharedCache] cacheObject:TestObject forKey:TestObjectKey3],
                    @"adding object %@ must not throw", TestObjectKey3);
    
    Wait(10); // make it old
    
    // 'new' object
    STAssertNoThrow([[ZNPersistentCache sharedCache] cacheObject:TestObject forKey:TestObjectKey2],
                    @"adding object %@ must not throw", TestObjectKey2);
    
    // purge 10 seconds old and older
    STAssertNoThrow([[ZNPersistentCache sharedCache] purgeCacheWithMaximumAge:5],
                    @"purgeCacheWithMaximumAge: must not throw");
    
    Wait(5);
    
    // Check that 'old' no longer exists
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[ZNPersistentCache sharedCache] cachedObjectForKey:TestObjectKey3
                                             completion:^(id<NSCoding> object) {
                                                 STAssertNil(object, @"old object shouldn't exist");
                                                 
                                                 dispatch_semaphore_signal(semaphore);
                                             }];
    
    WaitForSemaphore(semaphore, DISPATCH_TIME_FOREVER);
    
    // Check that 'new' is still present
    semaphore = dispatch_semaphore_create(0);
    [[ZNPersistentCache sharedCache] cachedObjectForKey:TestObjectKey2
                                             completion:^(id<NSCoding> object) {
                                                 STAssertNotNil(object, @"new object should exist");
                                                 
                                                 dispatch_semaphore_signal(semaphore);
                                             }];
    
    WaitForSemaphore(semaphore, DISPATCH_TIME_FOREVER);
    
}

@end
