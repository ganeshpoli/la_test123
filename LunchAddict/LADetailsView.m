//
//  LADetailsView.m
//  LunchAddict
//
//  Created by SPEROWARE on 11/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "LADetailsView.h"
#import "AppJsonConst.h"
#import "FdConfirmVO.h"
#import "AppDatabase.h"


@implementation LADetailsView

@synthesize btnHomeBack;
@synthesize btnRefresh;
@synthesize btnMyAccount;
@synthesize btnFoodTruckInfo;
@synthesize btnTwitterInfo;
@synthesize btnFacebookInfo;
@synthesize btnYelpInfo;
@synthesize btnWebInfo;
@synthesize btnSubmit;
@synthesize btnCancel;
@synthesize tableViewFacebook;
@synthesize tableViewTwitter;
@synthesize webViewYelp;
@synthesize webViewWebSite;
@synthesize headerMenuView;
@synthesize footerMenuView;
@synthesize detilsMenuView;
@synthesize activityindicatorView;
@synthesize numIndicator;
@synthesize detilsActionView;
//@synthesize intialload;
@synthesize isKeyBoardActive;
@synthesize detailsTextViewFrame;
@synthesize arrTweets;
@synthesize arrFBPosts;
@synthesize pendingOperations = _pendingOperations;
@synthesize clicktime;
@synthesize refreshcount;
@synthesize lblTitle;
@synthesize popupFtConfirmView;
@synthesize btnPopUpNoNoThere;
@synthesize btnPopUpYesItsThere;
@synthesize btnTryToConnectNow;
@synthesize viewInternetConn;
@synthesize noConnFailRestApiVO;
@synthesize isWebPageLoaded;
@synthesize isYelpPageLoaded;

