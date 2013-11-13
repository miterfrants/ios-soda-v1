//
//  Util.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/10/5.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>
@interface Util : NSObject
+ (NSString *)stringWithUrl:(NSString *)url ;
+ (void)stringAsyncWithUrl:(NSURL *)url completion:(void(^)(NSURLResponse *response, NSData *data, NSError *connectionError)) completion queue:(NSOperationQueue *) queue;
+(double) distBetweenTwoLocate:(CLLocation *) source destination:(CLLocation *) destination  ;
+ (UIColor *)colorWithHexString:(NSString *)str;
+ (UIColor *)colorWithHex:(UInt32)col;
@end
