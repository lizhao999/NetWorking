//
//  LZNetworking.m
//  LZNetworing
//
//  Created by lizhao on 14-11-20.
//  Copyright (c) 2014年 lizhao. All rights reserved.
//
/**
 同步 异步 请求数据
 */
#import "LZNetWorkRequestData.h"

@implementation LZNetWorkRequestData : NSObject


+ (void)RequestWithURL:(NSString *)urlString params:(NSDictionary *)params tag:(int)compares completeBlock:(RequestFinishBlock)block
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
                                                       timeoutInterval:30];
    NSError *error = nil;

    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];

    block(data,nil,error);

//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//                               if (!error) {
//                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//
//                                   if (httpResponse.statusCode == 200) {
//                                       //                                            id dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//                                       block(data,response,error);
//                                   }
//                               }else
//                               {
//                                   block(data,response,error);
//                               }
//                           }];
}
+ (void)RequestThreadWithURL:(NSString *)urlString params:(NSDictionary *)params tag:(int)compares completeBlock:(RequestFinishBlock)block
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
                                                       timeoutInterval:30];

        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
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
}

+ (void )GetRequestWithURL :(NSString *)urlString params:(NSDictionary *)params tag:(int)compares completeBlock:(RequestFinishBlock)block
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
                                                        timeoutInterval:30];
//    头部信息
//    NSString *userPasswordString = [NSString stringWithFormat:@"%@:%@", user, password];
//    NSData * userPasswordData = [userPasswordString dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *base64EncodedCredential = [userPasswordData base64EncodedStringWithOptions:0];
//    NSString *authString = [NSString stringWithFormat:@"Basic: %@", base64EncodedCredential];
//    NSString *userAgentString = @"AppName/com.example.app (iPhone 5s; iOS 7.0.2; Scale/2.0)";
//
//    configuration.HTTPAdditionalHeaders = @{@"Accept": @"application/json",
//                                            @"Accept-Language": @"en",
//                                            @"Authorization": authString,
//                                            @"User-Agent": userAgentString};

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
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
    [task resume];

}

+ (void )PostRequestWithURL :(NSString *)urlString params:(NSDictionary *)params tag:(int)compares completeBlock:(RequestFinishBlock)block
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
                                                       timeoutInterval:30];
    request.HTTPMethod = @"POST";
    // [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];//请求头
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[paramsString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postBody];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
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
    [task resume];
}

@end
