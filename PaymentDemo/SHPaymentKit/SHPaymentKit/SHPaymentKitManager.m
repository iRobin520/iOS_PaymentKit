//
//  SHPaymentKit.m
//  SHPaymentKit
//
//  Created by RobinShen on 15/8/14.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import "SHPaymentKitManager.h"
#import "SHPaymentKitDefs.h"
#import <AlipaySDK/AlipaySDK.h>
#import "BraintreeCore.h"

@interface SHPaymentKitManager()

@property (strong, nonatomic) SHUnionPay *unionPay;
@property (strong, nonatomic) SHAliPay *aliPay;
@property (strong, nonatomic) SHPayPalPay *paypalPay;

@end

@implementation SHPaymentKitManager

#pragma mark - Object lifecycles

+ (instancetype)sharedInstance {
    static SHPaymentKitManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[SHPaymentKitManager alloc] init];
        sharedManager.unionPay = [[SHUnionPay alloc] init];
        sharedManager.aliPay = [[SHAliPay alloc] init];
        sharedManager.paypalPay = [[SHPayPalPay alloc] init];
    });
    return sharedManager;
}

#pragma mark - Public methods

- (NSArray *)sourceApplications {
    return @[kSHAlipayAppBundleId,kSHUnionPayAppBundleId];
}

+ (BOOL)canSupportApplePay {
    return [SHUnionPay canSupportApplePay];
}

+ (void)startUnionPayWithOrderTransactionNo:(NSString *)transactionNo paymentMode:(NSString *)paymentMode presentFromViewController:(UIViewController *)viewController completeBlock:(SHUnionPayDidCompleteBlock)completeBlock {
    SHPaymentKitManager *sharedManager = [self sharedInstance];
    [sharedManager.unionPay setPaymentMode:paymentMode];
    [sharedManager.unionPay setFromScheme:kSHUnionPayAppScheme];
    [sharedManager.unionPay setUnionPayDidCompleteBlock:completeBlock];
    [sharedManager.unionPay payOrderWithTransactionNo:transactionNo presentFromViewController:viewController];
}

+ (void)startApplePayWithOrderTransactionNo:(NSString *)transactionNo paymentMode:(NSString *)paymentMode presentFromViewController:(UIViewController *)viewController merchantId:(NSString *)merchantId completeBlock:(SHApplePayDidCompleteBlock)completeBlock {
    SHPaymentKitManager *sharedManager = [self sharedInstance];
    [sharedManager.unionPay setPaymentMode:paymentMode];
    [sharedManager.unionPay setApplePayDidCompleteBlock:completeBlock];
    [sharedManager.unionPay applePayOrderWithTransactionNo:transactionNo presentFromViewController:viewController merchantId:merchantId];
}

+ (void)startAlipayWithSignedOrderString:(NSString *)orderString successBlock:(SHAliPayResult)success failureBlock:(SHAliPayResult)failure {
    SHPaymentKitManager *sharedManager = [self sharedInstance];
    [sharedManager.aliPay setPaidSuccessBlock:success];
    [sharedManager.aliPay setPaidFailureBlock:failure];
    [sharedManager.aliPay payOrderWithSignedOrderString:orderString];
}

+ (void)startAlipayWithUnSignedOrderString:(NSString *)orderString successBlock:(SHAliPayResult)success failureBlock:(SHAliPayResult)failure {
    SHPaymentKitManager *sharedManager = [self sharedInstance];
    [sharedManager.aliPay setPaidSuccessBlock:success];
    [sharedManager.aliPay setPaidFailureBlock:failure];
    [sharedManager.aliPay payOrderWithUnSignedOrderString:orderString];
}

+ (void)generatePaypalNonceWithClientToken:(NSString *)clientToken amount:(NSString *)amount currencyCode:(NSString *)currencyCode presentFromViewController:(UIViewController *)viewController completion:(SHPayPalPayResult)completion {
    SHPaymentKitManager *sharedManager = [self sharedInstance];
    [sharedManager.paypalPay generateNonceWithClientToken:clientToken amount:amount currencyCode:currencyCode presentFromViewController:viewController completion:completion];
}

+ (BOOL)handleOpenURL:(NSURL *)url withSourceApplication:(NSString *)sourceApplication {
    if ([sourceApplication isEqualToString:kSHAlipayAppBundleId]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    } else if ([sourceApplication isEqualToString:kSHUnionPayAppBundleId]) {
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            SHPaymentKitManager *sharedManager = [self sharedInstance];
            if (sharedManager.unionPay.unionPayDidCompleteBlock) {
                sharedManager.unionPay.unionPayDidCompleteBlock(code,data);
            }
        }];
    } else if ([url.scheme localizedCaseInsensitiveCompare:kSHPaypalAppScheme] == NSOrderedSame) {
        return [BTAppSwitch handleOpenURL:url sourceApplication:sourceApplication];
    }
    return YES;
}

@end
