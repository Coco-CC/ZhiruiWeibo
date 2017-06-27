//
//  YCNetWorkManage.h
//  YCMusic
//
//  Created by DIT on 16/9/21.
//  Copyright © 2016年 Coco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYCache/YYCache.h>

typedef void (^SuccessBlock)(id requestJson); //成功回调
typedef void (^FailureBlock)(NSString *errorInfo); // 失败回调
typedef void (^loadProgress)(float progress); // 进度回调
typedef enum {
    statusUnknown          = -1, // 未知网络
    statusNotReachable     = 0, //没有网络
    statusReachableViaWWAN = 1, //手机网络
    statusReachableViaWiFi = 2, //wifi
}Reachability;
@interface YCNetWorkManage : NSObject




/**
 *  Get请求 不对数据进行缓存
 *
 *  @param urlStr  url
 *  @param success 成功的回调
 *  @param failure 失败的回调
 */


+(void)getRequestUrlStr:(NSString *)urlStr success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  Get请求 对数据进行缓存
 *
 *  @param urlStr  url
 *  @param success 成功的回调
 *  @param failuer 失败的回调
 */


+(void)getRequestCacheUrlStr:(NSString *)urlStr success:(SuccessBlock)success failure:(FailureBlock)failuer ;

/**
 *  Post请求 不对数据进行缓存
 *
 *  @param urlStr     url
 *  @param parameters post参数
 *  @param success    成功的回调
 *  @param failure    失败的回调
 */
+(void)postRequestUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parameters success:(SuccessBlock )success failure:(FailureBlock)failure;


/**
 *  Post请求 对数据进行缓存
 *
 *  @param urlStr     url
 *  @param parameters post参数
 *  @param success    成功的回调
 *  @param failure    失败的回调
 */

+(void)postRequestCacheUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parameters success:(SuccessBlock )success failure:(FailureBlock)failure;

/**
 *  上传单个文件
 *
 *  @param urlStr       服务器地址
 *  @param parameters   参数
 *  @param attach       上传的key
 *  @param data         上传的问价
 *  @param loadProgress 上传的进度
 *  @param success      成功的回调
 *  @param failure      失败的回调
 */
+(void)upLoadDataWithUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parameters imageKey:(NSString *)attach withData:(NSData *)data upLoadProgress:(loadProgress)loadProgress success:(SuccessBlock)success failure:(FailureBlock)failure;



/**
 *  获取用户的网络状态
 *
 *  @param reastate 返回值当前状态
 */
+(void)netWorkReachability:(void (^)(NSInteger reastate))reastate;

@end
