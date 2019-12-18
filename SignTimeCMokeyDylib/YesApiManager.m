//
//  YesApiManager.m
//  SignTimeCMokeyDylib
//
//  Created by 郑桂华 on 2019/12/14.
//  Copyright © 2019 郑桂华. All rights reserved.
//

#import "YesApiManager.h"
#import <UIKit/UIKit.h>

#import "GSKeyChainDataManager.h"

@implementation YesApiManager

+ (void)finishLaunchingRequest{
    [self request];
//    [self localTime];
}

+ (void)localTime{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self alertWithEndTime:@"2019-12-24 23:59:59"]) {
            [self alertMessage:@"签名到期啦,请续费重签"];
        }
    });
}

+ (void)request{
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *bid =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://hb5.api.okayapi.com/"]];
    request.HTTPMethod = @"POST";
    NSDictionary *param = @{
        @"s":@"App.Table.FreeFindOne",
        @"app_key":@"6708DDDE5DBB3616CB9212977C3178D6",
        @"model_name":@"SignTimeControl",
        @"logic":@"and",
        @"where":[NSString stringWithFormat:@"[[\"bundle_id\", \"=\", \"%@\"]]", bid]
    };
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingFragmentsAllowed error:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if (dict && [dict[@"ret"] integerValue] == 200) { //请求成功
                    NSDictionary *dataDic = dict[@"data"];
                    if (dataDic && [dataDic[@"err_code"] integerValue] == 0) { // 数据查询成功  有数据  可继续判断时间
                        NSString *endtime = dataDic[@"data"][@"end_time"];
                        NSString *message = dataDic[@"data"][@"alert_message"];
                        NSString *equipments = dataDic[@"data"][@"equipments"];
                        NSInteger max_equipment = [dataDic[@"data"][@"max_equipment"] integerValue];
                        NSInteger ID = [dataDic[@"data"][@"id"] integerValue];
                        if (![self alertWithEndTime:endtime]) {
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                [self updateLastUseTimeWithId:ID equipments:equipments?:@"" max_equipment:max_equipment];
                            });
                        } else {
                            [self alertMessage:message];
                        }
                    }
                }
            });
        }
    }];
    [dataTask resume];
}

+ (void)updateLastUseTimeWithId:(NSInteger)ID equipments:(NSString *)equipments max_equipment:(NSInteger)max_equipment{
    NSString *key = @"SignTimeCMokeyUpdateLastUseTimeWithId";
    BOOL isStore = [[[NSUserDefaults standardUserDefaults] objectForKey:key] boolValue];
    if (isStore) {
        return;
    }
    BOOL isNewUdid = NO;
    NSString *udid = [self udid];
    if ([equipments isKindOfClass:[NSNull class]]) {
        equipments = @"";
    }
    NSArray *udids = [equipments componentsSeparatedByString:@","];
    if ([udids containsObject:udid]) {
        isNewUdid = NO;
    } else {
        isNewUdid = YES;
        if (max_equipment > 0 && udids.count >= max_equipment) { // 不可以再添加了
            [self alertMessage:@"设备数量已达最大限制"];
            return;
        }
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *now = [formatter stringFromDate:[NSDate date]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://hb5.api.okayapi.com/"]];
    request.HTTPMethod = @"POST";
    NSDictionary *param = @{
        @"s":@"App.Table.MultiUpdate",
        @"app_key":@"6708DDDE5DBB3616CB9212977C3178D6",
        @"model_name":@"SignTimeControl",
        @"ids":@(ID),
        @"data":[NSString stringWithFormat:@"{\"last_request_time\":\"%@\"%@}", now, !isNewUdid?@"":[NSString stringWithFormat:@",\"equipments\":\"%@,%@\"", equipments, udid]]
    };
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingFragmentsAllowed error:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict && [dict[@"ret"] integerValue] == 200) { //请求成功
                NSDictionary *dataDic = dict[@"data"];
                if (dataDic && [dataDic[@"err_code"] integerValue] == 0) {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }
    }];
    [dataTask resume];
}

+ (BOOL)alertWithEndTime:(NSString *)endTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *endDate = [formatter dateFromString:endTime];
    NSTimeInterval interval = endDate.timeIntervalSinceNow;
    return interval < 0;
}

+ (void)alertMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }]];
    UIWindow* window = nil;
    if (@available(iOS 13.0, *))
    {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes)
        {
            if (windowScene.activationState == UISceneActivationStateForegroundActive)
            {
                window = windowScene.windows.firstObject;
                break;
            }
        }
    }else{
        window = [UIApplication sharedApplication].keyWindow;
    }
    [window.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (NSString *)udid{
    NSString *udid = [GSKeyChainDataManager readUUID];
    if (!udid) {
        NSString *deviceUUID = [[UIDevice currentDevice].identifierForVendor UUIDString];
        [GSKeyChainDataManager saveUUID:deviceUUID];
        udid = deviceUUID;
    }
    return udid;
}
@end
