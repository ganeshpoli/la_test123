//
//  TwitterViewController.h
//  LunchAddict
//
//  Created by SPEROWARE on 20/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthConsumer.h"
#import "LAAppDelegate.h"
#import "MBProgressHUD.h"

@interface TwitterViewController : UIViewController <UIWebViewDelegate>{
    MBProgressHUD *hud;
}

@property (nonatomic, strong) IBOutlet UIWebView *webview;
@property (nonatomic, strong) OAToken *requestToken;

-(IBAction)cancelBtnClicked:(id)sender;

- (void)getAccountVerifyCredentials;

@end
