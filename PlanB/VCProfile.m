//
//  VCProfile.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/9/23.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import "VCProfile.h"
#import "AppDelegate.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "Util.h"
#import "VCGoodsList.h"
#import "VCCenter.h"
#import "VCDetail.h"
#import "VCRoot.h"
#import "JASidePanelController.h"
#import "VariableStore.h"
@interface VCProfile ()
- (void)updateView;
@end

@implementation VCProfile

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
    UIColor * greyColor=[UIColor colorWithRed:.6 green:.6 blue:.6 alpha:1];
    UIImage * imgFBLogin = [UIImage imageNamed:@"fb-login.png"];
    UIImage * imgGoogleLogin =[UIImage imageNamed:@"google-login.png"];
    _btnGoods.hidden=YES;
    _btnBadge.hidden=YES;
     _imgViewProfile=[[UIImageView alloc]init];
    _lblUserFullName=[[UILabel alloc]initWithFrame:CGRectMake(0, 93, 100, 100)];
    [_lblUserFullName setTextAlignment:NSTextAlignmentCenter];

    [_imgViewProfile setBackgroundColor:[UIColor clearColor]];
    _btnFBLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnGoogleLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnLogout =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [_btnLogout setFrame:CGRectMake(0,70,imgFBLogin.size.width,imgFBLogin.size.height)];
    _btnLogout.titleLabel.text=@"Logout";
    
    _btnLogout.hidden=YES;
    [_btnFBLogin setFrame:CGRectMake(0,30,imgFBLogin.size.width-20,imgFBLogin.size.height-20)];
    [_btnFBLogin setBackgroundImage:imgFBLogin forState:UIControlStateNormal];
    [_btnGoogleLogin setFrame:CGRectMake(0,imgFBLogin.size.height+20,imgFBLogin.size.width-20,imgFBLogin.size.height-20)];
    [_btnGoogleLogin setBackgroundImage:imgGoogleLogin forState:UIControlStateNormal];
    
    [self.view addSubview:_btnFBLogin];
    [self.view addSubview:_btnGoogleLogin];
    [self.view addSubview:_btnLogout];
    [self.view addSubview:_imgViewProfile];
    [self.view addSubview:_lblUserFullName];
    [_btnFBLogin addTarget:self action:@selector(handleBtnFBClick:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [_btnGoogleLogin addTarget:self action:@selector(handleBtnGoogleClick:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [_btnLogout addTarget:self action:@selector(handleBtnLogoutClick:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    [_btnGoods addTarget:self action:@selector(goToGoodsList:) forControlEvents:UIControlEventTouchUpInside];
    /* UIImage * someImage = [UIImage imageNamed:@"fb-login.png"];
    NSFileManager *filemgr;
    NSString *currentpath;
    filemgr = [NSFileManager defaultManager];
    
    currentpath = [filemgr currentDirectoryPath];
    NSLog (@"Current directory is %@", currentpath);
    NSLog(@"%@",someImage);
    UIImageView * UIIV=[[UIImageView alloc] initWithImage:someImage];
    [self.view addSubview:UIIV];*/

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
-(IBAction)handleBtnLogoutClick:(id) sender{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate.fb_session closeAndClearTokenInformation];
    [[GPPSignIn sharedInstance] signOut];
    _lblUserFullName.text=@"";
    [_imgViewProfile setImage:nil];
    [VariableStore sharedInstance].intLocalId=0;
    [self updateView];
}
-(IBAction) handleBtnFBClick:(id)sender{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    // this button's job is to flip-flop the session from open to closed
    
    if (appDelegate.fb_session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.fb_session closeAndClearTokenInformation];
    } else {
        if (appDelegate.fb_session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.fb_session = [[FBSession alloc] init];
        }
        // if the session isn't open, let's open it now and present the login UX to the user

        [appDelegate.fb_session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            switch (session.state) {
                case FBSessionStateOpen:
                    if (!error) {
                        // We have a valid session

                        [self finishedFbAuth];

                    }
                    break;
                case FBSessionStateClosed: NSLog(@"User session closed");
                case FBSessionStateClosedLoginFailed:{ NSLog(@"Login failed");
                    [FBSession.activeSession closeAndClearTokenInformation];}
                    break;
                default:
                    break;
            }
            // and here we make sure to update our UX according to the new session state

        }];
    }
}
-(void) handleBtnGoogleClick :(id) sender{
    // Do any additional setup after loading the view.
    GPPSignIn *_googleSignIn = [GPPSignIn sharedInstance];
    _googleSignIn.shouldFetchGoogleUserEmail=YES;
    // You previously set kClientId in the "Initialize the Google+ client" step
    NSString *kClientId=@"155217882778-17s2ii21k728qrojqdt9lggcm3aaqnfa.apps.googleusercontent.com";
    _googleSignIn.clientID = kClientId;
    _googleSignIn.scopes = [NSArray arrayWithObjects:
                            kGTLAuthScopePlusLogin, // defined in GTLPlusConstants.h
                            kGTLAuthScopePlusMe,
                            nil];
    _googleSignIn.delegate = self;
    [[GPPSignIn sharedInstance] authenticate];
}
- (void)finishedFbAuth
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [FBSession setActiveSession:appDelegate.fb_session];
    if ([FBSession activeSession].isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                //NSLog(@"%@",user);

                    NSInteger local_id= [[Util stringWithUrl:[NSString stringWithFormat:@"http://%@/controller/mobile/member.aspx?action=get_local_id&source=1&outer_id=%@",[VariableStore sharedInstance].domain,user.id]] intValue];
                     VariableStore *vs=[VariableStore sharedInstance];
                 vs.intLocalId=local_id;
                 [self updateView];
                 
                 [self generateGoods:local_id source:1 token:appDelegate.fb_session.accessTokenData.accessToken];
                 //NSURL *imgURL=[NSURL URLWithString: [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square" ,user.id]];
                 NSURL *imgURL=[NSURL URLWithString: [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=100&height=100" ,user.id]];
                NSData *imgData=[NSData dataWithContentsOfURL:imgURL];
                 UIImage * imgProfile=[UIImage imageWithData:imgData];
                 [_imgViewProfile setImage:imgProfile];
                 [_imgViewProfile setFrame:CGRectMake(0,30,imgProfile.size.width,imgProfile.size.height)];
                 [_lblUserFullName setText:user.name];

                 
             }else{
                 //NSLog(@"%@",error);
             }
         }];
    }
}


- (void)updateView {
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];

    if (appDelegate.fb_session.isOpen || [[[GPPSignIn sharedInstance] authentication] canAuthorize]) {
        _btnFBLogin.hidden=YES;
        _btnGoogleLogin.hidden=YES;
        _btnLogout.hidden=NO;
        _btnGoods.hidden=NO;
        _btnBadge.hidden=NO;
    } else {
        _btnGoods.hidden=YES;
        _btnBadge.hidden=YES;
        _btnFBLogin.hidden=NO;
                _btnGoogleLogin.hidden=NO;
        _btnLogout.hidden=YES;
    }
    UINavigationController *center=(UINavigationController *)self.sidePanelController.centerPanel;
    NSString *className=NSStringFromClass([[[center viewControllers] objectAtIndex:[center viewControllers].count-1] class]);

    
    if([className isEqualToString:@"VCDetail"]){
        VCDetail *vcDetail=(VCDetail *)[[center viewControllers] objectAtIndex:[center viewControllers].count-1];
        NSLog(@"%D",[VariableStore sharedInstance].intLocalId);
        [vcDetail viewDidLoad];
        //NSLog(@"%@",[[center viewControllers] objectAtIndex:[center viewControllers].count-1]);
        [self.sidePanelController showCenterPanelAnimated:YES];
    }
        
}

