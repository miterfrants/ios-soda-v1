//
//  VCGoodsList.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/10/7.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import "VCGoodsList.h"
#import "AppDelegate.h"
#import "VariableStore.h"
#import "AsyncImgView.h"
@interface VCGoodsList ()

@end

@implementation VCGoodsList

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
    //NSLog(@"%@",[VariableStore sharedInstance].json_goods);
    NSData * data_goods=[[VariableStore sharedInstance].jsonGoods dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonParsingError = nil;
    NSDictionary *dic_goods = [NSJSONSerialization JSONObjectWithData:data_goods options:0 error:&jsonParsingError];
    if(jsonParsingError==nil){
        //NSLog(@"%d",[[dic_goods objectForKey:@"goods"] count]);
        for( int i=0;i<[[dic_goods objectForKey:@"goods"] count];i++){
            UILabel *lblTitle= [[UILabel alloc] init];
            lblTitle.text=[[[dic_goods objectForKey:@"goods"] objectAtIndex:i] objectForKey:@"name"];
            //NSLog(@"%@",lblTitle.text);
            lblTitle.textColor = [UIColor blackColor];
            lblTitle.font = [UIFont italicSystemFontOfSize:12];
            lblTitle.numberOfLines = 5;
            //iOS 6,7
            //lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
            lblTitle.lineBreakMode= UILineBreakModeWordWrap;
            
            UILabel *lblNum= [[UILabel alloc] init];
            lblNum.textColor = [UIColor redColor];
            lblNum.font = [UIFont italicSystemFontOfSize:12];
            lblNum.numberOfLines = 5;
            //iOS 6,7
            //lblNum.lineBreakMode = NSLineBreakByWordWrapping;
            lblNum.lineBreakMode=UILineBreakModeWordWrap;
            
            lblNum.text=[[[dic_goods objectForKey:@"goods"] objectAtIndex:i] objectForKey:@"qty"];

            NSURL *imgURL=[NSURL URLWithString:[[[dic_goods objectForKey:@"goods"] objectAtIndex:i] objectForKey:@"pic"]];
            AsyncImgView *imgView=[[AsyncImgView  alloc] init];
            imgView.frame=CGRectMake(i%3*102.25+10,(floorf(i/3)*102.25)+70, 90, 90);
            [lblTitle setFrame:CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y+imgView.frame.size.height-40, imgView.frame.size.width, imgView.frame.size.height)];
            [lblNum setFrame:CGRectMake(imgView.frame.origin.x, imgView.frame.origin.y, 10, 20)];
            [imgView loadImageFromURL:imgURL target:self completion:@selector(completion)];
            [[self view] addSubview:imgView];
            [[self view] addSubview:lblTitle];
            [[self view] addSubview:lblNum];
        }
    }else{
        //NSLog(@"%@",jsonParsingError);
        
    }


	// Do any additional setup after loading the view.
}
-(void) completion{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
