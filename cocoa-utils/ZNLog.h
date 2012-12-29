//
//  ZNLog.h
//  cocoa-utils
//
//  Created by Zdenek Nemec on 9/4/12.
//  Copyright (c) 2012 zdne.org. All rights reserved.
//

#ifndef cocoa_utils_ZNLog_h
#define cocoa_utils_ZNLog_h

#if DEBUG == 1
#define ZNLogEntry      NSLog(@"ZN-IN: %s:%d", __PRETTY_FUNCTION__,__LINE__);
#define ZNLogExit       NSLog(@"ZN-OUT: %s:%d", __PRETTY_FUNCTION__,__LINE__);
#define ZNLog(A, ...)   NSLog(@"ZN: %s:%d:%@", __PRETTY_FUNCTION__,__LINE__,[NSString stringWithFormat:A, ## __VA_ARGS__]);
#define ZNRLog(A, ...)  NSLog(@"ZN-R: %s:%d: %@", __PRETTY_FUNCTION__,__LINE__,[NSString stringWithFormat:A, ## __VA_ARGS__]);
#else
#define ZNLogEntry
#define ZNLogExit
#define ZNLog(A, ...)
#define ZNRLog(A, ...)  NSLog(@"ZN-R: %s:%d: %@", __PRETTY_FUNCTION__,__LINE__,[NSString stringWithFormat:A, ## __VA_ARGS__]);
#endif

#endif
