//
//  VCTest.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/8/28.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import "VCTest.h"
#import "VariableStore.h"
#import <GoogleMaps/GoogleMaps.h>
#import <objC/runtime.h>
#import <CoreLocation/CoreLocation.h>
@interface VCTest ()

@end

@implementation VCTest{
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
    // Dispose of any resources that can be recreated.
}
-(void)getSelfLocation{

    CLLocation *location = mapview.myLocation;
    if (location) {
        [mapview animateToLocation:location.coordinate];
        NSHTTPURLResponse   * res;
        NSError * err;
        NSMutableURLRequest * req;
        //req =[[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.planb-on.com/controller/member.aspx?action=get"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60]];
        NSMutableString * nearbySearchURL=[NSMutableString string];
        
        [nearbySearchURL appendFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=500&types=food&sensor=true&key=AIzaSyCyb6ma56NFUYCQ898XD321qF74JGfkCI4",location.coordinate.latitude,location.coordinate.longitude];

        
        req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:nearbySearchURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
        
        NSData * response =[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        //NSLog(@"RESPONSE HEADERS: \n%@", [res allHeaderFields]);
        NSString * a=[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        //NSLog(@"RESPONSE BODY: \n%@",a);
        NSError *jsonParsingError = nil;
        NSDictionary *locationResults = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
        NSLog([locationResults objectForKey:@"status"]);
        if([locationResults objectForKey:@"status"]!=@"ZERO_RESULTS"){
            NSLog(@"%d",[locationResults count]);
            for(int i=0;i<[locationResults count];i++){
                NSString *name= [[[locationResults objectForKey:@"results"] objectAtIndex:i] valueForKey:@"name"] ;
                NSString *lat= [[[[[locationResults objectForKey:@"results"] objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lat"];
                NSString *lng= [[[[[locationResults objectForKey:@"results"] objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lng"] ;
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake([lat floatValue], [lng floatValue]);
                marker.title = name;
                NSLog(@"%@",[locationResults objectForKey:@"results"]
                      );
                //marker.snippet = [[[locationResults objectForKey:@"results"] objectAtIndex:i] valueForKey:@"formated_address"];
                marker.map = mapview;

            }


            /*NSString *stringLatitude = [[[[[locationResults objectForKey:@"results"] objectAtIndex:1] objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lat"];
            NSString *stringLongitude = [[[[[locationResults objectForKey:@"results"] objectAtIndex:1] objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lng"];
            NSLog(stringLatitude);
            NSLog(stringLongitude);*/
            
            
        }
 

    }
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
    NSMutableArray *arrMarker=(NSMutableArray *)[VariableStore sharedInstance].arrMarker;
    for(int i=0;i<arrMarker.count;i++){
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.map=nil;
    }
    [mapview clear];
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
    //mapview.settings.myLocationButton = YES;
    //mapview.myLocationEnabled = YES;
    //CLLocation *myLocation = mapview.myLocation;
    //NSLog(@"%f %f",myLocation.coordinate.latitude, myLocation.coordinate.longitude);
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0,410,300,50);
    [button setBackgroundColor:[UIColor redColor]];
    button.titleLabel.text=@"test";
    button.titleLabel.textColor=[UIColor blackColor];
    [button setTitle:@"Get My Location" forState:UIControlStateNormal];
    [button addTarget:self  action:@selector(getSelfLocation) forControlEvents:UIControlEventTouchUpInside];
    [mapview addSubview:button];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [mapview addGestureRecognizer:longPressGesture];
    //mapview.mapType = kGMSTypeSatellite;
//    mapview.indoorEnabled=NO;
//    mapview.center =;CGFloat y)
    // Creates a marker in the center of the map.
    /*GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapview;*/
}
#pragma mark - GMSMapViewDelegate
-(void) mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    //NSLog(@"test");
}
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {

    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
}
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    //marker.position.latitude
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        NSString *url =[NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%@&directionsmode=walking",marker.snippet];        
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    } else {
        NSLog(@"Can't use comgooglemaps://");
    }
    
}
-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
    // This is important if you only want to receive one tap and hold event
    NSLog(@"A");
    if (sender.state == UIGestureRecognizerStateEnded)
    {

    }
    else
    {

    }
}
@end
