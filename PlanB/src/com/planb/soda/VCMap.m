//
//  VCTest.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/8/28.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import "VCMap.h"
#import "VariableStore.h"
#import "VCList.h"
#import <GoogleMaps/GoogleMaps.h>
#import <objC/runtime.h>
#import <CoreLocation/CoreLocation.h>
#import "JASidePanelController.h"
@interface VCMap ()

@end

@implementation VCMap{
    //GMSMapView *mapview;
}
@synthesize mapview;
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
    if(_arrMarker.count==0){
        _btnNext.hidden=YES;
        _btnPrevious.hidden=YES;
    }

	// Do any additional setup after loading the view.
}
-(void)displayLayer:(CALayer *)layer{
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) pinMarker:(float) lat lng:(float) lng name:(NSString*) name snippet:(NSString *) snippet{
    _btnNext.hidden=NO;
    _btnPrevious.hidden=NO;
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lat, lng);
    marker.title = name;
    marker.snippet=snippet;
    [mapview animateToLocation:marker.position];
    if(_arrMarker==nil){
        _arrMarker=[[NSMutableArray alloc]init];
    }
    [_arrMarker addObject:marker];

    marker.map=mapview;
}

- (void) clearMarker{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *arrMarker=_arrMarker;
        for(int i=0;i<arrMarker.count;i++){
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.map=nil;
        }
        [mapview clear];
    });
    _arrMarker= [[NSMutableArray alloc]init];
}

-(void) takeMeThere:(id *) sender{
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]] && mapview.selectedMarker != nil) {
        NSString *url =[NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%@&directionsmode=walking",self.mapview.selectedMarker.snippet];
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    } else {
        NSLog(@"Can't use comgooglemaps://");
    }
}

- (void)loadView {

    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    //GMSCameraPosition 這個是用來設定 zoom 和 map center 有點像 3d的view port
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    //locationManager.delegate = self;//or whatever class you have for managing location
    [locationManager startUpdatingLocation];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:locationManager.location.coordinate.latitude
                                                            longitude:locationManager.location.coordinate.longitude
                                                                 zoom:15];

    mapview = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapview.myLocationEnabled = YES;
    self.view = mapview;
    mapview.accessibilityElementsHidden=NO;
    mapview.delegate=self;
    _vs= [VariableStore sharedInstance];
    _btnTakeMeThere=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnTakeMeThere.frame=CGRectMake(138,_vs.screenH-65,162,48);
    //[_btnTakeMeThere setBackgroundColor:[UIColor colorWithRed:0.3 green:0.6 blue:0.8 alpha:1]];
    _btnTakeMeThere.titleLabel.textColor=[UIColor blackColor];
    UIImageView *imgViewTakemethere=[[UIImageView alloc] init];
    [imgViewTakemethere setImage:[UIImage imageNamed:@"Nav-btn.png"]];
    [imgViewTakemethere setFrame:CGRectMake(0, 0, 162, 48)];
    UILabel *lblDirection=[[UILabel alloc]init];
    [imgViewTakemethere  addSubview:lblDirection];
    [lblDirection setFrame:CGRectMake(26,0, 100, 48)];
    lblDirection.text=@"導 航";
    lblDirection.textColor = [UIColor whiteColor];
    lblDirection.font = [UIFont fontWithName:@"黑體-繁" size:24.f];
    lblDirection.numberOfLines = 1;
    lblDirection.lineBreakMode = NSLineBreakByWordWrapping;
    lblDirection.textAlignment=NSTextAlignmentLeft;

    
    [_btnTakeMeThere addSubview:imgViewTakemethere];
    [_btnTakeMeThere addTarget:self  action:@selector(takeMeThere:) forControlEvents:UIControlEventTouchUpInside];
    _btnTakeMeThere.hidden=YES;
    [mapview addSubview:_btnTakeMeThere];
    
    _btnNext=[[UIButton alloc]init];
    _btnNext.frame=CGRectMake(250,30,48,48);
    _btnNext.titleLabel.textColor=[UIColor blackColor];
    _btnNext.hidden=NO;
    //[_btnNext setBackgroundColor:[UIColor colorWithRed:0.3 green:0.6 blue:0.8 alpha:1]];
    UIImageView *imgViewNext=[[UIImageView alloc] init];
    [imgViewNext setImage:[UIImage imageNamed:@"next-btn.png"]];
    [imgViewNext setFrame:CGRectMake(0, 0, 48, 48)];
    [_btnNext addSubview:imgViewNext];
    [_btnNext addTarget:self  action:@selector(nextMarker:) forControlEvents:UIControlEventTouchUpInside];
    [mapview addSubview:_btnNext];

    _btnPrevious=[[UIButton alloc]init];
    _btnPrevious.frame=CGRectMake(80,30,48,48);
    _btnPrevious.titleLabel.textColor=[UIColor blackColor];
    _btnPrevious.hidden=NO;
    //[_btnPrevious setBackgroundColor:[UIColor colorWithRed:0.3 green:0.6 blue:0.8 alpha:1]];
    UIImageView *imgViewPre=[[UIImageView alloc] init];
    [imgViewPre setImage:[UIImage imageNamed:@"pre-btn.png"]];
    [imgViewPre setFrame:CGRectMake(0, 0, 48, 48)];
    [_btnPrevious addSubview:imgViewPre];
    [_btnPrevious addTarget:self  action:@selector(prevMarker:) forControlEvents:UIControlEventTouchUpInside];
    [mapview addSubview:_btnPrevious];

    for(int i=0;i< _arrMarker.count;i++){
        GMSMarker * marker=(GMSMarker *) _arrMarker[i];
        marker.map=mapview;
    }
    mapview.padding= UIEdgeInsetsMake(0, 72, 0, 0);
    
}
#pragma mark - GMSMapViewDelegate
-(void) mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    //NSLog(@"test");
}
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    //NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
    _btnTakeMeThere.hidden=YES;
}
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    [mapview setSelectedMarker:marker];
    _btnTakeMeThere.hidden=NO;
    return YES;
}
-(void) nextMarker:(id) sender{
    if((int)_currIndex<_arrMarker.count-1){
        _currIndex = ((int) _currIndex +1);
    }else{
        _currIndex=0;
    }
    GMSMarker *marker=[_arrMarker objectAtIndex:_currIndex];
    [mapview setSelectedMarker:marker];
    [mapview setCamera:[GMSCameraPosition cameraWithLatitude:marker.position.latitude
                                                   longitude:marker.position.longitude
                                                        zoom:15]];
    _btnTakeMeThere.hidden=NO;
}

-(void) prevMarker:(id) sender{
    if((int)_currIndex>0){
        _currIndex = ((int) _currIndex -1);
    }else{
        _currIndex=_arrMarker.count-1;
    }
    GMSMarker *marker=[_arrMarker objectAtIndex:_currIndex];
    [mapview setSelectedMarker:marker];
    [mapview setCamera:[GMSCameraPosition cameraWithLatitude:marker.position.latitude
                                                   longitude:marker.position.longitude
                                                        zoom:15]];
    _btnTakeMeThere.hidden=NO;
}
@end
