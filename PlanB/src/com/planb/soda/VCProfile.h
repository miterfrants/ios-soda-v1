//
//  VCProfile.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/9/23.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import "UIDefaultTextField.h"
#import "UIViewController+JASidePanel.h"
@interface VCProfile : UIViewController <GPPSignInDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property IBOutlet UIImageView *imgViewProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnFBLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnGoogleLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (weak, nonatomic) IBOutlet UIButton *btnGoods;
@property (weak, nonatomic) IBOutlet UIButton *btnBadge;
@property UILabel* lblUserFullName;
//@property (weak, nonatomic)GPPSignIn* googleSignIn;
-(IBAction) handleLogin:(id) sender;
@end
