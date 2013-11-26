//
//  PlaceCategoryButton.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 2013/11/13.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import "PlaceCategoryButton.h"

@implementation PlaceCategoryButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }

    return self;
}
-(void) setLblName:(NSString*)name{
    _lblName=[[UILabel alloc]init];
    [self addSubview:_lblName];
    [_lblName setFrame:CGRectMake((self.frame.size.width-100)/2, (self.frame.size.height-30)/2+45, 100, 30)];
    _lblName.text=name;
    _lblName.textColor = [UIColor whiteColor];
    _lblName.font = [UIFont fontWithName:@"黑體-繁" size:16.f];
    _lblName.numberOfLines = 1;
    _lblName.lineBreakMode = NSLineBreakByWordWrapping;
    _lblName.textAlignment=NSTextAlignmentCenter;

    _name=name;
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
