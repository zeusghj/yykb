//
//  PayView.h
//  Semm
//
//  Created by 郭洪军 on 11/4/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IpaynowPluginDelegate.h"

@interface PayView : UIView<IpaynowPluginDelegate, UIAlertViewDelegate>
{
    UIAlertView* mAlert;
    NSMutableData* mData;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgAlipay;
@property (weak, nonatomic) IBOutlet UIImageView *imgWechat;

- (IBAction)closeAction:(id)sender;
- (IBAction)buyAction:(id)sender;

- (IBAction)choseAlipay:(id)sender;
- (IBAction)choseWechat:(id)sender;

@end
