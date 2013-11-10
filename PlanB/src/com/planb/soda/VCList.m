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
#import "VCMap.h"
#import "VCList.h"
#import "Util.h"
#import "AsyncImgView.h"
#import "SingleStartView.h"
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate=self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    [self generateList];
    [_SVListContainer setScrollEnabled:true];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    //NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)generateList{
    VariableStore *vs=[VariableStore sharedInstance];

        NSHTTPURLResponse   * res;
        NSError * err;
        NSMutableURLRequest * req;
        NSMutableString * nearbySearchURL=[NSMutableString string];

    self.navigationController.topViewController.title=_category;
        [nearbySearchURL appendFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=500&keyword=%@&sensor=true&key=%@&rankBy=prominence,distance",_locationManager.location.coordinate.latitude,_locationManager.location.coordinate.longitude,[[_category lowercaseString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[VariableStore sharedInstance].keyGoogleMap];

    req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:nearbySearchURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];

    NSData * response =[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    NSError *jsonParsingError = nil;

    if(response !=nil){
        NSDictionary *locationResults = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
        float contentHeight=[[locationResults objectForKey:@"results"] count]*[vs.listHeight floatValue]+15;
        [_SVListContainer setContentSize:CGSizeMake([vs.listWidth floatValue], contentHeight)];
        if(![[locationResults objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"]){
            _lblCount.text=[NSString stringWithFormat:@"%d",[[locationResults objectForKey:@"results"] count]];
            NSString *nextPageToken=(NSString *) [locationResults valueForKey:@"next_page_token"];
            VCMap *vcMap=(VCMap *)self.sidePanelController.rightPanel;
            [vcMap clearMarker];

            for(int i=0;i<[[locationResults objectForKey:@"results"] count];i++){
                NSString *name= [[[locationResults objectForKey:@"results"] objectAtIndex:i] valueForKey:@"name"] ;
                NSString *reference= [[[locationResults objectForKey:@"results"] objectAtIndex:i] valueForKey:@"reference"];
                NSString *placeId= [[[locationResults objectForKey:@"results"] objectAtIndex:i] valueForKey:@"id"];
                UIPlaceButton *btnList=[[UIPlaceButton alloc]init];
                NSString *lat=[[[[[locationResults objectForKey:@"results"] objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
                NSString *lng=[[[[[locationResults objectForKey:@"results"] objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
                float rating=[[[[locationResults objectForKey:@"results"] objectAtIndex:i] valueForKey:@"rating"] floatValue];
                
                /*remove and move to background thread*/
                CLLocation *destination=[[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lng doubleValue]];
                CLLocationManager *locationManager = [[CLLocationManager alloc] init];
                locationManager.delegate = self;//or whatever class you have for managing location
                [locationManager startUpdatingLocation];
                vs.myLocation=locationManager.location;
                
                double dist=[destination distanceFromLocation:locationManager.location]* 0.000621371192*1000;
                //double dist= [Util distBetweenTwoLocate:vs.myLocation destination:destination];
                
                
                VCMap *vcMap=(VCMap *)self.sidePanelController.rightPanel;
                [vcMap pinMarker:[lat floatValue] lng:[lng floatValue] name:name snippet:@""];
                btnList.frame = CGRectMake(0, [vs.listHeight floatValue]*i+15,  [vs.listWidth floatValue],[vs.listHeight floatValue]);
                [btnList setPlaceName:name];
                [btnList setReference:reference];
                /* view title */
                UIView *viewTitle=[[UIView alloc] init];
                [viewTitle setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8]];
                [viewTitle setFrame:CGRectMake(0, [vs.listHeight floatValue]-30, [vs.listWidth floatValue], 30)];
                CALayer *bottomBorder = [CALayer layer];
                bottomBorder.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1].CGColor;
                bottomBorder.borderWidth = 0.5;
                bottomBorder.frame = CGRectMake(-1, -0.5, btnList.frame.size.width+2 ,btnList.frame.size.height);
                [btnList.layer addSublayer:bottomBorder];

                
                SingleStartView * singleStart=[[SingleStartView alloc]init];
                [singleStart setScore:rating/5];
                [singleStart setFrame:CGRectMake([vs.listWidth floatValue ]-90,[vs.listHeight floatValue]-60, 35, 35)];
                //NSLog(@"%@", [NSString stringWithFormat:@"%@:%.2F", name,rating]);
                
                UILabel *lblRating=[[UILabel alloc]init];
                lblRating.textColor = [UIColor whiteColor];
                lblRating.font = [UIFont fontWithName:@"Arial-BoldMT" size:30.f];
                lblRating.numberOfLines = 1;
                lblRating.lineBreakMode = NSLineBreakByWordWrapping;
                lblRating.text=[ NSString stringWithFormat:@"%.1F", rating];
                lblRating.textAlignment=NSTextAlignmentRight;
                [lblRating setFrame:CGRectMake([vs.listWidth floatValue]-70, [vs.listHeight floatValue]-60, 60, 30)];
                
                UILabel *lblDesc =[[UILabel alloc]init];
                lblDesc.textColor = [UIColor blackColor];
                lblDesc.font = [UIFont fontWithName:@"Arial Black" size:14];
                lblDesc.numberOfLines = 1;
                lblDesc.lineBreakMode = NSLineBreakByWordWrapping;
                lblDesc.text=name;
                lblDesc.textAlignment=NSTextAlignmentRight;
                [lblDesc setFrame:CGRectMake([vs.listWidth floatValue]-200-5, 0, 200, 30)];
                [viewTitle addSubview:lblDesc];

                
                UILabel *lblDist =[[UILabel alloc]init];
                lblDist.textColor = [UIColor blackColor];
                lblDist.font = [UIFont fontWithName:@"Arial Black" size:10];
                lblDist.numberOfLines = 1;
                lblDist.lineBreakMode = NSLineBreakByWordWrapping;
                lblDist.text=[NSString stringWithFormat:@"%d 公尺", (int) dist];
                lblDist.textAlignment=NSTextAlignmentLeft;
                [lblDist setFrame:CGRectMake(10, 0, 90, 30)];
                [viewTitle addSubview:lblDist];

                
                [btnList setPlaceId:placeId];
                [btnList addTarget:self action:@selector(goToOne:) forControlEvents:UIControlEventTouchUpInside];
                [_SVListContainer addSubview:btnList];
                [[btnList layer] setBorderWidth:0.1f];
                [[btnList layer] setBorderColor:[UIColor grayColor].CGColor];
                [[btnList layer] setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor];
                
                @try {
                    if([[[[locationResults objectForKey:@"results"] objectAtIndex:i] objectForKey:@"photos"] count]>0){
                        NSString *photoRef=[[[[[locationResults objectForKey:@"results"] objectAtIndex:i] objectForKey:@"photos"] objectAtIndex:0] valueForKey:@"photo_reference"];
                        NSString *strURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&sensor=false&key=%@",photoRef,[VariableStore sharedInstance].keyGoogleMap] ;
                        NSURL *imgURL=[NSURL URLWithString:strURL];
                        AsyncImgView *asyncImgView=[[AsyncImgView alloc] init];
                        [asyncImgView setFrame:CGRectMake(0, 0, [vs.listWidth floatValue],[vs.listHeight floatValue] )];
                        [btnList addSubview:asyncImgView];
                        [asyncImgView loadImageFromURL:imgURL target:self completion:nil];
                    }else{
                        
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"HAHA Error:%@", exception.reason);
                }
                @finally {

                }
                [btnList addSubview:viewTitle];
                [btnList addSubview:singleStart];
                [btnList addSubview:lblRating];
            }
    }
    }else{
        NSLog(@"%@",err);
    }
}
-(void)goToOne: (id)sender{
    UIPlaceButton *btnPlace=(UIPlaceButton *) sender;
    VCDetail *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"VCDetail"];
    detail.strPlaceTitle=btnPlace.placeName;
    detail.strReference=btnPlace.reference;
    detail.strGoogleId=btnPlace.placeId;
    [self.navigationController pushViewController:detail animated:YES];

}

@end
