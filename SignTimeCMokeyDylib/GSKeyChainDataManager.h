//
//  GSKeyChainDataManager.h
//  SignTimeCMokeyDylib
//
//  Created by 郑桂华 on 2019/12/14.
//  Copyright © 2019 郑桂华. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSKeyChainDataManager : NSObject

/**
 *   存储 UUID
 *
 *     */
+(void)saveUUID:(NSString *)UUID;

/**
 *  读取UUID *
 *
 */
+(NSString *)readUUID;

/**
 *    删除数据
 */
+(void)deleteUUID;

@end

NS_ASSUME_NONNULL_END
