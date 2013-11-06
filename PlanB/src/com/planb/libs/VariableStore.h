//
//  VariableStore.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/10/8.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VariableStore : NSObject

@property NSString *domain;
@property NSString *jsonGoods;
@property NSString *jsonBadges;
@property NSInteger *intLocalId;
@property NSString *keyGoogleMap;
@property NSMutableArray *arrMarker;
@property NSString *listHeight;
@property NSString *listWidth;
@property NSOperationQueue *backgroundThreadManagement;
// message from which our instance is obtained
+ (VariableStore *)sharedInstance;
@end

