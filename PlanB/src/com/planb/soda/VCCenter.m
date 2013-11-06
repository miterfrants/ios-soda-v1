//
//  VCCenter.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/9/17.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import "VCCenter.h"
#import "VCList.h"
#import "VCRoot.h"
#import "VCMap.h"
#import "JASidePanelController.h"
#import "VariableStore.h"
#import "Util.h"
#import "AsyncImgView.h"
@interface VCCenter ()

@end

@implementation VCCenter

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIButton* btn = (UIButton*)sender;
    VCList *vcList = (VCList *)segue.destinationViewController;
    vcList.category=btn.titleLabel.text;
    VCMap * vcMap=(VCMap *)self.sidePanelController.rightPanel;
    
    if(![vcMap isViewLoaded]){
        vcMap=[[VCMap alloc] init];
        [vcMap loadView];
        self.sidePanelController.rightPanel=vcMap;
    }

}

@end
