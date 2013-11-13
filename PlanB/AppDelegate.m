//
//  AppDelegate.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/8/28.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import "AppDelegate.h"
#import "VCMap.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlus/GooglePlus.h>
#import <FacebookSDK/FacebookSDK.h>
#import "VariableStore.h"
@implementation AppDelegate
@synthesize fb_session = _fb_session;
@synthesize window = _window;
@synthesize json_goods = _json_goods;
static NSString * const kClientId = @"235322884744.apps.googleusercontent.com";

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSString *strURL =[ NSString stringWithFormat:@"%@",url];
    if([strURL hasPrefix:@"fb"]){
        return [FBAppCall handleOpenURL:url
                      sourceApplication:sourceApplication
                            withSession:self.fb_session];
    }else{
        return [GPPURLHandler handleURL:url
                      sourceApplication:sourceApplication
                             annotation:annotation];
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GMSServices provideAPIKey:@"AIzaSyBtb7I2tk-7hP6KWKU4wC4tNoFzM4pCcI0"];
    VariableStore *vs =[VariableStore sharedInstance];
    vs.keyGoogleMap=@"AIzaSyBtb7I2tk-7hP6KWKU4wC4tNoFzM4pCcI0";
    vs.domain=@"36.224.26.89";
    vs.listWidth=@"320.00";
    vs.listHeight=@"160.00";
    CLLocationManager * manager=[[CLLocationManager alloc]init];
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    manager.distanceFilter = kCLDistanceFilterNone;
    [manager startUpdatingLocation];
    vs.myLocation=manager.location;
    NSString *jsonCate= @"{\"cate\":[{\"name\":\"搜尋\",\"pic\":\"cate-search.png\",\"color\":\"#b7dd6c\"},{\"name\":\"景點\",\"pic\":\"cate-attraction.png\",\"color\":\"#abd156\"},{\"name\":\"餐廳\",\"pic\":\"cate-rest.png\",\"color\":\"#abd156\"},{\"name\":\"咖啡\",\"pic\":\"cate-cafe.png\",\"color\":\"#b4da5f\"},{\"name\":\"ATM\",\"pic\":\"cate-atm.png\",\"color\":\"#bcda78\"},{\"name\":\"旅館\",\"pic\":\"cate-hotel.png\",\"color\":\"#b9dd57\"}]}";
    NSData * dataCate=[jsonCate dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonParsingError = nil;
    vs.dicPlaceCate =(NSDictionary *) [NSJSONSerialization JSONObjectWithData:dataCate options:0 error:&jsonParsingError];
    vs.screenH=self.window.frame.size.height;
    vs.screenW=self.window.frame.size.width;
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppEvents activateApp];
    

    [FBAppCall handleDidBecomeActiveWithSession:self.fb_session];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.fb_session close];
}
@end
