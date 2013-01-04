//
//  ZNPersistentCache+Private.h
//  HelloCocoaUtils
//
//  Created by Zdenek Nemec on 1/4/13.
//  Copyright (c) 2013 zdne.org. All rights reserved.
//

#import "ZNPersistentCache.h"

@interface ZNPersistentCache (Private)

- (NSString*)pathForKeyHash:(NSString *)keyHash;

@end
