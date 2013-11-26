//
//  UIAsyncLabel.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 2013/11/24.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import "UIAsyncLabel.h"
#import "Util.h"
@implementation UIAsyncLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) asyncTextFromURL:(NSString *)url{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.text=[Util stringWithUrl:url];
    });
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
