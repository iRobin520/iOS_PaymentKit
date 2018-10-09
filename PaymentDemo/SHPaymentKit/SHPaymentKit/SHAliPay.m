//
//  SHAliPay.m
//  SHPaymentKit
//
//  Created by RobinShen on 15/8/14.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import "SHAliPay.h"
#import "SHPaymentKitDefs.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"

@interface SHAliPay()

@property (copy, nonatomic) SHAliPayResult paidSuccessBlock;
@property (copy, nonatomic) SHAliPayResult paidFailureBlock;

@end

@implementation SHAliPay

#pragma mark - Public methods

- (void)payOrderWithUnSignedOrderString:(NSString *)orderString {
    if ([kSHAlipayPartner length] == 0 || [kSHAlipaySeller length] == 0 || [kSHAlipayPrivateKey length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Partner or Seller or Private Key is missing, please fill in these parameters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (kSHAlipayPartner) {
        orderString = [NSString stringWithFormat:@"%@&partner=\"%@\"",orderString,kSHAlipayPartner];
    }
    if (kSHAlipaySeller) {
        orderString = [NSString stringWithFormat:@"%@&seller_id=\"%@\"",orderString,kSHAlipaySeller];
    }
    if (kSHAlipayAppId) {
        orderString = [NSString stringWithFormat:@"%@&app_id=\"%@\"",orderString,kSHAlipayAppId];
    }
    if (kSHAlipayService) {
        orderString = [NSString stringWithFormat:@"%@&service=\"%@\"",orderString,kSHAlipayService];
    }
    if (kSHAlipayInputCharset) {
        orderString = [NSString stringWithFormat:@"%@&_input_charset=\"%@\"",orderString,kSHAlipayInputCharset];
    }
    if (kSHAlipayPaymentType) {
        orderString = [NSString stringWithFormat:@"%@&payment_type=\"%@\"",orderString,kSHAlipayPaymentType];
    }
    if (kSHAlipayItBPay) {
        orderString = [NSString stringWithFormat:@"%@&it_b_pay=\"%@\"",orderString,kSHAlipayItBPay];
    }
    if (kShAlipayShowUrl) {
        orderString = [NSString stringWithFormat:@"%@&show_url=\"%@\"",orderString,kShAlipayShowUrl];
    }
    
    id<DataSigner> signer = CreateRSADataSigner(kSHAlipayPrivateKey);
    NSString *signedString = [signer signString:orderString];
    
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderString, signedString, @"RSA"];
        
        //orderString = @"out_trade_no=\"110000192\"&subject=\"1\"&body=\"我是测试数据\"&total_fee=\"0.01\"&notify_url=\"http://dev.wcc.purple.io:81/alipay/payment/notify/\"&partner=\"2088021458633501\"&seller_id=\"wangshuanghe@semir.com\"&app_id=\"2015092900340292\"&service=\"mobile.securitypay.pay\"&_input_charset=\"utf-8\"&payment_type=\"1\"&it_b_pay=\"60m\"&show_url=\"m.alipay.com\"&sign=\"DFaSNMQZ9hbH96wyG2tm6MZNtcDYihdnMb5S%2FB4a1BFW6JZZBi63atDROGIzLofW1bYUm1swnLrrGMwVx7AIO9G5yCkoBuN09%2BxrDZ343yUFhv6scSSyyqk2HzxkMsj5uxAeHaToMwEw1oW%2FuZKOnqhdQRDc41QxBJYnXrplycg%3D\"&sign_type=\"RSA\"";
        [self payOrderWithSignedOrderString:orderString];
    }
}

- (void)payOrderWithSignedOrderString:(NSString *)orderString {
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:kSHAlipayAppScheme callback:^(NSDictionary *resultDic) {
//  Paid Success Block
//        reslut = {
//            memo = "";
//            result = "out_trade_no=\"XG53CI3MAWWAHP8\"&subject=\"1\"&body=\"\U6211\U662f\U6d4b\U8bd5\U6570\U636e\"&total_fee=\"0.01\"&notify_url=\"http://www.wconcept.cn\"&partner=\"2088021168585767\"&seller_id=\"lookoptical@163.com\"&app_id=\"2015081800221416\"&service=\"mobile.securitypay.pay\"&_input_charset=\"utf-8\"&payment_type=\"1\"&it_b_pay=\"30m\"&show_url=\"m.alipay.com\"&success=\"true\"&sign_type=\"RSA\"&sign=\"Q+JVeUyVh17gvZfqYfrcvo0qzC24peSlz8CjiKhQyDfC58tbvZjTs6ZYNuEkPT6gLyZIf/uYe56RLVTLrfk6j6w1H5Oso+BZovmIdFvzcIpflpJDj+2LwNXwX2IOG5JCpqtOafgpch25WyRfSIp4ujFAxBNsSa9AdthltQMeDSc=\"";
//            resultStatus = 9000;
//        }
        NSLog(@"reslut = %@",resultDic);
        if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000) {
            if (self.paidSuccessBlock) {
                self.paidSuccessBlock(resultDic);
            }
        } else {
            if (self.paidFailureBlock) {
                self.paidFailureBlock(resultDic);
            }
        }
    }];
}

#pragma mark - Accessors

- (void)setPaidSuccessBlock:(SHAliPayResult)paidSuccessBlock {
    _paidSuccessBlock = paidSuccessBlock;
}

- (void)setPaidFailureBlock:(SHAliPayResult)paidFailureBlock {
    _paidFailureBlock = paidFailureBlock;
}

@end
