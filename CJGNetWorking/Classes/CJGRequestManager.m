//
//  CJGRequestManager.m
//  CJGNetworkingDemo
//
//  Created by NQ UEC on 2017/8/17.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "CJGRequestManager.h"
#import "CJGCacheManager.h"
#import "CJGURLRequest.h"
#import "NSString+CJGUTF8Encoding.h"

NSString *const _response =@"_response";
NSString *const _isCache =@"_isCache";
NSString *const _cacheKey =@"_cacheKey";
NSString *const _filePath =@"_filePath";
NSString *const cjg_downloadTempPath =@"AppTempDownload";
NSString *const cjg_downloadPath =@"AppDownload";
@implementation CJGRequestManager

#pragma mark - 公共配置
+ (void)setupBaseConfig:(void(^)(CJGConfig *config))block{
    CJGConfig *config=[[CJGConfig alloc]init];
    config.consoleLog=NO;
    block ? block(config) : nil;
    [[CJGRequestEngine defaultEngine] setupBaseConfig:config];
}
#pragma mark - 插件
+ (void)setRequestProcessHandler:(CJGRequestProcessBlock)requestHandler{
    [CJGRequestEngine defaultEngine].requestProcessHandler=requestHandler;
}

+ (void)setResponseProcessHandler:(CJGResponseProcessBlock)responseHandler{
    [CJGRequestEngine defaultEngine].responseProcessHandler = responseHandler;
}

+ (void)setErrorProcessHandler:(CJGErrorProcessBlock)errorHandler{
    [CJGRequestEngine defaultEngine].errorProcessHandler=errorHandler;
}

#pragma mark - 配置请求
+ (NSUInteger)requestWithConfig:(CJGRequestConfigBlock _Nonnull )config target:(id<CJGURLRequestDelegate>_Nonnull)target{
    return [self requestWithConfig:config progress:nil success:nil failure:nil finished:nil target:target];
}

+ (NSUInteger)requestWithConfig:(CJGRequestConfigBlock)config success:(CJGRequestSuccessBlock)success{
    return [self requestWithConfig:config progress:nil success:success failure:nil finished:nil];
}

+ (NSUInteger)requestWithConfig:(CJGRequestConfigBlock)config failure:(CJGRequestFailureBlock)failure{
    return [self requestWithConfig:config progress:nil success:nil failure:failure finished:nil];
}

+ (NSUInteger)requestWithConfig:(CJGRequestConfigBlock)config finished:(CJGRequestFinishedBlock)finished{
    return [self requestWithConfig:config progress:nil success:nil failure:nil finished:finished];
}

+ (NSUInteger)requestWithConfig:(CJGRequestConfigBlock)config success:(CJGRequestSuccessBlock)success failure:(CJGRequestFailureBlock)failure{
    return [self requestWithConfig:config progress:nil success:success failure:failure finished:nil];
}

+ (NSUInteger)requestWithConfig:(CJGRequestConfigBlock _Nonnull )config  success:(CJGRequestSuccessBlock _Nullable )success failure:(CJGRequestFailureBlock _Nullable )failure finished:(CJGRequestFinishedBlock _Nullable )finished{
    return [self requestWithConfig:config progress:nil success:success failure:failure finished:finished];
}

+ (NSUInteger)requestWithConfig:(CJGRequestConfigBlock)config progress:(CJGRequestProgressBlock)progress success:(CJGRequestSuccessBlock)success failure:(CJGRequestFailureBlock)failure{
    return [self requestWithConfig:config progress:progress success:success failure:failure finished:nil];
}

+ (NSUInteger)requestWithConfig:(CJGRequestConfigBlock)config progress:(CJGRequestProgressBlock)progress success:(CJGRequestSuccessBlock)success failure:(CJGRequestFailureBlock)failure finished:(CJGRequestFinishedBlock)finished{
    return [self requestWithConfig:config progress:progress success:success failure:failure finished:finished target:nil];
}

+ (NSUInteger)requestWithConfig:(CJGRequestConfigBlock)config progress:(CJGRequestProgressBlock)progress success:(CJGRequestSuccessBlock)success failure:(CJGRequestFailureBlock)failure finished:(CJGRequestFinishedBlock)finished target:(id<CJGURLRequestDelegate>)target{
    CJGURLRequest *request=[[CJGURLRequest alloc]init];
    config ? config(request) : nil;
    return [self sendRequest:request progress:progress success:success failure:failure finished:finished target:target];
}

