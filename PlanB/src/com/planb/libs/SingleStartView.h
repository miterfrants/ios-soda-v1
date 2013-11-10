//
//  SingleStartView.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 2013/11/10.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleStartView : UIView
@property NSString *imgFullName;
@property NSString *imgEmptyName;
@property UIImageView *imgFullView;
@property UIImageView *imgEmptyView;
@property UIImage *imgFull;
@property UIImage *imgEmpty;
-(void) setScore:(double) rate;
@end
