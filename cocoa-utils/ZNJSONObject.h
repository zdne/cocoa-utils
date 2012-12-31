//
//  ZNJSONObject.h
//  cocoa-utils
//
//  Created by Zdenek Nemec on 7/27/12.
//  Copyright (c) 2012 Passauthority.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZNJSONObject <NSObject>

// Initializes and sets default values for required parameters.
- (id)init;

// Initializes object with a JSON object.
- (id)initWithJSONObject:(id)object;

// Serializes as a JSON object.
- (id)JSONObject;

@end
