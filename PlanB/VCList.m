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
#import "VCTest.h"
#import "VCList.h"
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
    [self getSelfLocation];

    /*CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in _USView)
    {
        //scrollViewHeight += view.frame.size.height;
    }*/
    [_SVListContainer setScrollEnabled:true];
    
//    [_USView setContentSize:(CGSizeMake(320, 2500))];
    
	// Do any additional setup after loading the view.
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
-(void)getSelfLocation{


        NSHTTPURLResponse   * res;
        NSError * err;
        NSMutableURLRequest * req;
        //req =[[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.planb-on.com/controller/member.aspx?action=get"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60]];
        NSMutableString * nearbySearchURL=[NSMutableString string];

    self.navigationController.topViewController.title=_category;
        [nearbySearchURL appendFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=500&keyword=%@&sensor=true&key=%@",_locationManager.location.coordinate.latitude,_locationManager.location.coordinate.longitude,[[_category lowercaseString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[VariableStore sharedInstance].keyGoogleMap];
    
        //NSLog(@"longitude %f",_locationManager.location.coordinate.longitude);
        //NSLog(@"latitude %f",_locationManager.location.coordinate.latitude);
        req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:nearbySearchURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];

        NSData * response =[NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
        //NSLog(@"RESPONSE HEADERS: \n%@", [res allHeaderFields]);
        //NSString * a=[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        //NSLog(@"%@",a);
        //NSLog(@"RESPONSE BODY: \n%@",a);
    NSLog(@"%@",nearbySearchURL);
        NSError *jsonParsingError = nil;
    if(response !=nil){
        NSDictionary *locationResults = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
        //NSLog(@"%@",locationResults);
        if([locationResults objectForKey:@"status"]!=@"ZERO_RESULTS"){
            _lblCount.text=[NSString stringWithFormat:@"%d",[[locationResults objectForKey:@"results"] count]];
            VCTest *vcTest=(VCTest *)self.sidePanelController.rightPanel;
            [vcTest clearMarker];
            _SVListContainer.contentSize = CGSizeMake(320,[[locationResults objectForKey:@"results"] count]*40+30 );
            for(int i=0;i<[[locationResults objectForKey:@"results"] count];i++){
                
                NSString *name= [[[locationResults objectForKey:@"results"] objectAtIndex:i] valueForKey:@"name"] ;
                NSString *reference= [[[locationResults objectForKey:@"results"] objectAtIndex:i] valueForKey:@"reference"];
                NSString *placeId= [[[locationResults objectForKey:@"results"] objectAtIndex:i] valueForKey:@"id"];
                
                //UIPlaceButton *btnList = [UIPlaceButton buttonWithType:UIButtonTypeRoundedRect];
                UIPlaceButton *btnList=[[UIPlaceButton alloc]init];
                NSString *lat=[[[[[locationResults objectForKey:@"results"] objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
                NSString *lng=[[[[[locationResults objectForKey:@"results"] objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];

                VCTest *vcTest=(VCTest *)self.sidePanelController.rightPanel;
                [vcTest pinMarker:[lat floatValue] lng:[lng floatValue] name:name snippet:@""];
                btnList.frame = CGRectMake(5, 40*i+30, 200, 30);
                [btnList setPlaceName:name];
                [btnList setReference:reference];
                //btnList.reference=reference;
                [btnList setPlaceId:placeId];
                [btnList setTitle:name forState:UIControlStateNormal];
                [btnList addTarget:self action:@selector(goToOne:) forControlEvents:UIControlEventTouchUpInside];
                [_SVListContainer addSubview:btnList];
                [[btnList layer] setBorderWidth:0.1f];
                [[btnList layer] setBorderColor:[UIColor grayColor].CGColor];
                [[btnList layer] setBackgroundColor:[UIColor grayColor].CGColor];
                @try {
                    //NSLog(@"%@",[[[locationResults objectForKey:@"results"] objectAtIndex:i] valueForKey:@"name"] );
                    //NSLog(@"%@",[[[locationResults objectForKey:@"results"] objectAtIndex:i] valueForKey:@"reference"] );

                    if([[[[locationResults objectForKey:@"results"] objectAtIndex:i] objectForKey:@"photos"] count]>0){
                        NSString *photoRef=[[[[[locationResults objectForKey:@"results"] objectAtIndex:i] objectForKey:@"photos"] objectAtIndex:0] valueForKey:@"photo_reference"];
                        NSString *strURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&sensor=false&key=%@",photoRef,[VariableStore sharedInstance].keyGoogleMap] ;
                        //  NSLog(strURL);
                        //NSURL *imgURL=[NSURL URLWithString:strURL];
                        //NSData *imgData=[NSData dataWithContentsOfURL:imgURL];
                         //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imgData]];
                        //imageView.frame = CGRectMake(0,0, 100, 100);
                        //[btnList setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];
                        //[self.view addSubview:imageView];
                    }


                    /*NSString *lat= [[[[[locationResults objectForKey:@"results"] objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lat"];
                    NSString *lng= [[[[[locationResults objectForKey:@"results"] objectAtIndex:i] objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lng"] ;*/
                    /*UILabel *lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(100,(i*40), 100, 100)];

                    lblDesc.textColor = [UIColor blackColor];

                    lblDesc.font = [UIFont italicSystemFontOfSize:12];
                    lblDesc.numberOfLines = 5;
                    lblDesc.lineBreakMode = UILineBreakModeWordWrap;
                    lblDesc.text = @"mihir patel";
                    //Calculate the expected size based on the font and linebreak mode of label
                    CGSize maximumLabelSize = CGSizeMake(300,400);
                    CGSize expectedLabelSize = [@"mihir" sizeWithFont:lblDesc.font constrainedToSize:maximumLabelSize lineBreakMode:lblDesc.lineBreakMode];
                    //Adjust the label the the new height
                    CGRect newFrame = lblDesc.frame;
                    newFrame.size.height = expectedLabelSize.height;
                    newFrame.origin.x=20;
                    newFrame.origin.y=i*17+40;
                    lblDesc.frame = newFrame;
                    lblDesc.text=name;
                    [self.view addSubview:lblDesc];
*/
                }
                @catch (NSException *exception) {
                    NSLog(@"HAHA Error:%@", exception.reason);
                }
                @finally {

                }
                /*GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake([lat floatValue], [lng floatValue]);
                marker.title = name;
                marker.snippet = @"My Hometown";
                marker.map = mapView_;*/
            }
            /*NSString *stringLatitude = [[[[[locationResults objectForKey:@"results"] objectAtIndex:1] objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lat"];
             NSString *stringLongitude = [[[[[locationResults objectForKey:@"results"] objectAtIndex:1] objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lng"];
             NSLog(stringLatitude);
             NSLog(stringLongitude);*/
        //}
        
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
