//
//  UIScrollPlaceListView.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 2013/11/23.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import "UIScrollPlaceListView.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "VCList.h"
#import "Util.h"
#import "VariableStore.h"
#import "VCMap.h"
#import <GoogleMaps/GoogleMaps.h>
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

    
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(_vs.isChangeMarkerIndex){
        _memoryY=scrollView.contentOffset.y;
        VCList * vclist  =(VCList *) [self viewController];
        VCMap *vcMap= (VCMap *) vclist.sidePanelController.rightPanel;
        if(scrollView.contentOffset.y<128){
            vcMap.currIndex=0;
        }else{
            vcMap.currIndex=(int) floorf((_memoryY+128)/160);
        }
        if((int) vcMap.currIndex>vcMap.arrMarker.count){
            vcMap.currIndex= vcMap.arrMarker.count-1;
        }
        GMSMarker *marker=(GMSMarker *) [vcMap.arrMarker objectAtIndex:vcMap.currIndex];
        [vcMap.mapview setSelectedMarker:marker];
    }
    _vs.isChangeMarkerIndex=true;
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(_vs.isChangeMarkerIndex){
        _memoryY=scrollView.contentOffset.y;
        VCList * vclist  =(VCList *) [self viewController];
        VCMap *vcMap= (VCMap *) vclist.sidePanelController.rightPanel;
        if(scrollView.contentOffset.y<128){
            vcMap.currIndex=0;
        }else{
            vcMap.currIndex=(int) floorf((_memoryY+128)/160);
        }
        if((int) vcMap.currIndex>vcMap.arrMarker.count){
            vcMap.currIndex= vcMap.arrMarker.count-1;
        }
        GMSMarker *marker=(GMSMarker *) [vcMap.arrMarker objectAtIndex:vcMap.currIndex];
        [vcMap.mapview setSelectedMarker:marker];
    }
    _vs.isChangeMarkerIndex=true;
}

-(void) clearPlaceItemButton{
    for(int i =0;i< [[self subviews] count];i++){
        NSString *className =NSStringFromClass([[[self subviews] objectAtIndex:i] class]);
        if([className isEqualToString:@"UIPlaceButton"]){
            //NSLog(@"A");
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
