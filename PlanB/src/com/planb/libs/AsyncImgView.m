//
//  AsyncImgView.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 2013/11/3.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import "AsyncImgView.h"
#import "Util.h"
#import "VCCenter.h"
#import "AppDelegate.h"
// use stringAsyncWithUrl

@implementation AsyncImgView

@synthesize width,height,maskWidth,maskHeight;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }

    return self;
}
-(void) loadImageFromURL:(NSURL *)url target:(NSObject *) target completion:(SEL)completion{
    NSOperationQueue *queueImage=[[NSOperationQueue alloc] init];
    //NSOperationQueue *queueImage=dispatch_get_global_queue(0, 0);
    [Util stringAsyncWithUrl:url completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        UIImage *img=[[UIImage alloc] initWithData:data];
        [self setImage:img];
        [self setFrame:CGRectMake(0, 150, 50, 50)];
        [self setBackgroundColor:[UIColor redColor]];
        [target performSelector:completion];
    } queue:queueImage];

}
-(void) loadImageHasPreviewThumbnailFromURL:(NSURL *)thumbnailUrl url:(NSURL *)url completion:(SEL)completion{
    
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
