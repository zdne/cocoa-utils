# cocoa-utils

Miscellaneous Cocoa (Touch) utilities and helpers.

---

## ZNLog
NSLog replacement. Supports two levels of logging: Debug `ZNLog()` and Release `ZNRLog()`. Includes entry  and exit logging helpers as well (`ZNLogEntry` and `ZNLogExit`). 

Include in prefix file like so:

	#ifdef __OBJC__
	    #import <UIKit/UIKit.h>
	    #import <Foundation/Foundation.h>
	    #import "ZNLog.h"
	#endif

---

## ZNJSONObject
Protocol of an object that can be serialized and deserialized as a JSON.

---

## ZNCoordinatedFileManager
Asynchronous file manager for coordinated reading and writing. Supports `NSFilePresenter` and iCloud sandbox. With **every** completion handler called on the **main queue**.

---

