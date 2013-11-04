//
//  AsyncImgView.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 2013/11/3.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsyncImgView : UIImageView
@property double width;
@property double height;
@property double maskWidth;
@property double maskHeight;
-(void) loadImageFromURL:(NSURL *) url completion:(SEL) completion;
-(void) loadImageHasPreviewThumbnailFromURL:(NSURL *) thumbnailUrl url:(NSURL *) url completion:(SEL) completion;
@end
