//
//  AppDelegate.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/8/28.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "VariableStore.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FBSession *fb_session;
@property (nonatomic) NSInteger *local_id;
@property (strong,nonatomic) NSString *json_goods;
@property (strong,nonatomic) VariableStore* vs;
@end
