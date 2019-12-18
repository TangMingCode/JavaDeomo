//
//  GSKeyChainDataManager.m
//  SignTimeCMokeyDylib
//
//  Created by 郑桂华 on 2019/12/14.
//  Copyright © 2019 郑桂华. All rights reserved.
//

#import "GSKeyChainDataManager.h"
#import "GSKeyChain.h"

@implementation GSKeyChainDataManager

static NSString * const KEY_IN_KEYCHAIN_UUID = @"唯一识别的KEY_UUID";
static NSString * const KEY_UUID = @"唯一识别的key_uuid";

+(void)saveUUID:(NSString *)UUID{
    
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    [usernamepasswordKVPairs setObject:UUID forKey:KEY_UUID];
    
    [GSKeyChain save:KEY_IN_KEYCHAIN_UUID data:usernamepasswordKVPairs];
}

+(NSString *)readUUID{
    
    NSMutableDictionary *usernamepasswordKVPair = (NSMutableDictionary *)[GSKeyChain load:KEY_IN_KEYCHAIN_UUID];
    
    return [usernamepasswordKVPair objectForKey:KEY_UUID];
    
}

+(void)deleteUUID{
    
    [GSKeyChain delete:KEY_IN_KEYCHAIN_UUID];
    
}

@end
