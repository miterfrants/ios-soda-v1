//
//  VCList.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/9/17.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+JASidePanel.h"
#import "UIScrollPlaceListView.h"
#import "VariableStore.h"
@interface VCList : UIViewController
    @property (strong, nonatomic) IBOutlet UIScrollPlaceListView *SVListContainer;
    @property NSString *type;
    @property NSString *cateTitle;
    @property NSString *keyword;
    @property NSString *defaultBGName;
    @property (strong,nonatomic) NSMutableArray *arrButton;
    @property (strong,nonatomic) UIImageView *loadingView;
@property (strong,nonatomic) UILabel * loadingTitle;
    @property (strong,nonatomic) UIRefreshControl *refreshControl;
    @property BOOL isGenerateList;
    @property (strong,nonatomic) NSString *nextPageToken;
    @property int currentCount;
    @property VariableStore *vs;
@property NSTimer *requestTimoutTimer;
@property NSString *otherSource;
@property NSMutableDictionary *dicResult;
    -(void) generateList:(NSString *)isNext;
@end
