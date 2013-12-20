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
    _vs= [VariableStore sharedInstance];
}
-(void)viewDidAppear:(BOOL) show{
    if(!_isInitial){
        _isInitial=YES;
        UIScrollView *sv=[[UIScrollView alloc] init];

        [self.view addSubview:sv];
        float recWidth=self.view.frame.size.width/2;
        for(int i =0 ; i<[[_vs.dicPlaceCate objectForKey:@"cate"] count]; i++){
            PlaceCategoryButton * pcButton = [[PlaceCategoryButton alloc]init];
            NSDictionary *item=[[_vs.dicPlaceCate objectForKey:@"cate"] objectAtIndex:i];
            UIImage *imgIcon = [UIImage imageNamed: [item objectForKey:@"pic"]];
            UIImageView *imgViewIcon=[[UIImageView alloc] initWithImage:imgIcon];
            [imgViewIcon setFrame:CGRectMake((recWidth-50)/2, (recWidth-50)/2, 50, 50)];
            pcButton.keyword=[item objectForKey:@"keyword"];
            pcButton.name=[item objectForKey:@"name"];
            pcButton.otherSource=[item objectForKey:@"other-source"];
            [pcButton addSubview:imgViewIcon];
            [pcButton setBackgroundColor:[Util colorWithHexString:[item objectForKey:@"color"]]];
            [pcButton setFrame:CGRectMake(i%2*recWidth,floor(i/2)* recWidth,recWidth,recWidth)];
            [pcButton setLblName:[item objectForKey:@"name"]];
            pcButton.defaultBGName=[item objectForKey:@"bg"];
            pcButton.type=[item objectForKey:@"type"];
            [pcButton addTarget:self action:@selector(gotoList:) forControlEvents:UIControlEventTouchUpInside];
            [sv addSubview:pcButton];
        }
        [sv setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
        [self.view addSubview:sv];
        [sv setContentSize:CGSizeMake(self.view.frame.size.width, ceil((float)[[_vs.dicPlaceCate objectForKey:@"cate"] count]/2)*recWidth)];
    }
    
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
    vcList.keyword=btn.keyword;
    vcList.type=btn.type;
    vcList.cateTitle=btn.name;
    vcList.defaultBGName=btn.defaultBGName;
    vcList.otherSource=btn.otherSource;
    NSString *url=[NSString stringWithFormat:@"http://%@/controller/mobile/report.aspx?action=add-category-count&cate=%@&creator_ip=%@", _vs.domain,btn.name,[Util getIPAddress] ];
    [Util stringAsyncWithUrl:url completion:nil queue:_vs.backgroundThreadManagement];
    [self.navigationController pushViewController:vcList animated:YES];
    //NSLog(@"%@",result);
    //NSLog(@"click category");
//    dispatch_async(dispatch_get_main_queue(),^{
//        VCMap * vcMap=(VCMap *)self.sidePanelController.rightPanel;
//        if(![vcMap isViewLoaded]){
//            vcMap=[[VCMap alloc] init];
//            //[vcMap loadView];
//            self.sidePanelController.rightPanel=vcMap;
//        }
//    });

}

@end
