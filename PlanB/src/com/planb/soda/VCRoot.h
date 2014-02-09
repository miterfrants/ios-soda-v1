//
//  VCRoot.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/9/9.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JASidePanelController.h"
#import "PopupView.h"
@interface VCRoot : JASidePanelController
@property (strong,nonatomic) PopupView * viewPopup;
-(void)popUp:(NSString *) title msg:(NSString *) msg type:(NSInteger) type delay:(double) delay;

@end
