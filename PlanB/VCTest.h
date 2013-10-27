//
//  VCTest.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/8/28.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface VCTest : UIViewController<GMSMapViewDelegate>
@property (nonatomic,strong) GMSMapView *mapview;
@property int mapStatus;
-(void) pinMarker:(float) lat lng:(float) lng name:(NSString*) name;
-(void) clearMarker;
@end
