//
//  CJGRequestManager.h
//  CJGNetworkingDemo
//
//  Created by NQ UEC on 2017/8/17.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJGRequestEngine.h"

@class CJGConfig;

@interface CJGRequestManager : NSObject

///
/// 公共配置方法   此回调只会在配置时调用一次，如果不变的公共参数可在此配置。
///
/// @param block           请求配置  Block
///
+ (void)setupBaseConfig:(void(^_Nullable)(CJGConfig * _Nullable config))block;

///
/// 插件机制    此回调每次请求前调用一次，如果公共参数是动态的 可在此配置。
///
/// 自定义 请求 处理逻辑的方法
/// @param requestHandler        处理请求前的逻辑 Block
///
+ (void)setRequestProcessHandler:(CJGRequestProcessBlock _Nullable )requestHandler;
///
/// 插件机制   此回调每次请求成功时调用一次。
///
/// 自定义 响应 处理逻辑的方法
/// @param responseHandler       处理响应结果的逻辑 Block
///
+ (void)setResponseProcessHandler:(CJGResponseProcessBlock _Nullable )responseHandler;
///
/// 插件机制   此回调每次请求失败时调用一次。
///
/// 自定义 错误 处理逻辑的方法
/// @param errorHandler          处理响应结果的逻辑 Block
///
+ (void)setErrorProcessHandler:(CJGErrorProcessBlock _Nullable )errorHandler;

///
/// 请求方法
///
/// @param config           请求配置  Block
/// @param target           执行代理的对象
/// @return identifier      请求标识符
///
///
+ (NSUInteger)requestWithConfig:(CJGRequestConfigBlock _Nonnull )config target:(id<CJGURLRequestDelegate>_Nonnull)target;

///
/// 请求方法
///
/// @param config           请求配置  Block
/// @param success          请求成功的 Block
/// @return identifier      请求标识符
///
+ (NSUInteger)requestWithConfig:(CJGRequestConfigBlock _Nonnull )config success:(CJGRequestSuccessBlock _Nullable )success;

///
/// 请求方法
///
/// @param config           请求配置  Block
/// @param failure          请求失败的 Block
/// @return identifier      请求标识符
///
+ (NSUInteger)requestWithConfig:(CJGRequestConfigBlock _Nonnull )config failure:(CJGRequestFailureBlock _Nullable )failure;

///
/// 请求方法
///
/// @param config           请求配置  Block
/// @param finished         请求完成的 Block
/// @return identifier      请求标识符
///
+ (NSUInteger)requestWithConfig:(CJGRequestConfigBlock _Nonnull )config finished:(CJGRequestFinishedBlock _Nullable )finished;

///
/// 请求方法
///
/// @param config           请求配置  Block
/// @param success          请求成功的 Block
/// @param failure          请求失败的 Block
/// @return identifier      请求标识符
///
+ (NSUInteger)requestWithConfig:(CJGRequestConfigBlock _Nonnull )config  success:(CJGRequestSuccessBlock _Nullable )success failure:(CJGRequestFailureBlock _Nullable )failure;

///
/// 请求方法
///
/// @param config           请求配置  Block
/// @param success          请求成功的 Block
/// @param failure          请求失败的 Block
/// @param finished         请求完成的 Block
/// @return identifier      请求标识符
///
+ (NSUInteger)requestWithConfig:(CJGRequestConfigBlock _Nonnull )config  success:(CJGRequestSuccessBlock _Nullable )success failure:(CJGRequestFailureBlock _Nullable )failure finished:(CJGRequestFinishedBlock _Nullable )finished;

///
/// 请求方法 进度
///
/// @param config           请求配置  Block
/// @param progress         请求进度  Block
/// @param success          请求成功的 Block
/// @param failure          请求失败的 Block
/// @return identifier      请求标识符
///
+ (NSUInteger)requestWithConfig:(CJGRequestConfigBlock _Nonnull )config  progress:(CJGRequestProgressBlock _Nullable )progress success:(CJGRequestSuccessBlock _Nullable )success failure:(CJGRequestFailureBlock _Nullable )failure;

