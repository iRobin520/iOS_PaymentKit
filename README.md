# iOS_PaymentKit
iOS自主封装的第三方支付接口合集静态库，App调用支付接口只需一行代码就可搞定

 ![image](https://github.com/iRobin520/iOS_PaymentKit/blob/master/PaymentDemo/Resources/Images/screenshot.png)

目前支持五种支付方式：微信支付、支付宝支付、银联支付、Apple Pay和Paypal支付, 有其他的支付方式可以自己加上去，可无限扩展，App调的的时候非常的方便，只需一行代码，下面我粘出这四种支付方式的Demo代码：

### 支付宝支付： 
    NSString *orderString = @"out_trade_no=\"XG53CI3MAWWAHP8\"&subject=\"1\"&body=\"我是测试数据\"&total_fee=\"0.01\"&notify_url=\"http://www.wconcept.cn\"";
    [SHPaymentKitManager startAlipayWithUnSignedOrderString:orderString successBlock:^(NSDictionary *resultDict) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Payment Success" message:resultDict.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    } failureBlock:^(NSDictionary *resultDict) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Payment failure" message:resultDict.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }];

  
### 银联支付：
     
    NSString *transactionUrl = @"http://101.231.204.84:8091/sim/getacptn";
    NSURLRequest * request=[NSURLRequest requestWithURL:[NSURL URLWithString:transactionUrl]];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *transactionNo = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (transactionNo != nil && transactionNo.length > 0) {
                [SHPaymentKitManager startUnionPayWithOrderTransactionNo:transactionNo paymentMode:@"01" presentFromViewController:self completeBlock:^(NSString *code, NSDictionary *data) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    NSString *title = @"";
                    NSString *message = @"";
                    if ([code isEqualToString:@"success"]) {
                        title = @"Payment Success";
                    } else {
                        title = @"Payment failure";
                    }
                    message = [data description];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                }];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Get Transaction No. Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        });
    }];

### Apple Pay:
  
    NSString *transactionUrl = @"http://202.101.25.178:8080/sim/gettn";
    NSURLRequest * request=[NSURLRequest requestWithURL:[NSURL URLWithString:transactionUrl]];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *transactionNo = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (transactionNo != nil && transactionNo.length > 0) {
                [SHPaymentKitManager startApplePayWithOrderTransactionNo:transactionNo paymentMode:@"01" presentFromViewController:self merchantId:@"com.sh.wcc" completeBlock:^(UPPayResult *result) {
                    if(result.paymentResultStatus == UPPaymentResultStatusSuccess) {
                        NSString *otherInfo = result.otherInfo?result.otherInfo:@"";
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Payment Success" message:otherInfo delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertView show];
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    }
                    else if(result.paymentResultStatus == UPPaymentResultStatusCancel){
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Payment failure" message:@"User canceled the payment" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertView show];
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    }
                    else if (result.paymentResultStatus == UPPaymentResultStatusFailure) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Payment failure" message:result.errorDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertView show];
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    }
                    else if (result.paymentResultStatus == UPPaymentResultStatusUnknownCancel)  {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Payment failure" message:@"支付过程中用户取消了，请查询后台确认订单" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertView show];
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    }
                }];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Get Transaction No. Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        });
    }];
    
