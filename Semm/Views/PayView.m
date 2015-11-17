//
//  PayView.m
//  Semm
//
//  Created by 郭洪军 on 11/4/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "PayView.h"

#import "IPNPreSignMessageUtil.h"
#import "IpaynowPluginApi.h"
#import "DataManager.h"
#import "../Umeng/MobClick.h"
#import "../Umeng/MobClickGameAnalytics.h"
#import "CommonMethods.h"

#define kSignURL       @"http://yuyangnews.ipaynow.cn/ZyPluginPaymentTest_PAY/api/pay2.php"

#define kWaiting          @"正在获取订单,请稍候..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果："

@implementation PayView
{
    NSString *_presignStr;
    NSString *_orderNo;
    
    NSString* buyType;
    
    BOOL   isBuySuccess;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray* arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PayView" owner:self options:nil];
        
        if (arrayOfViews.count < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0]isKindOfClass:[UIView class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    
    return self;
}

// ipaynow methods
-(void)payByType:(NSString *)payChannelType{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    IPNPreSignMessageUtil *preSign=[[IPNPreSignMessageUtil alloc]init];
    preSign.appId=@"1445589078923233";
    preSign.mhtOrderNo=[dateFormatter stringFromDate:[NSDate date]];
    preSign.mhtOrderName=@"家庭影院";
    preSign.mhtOrderType=@"01";
    preSign.mhtCurrencyType=@"156";
    preSign.mhtOrderAmt=PRICE;
    preSign.mhtOrderDetail=@"dsds";
    preSign.mhtOrderStartTime=[dateFormatter stringFromDate:[NSDate date]];
    preSign.notifyUrl=@"http://api.adwan.cn:8088/ming/api/notify.php";
    preSign.mhtCharset=@"UTF-8";
    preSign.mhtOrderTimeOut=@"3600";
    preSign.mhtReserved=UMENG_CHANNEL;
    preSign.consumerId=@"IPN00001";
    preSign.consumerName=@"IpaynowCS";
    if (payChannelType!=nil) {
        preSign.payChannelType=payChannelType;
    }
    
    NSString *originStr=[preSign generatePresignMessage];
    _orderNo=preSign.mhtOrderNo;
    _presignStr= originStr;
    
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)originStr,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    
    
    NSString *presignStr=@"paydata=";
    presignStr=[presignStr stringByAppendingString:outputStr];
    
    NSURL* url = [NSURL URLWithString:kSignURL];
    NSMutableURLRequest * urlRequest=[NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    urlRequest.HTTPBody=[presignStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLConnection* urlConn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [urlConn start];
    [self showAlertWait];
}

- (void)showAlertWait {
    mAlert = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [mAlert show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(mAlert.frame.size.width / 2.0f - 15, mAlert.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [mAlert addSubview:aiv];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response {
    NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
    int code = (int)[rsp statusCode];
    if (code != 200) {
    } else {
        if (mData != nil) {
            mData = nil;
        }
        mData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [mData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self hideAlert];
    NSString* data = [[NSMutableString alloc] initWithData:mData encoding:NSUTF8StringEncoding];
    NSString* payData=[_presignStr stringByAppendingString:@"&"];
    payData=[payData stringByAppendingString:data];
    
    [IpaynowPluginApi pay:payData AndScheme:@"yyqvdIpaynow" viewController:[self getCurrentVC] delegate:self];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self hideAlert];
    [self showAlertMessage:kErrorNet];
}

-(void)IpaynowPluginResult:(IPNPayResult)result errCode:(NSString *)errCode errInfo:(NSString *)errInfo{
    NSString *resultString=nil;
    isBuySuccess = NO;
    switch (result) {
        case IPNPayResultSuccess:
            resultString=@"支付成功";
            isBuySuccess = YES;
            break;
        case IPNPayResultCancel:
            resultString=@"支付被取消";
            [MobClick event:@"paycancelled"];
            break;
        case IPNPayResultFail:
            resultString=[NSString stringWithFormat:@"支付失败:\r\n错误码:%@,异常信息:%@",errCode, errInfo];
            [MobClick event:@"payfailed"];
            break;
        case IPNPayResultUnknown:
            resultString=[NSString stringWithFormat:@"支付结果未知:%@",errInfo];
            [MobClick event:@"payunknown"];
            break;
            
        default:
            break;
    }
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kNote
                                                    message:resultString
                                                   delegate:nil
                                          cancelButtonTitle:kConfirm
                                          otherButtonTitles:nil];
    alert.delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (isBuySuccess) {
        
//        int fir = [[DataManager sharedManager] getFirstIdx];
//        int sec = [[DataManager sharedManager] getSecondIdx];
        
//        NSString* key = [NSString stringWithFormat:@"a%dandb%d",fir,sec];
        NSString* key = @"isBought";
        
        //统计付费事件
        [MobClickGameAnalytics pay:PRICE_INT source:([buyType  isEqual: @"12"] ? 22 : 21) coin:1];
        
        [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithInt:1] forKey:key];
        
//        NSURL * myURL_APP_A = [NSURL URLWithString:@"http://115.231.181.68/D197985770E67405D6F5B3B66AA2D6DCAEFAB8E7.mp4"];
        NSURL* myURL_APP_A = [CommonMethods getPlayAddress];
        if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
            [[UIApplication sharedApplication] openURL:myURL_APP_A];
        }
    }
    
}

- (void)showAlertMessage:(NSString*)msg{
    mAlert = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:nil cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    [mAlert show];
}

- (void)hideAlert {
    if (mAlert != nil){
        [mAlert dismissWithClickedButtonIndex:0 animated:YES];
        mAlert = nil;
    }
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (IBAction)closeAction:(id)sender {
    
    [self removeFromSuperview];
    
}

- (IBAction)buyAction:(id)sender {
    if (!buyType) {
        buyType = @"12";
    }
    
    [self payByType:buyType];
}

- (IBAction)choseAlipay:(id)sender {
    
    buyType = @"12";
    
    NSString* selImage = @"pay_wec_sel.png";
    NSString* unsImage = @"pay_wec_uns.png";
    
    [_imgAlipay setImage:[UIImage imageNamed:selImage]];
    [_imgWechat setImage:[UIImage imageNamed:unsImage]];
}

- (IBAction)choseWechat:(id)sender {
    
    buyType = @"13";
    
    NSString* selImage = @"pay_wec_sel.png";
    NSString* unsImage = @"pay_wec_uns.png";
    
    [_imgAlipay setImage:[UIImage imageNamed:unsImage]];
    [_imgWechat setImage:[UIImage imageNamed:selImage]];
}
@end
