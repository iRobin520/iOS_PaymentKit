//
//  SHPayPalPay.h
//  SHPaymentKit
//
//  Created by Robin Shen on 2018/1/23.
//  Copyright © 2018年 sh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;

typedef void (^SHPayPalPayResult)(NSString *nonce, NSError *error);

@interface SHPayPalPay : NSObject

- (void)generateNonceWithClientToken:(NSString *)clientToken amount:(NSString *)amount currencyCode:(NSString *)currencyCode presentFromViewController:(UIViewController *)viewController completion:(SHPayPalPayResult)completion;

@end
