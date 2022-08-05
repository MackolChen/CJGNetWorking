//
//  CJGRequestConst.h
//  CJGNetworkingDemo
//
//  Created by NQ UEC on 2017/8/17.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#ifndef CJGRequestConst_h
#define CJGRequestConst_h
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#endif

@class CJGURLRequest,CJGBatchRequest;

///用于标识不同类型的请求
///默认为重新请求.  default:CJGRequestTypeRefresh
typedef NS_ENUM(NSInteger,CJGApiType) {
     ///重新请求:  不读取缓存，不存储缓存
     ///没有缓存需求的，单独使用
    CJGRequestTypeRefresh,
     ///重新请求:  不读取缓存，但存储缓存
     ///可以与 CJGRequestTypeCache 配合使用
    CJGRequestTypeRefreshAndCache,
    ///读取缓存:  有缓存,读取缓存--无缓存，重新请求并存储缓存
    ///可以与CJGRequestTypeRefreshAndCache 配合使用
    CJGRequestTypeCache,
    ///重新请求： 上拉加载更多业务，不读取缓存，不存储缓存
    ///用于区分业务 可以不用
    CJGRequestTypeRefreshMore,
    ///重新请求:  不读取缓存，不存储缓存.同一请求重复请求，请求结果没有响应的时候，使用第一次请求结果
    ///如果请求结果响应了，会终止此过程
    CJGRequestTypeKeepFirst,
    ///重新请求:   不读取缓存，不存储缓存.同一请求重复请求，请求结果没有响应的时候，使用最后一次请求结果
    ///如果请求结果响应了，会终止此过程
    CJGRequestTypeKeepLast,
};
///HTTP 请求类型.
///默认为GET请求.   default:CJGMethodTypeGET
typedef NS_ENUM(NSInteger,CJGMethodType) {
    ///GET请求
    CJGMethodTypeGET,
    ///POST请求
    CJGMethodTypePOST,
    ///Upload请求
    CJGMethodTypeUpload,
    ///DownLoad请求
    CJGMethodTypeDownLoad,
    ///PUT请求
    CJGMethodTypePUT,
    ///PATCH
    CJGMethodTypePATCH,
    ///DELETE
    CJGMethodTypeDELETE,
    ///HEAD
    CJGMethodTypeHEAD
};
///请求参数的格式.
///默认为JSON.   default:CJGJSONRequestSerializer
typedef NS_ENUM(NSUInteger, CJGRequestSerializerType) {
    ///设置请求参数为JSON格式
    CJGJSONRequestSerializer,
    ///设置请求参数为二进制格式
    CJGHTTPRequestSerializer,
};
///返回响应数据的格式.
///默认为JSON.  default:CJGJSONResponseSerializer
typedef NS_ENUM(NSUInteger, CJGResponseSerializerType) {
    ///设置响应数据为JSON格式
    CJGJSONResponseSerializer,
    ///设置响应数据为二进制格式
    CJGHTTPResponseSerializer
};
///下载请求的 操作状态
typedef NS_ENUM(NSUInteger, CJGDownloadState) {
    ///开始请求
    CJGDownloadStateStart,
    ///暂停请求
    CJGDownloadStateStop,
};
///当前网络的状态值，
typedef NS_ENUM(NSInteger, CJGNetworkReachabilityStatus) {
    ///Unknown
    CJGNetworkReachabilityStatusUnknown          = -1,
    ///NotReachable
    CJGNetworkReachabilityStatusNotReachable     = 0,
    ///WWAN
    CJGNetworkReachabilityStatusViaWWAN          = 1,
    ///WiFi
    CJGNetworkReachabilityStatusViaWiFi          = 2,
};

//==================================================
///请求配置
typedef void (^CJGRequestConfigBlock)(CJGURLRequest * _Nullable request);
///请求成功
typedef void (^CJGRequestSuccessBlock)(id _Nullable responseObject,CJGURLRequest * _Nullable request);
///请求失败
typedef void (^CJGRequestFailureBlock)(NSError * _Nullable error);
///请求进度
typedef void (^CJGRequestProgressBlock)(NSProgress * _Nullable progress);
///请求完成 无论成功和失败
typedef void (^CJGRequestFinishedBlock)(id _Nullable responseObject,NSError * _Nullable error,CJGURLRequest * _Nullable request);
//==================================================
///批量请求配置
typedef void (^CJGBatchRequestConfigBlock)(CJGBatchRequest * _Nonnull batchRequest);
///批量请求 全部完成 无论成功和失败
typedef void (^CJGBatchRequestFinishedBlock)(NSArray * _Nullable responseObjects,NSArray<NSError *> * _Nullable errors,NSArray<CJGURLRequest *> *_Nullable requests);
//==================================================
///请求 处理逻辑
typedef void (^CJGRequestProcessBlock)(CJGURLRequest * _Nullable request,id _Nullable __autoreleasing * _Nullable setObject);
///响应 处理逻辑
typedef id _Nullable (^CJGResponseProcessBlock)(CJGURLRequest * _Nullable request, id _Nullable responseObject, NSError * _Nullable __autoreleasing * _Nullable error);
///错误 处理逻辑
typedef void (^CJGErrorProcessBlock)(CJGURLRequest * _Nullable request, NSError * _Nullable error);
//==================================================
///Request协议
@protocol CJGURLRequestDelegate <NSObject>
@required
///请求成功
- (void)requestSuccess:(CJGURLRequest *_Nullable)request responseObject:(id _Nullable)responseObject ;
@optional
///请求失败
- (void)requestFailed:(CJGURLRequest *_Nullable)request error:(NSError *_Nullable)error;
///请求进度
- (void)requestProgress:(NSProgress * _Nullable)progress;
///请求完成
- (void)requestFinished:(CJGURLRequest *_Nullable)request responseObject:(id _Nullable)responseObject error:(NSError *_Nullable)error;
///批量请求 全部完成 无论成功和失败
- (void)requestBatchFinished:(NSArray<CJGURLRequest *> *_Nullable)requests responseObjects:(NSArray * _Nullable) responseObjects errors:(NSArray<NSError *> * _Nullable)errors;
@end

#endif /* CJGRequestConst_h */
