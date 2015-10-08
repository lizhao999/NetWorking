//
//  LZNetWorkLoadData.m
//  LZNetworing
//
//  Created by lizhao on 14-11-21.
//  Copyright (c) 2014年 lizhao. All rights reserved.
//

#import "LZNetWorkLoadData.h"
static NSString * const kBackgroundSession   = @"Background Session";
static NSString * const kBackgroundSessionID = @"com.lz.DownloadTask.BackgroundSession";
static LZNetWorkLoadData *shareNetWork;

@implementation LZNetWorkLoadData
{
@private
    NSData *returnData;
    double totalWritten;
    double totalExpectedToWrite;
    NSURLRequest *privateRequest;
    NSURLSession *privateSession;
    NSURLSessionDownloadTask *privateDownloadTask;
}

+(LZNetWorkLoadData *)shareNetWorkLoadData
{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareNetWork = [[LZNetWorkLoadData alloc]init];

    });
    return shareNetWork;

}
//+(id) allocWithZone:(NSZone *)zone{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        shareNetWork = [LZNetWorkLoadData allocWithZone:zone];
//    });
//    return shareNetWork;
//}


+ (void )UpLoadWithURL :(NSString *)urlString params:(NSData *)fromData tag:(int)compares completeBlock:(UpLoadFinishBlock)block
{

    NSString * url = nil;

    url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:30];
    //request.HTTPMethod = @"GET";
    // [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];//请求头

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionUploadTask *UploadTask = [session uploadTaskWithRequest:request fromData:fromData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

            if (httpResponse.statusCode == 200) {
                //                                            id dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                block(data,response,error);
            }
        }else
        {
            block(data,response,error);
        }

    }];

    [UploadTask resume];

}

+ (void )DownLoadWithURL :(NSString *)urlString params:(NSDictionary *)params tag:(int)compares completeBlock:(DownLoadFinishBlock)block
{

    NSMutableString *paramsString = [NSMutableString string];
    NSArray *allkeys = [params allKeys];
    for(int i = 0;i< params.count ; i ++)
    {
        NSString *key = [allkeys objectAtIndex:i];
        id value = [params objectForKey:key];
        [paramsString appendFormat:@"%@=%@", key, value];
        if (i < params.count-1)
        {
            [paramsString appendFormat:@"&"];
        }
    }
    NSString * url = nil;
    url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60];
    request.HTTPMethod = @"POST";
    // [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];//请求头
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[paramsString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *DownloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                //                                            id dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                block(location,response,error);
            }
        }else
        {
            block(location,response,error);
        }
    }];
    [DownloadTask resume];
}

+ (void)ProgressDownLoadWithURL:(NSString *)urlString params:(NSDictionary *)params tag:(int)compares completeBlock:(ProgressDownLoadFinishBlock)block
{

    NSMutableString *paramsString = [NSMutableString string];
    NSArray *allkeys = [params allKeys];
    for(int i = 0;i< params.count ; i ++)
    {
        NSString *key = [allkeys objectAtIndex:i];
        id value = [params objectForKey:key];
        [paramsString appendFormat:@"%@=%@", key, value];
        if (i < params.count-1)
        {
            [paramsString appendFormat:@"&"];
        }
    }

    NSString * url = nil;

    if (paramsString.length > 0)
    {
        url = [NSString stringWithFormat:@"%@?%@",urlString,paramsString];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    }else
    {
        url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60];

    [LZNetWorkLoadData shareNetWorkLoadData]->privateRequest = request;

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:[LZNetWorkLoadData shareNetWorkLoadData] delegateQueue:nil];
    [LZNetWorkLoadData shareNetWorkLoadData]->privateSession =session;

    NSURLSessionDownloadTask *DownloadTask = [session downloadTaskWithRequest:request];
    [LZNetWorkLoadData shareNetWorkLoadData].progressDownLoadFinishBlock = block;

    [DownloadTask resume];

    [LZNetWorkLoadData shareNetWorkLoadData]->privateDownloadTask = DownloadTask;


}
//TODO:创建一个后台session单例
+ (NSURLSession *)shareBackgroundSession {
    static NSURLSession *backgroundSess = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:kBackgroundSessionID];
        backgroundSess = [NSURLSession sessionWithConfiguration:config delegate:[LZNetWorkLoadData shareNetWorkLoadData] delegateQueue:nil];
        backgroundSess.sessionDescription = kBackgroundSession;
    });

    return backgroundSess;
}

