//
//  Util.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/10/5.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import "Util.h"
#import <Foundation/Foundation.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation Util
const double PI = 3.141592653589793;
typedef void (^ completionBlock)(NSURLResponse *response, NSData *data, NSError *connectionError);
+ (NSString *)stringWithUrl:(NSString *)url
{
 
   /* NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];*/
NSMutableURLRequest *urlRequest= [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    // Fetch the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;

    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    // Construct a String around the Data from the response
    return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}
+ (void)stringAsyncWithUrl:(NSString *)url completion:(void(^)(NSURLResponse *response, NSData *data, NSError *connectionError)) completion queue:(NSOperationQueue *) queue {
    NSURLRequest *req= [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:completion];
}
+(NSString *)getFamousCompanyLogo:(NSString *) name{

    NSRange result = [name rangeOfString:@"摩斯"];
    if (result.location != NSNotFound)
    {
        return @"http://www.mos.com.tw/images/logo.png";
    }
    return @"";
}
+(NSMutableDictionary *) jsonWithUrl:(NSString *)url{
    NSString * result=[Util stringWithUrl:url];
    NSError *jsonParsingError=nil;
    NSMutableDictionary *dicResult=[NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding ] options:NSJSONReadingMutableContainers error:&jsonParsingError];
    if(jsonParsingError==nil){
        return dicResult;
    }else{
        return nil;
    }
}
+(double) distBetweenTwoLocate:(CLLocation *) source destination:(CLLocation *) destination  {
    double r=6378137;
    //NSString *sour=[NSString stringWithFormat:@"%.8f/%.8f",source.coordinate.latitude, source.coordinate.longitude];
    //NSString *dest=[NSString stringWithFormat:@"%.8f/%.8f",destination.coordinate.latitude, destination.coordinate.longitude];

    double dLat=convertToRadians(destination.coordinate.latitude-source.coordinate.latitude);
    double dLon=convertToRadians(destination.coordinate.longitude-source.coordinate.longitude);
    double lat1=convertToRadians(source.coordinate.latitude);
    double lat2=convertToRadians(destination.coordinate.latitude);
    double a =sin(dLat/2)*sin(dLat/2)+ sin(dLon/2)*sin(dLon/2)*cos(lat1)*cos(lat2);
    double c=2*atan2(sqrt(a),sqrt(1-a));
    return r*c;
}
+ (UIColor *)colorWithHexString:(NSString *)str {
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [Util colorWithHex:x];
}
+ (UIColor *)colorWithHex:(UInt32)col {
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}



+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}
double convertToRadians(double val) {
    return val * PI / 180;
}

@end
