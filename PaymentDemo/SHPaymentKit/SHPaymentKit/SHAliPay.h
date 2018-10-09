//
//  SHAliPay.h
//  SHPaymentKit
//
//  Created by RobinShen on 15/8/14.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SHAliPayResult)(NSDictionary *resultDict);

@interface SHAliPay : NSObject

- (void)payOrderWithUnSignedOrderString:(NSString *)orderString;
- (void)payOrderWithSignedOrderString:(NSString *)orderString;
- (void)setPaidSuccessBlock:(SHAliPayResult)paidSuccessBlock;
- (void)setPaidFailureBlock:(SHAliPayResult)paidFailureBlock;

@end
