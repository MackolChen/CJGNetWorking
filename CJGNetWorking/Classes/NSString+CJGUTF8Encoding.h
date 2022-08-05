//
//  NSString+CJGUTF8Encoding.h
//  CJGNetworkingDemo
//
//  Created by NQ UEC on 2018/5/21.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CJGUTF8Encoding)
/// UTF-8编码
/// @param urlString 编码前的url字符串
+ (NSString *)cjg_stringUTF8Encoding:(NSString *)urlString;

/// url路径拼接参数
/// @param urlString url
/// @param parameters 参数
+ (NSString *)cjg_urlString:(NSString *)urlString appendingParameters:(id)parameters;

@end

@interface CJGRequestTool : NSObject

/// 参数过滤变动参数
/// @param parameters 参数
/// @param filtrationCacheKey 需要过滤的参数Key
+ (id)formaParameters:(id)parameters filtrationCacheKey:(NSArray *)filtrationCacheKey;

@end
