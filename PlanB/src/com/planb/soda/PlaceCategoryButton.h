//
//  PlaceCategoryButton.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 2013/11/13.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceCategoryButton : UIButton
@property NSString *keyword;
@property NSString *name;
@property NSString *defaultBGName;
@property NSString *pic;
@property NSString *type;
@property NSString *otherSource;
@property (strong,nonatomic) UILabel * lblName;

@end
