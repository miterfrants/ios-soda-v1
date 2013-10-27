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
            UILabel *lblTitle= [[UILabel alloc] initWithFrame:CGRectMake(floorf(i/4)*80,(i*80+70), 100, 100)];
            lblTitle.text=[[[dic_goods objectForKey:@"goods"] objectAtIndex:i] objectForKey:@"name"];
            //NSLog(@"%@",lblTitle.text);
            lblTitle.textColor = [UIColor blackColor];
            lblTitle.font = [UIFont italicSystemFontOfSize:12];
            lblTitle.numberOfLines = 5;
            lblTitle.lineBreakMode = UILineBreakModeWordWrap;
            [[self view] addSubview:lblTitle];
            NSLog(@"test%@",[[dic_goods objectForKey:@"goods"] objectAtIndex:i]);
            NSURL *imgURL=[NSURL URLWithString:[[[dic_goods objectForKey:@"goods"] objectAtIndex:i] objectForKey:@"pic"]];
            NSData *imgData=[NSData dataWithContentsOfURL:imgURL];
            UIImage *img=[[UIImage alloc] initWithData:imgData];
            UIImageView *imgView=[[UIImageView  alloc] initWithImage:img];
            imgView.frame=CGRectMake(floorf(i/4)*80,(i*80)+50, 60, 60);
            [[self view] addSubview:imgView];
        }
    }else{
        NSLog(@"%@",jsonParsingError);
        
    }


	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
