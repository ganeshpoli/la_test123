//
//  LADetailsView.h
//  LunchAddict
//
//  Created by SPEROWARE on 11/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodTruckVO.h"
#import "AppConstants.h"
#import "LAAppDelegate.h"
#import "PendingOperations.h"
#import "ImageDownloader.h"
#import "ImageFiltration.h"
#import "LAViewController.h"
#import "FacebookCell.h"
#import "TwitterCell.h"
#import "TweetVO.h"
#import "AppUtil.h"

@interface LADetailsView : UIView <UIWebViewDelegate, UITextViewDelegate, UITableViewDataSource , UITableViewDelegate, ImageDownloaderDelegate, ImageFiltrationDelegate>


@property(strong, nonatomic) IBOutlet UIView *view;

@property(strong, nonatomic) IBOutlet UIButton *btnHomeBack;
@property(strong, nonatomic) IBOutlet UIButton *btnRefresh;
@property(strong, nonatomic) IBOutlet UIButton *btnMyAccount;
@property(strong, nonatomic) IBOutlet UIButton *btnFoodTruckInfo;
@property(strong, nonatomic) IBOutlet UIButton *btnTwitterInfo;
@property(strong, nonatomic) IBOutlet UIButton *btnFacebookInfo;
@property(strong, nonatomic) IBOutlet UIButton *btnYelpInfo;
@property(strong, nonatomic) IBOutlet UIButton *btnWebInfo;
@property(strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property(strong, nonatomic) IBOutlet UIButton *btnCancel;

@property(strong, nonatomic) IBOutlet UIButton *btnPopUpYesItsThere;
@property(strong, nonatomic) IBOutlet UIButton *btnPopUpNoNoThere;

@property(strong, nonatomic) IBOutlet UILabel *lblTitle;

@property(strong, nonatomic) IBOutlet UITableView *tableViewFacebook;
@property(strong, nonatomic) IBOutlet UITableView *tableViewTwitter;

@property(strong, nonatomic) IBOutlet UIWebView *webViewYelp;
@property(strong, nonatomic) IBOutlet UIWebView *webViewWebSite;

@property(strong, nonatomic) IBOutlet UITextView *detailsTextView;

@property(strong, nonatomic) IBOutlet UIView *headerMenuView;
@property(strong, nonatomic) IBOutlet UIView *footerMenuView;
@property(strong, nonatomic) IBOutlet UIView *detilsMenuView;
@property(strong, nonatomic) IBOutlet UIView *detilsActionView;
@property(strong, nonatomic) IBOutlet UIView *popupFtConfirmView;


//@property(assign, nonatomic) BOOL intialload;
@property(assign, nonatomic) BOOL isKeyBoardActive;


@property(strong, nonatomic) IBOutlet UIActivityIndicatorView *activityindicatorView;

@property(strong, nonatomic) NSNumber *numIndicator;

@property(assign, nonatomic) BOOL isWebPageLoaded;
@property(assign, nonatomic) BOOL isYelpPageLoaded;



-(IBAction)btnHomebackClicked:(id)sender;
-(IBAction)btnRefreshClicked:(id)sender;
-(IBAction)btnMyAccountClicked:(id)sender;
-(IBAction)btnFoodTruckInfoClicked:(id)sender;
-(IBAction)btnTwitterInfoClicked:(id)sender;
-(IBAction)btnFacebookInfoClicked:(id)sender;
-(IBAction)btnYelpInfoClicked:(id)sender;
-(IBAction)btnWebInfoClicked:(id)sender;
-(IBAction)btnSubmitClicked:(id)sender;
-(IBAction)btnCancelClicked:(id)sender;

-(IBAction)btnYesItisThereClicked:(id)sender;
-(IBAction)btnNoItisNotThereClicked:(id)sender;

@property(strong,nonatomic) FoodTruckVO *foodTruckVO;

@property(assign,nonatomic) long long clicktime;

@property(assign,nonatomic) long refreshcount;

-(void) designView;

-(void)showView;

-(NSURLRequest *)getWebSiteUrlRequestBasedOnString:(NSString *)strUrl;

-(NSURLRequest *)getYelpWebUrlRequestBasedOnString:(NSString *)strUrl;

@property(assign, nonatomic) CGRect detailsTextViewFrame;
@property(assign, nonatomic) CGRect defaultTextViewFrame;


@property(strong, nonatomic) NSMutableArray *arrTweets;
@property(strong, nonatomic) NSMutableArray *arrFBPosts;

@property (nonatomic, strong) PendingOperations *pendingOperations;

-(void)showPopUp:(id)obj;
-(void)hidePopUp:(id)obj;

-(void)loadErrorPage:(UIWebView *)webView withMsg:(NSString *)strMsg;


@property(strong, nonatomic) IBOutlet UIView *viewInternetConn;

@property(strong, nonatomic) IBOutlet UIButton *btnTryToConnectNow;

@property(strong, nonatomic) RestAPIVO *noConnFailRestApiVO;

-(IBAction)btnTryToCoonectNowClicked:(id)sender;

-(void) clearFoodTruckDetailsSession;

- (void)loadYelpSiteWebPage;
- (void)loadWebSiteWebPage;

@end
