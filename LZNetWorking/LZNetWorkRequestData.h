//
//  LZNetworking.h
//  LZNetworing
//
//  Created by lizhao on 14-11-20.
//  Copyright (c) 2014年 lizhao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestFinishBlock)(id result, NSURLResponse *response, NSError *error);

@interface LZNetWorkRequestData : NSObject
//<NSURLSessionDataDelegate,NSURLSessionDelegate,NSURLSessionDownloadDelegate,NSURLSessionTaskDelegate>

/**
 NSURLConnection 同步请求数据
 params 传递参数
 block  数据请求完成返回的参数
 */

+ (void)RequestWithURL:(NSString *)urlString params:(NSDictionary *)params tag:(int)compares completeBlock:(RequestFinishBlock)block;
/**
 NSURLConnection  异步请求数据
 params 传递参数
 block  数据请求完成返回的参数
 */
+ (void)RequestThreadWithURL:(NSString *)urlString params:(NSDictionary *)params tag:(int)compares completeBlock:(RequestFinishBlock)block;
/**
NSURLSession  GET异步请求数据
 */
+ (void )GetRequestWithURL :(NSString *)urlString params:(NSDictionary *)params tag:(int)compares completeBlock:(RequestFinishBlock)block; //compares 预留
/**
 NSURLSession POST异步请求数据
 */
+ (void )PostRequestWithURL :(NSString *)urlString params:(NSDictionary *)params tag:(int)compares completeBlock:(RequestFinishBlock)block; //compares 预留


@end
