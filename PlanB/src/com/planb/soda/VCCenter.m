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
#import "SingleStartView.h"
#import "PlaceCategoryButton.h"

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
-(void)viewDidAppear:(BOOL) show{
    UIScrollView *sv=[[UIScrollView alloc] init];
    VariableStore *vs =[VariableStore sharedInstance];
    [self.view addSubview:sv];
    float recWidth=self.view.frame.size.width/2;
    for(int i =0 ; i<[[vs.dicPlaceCate objectForKey:@"cate"] count]; i++){
        PlaceCategoryButton * pcButton = [[PlaceCategoryButton alloc]init];
        NSDictionary *item=[[vs.dicPlaceCate objectForKey:@"cate"] objectAtIndex:i];
        UIImage *imgIcon = [UIImage imageNamed: [item objectForKey:@"pic"]];
        UIImageView *imgViewIcon=[[UIImageView alloc] initWithImage:imgIcon];
        [imgViewIcon setFrame:CGRectMake((recWidth-40)/2, (recWidth-40)/2, 40, 40)];
        pcButton.keyword=[item objectForKey:@"name"];
        [pcButton addSubview:imgViewIcon];
        [pcButton setBackgroundColor:[Util colorWithHexString:[item objectForKey:@"color"]]];
        [pcButton setFrame:CGRectMake(i%2*recWidth,floor(i/2)* recWidth,recWidth,recWidth)];
        [pcButton addTarget:self action:@selector(gotoList:) forControlEvents:UIControlEventTouchUpInside];
        [sv addSubview:pcButton];
    }
    [sv setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    [self.view addSubview:sv];
    [sv setContentSize:CGSizeMake(self.view.frame.size.width, ceil((float)[[vs.dicPlaceCate objectForKey:@"cate"] count]/2)*recWidth)];
    [super viewDidAppear:show];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)gotoList:(id)sender{
    PlaceCategoryButton* btn = (PlaceCategoryButton*)sender;
    VCList *vcList = [[VCList alloc]init];
    vcList.category=btn.keyword;

    [self.navigationController pushViewController:vcList animated:YES];
    VCMap * vcMap=(VCMap *)self.sidePanelController.rightPanel;
    if(![vcMap isViewLoaded]){
        vcMap=[[VCMap alloc] init];
        [vcMap loadView];
        self.sidePanelController.rightPanel=vcMap;
    }

}

@end