#pragma mark - 配置批量请求
+ (CJGBatchRequest *)requestBatchWithConfig:(CJGBatchRequestConfigBlock)config target:(id<CJGURLRequestDelegate>_Nonnull)target{
    return [self requestBatchWithConfig:config progress:nil success:nil failure:nil finished:nil target:target];
}

+ (CJGBatchRequest *)requestBatchWithConfig:(CJGBatchRequestConfigBlock)config success:(CJGRequestSuccessBlock)success failure:(CJGRequestFailureBlock)failure finished:(CJGBatchRequestFinishedBlock)finished{
    return [self requestBatchWithConfig:config progress:nil success:success failure:failure finished:finished];
}

+ (CJGBatchRequest *)requestBatchWithConfig:(CJGBatchRequestConfigBlock)config progress:(CJGRequestProgressBlock)progress success:(CJGRequestSuccessBlock)success failure:(CJGRequestFailureBlock)failure finished:(CJGBatchRequestFinishedBlock)finished{
    return [self requestBatchWithConfig:config progress:progress success:success failure:failure finished:finished target:nil];
}

+ (CJGBatchRequest *)requestBatchWithConfig:(CJGBatchRequestConfigBlock)config progress:(CJGRequestProgressBlock)progress success:(CJGRequestSuccessBlock)success failure:(CJGRequestFailureBlock)failure finished:(CJGBatchRequestFinishedBlock)finished target:(id<CJGURLRequestDelegate>)target{
    CJGBatchRequest *batchRequest=[[CJGBatchRequest alloc]init];
    config ? config(batchRequest) : nil;
    if (batchRequest.requestArray.count==0)return nil;
    [batchRequest.responseArray removeAllObjects];
    [batchRequest.requestArray enumerateObjectsUsingBlock:^(CJGURLRequest *request , NSUInteger idx, BOOL *stop) {
        [batchRequest.responseArray addObject:[NSNull null]];
        [self sendRequest:request progress:progress success:success failure:failure finished:^(id responseObject, NSError *error,CJGURLRequest *request) {
            [batchRequest onFinishedRequest:request response:responseObject error:error finished:finished];
        }target:target];
    }];
    return batchRequest;
}

#pragma mark - 发起请求
+ (NSUInteger)sendRequest:(CJGURLRequest *)request progress:(CJGRequestProgressBlock)progress success:(CJGRequestSuccessBlock)success failure:(CJGRequestFailureBlock)failure finished:(CJGRequestFinishedBlock)finished target:(id<CJGURLRequestDelegate>)target{
        
    [self configBaseWithRequest:request progress:progress success:success failure:failure finished:finished target:target];
    
    if ([request.url isEqualToString:@""]||request.url==nil){
        NSLog(@"\n------------CJGNetworking------error info------begin------\n 请求失败 request.url 或 request.server + request.path不能为空 \n------------CJGNetworking------error info-------end-------");
        return 0;
    }
    
    if(request.parameters==nil){
        request.parameters= [NSMutableDictionary dictionary];
    }
    
    id obj=nil;
    if ([CJGRequestEngine defaultEngine].requestProcessHandler) {
        [CJGRequestEngine defaultEngine].requestProcessHandler(request,&obj);
        if (obj) {
            [self successWithResponse:nil responseObject:obj request:request];
            return 0;
        }
    }
    
    NSURLSessionTask * task=[[CJGRequestEngine defaultEngine]objectRequestForkey:request.url];
    if (request.apiType==CJGRequestTypeKeepFirst&&task) {
        return 0;
    }
    if (request.apiType==CJGRequestTypeKeepLast&&task) {
        [self cancelRequest:task.taskIdentifier];
    }

    NSUInteger identifier=[self startSendRequest:request];
    [[CJGRequestEngine defaultEngine]setRequestObject:request.task forkey:request.url];
    return identifier;
}

+ (NSUInteger)startSendRequest:(CJGURLRequest *)request{
    if (request.methodType==CJGMethodTypeUpload) {
       return [self sendUploadRequest:request];
    }else if (request.methodType==CJGMethodTypeDownLoad){
       return [self sendDownLoadRequest:request];
    }else{
       return [self sendHTTPRequest:request];
    }
}

+ (NSUInteger)sendUploadRequest:(CJGURLRequest *)request{
    return [[CJGRequestEngine defaultEngine] uploadWithRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        if (request.delegate&&[request.delegate respondsToSelector:@selector(requestProgress:)]) {
            [request.delegate requestProgress:uploadProgress];
        }
        request.progressBlock?request.progressBlock(uploadProgress):nil;
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self successWithResponse:task.response responseObject:responseObject request:request];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self failureWithError:error request:request];
    }];
}

