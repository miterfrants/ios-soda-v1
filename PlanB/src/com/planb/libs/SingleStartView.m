//
//  SingleStartView.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 2013/11/10.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import "SingleStartView.h"

@implementation SingleStartView
@synthesize imgEmpty,imgEmptyName,imgEmptyView,imgFull,imgFullName,imgFullView ;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    self.imgEmptyView= [[UIImageView alloc] init];
    self.imgFullView= [[UIImageView alloc] init];
    self.imgEmpty=[UIImage imageNamed:@"StarEmptyLarge@2x.png"];
    self.imgFull=[UIImage imageNamed:@"StarFullLarge@2x.png"];
    [self.imgEmptyView setImage:self.imgEmpty];
    //[self.imgEmptyView setFrame:CGRectMake(0,0,self.imgEmpty.size.width,self.imgEmpty.size.height)];
    [self.imgEmptyView setFrame:CGRectMake(0,0,27,27)];
    [self.imgFullView setImage:self.imgFull];
    //[self.imgFullView setFrame:CGRectMake(0,0,self.imgFull.size.width,self.imgFull.size.height)];
    [self.imgFullView setFrame:CGRectMake(0,0,27,27)];
    //mask
    [self addSubview:self.imgEmptyView];
    [self addSubview:self.imgFullView];
    return self;
}
-(void)setScore:(double)rate{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGRect maskRect = CGRectMake(0, imgFull.size.height*(1-rate), imgFull.size.width, imgFull.size.height*(rate));
    CGPathRef path = CGPathCreateWithRect(maskRect, NULL);
    maskLayer.path = path;
    CGPathRelease(path);
    imgFullView.layer.mask=maskLayer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
