//
//  VCCenter.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/9/17.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+JASidePanel.h"
#import "PopupView.h"
#import "VariableStore.h"
#import "GAITrackedViewController.h"

@interface VCCenter : GAITrackedViewController
@property BOOL isInitial;
@property VariableStore * vs;
@end