+ (NSUInteger)sendHTTPRequest:(CJGURLRequest *)request{
    if (request.apiType==CJGRequestTypeRefresh||request.apiType==CJGRequestTypeRefreshMore||request.apiType==CJGRequestTypeKeepFirst||request.apiType==CJGRequestTypeKeepLast) {
        return [self dataTaskWithHTTPRequest:request];
    }else{
        NSString *key = [self keyWithParameters:request];
        if ([[CJGCacheManager sharedInstance]cacheExistsForKey:key]&&request.apiType==CJGRequestTypeCache){
            [self getCacheDataForKey:key request:request];
            return 0;
        }else{
            return [self dataTaskWithHTTPRequest:request];
        }
    }
}

+ (NSUInteger)dataTaskWithHTTPRequest:(CJGURLRequest *)request{
    return [[CJGRequestEngine defaultEngine]dataTaskWithMethod:request progress:^(NSProgress * _Nonnull cjg_progress) {
        if (request.delegate&&[request.delegate respondsToSelector:@selector(requestProgress:)]) {
            [request.delegate requestProgress:cjg_progress];
        }
        request.progressBlock ? request.progressBlock(cjg_progress) : nil;
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self successWithResponse:task.response responseObject:responseObject request:request];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self failureWithError:error request:request];
    }];
}

+ (NSUInteger)sendDownLoadRequest:(CJGURLRequest *)request{
    if (request.downloadState==CJGDownloadStateStart) {
        [[CJGCacheManager sharedInstance]createDirectoryAtPath:[self AppDownloadPath]];
        return [self downloadStartWithRequest:request];
    }else{
        return [self downloadStopWithRequest:request];
    }
}

+ (NSUInteger)downloadStartWithRequest:(CJGURLRequest*)request{
    NSString *AppDownloadTempPath=[self AppDownloadTempPath];
    NSData *resumeData;
    if ([[CJGCacheManager sharedInstance]cacheExistsForKey:request.url inPath:AppDownloadTempPath]) {
        resumeData=[[CJGCacheManager sharedInstance]getCacheDataForKey:request.url inPath:AppDownloadTempPath];
    }
    return [[CJGRequestEngine defaultEngine] downloadWithRequest:request resumeData:resumeData savePath:[self AppDownloadPath] progress:^(NSProgress * _Nullable downloadProgress) {
        if (request.delegate&&[request.delegate respondsToSelector:@selector(requestProgress:)]) {
            [request.delegate requestProgress:downloadProgress];
        }
        request.progressBlock?request.progressBlock(downloadProgress):nil;
    }completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            [self failureWithError:error request:request];
        }else{
            [self successWithResponse:response responseObject:[filePath path] request:request];
            if ([[CJGCacheManager sharedInstance]cacheExistsForKey:request.url inPath:AppDownloadTempPath]) {
                [[CJGCacheManager sharedInstance]clearCacheForkey:request.url inPath:AppDownloadTempPath completion:nil];
            }
        }
    }];
}

+ (NSUInteger)downloadStopWithRequest:(CJGURLRequest*)request{
    NSURLSessionTask * task=[[CJGRequestEngine defaultEngine]objectRequestForkey:request.url];
    NSURLSessionDownloadTask *downloadTask=(NSURLSessionDownloadTask *)task;
    [downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        NSString *AppDownloadTempPath=[self AppDownloadTempPath];
        [[CJGCacheManager sharedInstance]createDirectoryAtPath:AppDownloadTempPath];
        [[CJGCacheManager sharedInstance] storeContent:resumeData forKey:request.url inPath:AppDownloadTempPath isSuccess:^(BOOL isSuccess) {
            if (request.consoleLog==YES) {
                NSLog(@"\n------------CJGNetworking------download info------begin------\n暂停下载请求，保存当前已下载文件进度\n-URLAddress-:%@\n-downloadFileDirectory-:%@\n------------CJGNetworking------download info-------end-------",request.url,AppDownloadTempPath);
            }
        }];
    }];
    [request setTask:downloadTask];
    [request setIdentifier:downloadTask.taskIdentifier];
    return request.identifier;
}

#pragma mark - 取消请求
+ (void)cancelRequest:(NSUInteger)identifier{
    [[CJGRequestEngine defaultEngine]cancelRequestByIdentifier:identifier];
}

