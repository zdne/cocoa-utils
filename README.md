# cocoa-utils

Miscellaneous Cocoa (Touch) utilities and helpers.

## ZNLog
NSLog replacement. Supports two levels of logging: Debug `ZNLog()` and Release `ZNRLog()`. Includes entry  and exit logging helpers as well (`ZNLogEntry` and `ZNLogExit`). 

Include in prefix file like so:

	#ifdef __OBJC__
	    #import <UIKit/UIKit.h>
	    #import <Foundation/Foundation.h>
	    #import "ZNLog.h"
	#endif

## ZNJSONObject
Protocol of an object that can be serialized and deserialized as a JSON.

## ZNCoordinatedFileManager
Asynchronous file manager for coordinated reading and writing. Supports `NSFilePresenter` and iCloud sandbox. With **every** completion handler called on the **main queue**.

It 'async'-wraps additional NSFileManager functionality, not just that of NSFileCoordinator jurisdiction.

## NSDate+ISO8601
Simple ISO8601 NString to NSDate (and vice versa) formatter. Converts "2012-12-31T08:08:45Z"-like strings to NSDate and back. Less powerful alternative to [boredzo / iso-8601-date-formatter](https://github.com/boredzo/iso-8601-date-formatter). 

## ZNViewTools
Provides tools to round corners of UIView and UIImage.

## ZNPersistentCache
Provides NSCache functionality shared in between app sessions. Object of `id<NSCoding>` are serialized into App's cache directory reused between sessions.

Utilizing [jerolimov / NSHash](https://github.com/jerolimov/NSHash) for MD5 hashing cache keys and filenames.

## ZNBlockActionSheet
Simple block-based UIActionSheet implementation.
