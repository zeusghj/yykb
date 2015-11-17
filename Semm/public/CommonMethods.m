//
//  CommonMethods.m
//  Semm
//
//  Created by 郭洪军 on 11/4/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "CommonMethods.h"

@implementation CommonMethods


+ (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view
{
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = 0.2;
    
    //设置运动type
    animation.type = type;
    if (subtype != nil) {
        
        //设置子类
        animation.subtype = subtype;
    }
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];
}

+ (NSURL *)getPlayAddress
{
    NSArray* array = @[@"http://115.231.181.85/play/C9E9B43E18F49DB640F8D7AF9983433585059D6C.mp4",
                       @"http://115.231.181.99/play/B58DEEAFE04D1A8CAE64C927700769D7CBF43898.mp4",
                       @"http://115.231.181.68/play/531503EBAB36A990A78DA9CA0B758E06502CF019.mp4",
                       @"http://115.231.181.97/play/2EF5F3CBF39595FADB9A4862AE6B428F33F0CC1F.mp4",
                       @"http://115.231.181.70/play/858EC3298B5C272D2830BF1B1295A07C563259E2.mp4",
                       @"http://115.231.181.70/play/E57BFD486499DFE974772B25D08F6156688BC122.mp4",
                       @"http://115.231.181.68/D197985770E67405D6F5B3B66AA2D6DCAEFAB8E7.mp4"];
    
    int value = arc4random() % 7 ;
    
    NSString* urlString = array[value];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    return url;
}
















@end
