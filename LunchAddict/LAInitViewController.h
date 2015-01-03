//
//  LAInitViewController.h
//  LunchAddict
//
//  Created by SPEROWARE on 01/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "RestApiWorker.h"
#import "AppConstants.h"
#import "RestAPIConsts.h"
#import "RestAPIVO.h"
#import <MessageUI/MessageUI.h>
#import "MZFormSheetController.h"
#import "MZCustomTransition.h"
#import "MZFormSheetSegue.h"

@interface LAInitViewController : UIViewController <RestAPIWorkerDelegate,MFMailComposeViewControllerDelegate>{
    
    MBProgressHUD *hud;
    MFMailComposeViewController *mailComposer;
}

@property(strong, nonatomic) IBOutlet UIView *viewInternetConn;
@property(strong, nonatomic) IBOutlet UIButton *btnTryToConnectNow;

@property(strong, nonatomic) RestAPIVO *noConnFailRestApiVO;
@property(strong, nonatomic) RestAPIVO *failureRestApiVO;

-(void)startAppRegistering;
-(void)getAppSettings;

- (void)validateTwitterUserCredentials;

-(IBAction)btnTryToCoonectNowClicked:(id)sender;

-(void) sendMailTo:(NSString *)strEmailID withEmailSubject:(NSString *)strEmailSubject withMessageBody:(NSString *)strMsg;

-(void)trytoReconnect;

-(void)openLunchAddictServerDialog;

@end
