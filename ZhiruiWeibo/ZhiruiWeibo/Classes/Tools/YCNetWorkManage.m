//
//  YCNetWorkManage.m
//  YCMusic
//
//  Created by DIT on 16/9/21.
//  Copyright © 2016年 Coco. All rights reserved.
//

#import "YCNetWorkManage.h"
#import "AFNetworking.h"
#import <YYCache/YYCache.h>
#define kNOWORK @"网路错误"

NSString * const YCHttpCache = @"YCHttpCache";
#define YCLog(...) NSLog(__VA_ARGS__)  //如果不需要打印数据, 注释掉NSLog
// 请求方式
typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypeGet,
    RequestTypePost,
    RequestTypeUpLoad,
    RequestTypeDownload
};

@implementation YCNetWorkManage







+(void)getRequestUrlStr:(NSString *)urlStr success:(SuccessBlock)success failure:(FailureBlock)failure
{
    
    
    [[self alloc] requestWithUrl:urlStr withDic:nil requestType:RequestTypeGet isCache:NO cacheKey:nil imageKey:nil withData:nil upLoadProgress:^(float progress) {
        
    } success:^(id requestJson) {
        
        success(requestJson);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];

}




+(void)getRequestCacheUrlStr:(NSString *)urlStr success:(SuccessBlock)success failure:(FailureBlock)failuer{
    
    
    [[self alloc] requestWithUrl:urlStr withDic:nil requestType:RequestTypeGet isCache:YES cacheKey:nil imageKey:nil withData:nil upLoadProgress:^(float progress) {
        
    } success:^(id requestJson) {
        success(requestJson);
    } failure:^(NSString *errorInfo) {
         failuer(errorInfo);
    }];
    
 
}


+(void)postRequestUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure
{
//    ..
    [[self alloc] requestWithUrl:urlStr withDic:parameters requestType:RequestTypePost isCache:NO cacheKey:urlStr imageKey:nil withData:nil upLoadProgress:^(float progress) {
        
    } success:^(id requestJson) {
         success(requestJson);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);

    }];

}

+(void)postRequestCacheUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[self alloc] requestWithUrl:urlStr withDic:parameters requestType:RequestTypePost isCache:YES cacheKey:urlStr imageKey:nil withData:nil upLoadProgress:^(float progress) {
        
    } success:^(id requestJson) {
         success(requestJson);
    } failure:^(NSString *errorInfo) {
        failure(errorInfo);
    }];

}

+(void)upLoadDataWithUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parameters imageKey:(NSString *)attach withData:(NSData *)data upLoadProgress:(loadProgress)loadProgress success:(SuccessBlock)success failure:(FailureBlock)failure
{
    
    [[self alloc] requestWithUrl:urlStr withDic:parameters requestType:RequestTypeUpLoad isCache:NO cacheKey:urlStr imageKey:attach withData:data upLoadProgress:^(float progress) {
        loadProgress(progress);
    } success:^(id requestJson) {
        success(requestJson);
    } failure:^(NSString *errorInfo) {
        
    }];

  
}
#pragma mark -- 网络请求统一处理
-(void)requestWithUrl:(NSString *)url withDic:(NSDictionary *)parameters requestType:(RequestType)requestType  isCache:(BOOL)isCache  cacheKey:(NSString *)cacheKey imageKey:(NSString *)attach withData:(NSData *)data upLoadProgress:(loadProgress)loadProgress success:(SuccessBlock)success failure:(FailureBlock)failure
{
    
    
  
    
    
    
    
//    for (NSString *dictKey  in [parameters allKeys]) {
//        
//        
//        if (![dictKey isEqualToString:@"coordSystem"]) {
//            [nowParamsDict setObject:[parameters objectForKey:dictKey] forKey:dictKey];
//            
//            
//        }
//        
//    }
    
   
   
    id cacheData;
    NSString * cacheUrl;
    if (isCache) {
        //拼接
        cacheUrl = [self urlDictToStringWithUrlStr:url WithDict:parameters];
//        YCLog(@"\n\n 网址 \n\n      %@    \n\n 网址 \n\n",cacheUrl);
        //设置YYCache属性
        YYCache *cache = [[YYCache alloc] initWithName:YCHttpCache];
        
        cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
        //根据网址从Cache中取数据
        cacheData = [cache objectForKey:cacheUrl];

        if (cacheData != 0) {
            //将数据统一处理
            
            [self returnDataWithRequestData:cacheData Success:^(id requestJson) {
//                NSLog(@"%@>>>>>>>",requestJson);
                success(requestJson);
            } failure:^(NSString *errorInfo) {

            }];

        }
    }
    
    //进行网络检查
    
//    if (![self requestBeforeJudgeConnect]) {
//        failure(kNOWORK);
//        YCLog(@"\n\n----%@------\n\n",@"没有网络");
//        return;
//    }
    
    [YCNetWorkManage netWorkReachability:^(NSInteger reastate) {
        switch (reastate) {
            case 0:
                failure(kNOWORK);
                return ;
                break;
                
            default:
                break;
        }
        
        
    }];
    
 
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes=[NSSet setWithArray:@[@"application/json;charset=UTF-8",@"application/json",@"text/javascript",@"text/json",@"text/plain;charset=UTF-8",@"text/html;charset=utf-8",@"text/plain"]];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer.timeoutInterval = 10;
     NSString *fileString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    //get请求
    if (requestType == RequestTypeGet) {
        [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (isCache) {
                [self dealWithResponseObject:responseObject cacheKey:cacheUrl];
            }
            id jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(jsonData);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(kNOWORK);
        }];
        
    }
    
    //post请求
    if (requestType == RequestTypePost) {
     
        
    
        
        [session POST:fileString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (isCache) {
                [self dealWithResponseObject:responseObject cacheKey:cacheUrl];
            }
            
            id jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(jsonData);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           
            

            
            NSInteger  statusCode = [error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
            
            
            if (statusCode == 401) {
                
               
                failure(@"登录失效");
            }else{
            
            failure(kNOWORK);
            }
        }];

    }
    
    //上传
    if (requestType == RequestTypeUpLoad) {
        [session POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSTimeInterval timeInterVal = [[NSDate date] timeIntervalSince1970];
            NSString * fileName = [NSString stringWithFormat:@"%@.png",@(timeInterVal)];
            [formData appendPartWithFileData:data name:attach fileName:fileName mimeType:@"image/png"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
            
            loadProgress((float)uploadProgress.completedUnitCount/(float)uploadProgress.totalUnitCount);
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            id jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(jsonData);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(kNOWORK);
            YCLog(@"上传文件发生错误\n\n    %@  \n\n",error);
        }];
        
        
        
        
    }
}




