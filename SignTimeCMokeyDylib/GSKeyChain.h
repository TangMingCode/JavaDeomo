//
//  GSKeyChain.h
//  SignTimeCMokeyDylib
//
//  Created by 郑桂华 on 2019/12/14.
//  Copyright © 2019 郑桂华. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSKeyChain : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;

@end

NS_ASSUME_NONNULL_END
