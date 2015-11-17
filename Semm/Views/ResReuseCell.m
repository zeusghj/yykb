//
//  ResReuseCell.m
//  Semm
//
//  Created by 郭洪军 on 11/11/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "ResReuseCell.h"

@implementation ResReuseCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray* arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ResReuseCell" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0]isKindOfClass:[UICollectionReusableView class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    
    return self;
}

@end