### Paypal 支付:

    NSString *clientToken = @"eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiJlNjcxY2FlYTgzYmU1YzJhNWYwOTRiNjIwMjAyMjlmYWM1MzJmNGRjMTFjNTMzYTAyN2RmOGVhZWEwZTFlOTFmfGNyZWF0ZWRfYXQ9MjAxOC0wMS0yM1QwOTozNTowNS4zNzY1Mjg1MDgrMDAwMFx1MDAyNmN1c3RvbWVyX2lkPTgzQjIxMzYyLTMzNTktNDE4QS04RjhELUNCNjFBRUM3NzczMVx1MDAyNm1lcmNoYW50X2lkPWRjcHNweTJicndkanIzcW5cdTAwMjZwdWJsaWNfa2V5PTl3d3J6cWszdnIzdDRuYzgiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZGNwc3B5MmJyd2RqcjNxbi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbImN2diIsInBvc3RhbF9jb2RlIl0sImVudmlyb25tZW50Ijoic2FuZGJveCIsImNsaWVudEFwaVVybCI6Imh0dHBzOi8vYXBpLnNhbmRib3guYnJhaW50cmVlZ2F0ZXdheS5jb206NDQzL21lcmNoYW50cy9kY3BzcHkyYnJ3ZGpyM3FuL2NsaWVudF9hcGkiLCJhc3NldHNVcmwiOiJodHRwczovL2Fzc2V0cy5icmFpbnRyZWVnYXRld2F5LmNvbSIsImF1dGhVcmwiOiJodHRwczovL2F1dGgudmVubW8uc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbSIsImFuYWx5dGljcyI6eyJ1cmwiOiJodHRwczovL2NsaWVudC1hbmFseXRpY3Muc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbS9kY3BzcHkyYnJ3ZGpyM3FuIn0sInRocmVlRFNlY3VyZUVuYWJsZWQiOnRydWUsInBheXBhbEVuYWJsZWQiOnRydWUsInBheXBhbCI6eyJkaXNwbGF5TmFtZSI6IkFjbWUgV2lkZ2V0cywgTHRkLiAoU2FuZGJveCkiLCJjbGllbnRJZCI6bnVsbCwicHJpdmFjeVVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS9wcCIsInVzZXJBZ3JlZW1lbnRVcmwiOiJodHRwOi8vZXhhbXBsZS5jb20vdG9zIiwiYmFzZVVybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXNzZXRzVXJsIjoiaHR0cHM6Ly9jaGVja291dC5wYXlwYWwuY29tIiwiZGlyZWN0QmFzZVVybCI6bnVsbCwiYWxsb3dIdHRwIjp0cnVlLCJlbnZpcm9ubWVudE5vTmV0d29yayI6dHJ1ZSwiZW52aXJvbm1lbnQiOiJvZmZsaW5lIiwidW52ZXR0ZWRNZXJjaGFudCI6ZmFsc2UsImJyYWludHJlZUNsaWVudElkIjoibWFzdGVyY2xpZW50MyIsImJpbGxpbmdBZ3JlZW1lbnRzRW5hYmxlZCI6dHJ1ZSwibWVyY2hhbnRBY2NvdW50SWQiOiJzdGNoMm5mZGZ3c3p5dHc1IiwiY3VycmVuY3lJc29Db2RlIjoiVVNEIn0sIm1lcmNoYW50SWQiOiJkY3BzcHkyYnJ3ZGpyM3FuIiwidmVubW8iOiJvZmZsaW5lIiwiYXBwbGVQYXkiOnsic3RhdHVzIjoibW9jayIsImNvdW50cnlDb2RlIjoiVVMiLCJjdXJyZW5jeUNvZGUiOiJVU0QiLCJtZXJjaGFudElkZW50aWZpZXIiOiJtZXJjaGFudC5jb20uYnJhaW50cmVlcGF5bWVudHMuc2FuZGJveC5CcmFpbnRyZWUtRGVtbyIsInN1cHBvcnRlZE5ldHdvcmtzIjpbInZpc2EiLCJtYXN0ZXJjYXJkIiwiYW1leCIsImRpc2NvdmVyIl19LCJicmFpbnRyZWVfYXBpIjp7InVybCI6Imh0dHBzOi8vcGF5bWVudHMuc2FuZGJveC5icmFpbnRyZWUtYXBpLmNvbSIsImFjY2Vzc190b2tlbiI6InNhbmRib3hfZjdkcjVjX2RxNnNzMl9qa3M3eHRfNGhzcHNoX3FiNyJ9fQ==";
    
    [SHPaymentKitManager generatePaypalNonceWithClientToken:clientToken amount:@"0.01" currencyCode:nil presentFromViewController:self completion:^(NSString *nonce, NSError *error) {
        NSLog(@"nonce:%@",nonce);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
    
