//
//  CJGRequestEngine.h
//  CJGNetworkingDemo
//
//  Created by NQ UEC on 2017/8/17.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "CJGRequestConst.h"
@class CJGConfig;

@interface CJGRequestEngine : AFHTTPSessionManager
NS_ASSUME_NONNULL_BEGIN
+ (instancetype)defaultEngine;

///自定义请求 处理逻辑的方法 Block
@property (nonatomic, copy) CJGRequestProcessBlock requestProcessHandler;

/// 自定义响应 处理逻辑的方法 Block
@property (nonatomic, copy) CJGResponseProcessBlock responseProcessHandler;

///自定义错误 处理逻辑的方法 Block
@property (nonatomic, copy) CJGErrorProcessBlock errorProcessHandler;

///公共基础配置
- (void)setupBaseConfig:(CJGConfig *)config;

///公共基础配置与单个请求配置的兼容
- (void)configBaseWithRequest:(CJGURLRequest *)request progressBlock:(CJGRequestProgressBlock)progressBlock successBlock:(CJGRequestSuccessBlock)successBlock failureBlock:(CJGRequestFailureBlock)failureBlock finishedBlock:(CJGRequestFinishedBlock)finishedBlock target:(id<CJGURLRequestDelegate>)target;

///
/// 发起网络请求

/// @param request             CJGURLRequest
/// @param progress            进度
/// @param success             成功回调
/// @param failure             失败回调
/// @return identifier         请求标识符
///
- (NSUInteger)dataTaskWithMethod:(CJGURLRequest *_Nullable)request progress:(void (^_Nullable)(NSProgress * _Nullable))progress success:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;

///
/// 上传文件

/// @param request                 CJGURLRequest
/// @param uploadProgressBlock     进度
/// @param success                 成功回调
/// @param failure                 失败回调
/// @return identifier             请求标识符
///
- (NSUInteger)uploadWithRequest:(CJGURLRequest *_Nullable)request progress:(void (^)(NSProgress * _Nonnull))uploadProgressBlock success:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;

///
/// 下载文件

/// @param request                 CJGURLRequest
/// @param downloadProgressBlock   进度
/// @param completionHandler       回调
/// @return identifier             请求标识符
///
- (NSUInteger)downloadWithRequest:(CJGURLRequest *)request resumeData:(NSData *)resumeData savePath:(NSString *)savePath progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

/// 当前网络的状态值，-1 表示 `Unknown`，0 表示 `NotReachable，1 表示 `WWAN`，2 表示 `WiFi`
- (NSInteger)networkReachability;

///动态获取 当前网络的状态值，-1 表示 `Unknown`，0 表示 `NotReachable，1 表示 `WWAN`，2 表示 `WiFi`
- (void)setReachabilityStatusChangeBlock:(void (^)(NSInteger status))block;

///
/// 取消单个请求任务
/// @param identifier        请求identifier
///
- (void)cancelRequestByIdentifier:(NSUInteger)identifier;

///取消所有请求任务
- (void)cancelAllRequest;

///管理请求对象的生命周期
- (void)setRequestObject:(id)obj forkey:(NSString *)key;
- (void)removeRequestForkey:(NSString *)key;
- (id _Nullable)objectRequestForkey:(NSString *)key;

NS_ASSUME_NONNULL_END

@end