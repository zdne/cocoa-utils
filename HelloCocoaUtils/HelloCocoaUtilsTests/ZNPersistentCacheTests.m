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

@end
