//
//  LZNetWorkLoadData.h
//  LZNetworing
//
//  Created by lizhao on 14-11-21.
//  Copyright (c) 2014年 lizhao. All rights reserved.
//
/**上传 下载 数据
*/
#import <Foundation/Foundation.h>

@interface LZNetWorkLoadData : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>


typedef void (^UpLoadFinishBlock)(id result,NSURLResponse *response, NSError *error);

typedef void (^DownLoadFinishBlock)(NSURL *location,NSURLResponse *response, NSError *error);

typedef void (^ProgressDownLoadFinishBlock)(NSData *data,NSURLResponse *response,double totalBytesWritten,double totalBytesExpectedToWrite, NSError *error);
/**
 进度 返回block
 */
@property (nonatomic ,readwrite ,copy)ProgressDownLoadFinishBlock progressDownLoadFinishBlock;

/**
 后台下载任务时调用
 */
@property (strong, nonatomic) NSURLSessionDownloadTask *backgroundTask;  // 后台的下载任务

/**
 用于可恢复的下载任务的数据 
 */
@property (nonatomic ,strong )NSData *partialData;
/**
下载时，存取request，传递。
 */
@property (nonatomic,readonly,strong )NSURLRequest *urlRequest;
/**
下载时，存取DownloadTask，传递。
 */
@property (nonatomic,readonly,strong )NSURLSessionDownloadTask *SessionDownloadTask;


+ (LZNetWorkLoadData *)shareNetWorkLoadData;
/**
 NSURLSession上传数据
 */
+ (void )UpLoadWithURL :(NSString *)urlString params:(NSData *)fromData tag:(int)compares completeBlock:(UpLoadFinishBlock)block; //compares 预留
/**
 NSURLSession下载数据,POST
 */
+ (void )DownLoadWithURL :(NSString *)urlString params:(NSDictionary *)params tag:(int)compares completeBlock:(DownLoadFinishBlock)block; //compares 预留
/**
 NSURLSession下载数据带进度,GET
 */
+ (void )ProgressDownLoadWithURL :(NSString *)urlString params:(NSDictionary *)params tag:(int)compares completeBlock:(ProgressDownLoadFinishBlock)block; //compares 预留

//[[LZNetWorkLoadData shareNetWorkLoadData]BackgroundSessionDownloadWithURL:@"http://farm3.staticflickr.com/2831/9823890176_82b4165653_b_d.jpg" params:nil tag:1 completeBlock:^(NSData *data, NSURLResponse *response, double totalBytesWritten, double totalBytesExpectedToWrite, NSError *error) {
//    NSLog(@"进度条：%f--%f",totalBytesWritten,totalBytesExpectedToWrite);
//}];
/**
 NSURLSession 后台下载
 */
- (void)BackgroundSessionDownloadWithURL:(NSString *)urlString params:(NSDictionary *)params tag:(int)compares completeBlock:(ProgressDownLoadFinishBlock)block;

/**
NSURLSession 取消下载
 */
- (void)cancelDownLoadTask;

- (void)cancelDownLoadTask:(NSURLSessionDownloadTask *)downLoadTask;
/**
NSURLSession 恢复下载
 */
- (void)resumeDownLoadTask;

- (void)resumeDownLoadTask:(NSURLSessionDownloadTask *)DownloadTask;


@end
