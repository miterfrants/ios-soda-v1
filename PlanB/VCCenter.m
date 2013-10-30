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
#import "VCTest.h"
#import "JASidePanelController.h"

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
    NSLog(@"jump to list");
    UIButton* btn = (UIButton*)sender;
    VCList *vcList = (VCList *)segue.destinationViewController;
    vcList.category=btn.titleLabel.text;
    VCTest * vcTest=(VCTest *)self.sidePanelController.rightPanel;
    
    if(![vcTest isViewLoaded]){
        vcTest=[[VCTest alloc] init];
        [vcTest loadView];
        self.sidePanelController.rightPanel=vcTest;
        
    }
    /*@try {
        [vcTest mapview];
    }
    @catch (NSException *exception) {
     
    }*/
    //NSLog(@"%@",vcTest.mapview);
    //[self.navigationControlle pushViewController:vcList animated:YES];
}

@end
