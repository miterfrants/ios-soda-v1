//
//  PopupView.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 2013/11/2.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupView : UIView
@property (strong,nonatomic) NSTimer *timer;
@property (strong,nonatomic) UILabel* lblTitle;
@property (strong,nonatomic) UILabel* lblMessage;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)fadeIn:(id) sender;
- (void)fadeOut:(id) sender;
@end
