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
    //NSOperationQueue *queueImage=[[NSOperationQueue alloc] init];
    //NSOperationQueue *queueImage=dispatch_get_global_queue(0, 0);
    /*[Util stringAsyncWithUrl:url completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        UIImage *img=[[UIImage alloc] initWithData:data];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        CGRect maskRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        CGPathRef path = CGPathCreateWithRect(maskRect, NULL);
        maskLayer.path = path;
        CGPathRelease(path);
        self.layer.mask=maskLayer;
        [self setImage:img];
        [self setContentMode:UIViewContentModeScaleAspectFill];
        NSLog(@"async img load com");
        if(completion != nil ){
            [target performSelector:completion];
        }
    } queue:queueImage];*/
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        dispatch_async(dispatch_get_main_queue(), ^{
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            CGRect maskRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            CGPathRef path = CGPathCreateWithRect(maskRect, NULL);
            maskLayer.path = path;
            CGPathRelease(path);
            self.layer.mask=maskLayer;
            [self setImage:img];
            [self setContentMode:UIViewContentModeScaleAspectFill];
            if(completion != nil ){
                [target performSelector:completion];
            }

        });  
    });
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
