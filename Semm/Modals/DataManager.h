//
//  DataManager.h
//  Semm
//
//  Created by 郭洪军 on 11/6/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject
{
    int firstIdx;
    int secondIdx;
}

- (void)setFirstIdx:(int)indx;
- (void)setSecondIdx:(int)indx;

- (int)getFirstIdx;
- (int)getSecondIdx;

+ (id)sharedManager;

@end