///
/// 请求方法 进度
///
/// @param config           请求配置  Block
/// @param progress         请求进度  Block
/// @param success          请求成功的 Block
/// @param failure          请求失败的 Block
/// @param finished         请求完成的 Block
/// @return identifier      请求标识符
///
+ (NSUInteger)requestWithConfig:(CJGRequestConfigBlock _Nonnull)config progress:(CJGRequestProgressBlock _Nullable )progress success:(CJGRequestSuccessBlock _Nullable )success failure:(CJGRequestFailureBlock _Nullable )failure finished:(CJGRequestFinishedBlock _Nullable )finished;

///
/// 批量请求方法
///
/// @param config           请求配置  Block
/// @param target           执行代理的对象
/// @return identifier      请求标识符
///
+ (CJGBatchRequest *_Nullable)requestBatchWithConfig:(CJGBatchRequestConfigBlock _Nonnull )config target:(id<CJGURLRequestDelegate>_Nonnull)target;

///
/// 批量请求方法
///
/// @param config           请求配置  Block
/// @param success          请求成功的 Block
/// @param failure          请求失败的 Block
/// @param finished         批量请求完成的 Block
/// @return BatchRequest    批量请求对象
///
+ (CJGBatchRequest *_Nullable)requestBatchWithConfig:(CJGBatchRequestConfigBlock _Nonnull )config success:(CJGRequestSuccessBlock _Nullable )success failure:(CJGRequestFailureBlock _Nullable )failure finished:(CJGBatchRequestFinishedBlock _Nullable )finished;

///
/// 批量请求方法 进度
///
/// @param config           请求配置  Block
/// @param progress         请求进度  Block
/// @param success          请求成功的 Block
/// @param failure          请求失败的 Block
/// @param finished         批量请求完成的 Block
/// @return BatchRequest    批量请求对象
///
+ (CJGBatchRequest *_Nullable)requestBatchWithConfig:(CJGBatchRequestConfigBlock _Nonnull )config progress:(CJGRequestProgressBlock _Nullable )progress success:(CJGRequestSuccessBlock _Nullable )success failure:(CJGRequestFailureBlock _Nullable )failure finished:(CJGBatchRequestFinishedBlock _Nullable )finished;

////
 /// 取消单个请求任务
 ///
 /// @param identifier         请求identifier
 ///
+ (void)cancelRequest:(NSUInteger)identifier;

///
/// 取消批量请求任务
///
/// @param batchRequest       批量请求对象
///
+ (void)cancelBatchRequest:(CJGBatchRequest *_Nullable)batchRequest;

/// 取消所有请求任务 活跃的请求都会被取消
+ (void)cancelAllRequest;

///获取网络状态 是否可用
+ (BOOL)isNetworkReachable;

///是否为WiFi网络
+ (BOOL)isNetworkWiFi;

///
/// 当前网络的状态值，
/// CJGNetworkReachabilityStatusUnknown      表示 `Unknown`，
/// CJGNetworkReachabilityStatusNotReachable 表示 `NotReachable
/// CJGNetworkReachabilityStatusViaWWAN      表示 `WWAN`
/// CJGNetworkReachabilityStatusViaWiFi      表示 `WiFi`
///
+ (CJGNetworkReachabilityStatus)networkReachability;

///
/// 动态获取当前网络的状态值，
/// @param block         当前网络的状态值
/// CJGNetworkReachabilityStatusUnknown      表示 `Unknown`，
/// CJGNetworkReachabilityStatusNotReachable 表示 `NotReachable
/// CJGNetworkReachabilityStatusViaWWAN      表示 `WWAN`
/// CJGNetworkReachabilityStatusViaWiFi      表示 `WiFi`
///
+ (void)setReachabilityStatusChangeBlock:(nullable void (^)(CJGNetworkReachabilityStatus status))block;

///
/// 获取下载文件
///
/// @param  key                 一般为请求地址
/// @return 获取下载文件
///
+ (NSString *_Nullable)getDownloadFileForKey:(NSString *_Nonnull)key;

///
/// 获取沙盒默认创建的AppDownload目录
///
/// @return Library/Caches/CJGKit/AppDownload路径
///
+ (NSString *_Nonnull)AppDownloadPath;

@end

