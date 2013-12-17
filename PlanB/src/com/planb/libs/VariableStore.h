//
//  VariableStore.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/10/8.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface VariableStore : NSObject

@property NSString *domain;
@property NSString *jsonGoods;
@property NSString *jsonBadges;
@property NSInteger *intLocalId;
@property NSString *googleWebKey;
@property (nonatomic,retain) NSMutableArray *arrMarker;
@property NSString *listHeight;
@property NSString *listWidth;
@property NSOperationQueue *backgroundThreadManagement;
@property CLLocation *myLocation;
@property NSDictionary *dicPlaceCate;
@property float screenH;
@property float screenW;
@property NSDate *appLaunchDate;
@property NSDate *appExitDate;
// message from which our instance is obtained
+ (VariableStore *)sharedInstance;
@end