#pragma mark  统一处理请求到的数据
-(void)dealWithResponseObject:(NSData *)responseData cacheKey:(NSString *)cacheKey
{
    
    //设置YYCache属性
    YYCache *cache = [[YYCache alloc] initWithName:YCHttpCache];
    
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;// 关闭网络指示器
    });
    NSString * dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    dataString = [self deleteSpecialCodeWithStr:dataString];
    NSData *requestData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [cache setObject:requestData forKey:cacheKey];
}


/**
 *  拼接post请求的网址
 *
 *  @param urlStr     基础网址
 *  @param parameters 拼接参数
 *
 *  @return 拼接完成的网址
 */
-(NSString *)urlDictToStringWithUrlStr:(NSString *)urlStr WithDict:(NSDictionary *)parameters
{
    if (!parameters) {
        return urlStr;
    }
    
    
    NSMutableArray *parts = [NSMutableArray array];
    //enumerateKeysAndObjectsUsingBlock会遍历dictionary并把里面所有的key和value一组一组的展示给你，每组都会执行这个block 这其实就是传递一个block到另一个方法，在这个例子里它会带着特定参数被反复调用，直到找到一个ENOUGH的key，然后就会通过重新赋值那个BOOL *stop来停止运行，停止遍历同时停止调用block
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //接收key
        NSString *finalKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        //接收值
        NSString *finalValue = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        
        NSString *part =[NSString stringWithFormat:@"%@=%@",finalKey,finalValue];
        
        [parts addObject:part];
        
    }];
    
    NSString *queryString = [parts componentsJoinedByString:@"&"];
    
    queryString = queryString ? [NSString stringWithFormat:@"?%@",queryString] : @"";
    
    NSString *pathStr = [NSString stringWithFormat:@"%@?%@",urlStr,queryString];
    
    return pathStr;
    
    
    
}


#pragma mark --根据返回的数据进行统一的格式处理  ----requestData 网络或者是缓存的数据----
- (void)returnDataWithRequestData:(NSData *)requestData Success:(SuccessBlock)success failure:(FailureBlock)failure{
    id myResult = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
    if (myResult) {
        success(myResult);
    }else{
    
        failure(kNOWORK);
    }
    
    //判断是否为字典
//    if ([myResult isKindOfClass:[NSDictionary  class]]) {
//        NSDictionary *  requestDic = (NSDictionary *)myResult;
//        NSLog(@"------ %@",myResult);
//        //根据返回的接口内容来变
//        NSString * succ = requestDic[@"status"];
//        if ([succ isEqualToString:@"success"]) {
//            success(requestDic[@"result"],requestDic[@"msg"]);
//        }else{
//            failure(requestDic[@"msg"]);
//        }
//        
//    }
    
}

#pragma mark  网络判断
//-(BOOL)requestBeforeJudgeConnect
//{
//    
//    [YCNetWorkManage netWorkReachability:^(NSInteger reastate) {
//        
//        switch (reastate) {
//            case 0:{
//                return  NO;
//            }
//                break;
//            
//                
//            default:{
//                return YES;
//            }break;
//        }
//        
//    }];

//    struct sockaddr zeroAddress;
//    bzero(&zeroAddress, sizeof(zeroAddress));
//    zeroAddress.sa_len = sizeof(zeroAddress);
//    zeroAddress.sa_family = AF_INET;
//    SCNetworkReachabilityRef defaultRouteReachability =
//    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
//    SCNetworkReachabilityFlags flags;
//    BOOL didRetrieveFlags =
//    SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
//    CFRelease(defaultRouteReachability);
//    if (!didRetrieveFlags) {
//        printf("Error. Count not recover network reachability flags\n");
//        return NO;
//    }
//    BOOL isReachable = flags & kSCNetworkFlagsReachable;
//    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
//    BOOL isNetworkEnable  =(isReachable && !needsConnection) ? YES : NO;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [UIApplication sharedApplication].networkActivityIndicatorVisible =isNetworkEnable;/*  网络指示器的状态： 有网络 ： 开  没有网络： 关  */
//    });
//    return YES;//isNetworkEnable;
//}

#pragma mark -- 处理json格式的字符串中的换行符、回车符
- (NSString *)deleteSpecialCodeWithStr:(NSString *)str {
    NSString *string = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    return string;
}



/**
 *  获取用户的网络状态
 *
 *  @param reastate 返回值当前状态
 */
+(void)netWorkReachability:(void (^)(NSInteger reastate))reastate{
    
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                reastate(statusUnknown);
                break;
            case AFNetworkReachabilityStatusNotReachable:
                reastate(statusNotReachable);
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                reastate(statusReachableViaWWAN);
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                reastate(statusReachableViaWiFi);
                break;
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
}


@end
