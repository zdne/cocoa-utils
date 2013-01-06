//
//  ZNCoordinatedFileManager.m
//  cocoa-utils
//
//  Created by Zdenek Nemec on 10/23/12.
//  Copyright (c) 2012 zdne.org. All rights reserved.
//

#import "ZNCoordinatedFileManager.h"

@implementation ZNCoordinatedFileManager

- (id)init
{
    self = [super init];
    if (self) {
        _filePresenter = nil;
    }
    return self;
}

- (id)initWithFilePresenter:(id<NSFilePresenter>) filePresenter
{
    self = [super init];
    if (self) {
        _filePresenter = filePresenter;
    }
    return self;
}

#pragma mark - Write

- (void)writeData:(NSData *)data toURL:(NSURL *)url completion:(void (^)(NSError *error))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:self.filePresenter];
        __block BOOL didInvokeCompletitionHandle = NO;
        [fileCoordinator coordinateWritingItemAtURL:url
                                            options:NSFileCoordinatorWritingForReplacing
                                              error:&error
                                         byAccessor:^(NSURL *newURL) {
                                             NSError *writerError = nil;
                                             [data writeToURL:url options:NSDataWritingAtomic error:&writerError];
                                             
                                             if (completion) {
                                                 didInvokeCompletitionHandle = YES;
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     completion(writerError);
                                                 });
                                             }
                                         }];
        if (completion && !didInvokeCompletitionHandle) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
        }
    });
}

#pragma mark - Read

- (void)readDataAtURL:(NSURL *)url completion:(void (^)(NSData *data, NSError *error))completion;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:self.filePresenter];
        __block BOOL didInvokeCompletitionHandle = NO;
        [fileCoordinator coordinateReadingItemAtURL:url
                                            options:0
                                              error:&error
                                         byAccessor:^(NSURL *newURL) {
                                             NSError *readerError = nil;
                                             NSData *data = [NSData dataWithContentsOfURL:newURL
                                                                                  options:0
                                                                                    error:&readerError];
                                             
                                             if (completion) {
                                                 didInvokeCompletitionHandle = YES;
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     completion(data, readerError);
                                                 });
                                             }
                                         }];
        if (completion && !didInvokeCompletitionHandle) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
        }
    });
}

#pragma mark - Delete

- (void)removeFileAtURL:(NSURL *)url completion:(void (^)(NSError *error))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:self.filePresenter];
        __block BOOL didInvokeCompletitionHandle = NO;
        [fileCoordinator coordinateWritingItemAtURL:url
                                            options:NSFileCoordinatorWritingForDeleting
                                              error:&error
                                         byAccessor:^(NSURL *newURL) {
                                             NSError *writerError = nil;
                                             [[NSFileManager defaultManager] removeItemAtURL:newURL error:&writerError];
                                             
                                             if (completion) {
                                                 didInvokeCompletitionHandle = YES;
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     completion(writerError);
                                                 });
                                             }
                                         }];
        if (completion && !didInvokeCompletitionHandle) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
        }
    });
}

#pragma mark - Move

- (void)moveSandboxFileAtURL:(NSURL *)sourceURL toiCloudURL:(NSURL *)targetURL completion:(void (^)(NSError *error))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:self.filePresenter];
        __block BOOL didInvokeCompletitionHandle = NO;
        [fileCoordinator coordinateWritingItemAtURL:targetURL
                                            options:NSFileCoordinatorWritingForReplacing
                                              error:&error
                                         byAccessor:^(NSURL *newURL) {
                                             NSError *writerError = nil;
                                             [[NSFileManager defaultManager] setUbiquitous:YES
                                                                                 itemAtURL:sourceURL
                                                                            destinationURL:newURL
                                                                                     error:&writerError];                                             
                                             if (completion) {
                                                 didInvokeCompletitionHandle = YES;
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     completion(writerError);
                                                 });
                                             }
                                         }];
        if (completion && !didInvokeCompletitionHandle) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(error);
            });
        }
    });
}

#pragma mark - Directory & File inquiries

- (void)contentOfDirectoryAtURL:(NSURL *)url completion:(void (^)(NSArray *content, NSError *error))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:url
                                                       includingPropertiesForKeys:nil
                                                                          options:NSDirectoryEnumerationSkipsSubdirectoryDescendants |
                                                                                    NSDirectoryEnumerationSkipsPackageDescendants |
                                                                                    NSDirectoryEnumerationSkipsHiddenFiles
                                                                            error:&error];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(files, error);
            });
        }
    });
}

- (void)attributesOfItemAtURL:(NSURL *)url completion:(void (^)(NSDictionary *attributes, NSError *error))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[url path] error:&error];
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(attributes, error);
            });
        }
    });
}

@end
