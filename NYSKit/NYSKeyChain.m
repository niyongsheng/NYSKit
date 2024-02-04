//
//  NYSSignHandleKeyChain.m
//
//  NYSKit http://github.com/niyongsheng
//  Copyright © 2020 NYS. ALL rights reserved.
//

#import "NYSKeyChain.h"
#import "NYSTools.h"
#import <Security/Security.h>

@implementation NYSKeyChain

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword, (id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock, (id)kSecAttrAccessible, nil];
}

#pragma mark - 写入
+ (void)save:(NSString *)service data:(id)data {
    // Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    // Archive data using the new method
    NSError *archiveError = nil;
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:data
                                               requiringSecureCoding:NO
                                                               error:&archiveError];
    if (archiveError) {
        // Handle the archiving error
        [NYSTools log:self.class error:archiveError];
        return;
    }
    
    // Add new object to search dictionary
    [keychainQuery setObject:archivedData forKey:(id)kSecValueData];
    
    // Add item to keychain with the search dictionary
    OSStatus status = SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    
    if (status == errSecDuplicateItem) {
        // If item already exists, update it
        [self update:service data:data];
    }
}

+ (void)update:(NSString *)service data:(id)data {
    // Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    // Archive data using the new method
    NSError *archiveError = nil;
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:data
                                               requiringSecureCoding:NO
                                                               error:&archiveError];
    if (archiveError) {
        // Handle the archiving error
        [NYSTools log:self.class error:archiveError];
        return;
    }
    
    // Create a new search dictionary with the updated data
    NSDictionary *updateDictionary = @{(id)kSecValueData: archivedData};
    
    // Update existing item in keychain
    OSStatus status = SecItemUpdate((CFDictionaryRef)keychainQuery, (CFDictionaryRef)updateDictionary);
    
    if (status != errSecSuccess) {
        // Handle the update error
        [NYSTools log:self.class msg:[NSString stringWithFormat:@"Keychain update error: %ld", (long)status]];
    }
}


#pragma mark - 读取
+ (id)load:(NSString *)service {
    id result = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    // Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            NSError *unarchiveError = nil;
            result = [NSKeyedUnarchiver unarchivedObjectOfClass:[NYSKeyChain class] fromData:(__bridge_transfer NSData *)keyData error:&unarchiveError];
            
            if (unarchiveError) {
                // Handle the unarchiving error
                [NYSTools log:self.class error:unarchiveError];
            }
        } @catch (NSException *exception) {
            [NYSTools log:self.class msg:[NSString stringWithFormat:@"Unarchive of %@ failed: %@", service, exception]];
        } @finally {
            
        }
    }
    
    if (keyData) {
        CFRelease(keyData);
    }
    
    return result;
}

#pragma mark - 删除
+ (void)delete:(NSString *)service{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

@end
