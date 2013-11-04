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
        NSLog(@"aaaa");
    AsyncImgView * asyncImageView= [[AsyncImgView alloc] init];
    [self.view addSubview:asyncImageView];
    NSURL *url=[[NSURL alloc] initWithString:@"https://fbcdn-sphotos-h-a.akamaihd.net/hphotos-ak-prn1/v/1208682_576060729117072_641833310_n.jpg?oh=a275a252fdd053115cabd835229cb198&oe=52784C8A&__gda__=1383647659_57a56c1b545133ae6c09c5e9941c488c"];
    [asyncImageView loadImageFromURL:url completion:@selector(handleComplete)];
	// Do any additional setup after loading the view.
}
-(void)handleComplete{
    NSLog(@"dadafdsaf");
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
