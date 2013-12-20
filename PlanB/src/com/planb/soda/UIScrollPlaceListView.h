//
//  UIScrollPlaceListView.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 2013/11/23.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VariableStore.h"

@interface UIScrollPlaceListView : UIScrollView <UIScrollViewDelegate>
@property BOOL isBusy;
@property BOOL isShowNext;
@property BOOL isShowingNextButton;
@property (strong,nonatomic) VariableStore *vs;
@property double memoryY;
-(void) clearPlaceItemButton;
@end