- (void)BackgroundSessionDownloadWithURL:(NSString *)urlString params:(NSDictionary *)params tag:(int)compares completeBlock:(ProgressDownLoadFinishBlock)block
{
    NSMutableString *paramsString = [NSMutableString string];
    NSArray *allkeys = [params allKeys];
    for(int i = 0;i< params.count ; i ++)
    {
        NSString *key = [allkeys objectAtIndex:i];
        id value = [params objectForKey:key];
        [paramsString appendFormat:@"%@=%@", key, value];
        if (i < params.count-1)
        {
            [paramsString appendFormat:@"&"];
        }
    }

    NSString * url = nil;

    if (paramsString.length > 0)
    {
        url = [NSString stringWithFormat:@"%@?%@",urlString,paramsString];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    }else
    {
        url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60];
    privateRequest = request;

    NSURLSessionDownloadTask *DownloadTask = [[LZNetWorkLoadData shareBackgroundSession] downloadTaskWithRequest:request];
    privateDownloadTask = DownloadTask;

    [DownloadTask resume];
    self.progressDownLoadFinishBlock = block;
}


#pragma mark - NSURLSessionDownloadDelegate

//TODO: 执行下载任务时有数据写入
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten // 每次写入的data字节数
 totalBytesWritten:(int64_t)totalBytesWritten // 当前一共写入的data字节数
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite // 期望收到的所有data字节数
{
    totalWritten = totalBytesWritten;
    totalExpectedToWrite = totalBytesExpectedToWrite;

    if (self.progressDownLoadFinishBlock) {
        self.progressDownLoadFinishBlock(returnData,downloadTask.response,totalWritten,totalExpectedToWrite,nil);
    }

}

-(NSURLRequest *)urlRequest
{
    return  privateRequest;
}

-(NSURLSessionDownloadTask *)SessionDownloadTask
{
    return privateDownloadTask;
}
//TODO:取消下载
- (void)cancelDownLoadTask:(NSURLSessionDownloadTask *)downLoadTask
{
    if (downLoadTask == privateDownloadTask) {

        [privateDownloadTask cancelByProducingResumeData:^(NSData *resumeData) {
            NSLog(@"保存的DATA:%lu",sizeof(resumeData));

            self.partialData =resumeData;

        }];
        // [privateDownloadTask resume];
    }
}

//TODO:取消下载
- (void)cancelDownLoadTask
{
    //取消下载
    [privateDownloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        self.partialData =resumeData;
        privateDownloadTask = nil;
    }];
    // [privateDownloadTask resume];
}

//TODO:恢复下载
- (void)resumeDownLoadTask:(NSURLSessionDownloadTask *)downLoadTask
{
    if (self.partialData) {

        downLoadTask = [privateSession downloadTaskWithResumeData:self.partialData];
        self.partialData = nil;
    }
    else{
        downLoadTask = [privateSession downloadTaskWithRequest:privateRequest];
    }
    [downLoadTask resume];
}

//TODO:恢复下载
- (void)resumeDownLoadTask
{
    if (self.partialData) {

        privateDownloadTask = [privateSession downloadTaskWithResumeData:self.partialData];
        self.partialData = nil;
    }
    else{
        privateDownloadTask = [privateSession downloadTaskWithRequest:privateRequest];
    }
    [privateDownloadTask resume];

}

//TODO:从fileOffset位移处恢复下载任务
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {

    NSLog(@"NSURLSessionDownloadDelegate: Resume download at %lld", fileOffset);
}

//TODO:完成下载任务，只有下载成功才调用该方法
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"NSURLSessionDownloadDelegate: Finish downloading");

    // 1.将下载成功后的文件移动到目标路径
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = URLs[0];
    NSURL *destinationPath = [documentsDirectory URLByAppendingPathComponent:[location lastPathComponent]];

    if ([fileManager fileExistsAtPath:[destinationPath path] isDirectory:NULL]) {
        [fileManager removeItemAtURL:destinationPath error:NULL];
    }

    NSError *error = nil;

    if ([fileManager copyItemAtURL:location toURL:destinationPath error:&error]) {
        returnData = [NSData dataWithContentsOfURL:destinationPath];
        if (self.progressDownLoadFinishBlock) {
            self.progressDownLoadFinishBlock(returnData,downloadTask.response,totalWritten,totalExpectedToWrite,nil);
        }
    }
    downloadTask = nil;
}

//TODO:完成下载任务，无论下载成功还是失败都调用该方法
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {

    if (error) {
        NSLog(@"下载失败：%@", error);
        self.progressDownLoadFinishBlock(returnData,task.response,totalWritten,totalExpectedToWrite,error);

    }else
    {
        if (self.progressDownLoadFinishBlock) {
            self.progressDownLoadFinishBlock(returnData,task.response,totalWritten,totalExpectedToWrite,error);
        }
        returnData = nil;
        task = nil;
    }
}

//TODO:后台下载执行回调代码块
//- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
//{
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if (appDelegate.backgroundURLSessionCompletionHandler) {
//        void (^completionHandler)() = appDelegate.backgroundURLSessionCompletionHandler;
//        appDelegate.backgroundURLSessionCompletionHandler = nil;
//        completionHandler();
//    }
//    NSLog(@"所有任务已完成!");
//}

@end
