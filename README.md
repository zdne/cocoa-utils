# cocoa-utils

Miscellaneous Cocoa (Touch) utilities and helpers.

---

## ZNLog.h
NSLog replacement. Supports two levels of logging: Debug `ZNLog()` and Release `ZNRLog()`. Includes entry  and exit logging helpers as well (`ZNLogEntry` and `ZNLogExit`). 

Include in prefix file like so:

	#ifdef __OBJC__
	    #import <UIKit/UIKit.h>
	    #import <Foundation/Foundation.h>
	    #import "ZNLog.h"
	#endif

---