//
//  VCList.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/9/17.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+JASidePanel.h"

@interface VCList : UIViewController
    @property (strong, nonatomic) IBOutlet UIScrollView *SVListContainer;
    @property NSString *category;
@end
