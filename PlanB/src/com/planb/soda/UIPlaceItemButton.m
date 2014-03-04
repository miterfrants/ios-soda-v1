//
//  PlaceItemButton.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 2013/11/12.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import "UIPlaceItemButton.h"
#import "VariableStore.h"
#import "Util.h"
#import "VCMap.h"
@implementation UIPlaceItemButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    VariableStore *vs = [VariableStore sharedInstance];
    
    
    _viewTitle=[[UIView alloc] init];
    [_viewTitle setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8]];
    [_viewTitle setFrame:CGRectMake(0, [vs.listHeight floatValue]-30, [vs.listWidth floatValue], 30)];

    
    _asyncImgView=[[AsyncImgView alloc] init];
    [_asyncImgView setFrame:CGRectMake(0, 0, [vs.listWidth floatValue],[vs.listHeight floatValue] )];

    
    _lblName =[[UILabel alloc]init];
    _lblName.textColor = [UIColor blackColor];
    _lblName.font = [UIFont fontWithName:@"黑體-繁" size:18];
    _lblName.numberOfLines = 1;
    _lblName.lineBreakMode = NSLineBreakByWordWrapping;
    _lblName.textAlignment=NSTextAlignmentRight;
    [_lblName setBackgroundColor:[Util colorWithHexString:@"FF000000"]];
    
    [_lblName setFrame:CGRectMake([vs.listWidth floatValue]-200-5, 0, 200, 30)];
    [_viewTitle addSubview:_lblName];
    
    
    _lblDist =[[UILabel alloc]init];
    _lblDist.textColor = [UIColor blackColor];
    _lblDist.font = [UIFont fontWithName:@"黑體-繁" size:15];
    _lblDist.numberOfLines = 1;
    [_lblDist setBackgroundColor:[Util colorWithHexString:@"FF000000"]];
    _lblDist.lineBreakMode = NSLineBreakByWordWrapping;
    _lblDist.textAlignment=NSTextAlignmentLeft;
    
    [_lblDist setFrame:CGRectMake(30, 6, 90, 22.5)];
    [self.viewTitle addSubview:_lblDist];
    
    
    _bgRating=[[UIView alloc] init];
    _bgRating.layer.cornerRadius=2;
    [_bgRating setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8]];
    [_bgRating setFrame:CGRectMake([vs.listWidth floatValue]-75, [vs.listHeight floatValue]- 66, 70, 30)];
    
    
    _singleStart=[[SingleStartView alloc]initWithFrame:CGRectMake(4,4, 23, 23)];
    [_bgRating addSubview:_singleStart];
    
    
    _lblRating=[[UILabel alloc]init];
    _lblRating.textColor = [UIColor whiteColor];
    _lblRating.font = [UIFont fontWithName:@"Arial-BoldMT" size:22.f];
    _lblRating.numberOfLines = 1;
    [_lblRating setBackgroundColor:[Util colorWithHexString:@"FFFFFF00"]];
    _lblRating.lineBreakMode = NSLineBreakByWordWrapping;
    _lblRating.textAlignment=NSTextAlignmentRight;
    
    [_lblRating setFrame:CGRectMake(4, 0, 60, 30)];
    [_bgRating addSubview:_lblRating];
    
    
    _btnDirection=[[UIPlaceButton alloc] init];
    UIImage *imgDir=[UIImage imageNamed:@"arrow"];
    [_btnDirection setBackgroundImage:imgDir forState:UIControlStateNormal];
    [_btnDirection setFrame:CGRectMake(5, 5, imgDir.size.width/2, imgDir.size.height/2)];
    [_btnDirection addTarget:self action:@selector(takeMeThere:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewTitle addSubview:_btnDirection];
    
    
    [self addSubview:_asyncImgView];
    [self addSubview:_viewTitle];
    [self addSubview:_bgRating];
    
    
    
    return self;
}

-(void) asyncGetDistAndAddressAndChangeMarker:(NSString*) url  lat:(double) lat lng:(double) lng mapView:(VCMap *) mapView{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *distJson=[Util stringWithUrl:url];
        NSError *jsonParsingError=[[NSError alloc]init];
        NSDictionary *dicDist=[NSJSONSerialization JSONObjectWithData:[distJson dataUsingEncoding:NSUTF8StringEncoding ] options:0 error:&jsonParsingError];
        if(jsonParsingError==nil){
            NSString *address=[[dicDist objectForKey:@"destination_addresses"] objectAtIndex:0];
            self.lblDist.text=[[[[[[dicDist objectForKey:@"rows"] objectAtIndex:0] objectForKey:@"elements"] objectAtIndex:0] objectForKey:@"distance"] objectForKey:@"value"];
            [mapView pinMarker:lat lng:lng name:self.placeName snippet:address];
        }
    });
}

-(void) takeMeThere:(UIPlaceButton *)sender{
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        NSString *url =[NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%F,%F&directionsmode=walking",sender.lat,sender.lng];
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您的 iPhone 未安裝 Google Map" message:@"" delegate:self cancelButtonTitle:@"關閉" otherButtonTitles:@"安裝Google Map",nil];
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
    }else if (buttonIndex == 1) {
        //http://itunes.apple.com/google/maps
        //comappleitunes://?appname=googlemaps
        NSString *url =[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id585027354?mt=8"];
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
