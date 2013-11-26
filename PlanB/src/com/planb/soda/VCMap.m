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
    



	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) pinMarker:(float) lat lng:(float) lng name:(NSString*) name snippet:(NSString *) snippet{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lat, lng);
    marker.title = name;
    marker.snippet=snippet;
    [mapview animateToLocation:marker.position];
    marker.map=mapview;
    [[VariableStore sharedInstance].arrMarker  addObject:marker];
}

- (void) clearMarker{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *arrMarker=(NSMutableArray *)[VariableStore sharedInstance].arrMarker;
        for(int i=0;i<arrMarker.count;i++){
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.map=nil;
        }
        [mapview clear];
    });
    
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
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:24.942561337387872
                                                            longitude:121.36862754821777
                                                                 zoom:15];
    mapview = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapview.myLocationEnabled = YES;
    self.view = mapview;
    mapview.accessibilityElementsHidden=NO;
    mapview.delegate=self;

    _btnTakeMeThere=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnTakeMeThere.frame=CGRectMake(0,410,300,50);
    [_btnTakeMeThere setBackgroundColor:[UIColor colorWithRed:0.3 green:0.6 blue:0.8 alpha:1]];
    _btnTakeMeThere.titleLabel.textColor=[UIColor blackColor];
    [_btnTakeMeThere setTitle:@"Take Me There" forState:UIControlStateNormal];
    [_btnTakeMeThere addTarget:self  action:@selector(takeMeThere:) forControlEvents:UIControlEventTouchUpInside];
    _btnTakeMeThere.hidden=YES;
    [mapview addSubview:_btnTakeMeThere];
    
    _btnNext=[[UIButton alloc]init];
    _btnNext.frame=CGRectMake(220,30,80,50);
    _btnNext.titleLabel.textColor=[UIColor blackColor];
    _btnNext.hidden=NO;
    [_btnNext setBackgroundColor:[UIColor colorWithRed:0.3 green:0.6 blue:0.8 alpha:1]];
    [_btnNext setTitle:@"Next" forState:UIControlStateNormal];
    [_btnNext addTarget:self  action:@selector(nextMarker:) forControlEvents:UIControlEventTouchUpInside];
    [mapview addSubview:_btnNext];

    _btnPrevious=[[UIButton alloc]init];
    _btnPrevious.frame=CGRectMake(80,30,80,50);
    _btnPrevious.titleLabel.textColor=[UIColor blackColor];
    _btnPrevious.hidden=NO;
    [_btnPrevious setBackgroundColor:[UIColor colorWithRed:0.3 green:0.6 blue:0.8 alpha:1]];
    [_btnPrevious setTitle:@"Prev" forState:UIControlStateNormal];
    [_btnPrevious addTarget:self  action:@selector(prevMarker:) forControlEvents:UIControlEventTouchUpInside];
    [mapview addSubview:_btnPrevious];
    
}
#pragma mark - GMSMapViewDelegate
-(void) mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    //NSLog(@"test");
}
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    //NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
}
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    mapView.selectedMarker=marker;
    _btnTakeMeThere.hidden=NO;
    /*if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        NSString *url =[NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%@&directionsmode=walking",marker.snippet];        
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    } else {
        NSLog(@"Can't use comgooglemaps://");
    }*/
    return YES;
}
-(void) nextMarker:(id) sender{
    UINavigationController * center=(UINavigationController *) self.sidePanelController.centerPanel;
    for(int i=1; i<=[center viewControllers].count ;i++){
        NSString *className=NSStringFromClass([[[center viewControllers] objectAtIndex:[center viewControllers].count-i] class]);
        if([className isEqual:@"VCList"]){
            VCList * vcList=(VCList *)[[center viewControllers] objectAtIndex:[center viewControllers].count-i];
            for(int j =0 ; j<vcList.arrButton.count;j++){
                UIButton * btn=(UIButton *)[vcList.arrButton objectAtIndex:j];
                //[btn sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}
-(void) prevMarker:(id) sender{
    
}
@end
