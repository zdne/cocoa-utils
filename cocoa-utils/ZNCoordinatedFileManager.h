//
//  ZNCoordinatedFileManager.h
//  cocoa-utils
//
//  Created by Zdenek Nemec on 10/23/12.
//  Copyright (c) 2012 zdne.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNCoordinatedFileManager : NSObject

@property (assign, atomic) id<NSFilePresenter> filePresenter;

- (id)init;
- (id)initWithFilePresenter:(id<NSFilePresenter>) filePresenter;

- (void)writeData:(NSData *)data toURL:(NSURL *)url completion:(void (^)(NSError *error))completion;
- (void)readDataAtURL:(NSURL *)url completion:(void (^)(NSData *data, NSError *error))completion;
- (void)removeFileAtURL:(NSURL *)url completion:(void (^)(NSError *error))completion;
- (void)moveSandboxFileAtURL:(NSURL *)sourceURL toiCloudURL:(NSURL *)targetURL completion:(void (^)(NSError *error))completion;

- (void)contentOfDirectoryAtURL:(NSURL *)url completion:(void (^)(NSArray *content, NSError *error))completion;
- (void)attributesOfItemAtURL:(NSURL *)url completion:(void (^)(NSDictionary *attributes, NSError *error))completion;

@end
