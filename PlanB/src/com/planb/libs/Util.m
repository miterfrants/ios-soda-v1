//
//  Util.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/10/5.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import "Util.h"
#import <Foundation/Foundation.h>

@implementation Util
typedef void (^ completionBlock)(NSURLResponse *response, NSData *data, NSError *connectionError);
+ (NSString *)stringWithUrl:(NSString *)url
{
 
   /* NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];*/
NSMutableURLRequest *urlRequest= [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    // Fetch the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;

    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    NSLog(@"%@",error);
    // Construct a String around the Data from the response
    return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}
+ (void)stringAsyncWithUrl:(NSURL *)url completion:(void(^)(NSURLResponse *response, NSData *data, NSError *connectionError)) completion queue:(NSOperationQueue *) queue {
    NSURLRequest *req= [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:completion];
}

@end
