//
//  UIScrollPlaceListView.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 2013/11/23.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import "UIScrollPlaceListView.h"
#import "VCList.h"
#import "Util.h"
@implementation UIScrollPlaceListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
    }
    _isBusy=NO;
    _vs=[VariableStore sharedInstance];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)scrollViewDidScroll:(UIScrollView*)scrollView{
    /*if(scrollView.contentSize.height-scrollView.contentOffset.y- scrollView.frame.size.height<300){
        if(!_isBusy){
            _isBusy=YES;
            VCList *vsList= [self viewController];
            NSString *url=[NSString stringWithFormat:@"http://%@/controller/mobile/report.aspx?action=add-pull-up&creator_ip=%@&cate=%@", _vs.domain,[Util getIPAddress], vsList.cateTitle];
            [Util stringAsyncWithUrl:url completion:nil queue:_vs.backgroundThreadManagement];
            [vsList generateList:@"YES"];
        }
    };*/
}

- (VCList*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (VCList*)nextResponder;
        }
    }
    
    return nil;
}
@end
