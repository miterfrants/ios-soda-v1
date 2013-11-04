//
//  PopupView.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 2013/11/2.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import "PopupView.h"

@implementation PopupView
@synthesize timer;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }

    self.lblTitle = [[UILabel alloc] init];
    [self.lblTitle setFrame:CGRectMake(0, 0, 0, 0)];
    [self addSubview: self.lblTitle];
    self.lblMessage= [[UILabel alloc] init];
    [self.lblMessage setFrame:CGRectMake(0, 0, 0, 0)];
    [self addSubview: self.lblMessage];
    return self;
}
-(void) fadeIn:(id) sender{
    [self setFrame:[self caculateFrame:50]];
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^(){self.frame=CGRectMake(0, [self frame].origin.y, [self frame].size.width, [self frame].size.height);}
                     completion:^(BOOL fin) {
                            [self resetTimeout:5];
                         
                     }];
}
-(CGRect) caculateFrame:(float) height{
    double parentWidth=[self superview].bounds.size.width;
    double parentHeight=[self superview].bounds.size.height;
    double defaultHeight=height;
    double defaultX=-parentWidth;
    double defaultY=parentHeight-defaultHeight;
    return CGRectMake(defaultX, defaultY,parentWidth , height);
}

-(void) fadeOut:(id) sender{

    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^(){self.frame=CGRectMake(-[self frame].size.width, [self frame].origin.y, [self frame].size.width, [self frame].size.height);}
                     completion:^(BOOL fin) {}];
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event   {
    [timer invalidate];
    timer=nil;
}
-(void) resetTimeout:(double) time{
    self.timer=[NSTimer scheduledTimerWithTimeInterval:time
                                                target:self
                                              selector:@selector(fadeOut:)
                                              userInfo:nil
                                               repeats:NO];
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event   {
    [self resetTimeout:2];
}
/*-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event   {
    NSLog(@"test move");
}
-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event   {
    NSLog(@"test cancelled");
}*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
