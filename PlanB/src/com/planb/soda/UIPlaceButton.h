//
//  UIPlaceButton.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/9/19.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceButton : UIButton
@property (nonatomic, retain) NSString *placeName;
@property (nonatomic, retain) NSString *placeId;
@property (nonatomic, retain)  NSString *reference;
@property (nonatomic) double lat;
@property (nonatomic) double lng;
@property (nonatomic) int index;
@end
