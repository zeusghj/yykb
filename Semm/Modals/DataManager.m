//
//  DataManager.m
//  Semm
//
//  Created by 郭洪军 on 11/6/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

- (void)setFirstIdx:(int)indx
{
    firstIdx = indx;
}

- (void)setSecondIdx:(int)indx
{
    secondIdx = indx;
}

- (int)getFirstIdx
{
    return firstIdx;
}

- (int)getSecondIdx
{
    return secondIdx;
}

+ (id)sharedManager {
    static DataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init
{
    if (self = [super init]) {
        firstIdx = 0;
        secondIdx = 0;
    }
    
    return self;
}

@end
