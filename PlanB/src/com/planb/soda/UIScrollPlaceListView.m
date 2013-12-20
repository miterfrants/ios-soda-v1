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
@implementation UIScrollPlaceListView{
    VCList *vcList;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
    }
    _isBusy=NO;
    _isShowNext=NO;
    _isShowingNextButton=NO;
    _vs=[VariableStore sharedInstance];
    _memoryY=0;
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
    
    if(scrollView.contentOffset.y<0){
        return;
    };
    if(scrollView.contentOffset.y > _memoryY){
        vcList=[self viewController];
        [vcList.nextButtonTimoutTimer invalidate];
        vcList.nextButtonTimoutTimer=nil;
        [vcList hideBtnNextPage];
        if( _isShowNext && !_isShowingNextButton){
            _isShowingNextButton=YES;
            [vcList showBtnNextPage];
        }
    }
    _memoryY=scrollView.contentOffset.y;
    /*if(- scrollView.frame.size.height<300){
        if(!_isBusy){
            _isBusy=YES;
            VCList *vsList= [self viewController];
            NSString *url=[NSString stringWithFormat:@"http://%@/controller/mobile/report.aspx?action=add-pull-up&creator_ip=%@&cate=%@", _vs.domain,[Util getIPAddress], vsList.cateTitle];
            [Util stringAsyncWithUrl:url completion:nil queue:_vs.backgroundThreadManagement];
            [vsList generateList:@"YES"];
        }
    };*/
}
-(void) clearPlaceItemButton{
    for(int i =0;i< [[self subviews] count];i++){
        NSString *className =NSStringFromClass([[[self subviews] objectAtIndex:i] class]);
        if([className isEqualToString:@"UIPlaceButton"]){
            NSLog(@"A");
            [[[self subviews] objectAtIndex:i] removeFromSuperview];
        }
    }
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
