//
//  VCList.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/9/17.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <QuartzCore/QuartzCore.h>
#import "JASidePanelController.h"
#import "VariableStore.h"
#import "VCDetail.h"
#import "UIPlaceButton.h"
#import "UIPlaceItemButton.h"
#import "VCMap.h"
#import "VCList.h"
#import "Util.h"
#import "AsyncImgView.h"
#import "SingleStartView.h"
#import "AnimatedGif.h"
#import "UIScrollPlaceListView.h"
#import "VCRoot.h"


@interface VCList ()
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property CLLocationManager *locationManager;
@end

@implementation VCList

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(!_isGenerateList){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self generateList:nil isReget:NO];
            _loadingView.alpha=1;
            
        });
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate=self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    _arrButton=[[NSMutableArray alloc]init];
    _vs=[VariableStore sharedInstance];
    [self.view setFrame:CGRectMake(0, 0, _vs.screenW, _vs.screenH)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //讀取條
    _loadingCon= [[UIView alloc] init];
    [_loadingCon setFrame:CGRectMake(0, (_vs.screenH-60)/2, _vs.screenW, 60)];
    [self.view addSubview:_loadingCon];
    _loadingView =[AnimatedGif getAnimationForGifAtUrl:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"loading.gif" ofType:nil]]];

    _loadingTitle =[[UILabel alloc]init];
    _loadingTitle.textColor = [Util colorWithHexString:@"#999999FF"];
    _loadingTitle.font = [UIFont fontWithName:@"黑體-繁" size:13];
    _loadingTitle.numberOfLines = 2;
    _loadingTitle.lineBreakMode = NSLineBreakByWordWrapping;
    _loadingTitle.textAlignment=NSTextAlignmentCenter;
    [_loadingTitle setFrame:CGRectMake(0, 30, 320, 36)];
    [_loadingCon addSubview:_loadingView];
    [_loadingCon addSubview:_loadingTitle];
    
    //scroll view
    _SVListContainer=[[UIScrollPlaceListView alloc]init];
    [self.view addSubview:_SVListContainer];
    [_SVListContainer setScrollEnabled:true];
    [_SVListContainer setFrame:CGRectMake(0, 64, _vs.screenW,_vs.screenH)];
    [self initialScrollView:false];

    
    //next page button
    _btnNextPage = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnNextPage setBackgroundColor:[Util colorWithHexString:@"#33b5e5dd"]];
    _btnNextPage.layer.cornerRadius = 20;//half of the width
    _btnNextPage.layer.borderWidth=3;
    _btnNextPage.layer.borderColor=[Util colorWithHexString:@"ffffffff"].CGColor;	
    [_btnNextPage setTitle:@"更多" forState:UIControlStateNormal];
    _btnNextPage.titleLabel.font =[UIFont fontWithName:@"黑體-繁" size:12];;
    _btnNextPage.titleLabel.numberOfLines=1;
    _btnNextPage.titleLabel.lineBreakMode=NSLineBreakByCharWrapping;
    _btnNextPage.titleLabel.textColor=[Util colorWithHexString:@"#ffffffff"];
    [_btnNextPage setFrame:CGRectMake(-20,_vs.screenH-20,40,40)];
    _btnNextPage.hidden=YES;

    [self.view addSubview:_btnNextPage];
}

-(void) showMap:(UIPlaceItemButton *)sender{
    [self.sidePanelController showRightPanelAnimated:true];
    VCMap *vcMap=(VCMap *) self.sidePanelController.rightPanel;
    vcMap.currIndex=sender.index;
    [vcMap.btnTakeMeThere setHidden:NO];
    GMSMarker *marker=[vcMap.arrMarker objectAtIndex:sender.index];
    [vcMap.mapview setSelectedMarker:marker];
    [vcMap.mapview setCamera:[GMSCameraPosition cameraWithLatitude:marker.position.latitude
                                                   longitude:marker.position.longitude
                                                        zoom:15]];
    UINavigationController * center=(UINavigationController *) self.sidePanelController.centerPanel;
    VCList *vclist= (VCList *) [[center childViewControllers] objectAtIndex:[[center childViewControllers] count]-1];
    int scrollY=(int) sender.index*160-64;
    if(scrollY<0){
        scrollY=0;
    }else if(scrollY> [[vclist SVListContainer] contentSize].height- [[vclist SVListContainer] frame].size.height){
        scrollY=[[vclist SVListContainer] contentSize].height-[[vclist SVListContainer] frame].size.height;
    }
    [vclist SVListContainer].contentOffset = CGPointMake(0,scrollY);

}

