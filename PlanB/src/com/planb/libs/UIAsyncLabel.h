//
//  UIAsyncLabel.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 2013/11/24.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ completionBlock)(void);
@interface UIAsyncLabel : UILabel
-(void) asyncTextFromURL:(NSString *)url completion:(SEL) completion;
@end
