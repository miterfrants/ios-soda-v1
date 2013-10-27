//
//  VCRoot.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/9/9.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import "VCRoot.h"
#import "AppDelegate.h"
@interface VCRoot ()

@end

@implementation VCRoot

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
     AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.fb_session.isOpen) {
        appDelegate.fb_session = [[FBSession alloc] init];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) awakeFromNib
{
    self.shouldDelegateAutorotateToVisiblePanel=NO;
    self.panningLimitedToTopViewController=NO;

    [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"VCLeft"]];
    [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"NCCenter"]];
    [self setRightPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"VCRight"]];

}

@end
