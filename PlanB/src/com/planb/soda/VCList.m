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
            [self generateList:nil];
            _loadingView.alpha=0;
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
    _loadingView =[AnimatedGif getAnimationForGifAtUrl:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"loading.gif" ofType:nil]]];
    [self.view addSubview:_loadingView];
    [self initialScrollView:false];
}

-(void) updateList:(UIRefreshControl *)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.26];
    [_SVListContainer setAlpha:0];
    [UIView commitAnimations];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
    [_refreshControl endRefreshing];
    NSString *url=[NSString stringWithFormat:@"http://%@/controller/mobile/report.aspx?action=add-pull-down&creator_ip=%@&cate=%@", _vs.domain,[Util getIPAddress], self.cateTitle];
    [Util stringAsyncWithUrl:url completion:nil queue:_vs.backgroundThreadManagement];
    _currentCount=0;
    
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished    context:(NSString *)context {
    if([context isEqualToString:@"show_scroll_view"]){
        _SVListContainer.isBusy=NO;
    }else{
        for(int i =0;i< [[_SVListContainer subviews] count];i++){
            NSString *className =NSStringFromClass([[[_SVListContainer subviews] objectAtIndex:i] class]);
            if([className isEqualToString:@"UIPlaceButton"]){
            [[[_SVListContainer subviews] objectAtIndex:i] removeFromSuperview];
            }
        }
        [self initialScrollView: true];
    }
}
-(void)initialScrollView:(BOOL) isGenerateList{
    VariableStore *vs= [VariableStore sharedInstance];
    _SVListContainer=[[UIScrollPlaceListView alloc]init];
    [_SVListContainer setAlpha:0];
    [self.view addSubview:_SVListContainer];
    [_SVListContainer setScrollEnabled:true];
    [_SVListContainer setFrame:CGRectMake(0, 64, vs.screenW,vs.screenH)];
    _refreshControl=[[ UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(updateList:) forControlEvents:UIControlEventValueChanged];
    [_SVListContainer addSubview:_refreshControl];
    if(isGenerateList){
        [self generateList:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    //NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

-(void)generateListMain:(NSMutableDictionary *) dicResult{
    //NSLog(@"generate list start");
    VariableStore *vs=[VariableStore sharedInstance];
    VCMap *vcMap=(VCMap *)self.sidePanelController.rightPanel;
    float contentHeight=([[dicResult objectForKey:@"results"] count]+_currentCount)*[vs.listHeight floatValue]+15;
    if(contentHeight < vs.screenH){
        contentHeight=vs.screenH;
    }
    [_SVListContainer setContentSize:CGSizeMake([vs.listWidth floatValue], contentHeight+49)];
    if(![[dicResult objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"]){
        _nextPageToken=(NSString *) [dicResult valueForKey:@"next_page_token"];
        VCMap *vcMap=(VCMap *)self.sidePanelController.rightPanel;
        [vcMap clearMarker];
    }else{
        _loadingView.alpha=0;
    }
    /*remove and move to background thread*/

    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;//or whatever class you have for managing location
    [locationManager startUpdatingLocation];
    vs.myLocation=locationManager.location;
    //加距離資料
    for(int i=0;i<[[dicResult objectForKey:@"results"] count];i++){
        NSString *lat=[[[[[dicResult objectForKey:@"results"] objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
        NSString *lng=[[[[[dicResult objectForKey:@"results"] objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
        NSMutableDictionary *dicDist =[Util jsonWithUrl:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%.8F,%.8F&destinations=%.8F,%.8F&mode=walk&language=zh-TW&sensor=false",vs.myLocation.coordinate.latitude,vs.myLocation.coordinate.longitude,[lat doubleValue],[lng doubleValue] ]];
        NSString *stringDist=[[[[[[dicDist objectForKey:@"rows"] objectAtIndex:0] objectForKey:@"elements"] objectAtIndex:0] objectForKey:@"distance"] objectForKey:@"value"];
        NSString *address=[dicDist objectForKey:@"destination_addresses"];
        [[[dicResult objectForKey:@"results"]objectAtIndex:i] setObject:stringDist forKey:@"dist"];
        [[[dicResult objectForKey:@"results"]objectAtIndex:i] setObject:address forKey:@"address"];
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
        UIPlaceItemButton *btnList=[[UIPlaceItemButton alloc]initWithFrame:CGRectMake(0, [vs.listHeight floatValue]*(_currentCount+i),  [vs.listWidth floatValue],[vs.listHeight floatValue])];
        
        double dist=[destination distanceFromLocation:locationManager.location]* 0.000621371192*1000;


        //[btnList asyncGetDistAndAddressAndChangeMarker:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%.8F,%.8F&destinations=%.8F,%.8F&mode=walk&language=zh-TW&sensor=false",vs.myLocation.coordinate.latitude,vs.myLocation.coordinate.longitude,destination.coordinate.latitude,destination.coordinate.longitude ] lat:destination.coordinate.latitude lng:destination.coordinate.longitude mapView:vcMap] ;

        NSString *stringDist=[[[dicResult objectForKey:@"results"]objectAtIndex:i] objectForKey:@"dist"];
        NSString *address=[[[dicResult objectForKey:@"results"]objectAtIndex:i] objectForKey:@"address"];
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
        //NSLog(@"list 4");
        @try {
            if([[[[dicResult objectForKey:@"results"] objectAtIndex:i] objectForKey:@"photos"] count]>0){
                NSString *photoRef=[[[[[dicResult objectForKey:@"results"] objectAtIndex:i] objectForKey:@"photos"] objectAtIndex:0] valueForKey:@"photo_reference"];
                NSString *strURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&sensor=false&key=%@",photoRef,[VariableStore sharedInstance].keyGoogleMap] ;
                NSURL *imgURL=[NSURL URLWithString:strURL];
                [btnList.asyncImgView loadImageFromURL:imgURL target:self completion:nil];
            }else{
                [btnList.asyncImgView setImage:[UIImage imageNamed:_defaultBGName]];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"HAHA Error:%@", exception.reason);
        }
        @finally {
            
        }
    }
    //NSLog(@"%@",dicResult);
    //NSLog(@"generate list finish");
}

-(void)generateList:(NSString *) isNext{
    //NSLog(@"get json start");
    NSHTTPURLResponse   * res;
    NSError * err;
    NSMutableURLRequest * req;
    NSMutableString * nearbySearchURL=[NSMutableString string];

    //next page but token is empty,
    //_SVListContainer.isBusy is YES and in the block change to NO.
    _loadingView.alpha=1;
    if(isNext != nil && [isNext boolValue]==YES && (_nextPageToken==nil || _nextPageToken.length==0)){
        return;
    }
    if(_nextPageToken == nil){
        
        [nearbySearchURL appendFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=500&keyword=%@&sensor=true&key=%@&rankBy=prominence&types=%@",_locationManager.location.coordinate.latitude,_locationManager.location.coordinate.longitude,[[_keyword lowercaseString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[VariableStore sharedInstance].keyGoogleMap,[_type stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }else{
        [nearbySearchURL appendFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=500&keyword=%@&sensor=true&key=%@&rankBy=prominence&pagetoken=%@&types=%@",_locationManager.location.coordinate.latitude,_locationManager.location.coordinate.longitude,[[_keyword lowercaseString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[VariableStore sharedInstance].keyGoogleMap,_nextPageToken,[_type stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }

    req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:nearbySearchURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    NSData * response =[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    NSError *jsonParsingError = nil;
    if(response !=nil){
        NSMutableDictionary *dicResult = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&jsonParsingError];
        //NSLog(@"json finish");

        dispatch_async(dispatch_get_main_queue(),^{
            NSLog(@"%b",[dicResult count]);
            
            [self generateListMain:dicResult];
            if([isNext boolValue]){
                _currentCount+=[[dicResult objectForKey:@"results"] count];
            }else{
                self.navigationController.topViewController.title=_cateTitle;
                _currentCount=[[dicResult objectForKey:@"results"] count];
            }
            //給 viewDidAppear 用的 因為view did appear 會被subview觸發，這邊加計一個Mark 讓generateList只會被觸發一次
            _isGenerateList=YES;
            [UIView beginAnimations:@"" context:@"show_scroll_view"];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.26];
            [_SVListContainer setAlpha:1];
            [UIView commitAnimations];
            _SVListContainer.isBusy=NO;
        });
        
    }else{
        NSLog(@"%@",err);
    }

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
