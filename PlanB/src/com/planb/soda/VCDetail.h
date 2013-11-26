//
//  VCDetail.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/9/19.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+JASidePanel.h"
#import "DYRateView.h"

@interface VCDetail : UIViewController
@property NSString *strReference;
@property NSString *strPlaceTitle;
@property NSString *strGoogleId;
@property NSString *strGooglePhone;
@property NSString *strGoogleAddress;
@property NSString *strLat;
@property NSString *strLng;
@property (strong,nonatomic) DYRateView *rateView;
@property (strong, nonatomic)  UITextField *txtComment;
@property (strong, nonatomic) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnPin;
@property (strong, nonatomic) IBOutlet UIScrollView *usvGallery;
@property (strong, nonatomic) IBOutlet UIScrollView *usvDetail;
@property BOOL isInitial;

@end