- (PendingOperations *)pendingOperations {
    if (!_pendingOperations) {
        _pendingOperations = [[PendingOperations alloc] init];
    }
    return _pendingOperations;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)designView{
    
    self.clicktime = 0;
    self.refreshcount = 0;
    
    self.isYelpPageLoaded = NO;
    self.isWebPageLoaded  = NO;
    
    [self.viewInternetConn setHidden:YES];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint
                                      constraintWithItem:self.viewInternetConn
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self
                                      attribute:NSLayoutAttributeCenterX
                                      multiplier:1.0f
                                      constant:0.0f];
    
    [self addConstraint:constraint];
    
    constraint = [NSLayoutConstraint
                  constraintWithItem:self.viewInternetConn
                  attribute:NSLayoutAttributeCenterY
                  relatedBy:NSLayoutRelationEqual
                  toItem:self
                  attribute:NSLayoutAttributeCenterY
                  multiplier:1.0f
                  constant:0.0f];
    
    [self addConstraint:constraint];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardDidHideNotification object: nil];
    
    [self.activityindicatorView setHidden:YES];
    [self.tableViewFacebook setHidden:YES];
    [self.tableViewTwitter setHidden:YES];
    [self.webViewWebSite setHidden:YES];
    [self.webViewYelp setHidden:YES];
    [self.detailsTextView setHidden:YES];
    [self.detilsActionView setHidden:YES];
    [self.popupFtConfirmView setHidden:YES];
    
    self.webViewYelp.delegate = self;
    self.webViewWebSite.delegate = self;
    
    self.detailsTextView.delegate   = self;
    
    self.defaultTextViewFrame = self.detailsTextView.frame;
    
    self.detailsTextView.text   = self.foodTruckVO.description;
    self.lblTitle.text = self.foodTruckVO.name;
    
    
    [headerMenuView.layer setCornerRadius:10.0f];
    [headerMenuView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [headerMenuView.layer setBorderWidth:1.5f];
    
    [self.viewInternetConn.layer setCornerRadius:10.0f];
    [self.viewInternetConn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.viewInternetConn.layer setBorderWidth:1.5f];
    
    btnTryToConnectNow.layer.cornerRadius = 4;
    btnTryToConnectNow.layer.borderWidth = 1;
    btnTryToConnectNow.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    
    [popupFtConfirmView.layer setCornerRadius:10.0f];
    [popupFtConfirmView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [popupFtConfirmView.layer setBorderWidth:1.5f];
    
    [footerMenuView.layer setCornerRadius:10.0f];
    [footerMenuView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [footerMenuView.layer setBorderWidth:1.5f];
    
    [detilsMenuView.layer setCornerRadius:10.0f];
    [detilsMenuView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [detilsMenuView.layer setBorderWidth:1.5f];
    
//    btnHomeBack.layer.cornerRadius = 4;
//    btnHomeBack.layer.borderWidth = 1;
//    btnHomeBack.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    btnSubmit.layer.cornerRadius = 4;
    btnSubmit.layer.borderWidth = 1;
    btnSubmit.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    btnCancel.layer.cornerRadius = 4;
    btnCancel.layer.borderWidth = 1;
    btnCancel.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    btnPopUpYesItsThere.layer.cornerRadius = 4;
    btnPopUpYesItsThere.layer.borderWidth = 1;
    btnPopUpYesItsThere.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    btnPopUpNoNoThere.layer.cornerRadius = 4;
    btnPopUpNoNoThere.layer.borderWidth = 1;
    btnPopUpNoNoThere.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    self.tableViewFacebook.dataSource = self;
    self.tableViewTwitter.dataSource  = self;
    
    self.tableViewFacebook.delegate = self;
    self.tableViewTwitter.delegate  = self;
    
    self.numIndicator = [[NSNumber alloc] initWithInt:TRUCK_INFO_TAB];
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
    [vc.viewInternetConn setHidden:YES];
    
    appdelegte.FD_TRACK_ENABLED = NO;
    
    FdConfirmVO *fdConfirmVO    = [AppDatabase getFoodTruckFromLocationCache:self.foodTruckVO];
    
    if (fdConfirmVO != nil) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:APP_DB_DATE_FORMATE];
        NSDate *fdConfirmUpdateDate  = [df dateFromString:fdConfirmVO.updatedate];
        
        
        NSDate *date = [NSDate date];
        NSCalendar *calender = [NSCalendar currentCalendar];
        NSDateComponents *hourComponent = [calender components:NSCalendarUnitHour fromDate:fdConfirmUpdateDate toDate:date options:NSCalendarWrapComponents];
        
        NSLog(@"hour date component%@", hourComponent);
        
        //BETA-43
        
        if ([hourComponent hour] >= 24 && appdelegte.RECORDS_INDICATOR != nil &&
            [appdelegte.RECORDS_INDICATOR integerValue] == TRUCKS_RECORDS) {
            appdelegte.POP_UP_FT_SHOW_TIMER = [NSTimer scheduledTimerWithTimeInterval:POP_UP_CONFIRM_SHOW_DELAY target:self selector:@selector(showPopUp:) userInfo:nil repeats:NO];
            LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
            [vc startTrackFoodTruckLocation];
        }
        
        if ([APP_YES isEqualToString:fdConfirmVO.confirmation]) {
            appdelegte.POP_UP_FT_CONFIRM_NO     = NO;
            appdelegte.POP_UP_FT_CONFIRM_YES    = YES;
        }else if([APP_NO isEqualToString:fdConfirmVO.confirmation]){
            appdelegte.POP_UP_FT_CONFIRM_NO     = YES;
            appdelegte.POP_UP_FT_CONFIRM_YES    = NO;
        }
        
    }else{
        
        //BETA-43
        
        if (appdelegte.RECORDS_INDICATOR != nil &&
            [appdelegte.RECORDS_INDICATOR integerValue] == TRUCKS_RECORDS) {
            appdelegte.POP_UP_FT_SHOW_TIMER = [NSTimer scheduledTimerWithTimeInterval:POP_UP_CONFIRM_SHOW_DELAY target:self selector:@selector(showPopUp:) userInfo:nil repeats:NO];
            LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
            
            [vc startTrackFoodTruckLocation];
        }
        
        appdelegte.POP_UP_FT_CONFIRM_NO     = NO;
        appdelegte.POP_UP_FT_CONFIRM_YES    = NO;
    }
    
    
    [self showView];
}

-(IBAction)btnTryToCoonectNowClicked:(id)sender{
    [self.viewInternetConn setHidden:YES];
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
    
    [vc connectToInternet];
}

-(void)showPopUp:(id)obj{
    [self.popupFtConfirmView setHidden:NO];
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegte.POP_UP_FT_HIDE_TIMER = [NSTimer scheduledTimerWithTimeInterval:POP_UP_CONFIRM_HIDE_DELAY target:self selector:@selector(hidePopUp:) userInfo:nil repeats:NO];
}

-(void)hidePopUp:(id)obj{
    [self.popupFtConfirmView setHidden:YES];
}



-(IBAction)btnHomebackClicked:(id)sender{
    NSLog(@"Home btn back");
    [self.viewInternetConn setHidden:YES];
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
    
    [self clearFoodTruckDetailsSession];
    
    [vc homeBackAction];    
}

- (void) clearGpsTrackerAndTimer{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
    if (appdelegte.FD_TRACK_ENABLED) {
        appdelegte.FD_TRACK_ENABLED = NO;
        [vc stopTrackFoodTruckLocation];
    }
    
    if (appdelegte.POP_UP_FT_SHOW_TIMER != nil) {
        [appdelegte.POP_UP_FT_SHOW_TIMER invalidate];
        appdelegte.POP_UP_FT_SHOW_TIMER = nil;
    }
    
    if (appdelegte.POP_UP_FT_HIDE_TIMER != nil) {
        [appdelegte.POP_UP_FT_HIDE_TIMER invalidate];
        appdelegte.POP_UP_FT_HIDE_TIMER = nil;
    }
}


- (void) clearFoodTruckDetailsSession{
    [self clearGpsTrackerAndTimer];
    [self cancelAllOperations];
    [self setPendingOperations:nil];
    [self deregisterForKeyboardNotifications];
    self.isWebPageLoaded = NO;
    self.isYelpPageLoaded = NO;
}


-(IBAction)btnRefreshClicked:(id)sender{
    NSLog(@"Refresh btn back");
    [self.viewInternetConn setHidden:YES];
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
    appdelegte.ALERT_ACTION_INDICATOR = [self.numIndicator intValue];
    [vc detailsPageLongRefresh];
    
    
//    long long currentmilliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
//    
//    if (currentmilliseconds - clicktime <1000) {
//        refreshcount++;
//    }else{
//        refreshcount = 1;
//    }
//    
//    self.clicktime = currentmilliseconds;
//    
//    if (refreshcount >= appdelegte.settingsVO.longrefreshlimit) {
//        LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
//        appdelegte.ALERT_ACTION_INDICATOR = [self.numIndicator intValue];
//        [vc detailsPageLongRefresh];
//        
//    }else{
//        [self showView];
//    }
    
    
}
-(IBAction)btnMyAccountClicked:(id)sender{
    NSLog(@"MyAccount btn back");
    [self.viewInternetConn setHidden:YES];
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    LAViewController *vc = (LAViewController *)appdelegte.window.rootViewController;
    
    if (appdelegte.userVO != nil && appdelegte.userVO.twitterLogin && appdelegte.userVO.isMarchant) {
        [vc openDetailsMyAccountCheckInDialog];
    }else{
        [vc openDetailsMyAccountDialog];
    }
    
    
    
}
-(IBAction)btnFoodTruckInfoClicked:(id)sender{
    NSLog(@"FoodtruckInfo btn back");
    [self.viewInternetConn setHidden:YES];
    if ([self.numIndicator integerValue] == TRUCK_INFO_TAB) {
        return;
    }
    
    self.numIndicator = [[NSNumber alloc] initWithInt:TRUCK_INFO_TAB];
    [self showView];
}
-(IBAction)btnTwitterInfoClicked:(id)sender{
    NSLog(@"Twitter info btn back");
    [self.viewInternetConn setHidden:YES];
    if ([self.numIndicator integerValue] == TWITTER_INFO_TAB) {
        return;
    }
    
    [self cancelAllOperations];
    self.numIndicator = [[NSNumber alloc] initWithInt:TWITTER_INFO_TAB];
    [self showView];
}
-(IBAction)btnFacebookInfoClicked:(id)sender{
    NSLog(@"facebook info btn back");
    [self.viewInternetConn setHidden:YES];
    if ([self.numIndicator integerValue] == FACEBOOK_INFO_TAB) {
        return;
    }
    
    [self cancelAllOperations];
    self.numIndicator = [[NSNumber alloc] initWithInt:FACEBOOK_INFO_TAB];
    [self showView];
}
-(IBAction)btnYelpInfoClicked:(id)sender{
    NSLog(@"Yelp info btn back");
    [self.viewInternetConn setHidden:YES];
    if ([self.numIndicator integerValue] == YELP_INFO_TAB) {
        return;
    }
    
    
    self.numIndicator = [[NSNumber alloc] initWithInt:YELP_INFO_TAB];
    [self showView];
}
-(IBAction)btnWebInfoClicked:(id)sender{
    NSLog(@"web info btn back");
    [self.viewInternetConn setHidden:YES];
    if ([self.numIndicator integerValue] == WEB_INFO_TAB) {
        return;
    }
    
    self.numIndicator = [[NSNumber alloc] initWithInt:WEB_INFO_TAB];
    [self showView];
}
-(IBAction)btnSubmitClicked:(id)sender{
    [self.viewInternetConn setHidden:YES];
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
    self.foodTruckVO.description = self.detailsTextView.text;
    [vc updateFoodTruckLocation];
    
}
-(IBAction)btnCancelClicked:(id)sender{
    [self.viewInternetConn setHidden:YES];
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
    [vc homeBackAction];
}


-(IBAction)btnYesItisThereClicked:(id)sender{
    NSLog(@"Yes btn clicked");
    [self.viewInternetConn setHidden:YES];
    [self clearGpsTrackerAndTimer];
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
    [vc doFoodTruckConfirm:self.foodTruckVO withConfirm:YES];
    [self.popupFtConfirmView setHidden:YES];
}
-(IBAction)btnNoItisNotThereClicked:(id)sender{
    NSLog(@"No btn clicked");
    [self.viewInternetConn setHidden:YES];
    [self clearGpsTrackerAndTimer];
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
    [vc doFoodTruckConfirm:self.foodTruckVO withConfirm:NO];
    [self.popupFtConfirmView setHidden:YES];
}

-(void)showView{
    
    [self.activityindicatorView setHidden:NO];
    [self.activityindicatorView startAnimating];
    
    NSURLRequest *reqUrl = nil;
    
    switch ([self.numIndicator integerValue]) {
        case TRUCK_INFO_TAB:{
            [self.detailsTextView setText:self.foodTruckVO.description];
            [self.activityindicatorView setHidden:YES];
            [self.tableViewFacebook setHidden:YES];
            [self.tableViewTwitter setHidden:YES];
            [self.webViewWebSite setHidden:YES];
            [self.webViewYelp setHidden:YES];
            [self.detailsTextView setHidden:NO];
            [self.detilsActionView setHidden:YES];
            [self.activityindicatorView stopAnimating];
        }
            break;
            
        case TWITTER_INFO_TAB:{
            //[self cancelAllOperations];
            [self.activityindicatorView setHidden:YES];
            [self.tableViewFacebook setHidden:YES];
            [self.tableViewTwitter setHidden:NO];
            [self.webViewWebSite setHidden:YES];
            [self.webViewYelp setHidden:YES];
            [self.detailsTextView setHidden:YES];
            [self.detilsActionView setHidden:YES];
            [self.activityindicatorView stopAnimating];
            //[self.tableViewTwitter reloadData];
            if (self.arrTweets != nil && [self.arrTweets count] > 0) {
                [self.tableViewTwitter reloadData];
            }else{
                //call to methode
                LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
                LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
                [vc loadCacheTweets:JSON_TWITTER];
            }
        }
            break;
            
        case FACEBOOK_INFO_TAB:{
            //[self cancelAllOperations];
            [self.activityindicatorView setHidden:YES];
            [self.tableViewFacebook setHidden:NO];
            [self.tableViewTwitter setHidden:YES];
            [self.webViewWebSite setHidden:YES];
            [self.webViewYelp setHidden:YES];
            [self.detailsTextView setHidden:YES];
            [self.detilsActionView setHidden:YES];
            [self.activityindicatorView stopAnimating];
            //[self.tableViewFacebook reloadData];
            if (self.arrFBPosts != nil && [self.arrFBPosts count] > 0) {
                [self.tableViewFacebook reloadData];
            }else{
                //call to methode
                LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
                LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
                [vc loadCacheTweets:JSON_FACEBOOK];
            }
        }
            
            break;
            
        case YELP_INFO_TAB:{
            //self.intialload = YES;
            [self loadYelpSiteWebPage];
        }
            break;
            
        case WEB_INFO_TAB:{
            //self.intialload = YES;
            
            [self loadWebSiteWebPage];
        }
            break;
            
        default:
            break;
    }
}



- (void)loadYelpSiteWebPage{
    NSURLRequest *reqUrl = [self getYelpWebUrlRequestBasedOnString:self.foodTruckVO.yelpAddress];
    NSString *strYelpUrl = [[[self.webViewYelp request] URL] absoluteString];
    
    
    if (reqUrl != nil) {
        if (self.isYelpPageLoaded && self.foodTruckVO != nil && strYelpUrl != nil && self.foodTruckVO.yelpAddress != nil && [[strYelpUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0 && [strYelpUrl rangeOfString:self.foodTruckVO.yelpAddress].location != NSNotFound) {
            
            [self.tableViewFacebook setHidden:YES];
            [self.tableViewTwitter setHidden:YES];
            [self.webViewWebSite setHidden:YES];
            [self.webViewYelp setHidden:NO];
            [self.detailsTextView setHidden:YES];
            [self.detilsActionView setHidden:YES];
            
            [self.activityindicatorView setHidden:YES];
            [self.activityindicatorView stopAnimating];
            
        }else{
            
            [self.activityindicatorView setHidden:NO];
            [self.activityindicatorView startAnimating];
            
            [self.tableViewFacebook setHidden:YES];
            [self.tableViewTwitter setHidden:YES];
            [self.webViewWebSite setHidden:YES];
            [self.webViewYelp setHidden:YES];
            [self.detailsTextView setHidden:YES];
            [self.detilsActionView setHidden:YES];
            
            if (![self.webViewYelp isLoading]) {
                [self.webViewYelp loadRequest:reqUrl];
            }
            
            
        }
    }else{
         [self loadErrorPage:self.webViewYelp withMsg:@"Sorry, Yelp data is not available in the system"];
    }
    
    
    
    
}


- (void)loadWebSiteWebPage{
    NSURLRequest *reqUrl = [self getWebSiteUrlRequestBasedOnString:self.foodTruckVO.website];
    NSString *strWebUrl = [[[self.webViewWebSite request] URL] absoluteString];
    
     NSUInteger interger = [strWebUrl rangeOfString:self.foodTruckVO.website].location;
    
    if (reqUrl != nil) {
       // if (self.isWebPageLoaded && self.foodTruckVO != nil && strWebUrl != nil && self.foodTruckVO.website != nil && [[strWebUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0 && [strWebUrl rangeOfString:self.foodTruckVO.website].location != NSNotFound) {
            
            if (self.isWebPageLoaded && self.foodTruckVO != nil && strWebUrl != nil && self.foodTruckVO.website != nil && [[strWebUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
            
            [self.tableViewFacebook setHidden:YES];
            [self.tableViewTwitter setHidden:YES];
            [self.webViewWebSite setHidden:NO];
            [self.webViewYelp setHidden:YES];
            [self.detailsTextView setHidden:YES];
            [self.detilsActionView setHidden:YES];
            
            [self.activityindicatorView setHidden:YES];
            [self.activityindicatorView stopAnimating];
            
        }else{
            
            [self.tableViewFacebook setHidden:YES];
            [self.tableViewTwitter setHidden:YES];
            [self.webViewWebSite setHidden:YES];
            [self.webViewYelp setHidden:YES];
            [self.detailsTextView setHidden:YES];
            [self.detilsActionView setHidden:YES];
            
            [self.activityindicatorView setHidden:NO];
            [self.activityindicatorView startAnimating];
            
            if (![self.webViewWebSite isLoading]) {
                [self.webViewWebSite loadRequest:reqUrl];
            }
            
            //[self.webViewWebSite loadRequest:reqUrl];
        }
    }else{
        //NSLog(@"req url ===");
        [self loadErrorPage:self.webViewWebSite withMsg:@"Sorry, Website data is not available in the system"];
    }

    
    
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"web view stated");
    [webView endEditing:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"web view finish load");
    
    switch ([self.numIndicator integerValue]) {
        case WEB_INFO_TAB:{
            isWebPageLoaded = YES;
            
            [self.activityindicatorView setHidden:YES];
            [self.activityindicatorView stopAnimating];
            
            [self.webViewWebSite setHidden:NO];
            [self.tableViewFacebook setHidden:YES];
            [self.tableViewTwitter setHidden:YES];
            [self.webViewYelp setHidden:YES];
            [self.detailsTextView setHidden:YES];
            [self.detilsActionView setHidden:YES];
            
        }
            break;
            
        case YELP_INFO_TAB:{
            isYelpPageLoaded = YES;
            
            [self.activityindicatorView setHidden:YES];
            [self.activityindicatorView stopAnimating];
            
            [self.webViewWebSite setHidden:YES];
            [self.tableViewFacebook setHidden:YES];
            [self.tableViewTwitter setHidden:YES];
            [self.webViewYelp setHidden:NO];
            [self.detailsTextView setHidden:YES];
            [self.detilsActionView setHidden:YES];
        }
            break;
            
        default:{
        }
            break;
    }
    
    
    //intialload = NO;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    return ![self.detilsActionView isHidden];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"web view faild");
    
    switch ([self.numIndicator integerValue]) {
        case WEB_INFO_TAB:{
            [self.webViewWebSite setHidden:YES];
            [self.tableViewFacebook setHidden:YES];
            [self.tableViewTwitter setHidden:YES];
            [self.webViewYelp setHidden:YES];
            [self.detailsTextView setHidden:YES];
            [self.detilsActionView setHidden:YES];
            
            [self loadErrorPage:self.webViewWebSite withMsg:@"Sorry, Website data is not available in the system"];
            
        }
            break;
            
        case YELP_INFO_TAB:{
            [self.webViewWebSite setHidden:YES];
            [self.tableViewFacebook setHidden:YES];
            [self.tableViewTwitter setHidden:YES];
            [self.webViewYelp setHidden:YES];
            [self.detailsTextView setHidden:YES];
            [self.detilsActionView setHidden:YES];
            
            [self loadErrorPage:self.webViewYelp withMsg:@"Sorry, Yelp data is not available in the system"];
        }
            break;
            
        default:{
        }
            break;
    }
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    
//    if (intialload) {
//        return YES;
//    }
//    
//    return NO;
//}

-(NSURLRequest *)getYelpWebUrlRequestBasedOnString:(NSString *)strUrl{
    if(strUrl != nil && [[strUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0 ){
        
        strUrl = [strUrl lowercaseString];
//        if (![strUrl hasPrefix:HTTP_PROTOCAL]) {
//            strUrl = [YELIP_PROTOCAL stringByAppendingString:strUrl];
//            strUrl = [HTTP_PROTOCAL stringByAppendingString:strUrl];
//        }else{
//            strUrl = [strUrl stringByReplacingOccurrencesOfString:HTTP_PROTOCAL withString:@""];
//            strUrl = [YELIP_PROTOCAL stringByAppendingString:strUrl];
//            strUrl = [HTTP_PROTOCAL stringByAppendingString:strUrl];
//        }
        
        NSString *strURL = strUrl;
        NSURL *url = [NSURL URLWithString:strURL];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        return urlRequest;
    }else{
        return nil;
    }
}

-(NSURLRequest *)getWebSiteUrlRequestBasedOnString:(NSString *)strUrl{
    
    if(strUrl != nil && [[strUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0 ){
        
        strUrl = [strUrl lowercaseString];
//        if (![strUrl hasPrefix:HTTP_PROTOCAL]) {
//            strUrl = [HTTP_PROTOCAL stringByAppendingString:strUrl];
//        }
        
        NSString *strURL = strUrl;
        NSURL *url = [NSURL URLWithString:strURL];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        return urlRequest;
    }else{
        return nil;
    }
    
}

-(void)loadErrorPage:(UIWebView *)webView withMsg:(NSString *)strMsg{
    NSString *embedHTML = [NSString stringWithFormat: @"<html><head></head><body><center> %@ </center></body></html>", strMsg];
    
    webView.userInteractionEnabled = NO;
    webView.opaque = NO;
    webView.backgroundColor = [UIColor clearColor];
    [webView loadHTMLString: embedHTML baseURL: nil];
}

-(void) keyBoardWillShow:(NSNotification *) notification{
    //[self.webViewWebSite endEditing:YES];
    //[self.webViewYelp endEditing:YES];
}


-(void) keyBoardDidShow:(NSNotification *) notification{
    
    if(isKeyBoardActive){
        return;
    }
    
    NSDictionary *info  = [notification userInfo];
    
    NSValue *value  = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [self convertRect:[value CGRectValue] fromView:nil];
    
    CGRect viewFrame   = [self.detailsTextView frame];
    
    self.detailsTextViewFrame = viewFrame;
    
    viewFrame.size.height -= keyboardRect.size.height - viewFrame.origin.y-self.detilsMenuView.frame.origin.y;
    self.detailsTextView.frame    = viewFrame;
    
    isKeyBoardActive    = YES;
    
    
}

-(void) keyBoardDidHide:(NSNotification *) notifiaction{
    
    if(!isKeyBoardActive){
        return;
    }
    
    self.detailsTextView.frame   = self.detailsTextViewFrame;
    
    isKeyBoardActive = NO;
    
}

- (void)deregisterForKeyboardNotifications {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardDidHideNotification object:nil];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    switch ([self.numIndicator integerValue]) {
        case TWITTER_INFO_TAB:{
            return arrTweets.count;
        }
            
            
        case FACEBOOK_INFO_TAB:{
            return arrFBPosts.count;
        }
        
        default:
            return 0;
           
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch ([self.numIndicator integerValue]) {
        case TWITTER_INFO_TAB:{
            static NSString *CellIdentifier = @"twittercell";
            TwitterCell *cell = (TwitterCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:@"TwitterCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            TweetVO *tweetVO    = [self.arrTweets objectAtIndex:indexPath.row];
            
            cell.lablescreenname.text = [NSString stringWithFormat:@"@%@",tweetVO.screenName];
            cell.lablefromname.text = tweetVO.fromName;
            cell.lableMsg.text = tweetVO.message;
            cell.labledate.text = [AppUtil getTwitterDateString:tweetVO.createddate];
            
            if (tweetVO.retweeted) {
                [cell.lablereTweetedOwner setHidden:NO];
                [cell.lablereTweeted setHidden:NO];
                [cell.retweetedImgView setHidden:NO];
            }else{
                [cell.lablereTweetedOwner setHidden:YES];
                [cell.lablereTweeted setHidden:YES];
                [cell.retweetedImgView setHidden:YES];
            }
            
            cell.lablereTweetedOwner.text = tweetVO.fromName;
            
            if (tweetVO.hasImage) {
                cell.tweetImgView.image = tweetVO.image;
            }else if (tweetVO.isFailed) {
                cell.tweetImgView.image = [UIImage imageNamed:@"Placeholder.png"];
            }else {
                cell.tweetImgView.image = [UIImage imageNamed:@"Placeholder.png"];
                
            }
            
            if (!tableView.dragging && !tableView.decelerating) {
                [self startOperationsForTweetVO:tweetVO atIndexPath:indexPath];
            }
            
            return cell;
        }
            
            
        case FACEBOOK_INFO_TAB:{
            static NSString *CellIdentifier = @"facebookcell";
            FacebookCell *cell = (FacebookCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:@"FacebookCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            TweetVO *tweetVO    = [self.arrFBPosts objectAtIndex:indexPath.row];
            
            cell.lablefromname.text = tweetVO.fromName;
            cell.lableMsg.text = tweetVO.message;
            cell.labledate.text = [AppUtil getFacebookDateString:tweetVO.createddate];            
            
            if (tweetVO.hasImage) {
                cell.fbImgView.image = tweetVO.image;
            }else if (tweetVO.isFailed) {
                cell.fbImgView.image = [UIImage imageNamed:@"facebook32.png"];
            }else {
                cell.fbImgView.image = [UIImage imageNamed:@"Placeholder.png"];
                
            }
            
            if (!tableView.dragging && !tableView.decelerating) {
                [self startOperationsForTweetVO:tweetVO atIndexPath:indexPath];
            }
            
            return cell;
        }
            
            
        default:
            return nil;
            
    }
    
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch ([self.numIndicator integerValue]) {
        case TWITTER_INFO_TAB:{
            return 164;
        }
           
            
            
        case FACEBOOK_INFO_TAB:{
            return 191;
        }
            
            
            
        default:{
        }
            return 0;
            
    }
    
    
    
    
}


- (void)startOperationsForTweetVO:(TweetVO *)tweetVO atIndexPath:(NSIndexPath *)indexPath {
    
    if (!tweetVO.hasImage) {
        [self startImageDownloadingForTweetVO:tweetVO atIndexPath:indexPath];
        
    }
    
    if (!tweetVO.isFiltered) {
        //[self startImageFiltrationForTweetVO:tweetVO atIndexPath:indexPath];
    }
}


- (void)startImageDownloadingForTweetVO:(TweetVO *)tweetVO atIndexPath:(NSIndexPath *)indexPath {
    if (![self.pendingOperations.downloadsInProgress.allKeys containsObject:indexPath]) {
        ImageDownloader *imageDownloader = [[ImageDownloader alloc] initWithTweetRecord:tweetVO atIndexPath:indexPath delegate:self withProviderIndicator:self.numIndicator];
        [self.pendingOperations.downloadsInProgress setObject:imageDownloader forKey:indexPath];
        [self.pendingOperations.downloadQueue addOperation:imageDownloader];
    }
}


- (void)startImageFiltrationForTweetVO:(TweetVO *)tweetVO atIndexPath:(NSIndexPath *)indexPath {
    
    if (![self.pendingOperations.filtrationsInProgress.allKeys containsObject:indexPath]) {
        ImageFiltration *imageFiltration = [[ImageFiltration alloc] initWithTweetRecord:tweetVO atIndexPath:indexPath delegate:self withProviderIndicator:self.numIndicator];
        ImageDownloader *dependency = [self.pendingOperations.downloadsInProgress objectForKey:indexPath];
        if (dependency)
            [imageFiltration addDependency:dependency];
        [self.pendingOperations.filtrationsInProgress setObject:imageFiltration forKey:indexPath];
        [self.pendingOperations.filtrationQueue addOperation:imageFiltration];
    }
}


#pragma mark -
#pragma mark - ImageDownloader delegate


- (void)imageDownloaderDidFinish:(ImageDownloader *)downloader {
    NSIndexPath *indexPath = downloader.indexPathInTableView;
    TweetVO *tweetVO = downloader.tweetVO;
    
    switch ([downloader.numProviderIndicator integerValue]) {
        case TWITTER_INFO_TAB:{
            [self.arrTweets replaceObjectAtIndex:indexPath.row withObject:tweetVO];
            [self.tableViewTwitter reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
            
            
        case FACEBOOK_INFO_TAB:{
            [self.arrFBPosts replaceObjectAtIndex:indexPath.row withObject:tweetVO];
            [self.tableViewFacebook reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
            
            
        default:{
        }
            break;
            
    }
    
    [self.pendingOperations.downloadsInProgress removeObjectForKey:indexPath];
}


#pragma mark -
#pragma mark - ImageFiltration delegate


- (void)imageFiltrationDidFinish:(ImageFiltration *)filtration {
    NSIndexPath *indexPath = filtration.indexPathInTableView;
    TweetVO *tweetVO = filtration.tweetVO;
    
    switch ([filtration.numProviderIndicator integerValue]) {
        case TWITTER_INFO_TAB:{
            [self.arrTweets replaceObjectAtIndex:indexPath.row withObject:tweetVO];
            [self.tableViewTwitter reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
            
            
        case FACEBOOK_INFO_TAB:{
            [self.arrFBPosts replaceObjectAtIndex:indexPath.row withObject:tweetVO];
            [self.tableViewFacebook reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
            
            
        default:{
        }
            break;
            
    }
    
    [self.pendingOperations.filtrationsInProgress removeObjectForKey:indexPath];
}


#pragma mark -
#pragma mark - UIScrollView delegate


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self suspendAllOperations];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!decelerate) {
        switch ([self.numIndicator integerValue]) {
            case TWITTER_INFO_TAB:{
                [self loadImagesForOnscreenCellsTableView:self.tableViewTwitter withData:self.arrTweets];
            }
                break;
                
            case FACEBOOK_INFO_TAB:{
                [self loadImagesForOnscreenCellsTableView:self.tableViewFacebook withData:self.arrFBPosts];
            }
                break;
                
            default:
                break;
        }
        
        [self resumeAllOperations];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    switch ([self.numIndicator integerValue]) {
        case TWITTER_INFO_TAB:{
            [self loadImagesForOnscreenCellsTableView:self.tableViewTwitter withData:self.arrTweets];
        }
            break;
            
        case FACEBOOK_INFO_TAB:{
            [self loadImagesForOnscreenCellsTableView:self.tableViewFacebook withData:self.arrFBPosts];
        }
            break;
            
        default:
            break;
    }
    [self resumeAllOperations];
}



#pragma mark -
#pragma mark - Cancelling, suspending, resuming queues / operations


- (void)suspendAllOperations {
    [self.pendingOperations.downloadQueue setSuspended:YES];
    [self.pendingOperations.filtrationQueue setSuspended:YES];
}


- (void)resumeAllOperations {
    [self.pendingOperations.downloadQueue setSuspended:NO];
    [self.pendingOperations.filtrationQueue setSuspended:NO];
}


- (void)cancelAllOperations {
    [self.pendingOperations.downloadQueue cancelAllOperations];
    [self.pendingOperations.filtrationQueue cancelAllOperations];
    [self.pendingOperations.downloadsInProgress removeAllObjects];
    [self.pendingOperations.filtrationsInProgress removeAllObjects];
    
}


- (void)loadImagesForOnscreenCellsTableView:(UITableView *)tableView withData:(NSMutableArray *)array {
    
    
    NSSet *visibleRows = [NSSet setWithArray:[tableView indexPathsForVisibleRows]];
    
    
    NSMutableSet *pendingOperations = [NSMutableSet setWithArray:[self.pendingOperations.downloadsInProgress allKeys]];
    [pendingOperations addObjectsFromArray:[self.pendingOperations.filtrationsInProgress allKeys]];
    
    NSMutableSet *toBeCancelled = [pendingOperations mutableCopy];
    NSMutableSet *toBeStarted = [visibleRows mutableCopy];
    [toBeStarted minusSet:pendingOperations];
    [toBeCancelled minusSet:visibleRows];
    
    
    for (NSIndexPath *anIndexPath in toBeCancelled) {
        
        ImageDownloader *pendingDownload = [self.pendingOperations.downloadsInProgress objectForKey:anIndexPath];
        [pendingDownload cancel];
        [self.pendingOperations.downloadsInProgress removeObjectForKey:anIndexPath];
        
        ImageFiltration *pendingFiltration = [self.pendingOperations.filtrationsInProgress objectForKey:anIndexPath];
        [pendingFiltration cancel];
        [self.pendingOperations.filtrationsInProgress removeObjectForKey:anIndexPath];
    }
    toBeCancelled = nil;
    for (NSIndexPath *anIndexPath in toBeStarted) {
        
        TweetVO *tweetVO = [array objectAtIndex:anIndexPath.row];
        [self startOperationsForTweetVO:tweetVO atIndexPath:anIndexPath];
    }
    toBeStarted = nil;
    
}



- (void)dealloc{
    [self clearFoodTruckDetailsSession];
}




@end