-(void) generateNextList:(UIButton *)sender{
    [self hideBtnNextPageMain:nil];
    [sender removeTarget:self action:@selector(generateNextList:) forControlEvents:UIControlEventTouchUpInside];
    NSString *url=[NSString stringWithFormat:@"http://%@/controller/mobile/report.aspx?action=add-get-more&creator_ip=%@&cate=%@", _vs.domain,[Util getIPAddress],self.cateTitle];
    [Util stringAsyncWithUrl:url completion:nil queue:_vs.backgroundThreadManagement];
    //抓下一頁資料要把現有的scroll view 先清掉 然後再重排
    [UIView beginAnimations:nil context:@"hide_scroll_view"];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.26];
    [_SVListContainer setAlpha:0];
    [UIView commitAnimations];

}
-(void) updateList:(UIRefreshControl *)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.26];
    [_SVListContainer setAlpha:0];
    _loadingView.alpha=1;
    [UIView commitAnimations];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
    [_refreshControl endRefreshing];
    NSString *url=[NSString stringWithFormat:@"http://%@/controller/mobile/report.aspx?action=add-pull-down&creator_ip=%@&cate=%@", _vs.domain,[Util getIPAddress], self.cateTitle];
    [Util stringAsyncWithUrl:url completion:nil queue:_vs.backgroundThreadManagement];
    //這邊要先更新 location
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager startUpdatingLocation];

    //refresh controller 要把資料刪掉重抓
    [self generateList:nil isReget:YES];
    //_currentCount=0;
    
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished    context:(NSString *)context {
    if([context isEqualToString:@"show_scroll_view"]){
        _SVListContainer.isBusy=NO;
    }else if([context isEqualToString:@"hide_scroll_view"]){
        [self generateList:@"YES" isReget:NO];
    }else{
//        for(int i =0;i< [[_SVListContainer subviews] count];i++){
//            NSString *className =NSStringFromClass([[[_SVListContainer subviews] objectAtIndex:i] class]);
//            if([className isEqualToString:@"UIPlaceButton"]){
//            [[[_SVListContainer subviews] objectAtIndex:i] removeFromSuperview];
//            }
//        }
//        [self initialScrollView: true];
    }
}
-(void)initialScrollView:(BOOL) isGenerateList{
    if(isGenerateList){
        [self generateList:nil isReget:NO];
    }else{
        [_SVListContainer setAlpha:0];
        _refreshControl=[[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(updateList:) forControlEvents:UIControlEventValueChanged];
        [_SVListContainer addSubview:_refreshControl];
    }
}


-(void)generateListMain:(NSMutableDictionary *) dicResult{
    //NSLog(@"generate list start");
    VariableStore *vs=[VariableStore sharedInstance];
    VCMap *vcMap=(VCMap *)self.sidePanelController.rightPanel;

    float contentHeight=([[dicResult objectForKey:@"results"] count])*[vs.listHeight floatValue]+15;
    if(contentHeight < vs.screenH){
        contentHeight=vs.screenH;
    }
    [_SVListContainer setContentSize:CGSizeMake([vs.listWidth floatValue], contentHeight+49)];
    if(![[dicResult objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"]){
        if(((NSString *) [dicResult valueForKey:@"next_page_token"]).length>0 && ![((NSString *) [dicResult valueForKey:@"next_page_token"]) isEqualToString:_nextPageToken]){
            _nextPageToken=(NSString *) [dicResult valueForKey:@"next_page_token"];
            _btnNextPage.hidden=NO;
            [_btnNextPage addTarget:self action:@selector(generateNextList:) forControlEvents:UIControlEventTouchUpInside];
            _SVListContainer.isShowNext=YES;
        }else{
            _btnNextPage.hidden=YES;
            _SVListContainer.isShowNext=NO;
        }
    }else{
        //沒有資料
        _loadingView.alpha=0;
        _dicResult=[[NSMutableDictionary alloc] init];
        _loadingTitle.text=@"您的位置沒有資料";
        _SVListContainer.alpha=0;
        [vcMap clearMarker];
        return;
    }
    /*remove and move to background thread*/
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    //locationManager.delegate = self;//or whatever class you have for managing location
    [locationManager startUpdatingLocation];
    vs.myLocation=locationManager.location;
    //加距離資料
    for(int i=0;i<[[dicResult objectForKey:@"results"] count];i++){
        NSString *lat=[[[[[dicResult objectForKey:@"results"] objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
        NSString *lng=[[[[[dicResult objectForKey:@"results"] objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
        NSMutableDictionary *dicDist =[Util jsonWithUrl:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?origins=%.8F,%.8F&destinations=%.8F,%.8F&mode=walk&language=zh-TW&sensor=false",vs.myLocation.coordinate.latitude,vs.myLocation.coordinate.longitude,[lat doubleValue],[lng doubleValue]]];
        //NSLog([NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?origins=%.8F,%.8F&destinations=%.8F,%.8F&mode=walk&language=zh-TW&sensor=false",vs.myLocation.coordinate.latitude,vs.myLocation.coordinate.longitude,[lat doubleValue],[lng doubleValue]]);
        if([(NSString * )[dicDist objectForKey:@"status"] isEqualToString:@"OK"]){
            NSString *stringDist=[[[[[[dicDist objectForKey:@"rows"] objectAtIndex:0] objectForKey:@"elements"] objectAtIndex:0] objectForKey:@"distance"] objectForKey:@"value"];
            NSString *address=[dicDist objectForKey:@"destination_addresses"];
            [[[dicResult objectForKey:@"results"]objectAtIndex:i] setObject:[NSNumber numberWithFloat:[stringDist floatValue]] forKey:@"dist"];
            [[[dicResult objectForKey:@"results"]objectAtIndex:i] setObject:address forKey:@"address"];
        }else{
            CLLocation *destination=[[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lng doubleValue]];
            double dist=[destination distanceFromLocation:locationManager.location]* 0.000621371192*1000;
            [[[dicResult objectForKey:@"results"]objectAtIndex:i] setObject:[NSNumber numberWithFloat:dist] forKey:@"dist"];
        }
    }
    //排序
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"dist" ascending:YES];
    [[dicResult objectForKey:@"results" ] sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    for(int i=0;i<[[dicResult objectForKey:@"results"] count];i++){
        //NSLog(@"list 1");
        NSString *name= [[[dicResult objectForKey:@"results"] objectAtIndex:i] valueForKey:@"name"] ;
        NSString *reference= [[[dicResult objectForKey:@"results"] objectAtIndex:i] valueForKey:@"reference"];
        NSString *placeId= [[[dicResult objectForKey:@"results"] objectAtIndex:i] valueForKey:@"id"];
        NSString *lat=[[[[[dicResult objectForKey:@"results"] objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
        NSString *lng=[[[[[dicResult objectForKey:@"results"] objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
        float rating=[[[[dicResult objectForKey:@"results"] objectAtIndex:i] valueForKey:@"rating"] floatValue];
            CLLocation *destination=[[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lng doubleValue]];

        //NSLog(@"list 2");
        UIPlaceItemButton *btnList=[[UIPlaceItemButton alloc]initWithFrame:CGRectMake(0, [vs.listHeight floatValue]*i,  [vs.listWidth floatValue],[vs.listHeight floatValue])];
        double dist=[destination distanceFromLocation:locationManager.location]* 0.000621371192*1000;
        //[btnList asyncGetDistAndAddressAndChangeMarker:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%.8F,%.8F&destinations=%.8F,%.8F&mode=walk&language=zh-TW&sensor=false",vs.myLocation.coordinate.latitude,vs.myLocation.coordinate.longitude,destination.coordinate.latitude,destination.coordinate.longitude ] lat:destination.coordinate.latitude lng:destination.coordinate.longitude mapView:vcMap] ;

        NSString *stringDist=(NSString *)[[[dicResult objectForKey:@"results"]objectAtIndex:i] valueForKey:@"dist"];
        NSString *address=[((NSArray *) [[[dicResult objectForKey:@"results"]objectAtIndex:i]valueForKey:@"address"] ) componentsJoinedByString:@""];

        if (stringDist !=nil){
            dist =[stringDist floatValue];
        }

        [vcMap pinMarker:[lat floatValue] lng:[lng floatValue] name:name snippet:address];
        //set property
        [btnList setPlaceName:name];
        [btnList setReference:reference];
        btnList.lblName.text=name;
        btnList.lblRating.text=[ NSString stringWithFormat:@"%.1F", rating];
        if(dist>1000){
            btnList.lblDist.text=[NSString stringWithFormat:@"%.2F 公里", (double) dist/1000];
        }else{
            btnList.lblDist.text=[NSString stringWithFormat:@"%d 公尺", (int) dist];
        }
        [btnList.singleStart setScore:rating/5];
        [btnList setPlaceId:placeId];
        btnList.btnDirection.lat=[lat floatValue];
        btnList.btnDirection.lng=[lng floatValue];
        btnList.index=i;
        
        /* view title */
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1].CGColor;
        bottomBorder.borderWidth = 0.5;
        bottomBorder.frame = CGRectMake(-1, -0.5, btnList.frame.size.width+2 ,btnList.frame.size.height);
        [btnList.layer addSublayer:bottomBorder];
        
        //[btnList addTarget:self action:@selector(goToOne:) forControlEvents:UIControlEventTouchUpInside];
        [_SVListContainer addSubview:btnList];
        [_arrButton  addObject:btnList];
        [[btnList layer] setBorderWidth:0.1f];
        [[btnList layer] setBorderColor:[UIColor grayColor].CGColor];
        [[btnList layer] setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor];
        [btnList addTarget:self action:@selector(showMap:) forControlEvents:UIControlEventTouchUpInside];
        //NSLog(@"list 4");
        @try {
            if([[[[dicResult objectForKey:@"results"] objectAtIndex:i] objectForKey:@"photos"] count]>0){
                NSString *photoRef=[[[[[dicResult objectForKey:@"results"] objectAtIndex:i] objectForKey:@"photos"] objectAtIndex:0] valueForKey:@"photo_reference"];
                NSString *strURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&sensor=false&key=%@",photoRef,[VariableStore sharedInstance].googleWebKey] ;
                NSURL *imgURL=[NSURL URLWithString:strURL];
                [btnList.asyncImgView loadImageFromURL:imgURL target:self completion:nil];
            }else{
                [btnList.asyncImgView setImage:[UIImage imageNamed:_defaultBGName]];
            }
            
        }
        @catch (NSException *exception) {
            //NSLog(@"HAHA Error:%@", exception.reason);
        }
        @finally {
            
        }
    }
    _loadingView.alpha=0;
    //NSLog(@"%@",dicResult);
    //NSLog(@"generate list finish");
}
-(void)showBtnNextPage{
    //顯示 scroll
    [UIView beginAnimations:@"" context:@"show_next_btn"];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.26];
    _btnNextPage.layer.cornerRadius=24;
    [_btnNextPage setFrame:CGRectMake(10, _vs.screenH-58, 48, 48)];
    [UIView commitAnimations];
}

-(void)hideBtnNextPage{
        _nextButtonTimoutTimer=[NSTimer scheduledTimerWithTimeInterval:3
                                                                target:self
                                                              selector:@selector(hideBtnNextPageMain:)
                                                              userInfo:nil
                                                               repeats:NO];

}
-(void)hideBtnNextPageMain:(id *) sender{
    [UIView beginAnimations:@"" context:@"hide_next_btn"];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.26];
    [_btnNextPage setFrame:CGRectMake(-20, _vs.screenH-20, 40, 40)];
    [UIView commitAnimations];
    _SVListContainer.isShowingNextButton=NO;

}

//other htread
-(void)generateList:(NSString *) isNext isReget:(BOOL) isReget{
    [_SVListContainer clearPlaceItemButton];
    if(isReget){
        _dicResult=nil;
        _nextPageToken=nil;
    }
    VCMap *vcMap=(VCMap *)self.sidePanelController.rightPanel;
    [vcMap clearMarker];
    vcMap.currIndex=0;

    NSMutableString * nearbySearchURL=[NSMutableString string];
    _loadingView.alpha=1;
    if(isNext != nil && [isNext boolValue]==YES && (_nextPageToken==nil || _nextPageToken.length==0)){
        return;
    }
    
    /*讀我們自己的資料 這邊不知道要怎麼寫比較好*/
    if([isNext boolValue] ==NO && _otherSource.length>0){
        [nearbySearchURL appendFormat:@"http://%@%@&lat=%f&lng=%f",_vs.domain,_otherSource,_locationManager.location.coordinate.latitude,_locationManager.location.coordinate.longitude];
        //NSLog(nearbySearchURL);
        _dicResult=[Util jsonWithUrl:nearbySearchURL];
    }


    
    
    //太久的話就在loading 加上一個label
    [self setLongTimeRequest];
    
    nearbySearchURL=[[NSMutableString alloc] init];
    //抓google 資料
    if(_nextPageToken == nil){
        [nearbySearchURL appendFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=500&keyword=%@&sensor=false&key=%@&rankBy=prominence&types=%@",_locationManager.location.coordinate.latitude,_locationManager.location.coordinate.longitude,[[_keyword lowercaseString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[VariableStore sharedInstance].googleWebKey,[_type stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }else{
        [nearbySearchURL appendFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=500&keyword=%@&sensor=false&key=%@&rankBy=prominence&pagetoken=%@&types=%@",_locationManager.location.coordinate.latitude,_locationManager.location.coordinate.longitude,[[_keyword lowercaseString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[VariableStore sharedInstance].googleWebKey,_nextPageToken,[_type stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    NSLog(@"%@",nearbySearchURL);
    if(_dicResult !=nil && _dicResult.count>0){
        NSMutableDictionary* dicTempResult=[Util jsonWithUrl:nearbySearchURL];
        [[_dicResult objectForKey:@"results"] addObjectsFromArray:[dicTempResult objectForKey:@"results"] ];
    }else{
        _dicResult= [Util jsonWithUrl:nearbySearchURL];
    }
    
    
    

    dispatch_async(dispatch_get_main_queue(),^{
        //清掉timer
        [_requestTimoutTimer invalidate];
        _requestTimoutTimer=nil;
        _loadingTitle.text=@"Google Place 資料讀取完成 產生列表中...";

        [self generateListMain:_dicResult];
        
        //_currentCount 是拿來算位置的 下一頁要夾上去
        if([isNext boolValue]){
            //_currentCount+=[[_dicResult objectForKey:@"results"] count];
        }else{
            self.navigationController.topViewController.title=_cateTitle;
            //_currentCount=[[_dicResult objectForKey:@"results"] count];
        }
        //給 viewDidAppear 用的 因為view did appear 會被subview觸發，這邊加計一個Mark 讓generateList只會被觸發一次
        //下一頁 不會判斷 _isGenerateList
        _isGenerateList=YES;
        
        //顯示 scroll
        [UIView beginAnimations:@"" context:@"show_scroll_view"];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.26];
        [_SVListContainer setAlpha:1];
        [UIView commitAnimations];
        _SVListContainer.isBusy=NO;
    });
}

-(void) setLongTimeRequest{
    dispatch_async(dispatch_get_main_queue(),^{
        _loadingTitle.text=@"正在讀取的資料...";
        _requestTimoutTimer=[NSTimer scheduledTimerWithTimeInterval:1.8
                                                             target:self
                                                           selector:@selector(loadingTooLong:)
                                                           userInfo:nil
                                                            repeats:NO];
    });
}


-(void) loadingTooLong: (id) sender{
    _loadingTitle.text=@"現在的網路速度有點慢，請耐心等候．";
}
-(void)goToOne: (id)sender{
    UIPlaceButton *btnPlace=(UIPlaceButton *) sender;
    VCDetail *detail = [[VCDetail alloc] init];
    detail.strPlaceTitle=btnPlace.placeName;
    detail.strReference=btnPlace.reference;
    detail.strGoogleId=btnPlace.placeId;
    [self.navigationController pushViewController:detail animated:YES];

}


@end
