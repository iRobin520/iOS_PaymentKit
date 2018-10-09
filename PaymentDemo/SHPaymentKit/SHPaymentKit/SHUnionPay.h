//
//  SHUnionPay.h
//  SHPaymentKit
//
//  Created by RobinShen on 15/8/14.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPPaymentControl.h"
#import "UPAPayPluginDelegate.h"

typedef void(^SHUnionPayDidCompleteBlock)(NSString *code, NSDictionary *data);
typedef void(^SHApplePayDidCompleteBlock)(UPPayResult *result);

@class UIViewController;
@interface SHUnionPay : NSObject<UPAPayPluginDelegate>

@property (copy, readonly, nonatomic) SHUnionPayDidCompleteBlock unionPayDidCompleteBlock;

- (void)payOrderWithTransactionNo:(NSString *)transactionNo presentFromViewController:(UIViewController *)viewController;
- (void)applePayOrderWithTransactionNo:(NSString *)transactionNo presentFromViewController:(UIViewController *)viewController  merchantId:(NSString *)merchantId;
- (void)setPaymentMode:(NSString *)paymentMode;
- (void)setFromScheme:(NSString *)fromScheme;
- (void)setUnionPayDidCompleteBlock:(SHUnionPayDidCompleteBlock)unionPayDidCompleteBlock;
- (void)setApplePayDidCompleteBlock:(SHApplePayDidCompleteBlock)applePayDidCompleteBlock;
+ (BOOL)canSupportApplePay;

@end
