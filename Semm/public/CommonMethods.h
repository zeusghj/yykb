//
//  CommonMethods.h
//  Semm
//
//  Created by 郭洪军 on 11/4/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommonDefine.h"

@interface CommonMethods : NSObject

+ (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view;

+ (NSURL *)getPlayAddress;

@end