+ (void)cancelBatchRequest:(CJGBatchRequest *)batchRequest{
    if (batchRequest.requestArray.count>0) {
        [batchRequest.requestArray enumerateObjectsUsingBlock:^(CJGURLRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.identifier>0) {
                [self cancelRequest:obj.identifier];
            }
        }];
    }
}

+ (void)cancelAllRequest{
    [[CJGRequestEngine defaultEngine]cancelAllRequest];
}

#pragma mark - 其他配置
+ (void)configBaseWithRequest:(CJGURLRequest *)request progress:(CJGRequestProgressBlock)progress success:(CJGRequestSuccessBlock)success failure:(CJGRequestFailureBlock)failure finished:(CJGRequestFinishedBlock)finished target:(id<CJGURLRequestDelegate>)target{
    [[CJGRequestEngine defaultEngine] configBaseWithRequest:request progressBlock:progress successBlock:success failureBlock:failure finishedBlock:finished target:target];
}

+ (NSString *)keyWithParameters:(CJGURLRequest *)request{
    id newParameters;
    if (request.filtrationCacheKey.count>0) {
        newParameters=[CJGRequestTool formaParameters:request.parameters filtrationCacheKey:request.filtrationCacheKey];
    }else{
        newParameters = request.parameters;
    }
    NSString *key=[NSString cjg_stringUTF8Encoding:[NSString cjg_urlString:request.url appendingParameters:newParameters]];
    [request setValue:key forKey:_cacheKey];
    return key;
}

+ (void)storeObject:(NSObject *)object request:(CJGURLRequest *)request{
    [[CJGCacheManager sharedInstance] storeContent:object forKey:request.cacheKey isSuccess:nil];
}

+ (id)responsetSerializerConfig:(CJGURLRequest *)request responseObject:(id)responseObject{
    if (request.responseSerializer==CJGHTTPResponseSerializer||request.methodType==CJGMethodTypeDownLoad||![responseObject isKindOfClass:[NSData class]]) {
        return responseObject;
    }else{
        NSError *serializationError = nil;
        NSData *data = (NSData *)responseObject;
        // Workaround for behavior of Rails to return a single space for `head :ok` (a workaround for a bug in Safari), which is not interpreted as valid input by NSJSONSerialization.
        // See https://github.com/rails/rails/issues/1742
        BOOL isSpace = [data isEqualToData:[NSData dataWithBytes:" " length:1]];
        if (data.length > 0 && !isSpace) {
            id result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializationError];
            return result;
        } else {
            return nil;
        }
    }
}

+ (void)successWithResponse:(NSURLResponse *)response responseObject:(id)responseObject request:(CJGURLRequest *)request{
    [request setValue:response forKey:_response];
    [request setValue:@(NO) forKey:_isCache];
    id result=[self responsetSerializerConfig:request responseObject:responseObject];
    if ([CJGRequestEngine defaultEngine].responseProcessHandler) {
        NSError *processError = nil;
        id newResult =[CJGRequestEngine defaultEngine].responseProcessHandler(request, result,&processError);
        if (newResult) {
            result = newResult;
        }
        if (processError) {
            [self failureWithError:processError request:request];
            return;
        }
    }
    if (request.apiType == CJGRequestTypeRefreshAndCache||request.apiType == CJGRequestTypeCache) {
        [self storeObject:responseObject request:request];
    }
    [self successWithCacheCallbackForResult:result forRequest:request];
}

+ (void)failureWithError:(NSError *)error request:(CJGURLRequest *)request{
    if (request.consoleLog==YES) {
        [self printfailureInfoWithError:error request:request];
    }
    if ([CJGRequestEngine defaultEngine].errorProcessHandler) {
        [CJGRequestEngine defaultEngine].errorProcessHandler(request, error);
    }
    if (request.retryCount > 0) {
        request.retryCount --;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self startSendRequest:request];
        });
        return;
    }
    [self failureCallbackForError:error forRequest:request];
}

+ (void)getCacheDataForKey:(NSString *)key request:(CJGURLRequest *)request{
    [[CJGCacheManager sharedInstance]getCacheDataForKey:key value:^(NSData *data,NSString *filePath) {
        if (request.consoleLog==YES) {
            [self printCacheInfoWithkey:key filePath:filePath request:request];
        }
        [request setValue:filePath forKey:_filePath];
        [request setValue:@(YES) forKey:_isCache];
        id result=[self responsetSerializerConfig:request responseObject:data];
        if ([CJGRequestEngine defaultEngine].responseProcessHandler) {
            NSError *processError = nil;
            id newResult =[CJGRequestEngine defaultEngine].responseProcessHandler(request, result,&processError);
            if (newResult) {
                result = newResult;
            }
        }
        [self successWithCacheCallbackForResult:result forRequest:request];
    }];
}