-(IBAction) focusText:(UIDefaultTextField *)sender{
    if([[UIColor colorWithRed:.6 green:.6 blue:.6 alpha:1] isEqual:sender.textColor]){
        sender.textColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        sender.text=@"";
    }

}
-(IBAction) blurText:(UIDefaultTextField *)sender{
    if(sender.text.length ==0){
        sender.text=sender.defaultValue;
        sender.textColor= [UIColor colorWithRed:.6 green:.6 blue:.6 alpha:1];
    }
}

//google plus auth
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{

    if(auth.canAuthorize){
        GTLServicePlus *service = [[GTLServicePlus alloc] init];
        service.retryEnabled = YES;
        service.authorizer = auth;
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        query.completionBlock = ^(GTLServiceTicket *ticket, id object, NSError *error) {
            if (error == nil) {
                // Want to get here
            } else {
                //NSLog(@"%@", error);
            }
        };
        [service executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                    if (error) {
                        GTMLoggerError(@"Error: %@", error);
                    } else {
                        [self updateView];
                        // Retrieve the display name and "about me" text
                        //NSLog(@"%@",person);
                        _lblUserFullName.text=person.displayName;
                        NSURL *imgURL=[NSURL URLWithString: [NSString stringWithFormat:@"https://plus.google.com/s2/photos/profile/%@?sz=50" ,person.identifier]];
                        NSData *imgData=[NSData dataWithContentsOfURL:imgURL];
                        UIImage * imgProfile=[UIImage imageWithData:imgData];
                        [_imgViewProfile setImage:imgProfile];
                        [_imgViewProfile setFrame:CGRectMake(0,0,imgProfile.size.width,imgProfile.size.height)];
                        NSString *description = [NSString stringWithFormat:
                                                 @"%@\n%@", person.displayName,
                                                 person.aboutMe];

                    }
                }];


    }else{
        NSLog(@"Not Auth");
    }
}
-(void)generateGoods:( NSInteger *) local_id
              source:(NSInteger *) source
               token:(NSString *) token{
    VariableStore *vs=[VariableStore sharedInstance];
    NSString *url=[NSString stringWithFormat:@"http://%@/controller/mobile/member.aspx?action=get_goods&id=%D&source=%d&token=%@",vs.domain,local_id,source,token];
    NSString *strGoods=[Util stringWithUrl:url];
    

    vs.jsonGoods=strGoods;
}

-(void)goToGoodsList: (id)sender{
     VCGoodsList * goodsList= [self.storyboard instantiateViewControllerWithIdentifier:@"VCGoodsList"];
    UINavigationController * center=self.sidePanelController.centerPanel;
    [center pushViewController:goodsList animated:YES];
        center.topViewController.title=@"Goods";
    [self.sidePanelController showCenterPanelAnimated:YES];
    //[[self.sidePanelController rightPanel]    //[[center view] addSubview:lblDesc];
    
}


@end
