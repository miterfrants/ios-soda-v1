//
//  PlaceItemButton.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 2013/11/12.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceButton.h"
#import "SingleStartView.h"
#import "AsyncImgView.h"
#import "VCMap.h"
@interface UIPlaceItemButton : UIPlaceButton
@property (strong,nonatomic) UIPlaceButton *btnDirection;
@property (strong,nonatomic) UILabel *lblDist;
@property (strong,nonatomic) UILabel *lblName;
@property (strong,nonatomic) SingleStartView *singleStart;
@property (strong,nonatomic) UILabel *lblRating;
@property (strong,nonatomic) UIView *bgRating;
@property (strong,nonatomic) UIView *viewTitle;
@property (strong,nonatomic) AsyncImgView *asyncImgView;
-(void) takeMeThere:(UIPlaceButton *) sender;
-(void) asyncGetDistAndAddressAndChangeMarker:(NSString*) url  lat:(double) lat lng:(double) lng mapView:(VCMap *) mapView;
@end