+ (void)successWithCacheCallbackForResult:(id)result forRequest:(CJGURLRequest *)request{
    if (request.delegate&&[request.delegate respondsToSelector:@selector(requestSuccess:responseObject:)]) {
        [request.delegate requestSuccess:request responseObject:result];
    }
    if (request.delegate&&[request.delegate respondsToSelector:@selector(requestFinished:responseObject:error:)]) {
        [request.delegate requestFinished:request responseObject:result error:nil];
    }
    request.successBlock?request.successBlock(result, request):nil;
    request.finishedBlock?request.finishedBlock(result, nil,request):nil;
    [request cleanAllCallback];
    [[CJGRequestEngine defaultEngine] removeRequestForkey:request.url];
}

+ (void)failureCallbackForError:(NSError *)error forRequest:(CJGURLRequest *)request{
    if (request.delegate&&[request.delegate respondsToSelector:@selector(requestFailed:error:)]) {
        [request.delegate requestFailed:request error:error];
    }
    if (request.delegate&&[request.delegate respondsToSelector:@selector(requestFinished:responseObject:error:)]) {
        [request.delegate requestFinished:request responseObject:nil error:error];
    }
    request.failureBlock?request.failureBlock(error):nil;
    request.finishedBlock?request.finishedBlock(nil,error,request):nil;
    [request cleanAllCallback];
    [[CJGRequestEngine defaultEngine] removeRequestForkey:request.url];
}

#pragma mark - 获取网络状态
+ (BOOL)isNetworkReachable{
    return [CJGRequestEngine defaultEngine].networkReachability != 0;
}

+ (BOOL)isNetworkWiFi{
    return [CJGRequestEngine defaultEngine].networkReachability == 2;
}

+ (CJGNetworkReachabilityStatus)networkReachability{
    return [[CJGRequestEngine defaultEngine]networkReachability];
}

+ (void)setReachabilityStatusChangeBlock:(void (^)(CJGNetworkReachabilityStatus status))block{
    [[CJGRequestEngine defaultEngine]setReachabilityStatusChangeBlock:block];
}

#pragma mark - 下载获取文件
+ (NSString *)getDownloadFileForKey:(NSString *)key{
    return [[CJGCacheManager sharedInstance]getDiskFileForKey:[key lastPathComponent] inPath:[self AppDownloadPath]];
}

+ (NSString *)AppDownloadPath{
    return [[[CJGCacheManager sharedInstance] CJGKitPath]stringByAppendingPathComponent:cjg_downloadPath];
}

+ (NSString *)AppDownloadTempPath{
    return [[[CJGCacheManager sharedInstance] CJGKitPath]stringByAppendingPathComponent:cjg_downloadTempPath];
}

#pragma mark - 打印log
+ (void)printCacheInfoWithkey:(NSString *)key filePath:(NSString *)filePath request:(CJGURLRequest *)request{
    NSString *responseStr=request.responseSerializer==CJGHTTPResponseSerializer ?@"HTTP":@"JOSN";
    if ([filePath isEqualToString:@"memoryCache"]) {
        NSLog(@"\n------------CJGNetworking------cache info------begin------\n-cachekey-:%@\n-cacheFileSource-:%@\n-responseSerializer-:%@\n-filtrationCacheKey-:%@\n------------CJGNetworking------cache info-------end-------",key,filePath,responseStr,request.filtrationCacheKey);
    }else{
        NSLog(@"\n------------CJGNetworking------cache info------begin------\n-cachekey-:%@\n-cacheFileSource-:%@\n-cacheFileInfo-:%@\n-responseSerializer-:%@\n-filtrationCacheKey-:%@\n------------CJGNetworking------cache info-------end-------",key,filePath,[[CJGCacheManager sharedInstance] getDiskFileAttributesWithFilePath:filePath],responseStr,request.filtrationCacheKey);
    }
}

+ (void)printfailureInfoWithError:(NSError *)error request:(CJGURLRequest *)request{
    NSLog(@"\n------------CJGNetworking------error info------begin------\n-URLAddress-:%@\n-retryCount-%ld\n-error code-:%ld\n-error info-:%@\n------------CJGNetworking------error info-------end-------",request.url,request.retryCount,error.code,error.localizedDescription);
}

@end
