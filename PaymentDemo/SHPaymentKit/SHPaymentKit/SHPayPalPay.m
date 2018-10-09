//
//  SHPayPalPay.m
//  SHPaymentKit
//
//  Created by Robin Shen on 2018/1/23.
//  Copyright © 2018年 sh. All rights reserved.
//

#import "SHPayPalPay.h"
#import "SHPaymentKitDefs.h"
#import "BraintreeCore.h"
#import "BraintreePayPal.h"

@interface SHPayPalPay ()<BTViewControllerPresentingDelegate>

@property (strong, nonatomic) UIViewController *viewController;
@property (copy, nonatomic) SHPayPalPayResult completion;
@property (strong, nonatomic) BTPayPalDriver *driver;

@end

@implementation SHPayPalPay

#pragma mark - View lifecycles

- (instancetype)init {
    self = [super init];
    if (self) {
        [BTAppSwitch setReturnURLScheme:kSHPaypalAppScheme];
    }
    return self;
}

#pragma mark - Public methods

- (void)generateNonceWithClientToken:(NSString *)clientToken amount:(NSString *)amount currencyCode:(NSString *)currencyCode presentFromViewController:(UIViewController *)viewController completion:(SHPayPalPayResult)completion {
    self.viewController = viewController;
    self.completion = completion;
    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:clientToken];
    self.driver = [[BTPayPalDriver alloc] initWithAPIClient:apiClient];
    self.driver.viewControllerPresentingDelegate = self;
    BTPayPalRequest *request = [[BTPayPalRequest alloc] initWithAmount:amount];
    request.currencyCode = currencyCode?currencyCode:@"HKD";
    request.intent = BTPayPalRequestIntentSale;
    [self.driver requestOneTimePayment:request completion:^(BTPayPalAccountNonce * _Nullable payPalAccount, NSError * _Nullable error) {
        if (self.completion) {
            self.completion(payPalAccount.nonce,error);
        }
    }];
}

#pragma mark BTAppSwitchDelegate

- (void)paymentDriver:(__unused id)driver requestsPresentationOfViewController:(UIViewController *)viewController {
    [self.viewController presentViewController:viewController animated:YES completion:nil];
}

- (void)paymentDriver:(__unused id)driver requestsDismissalOfViewController:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
