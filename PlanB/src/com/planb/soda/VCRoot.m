//
//  VCRoot.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/9/9.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import "VCRoot.h"
#import "VCMap.h"
#import "AppDelegate.h"
#import "Util.h"
#import "VCList.h"
@interface VCRoot ()

@end

@implementation VCRoot

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
     AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.fb_session.isOpen) {
        appDelegate.fb_session = [[FBSession alloc] init];
    }
    _viewPopup = [[PopupView alloc]init];
    [self.view addSubview:_viewPopup];

}
//-1:error 0:war 1:note
-(void)popUp:(NSString *) title msg:(NSString *) msg type:(NSInteger) type delay:(double) delay{
    switch (type) {
        case -1:
            [_viewPopup setBackgroundColor:[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.6]];
            break;
        case 0:
            [_viewPopup setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.1 alpha:0.6]];
            break;
        case 1:
            [_viewPopup setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6]];
            break;
            
        default:
            break;
    }
    //peter modify @selector 不知道要如何把parameter 傳進去
    //如果能放在下面的 fadeIn 以後比較好管理
    _viewPopup.lblTitle.text=title;
    _viewPopup.lblMessage.text=msg;
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(fadeIn:)
                                   userInfo:nil
                                    repeats:NO];
}
-(void)fadeIn:(id) sender{
    [_viewPopup fadeIn:sender];
    [_viewPopup.lblMessage setFrame:CGRectMake(5, 10, 300, 40)];
    _viewPopup.lblMessage .textColor = [UIColor blackColor];
    _viewPopup.lblMessage .font = [UIFont italicSystemFontOfSize:12];
    _viewPopup.lblMessage .numberOfLines = 5;
    _viewPopup.lblMessage .lineBreakMode = NSLineBreakByWordWrapping;
    
    [_viewPopup.lblTitle setFrame:CGRectMake(5, 5, 300,15)];
    _viewPopup.lblTitle .textColor = [UIColor blackColor];
    _viewPopup.lblTitle .font = [UIFont italicSystemFontOfSize:15];
    _viewPopup.lblTitle .numberOfLines = 1;
    _viewPopup.lblTitle .lineBreakMode = NSLineBreakByWordWrapping;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) awakeFromNib
{
    self.shouldDelegateAutorotateToVisiblePanel=NO;
    self.panningLimitedToTopViewController=NO;
    [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"NCCenter"]];
    VCMap  *vcRight=[self.storyboard instantiateViewControllerWithIdentifier:@"VCRight"];
    [self setRightPanel:vcRight];
}

-(void) didOpened{

    UINavigationController * center=(UINavigationController *) [self centerPanel];
    
    VariableStore *_vs= [VariableStore sharedInstance];
    for(int i=0;i<[center childViewControllers].count;i++){
        NSString *className=NSStringFromClass([[[center childViewControllers] objectAtIndex:i] class]);
        if([className isEqualToString:@"VCList"]){
            VCList *vclist= (VCList *) [[center childViewControllers] objectAtIndex:[[center childViewControllers] count]-1];
            NSString *url=[NSString stringWithFormat:@"http://%@/controller/mobile/report.aspx?action=add-slide-to-map&creator_ip=%@&cate=%@", _vs.domain,[Util getIPAddress], vclist.cateTitle];
            [Util stringAsyncWithUrl:url completion:nil queue:_vs.backgroundThreadManagement];
            return;
        }
    }
    NSString *url=[NSString stringWithFormat:@"http://%@/controller/mobile/report.aspx?action=add-slide-to-map&creator_ip=%@&cate=Center", _vs.domain,[Util getIPAddress]];
    [Util stringAsyncWithUrl:url completion:nil queue:_vs.backgroundThreadManagement];
}

@end
