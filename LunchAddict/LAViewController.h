//
//  LAViewController.h
//  LunchAddict
//
//  Created by ramu chembeti on 29/07/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "GPSTracker.h"
#import "RestAPIVO.h"
#import "RestAPIConsts.h"
#import "RestApiWorker.h"
#import "MBProgressHUD.h"
#import "MapWorker.h"
#import "AddFoodTruckVO.h"
#import "GeoCoder.h"
#import <MessageUI/MessageUI.h>
#import "Service.h"


@interface LAViewController : UIViewController <GPSTrackerDelegate, RestAPIWorkerDelegate, GMSMapViewDelegate, GeoCoderDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, ServiceDelegate>{
    MBProgressHUD *hud;
    MFMailComposeViewController *mailComposer;
}


@property(strong, nonatomic) MBProgressHUD *hud;
@property(strong, nonatomic) IBOutlet GMSMapView *mapView;
@property(strong, nonatomic) IBOutlet UIView *superView;
@property(strong, nonatomic) IBOutlet UIView *menuView;

@property(strong, nonatomic) IBOutlet UIButton *truckListBtn;
@property(strong, nonatomic) IBOutlet UIButton *pinMeBtn;
@property(strong, nonatomic) IBOutlet UIButton *refreshBtn;
@property(strong, nonatomic) IBOutlet UIButton *myAccBtn;

@property(strong, nonatomic) NSMutableArray *arrFoodTrucks;

@property(strong, retain) GPSTracker *gpsTracker;

@property(strong, nonatomic) MapWorker *mapworker;

@property(strong, nonatomic) id socialNWDataObj;

@property(strong, nonatomic) NSNumber *numTwitterPostIndicator;

@property(strong, nonatomic) GeoCoder *geocoder;

@property(strong, nonatomic) AddFoodTruckVO *addFdVO;

@property(strong, nonatomic) NSString *strPartAddress;

@property(strong, nonatomic) RestAPIVO *failureRestApiVO;

@property(strong, nonatomic) IBOutlet UIView *detailsView;

@property(strong, nonatomic) IBOutlet UIView *viewInternetConn;

@property(strong, nonatomic) IBOutlet UIButton *btnTryToConnectNow;

@property(strong, nonatomic) RestAPIVO *noConnFailRestApiVO;

@property(strong, nonatomic) AddFoodTruckVO *resAddFoodTruckVO;

@property(assign, nonatomic) NSInteger checkinAction;

-(IBAction)btnTryToCoonectNowClicked:(id)sender;
-(IBAction)truckListBtnClicked:(id)sender;
-(IBAction)pinMeBtnClicked:(id)sender;
-(IBAction)refreshBtnClicked:(id)sender;
-(IBAction)myAccBtnClicked:(id)sender;

- (void)getFoodTruckDataBasedOnAddress:(CLLocation*)location;

- (void)getFoodTruckDataBasedOnGPS:(CLLocation*)location;

- (void)goToAddFoodTruckMoreDetails;

- (void)addFoodTruckDetailsToServer;

- (void)openAddFoodTruckDialog:(NSString *)strAddress withPartialAddress:(NSString *)strPartialAddress;

- (void)openMoreInfoDialogWithFoodTruckDetails:(FoodTruckVO *)fdVO;

- (void)getFoodTruckData;

- (void) sendMailTo:(NSString *)strEmailID withEmailSubject:(NSString *)strEmailSubject withMessageBody:(NSString *)strMsg;

- (void)trytoReconnect;

- (void)openLunchAddictServerDialog;

- (void)openRefreshDialog:(NSString *)strAddress;

- (void)showDetailsView:(FoodTruckVO *)fdVO;

- (void)homeBackAction;

- (void)loadCacheTweets:(NSString *)strProvider;

- (void)loadLiveTweets;

- (void)updateFoodTruckLocation;

- (void)detailsPageLongRefresh;

- (void)doFoodTruckConfirm:(FoodTruckVO *)fdVO withConfirm:(BOOL)bConfirm;

- (void)startTrackFoodTruckLocation;

- (void)stopTrackFoodTruckLocation;

- (void)calculateDistance:(CLLocation *)userCurrentlocation;

- (void)openHomeMyAccountDialog;

- (void)addFoodTruckBasedOnLocation:(CLLocationCoordinate2D)coordinate;

- (void)openTruckListDialog:(NSString *)strTitle withFoodTrucksList:(NSMutableArray *)fdlist;

- (void)showRecentFoodTruck;

- (void)openDetailsMyAccountDialog;

- (void)openTweetDialog;

-(void)postTweetUpdate:(NSString *)strmsg withindicator:(NSNumber *)indicator;

//- (void)getAccountVerifyCredentials;

- (void)isMerchantValidation:(SocialNetworkVO *)socialNetworkVO;

- (void)saveFacebookUserInfo;

- (void)openTokenStatusErrorDialog:(TokenCacheVO *)tokenCacheVO;

- (void)logToken:(SocialNetworkVO *)socialNetworkVO;

- (void) connectToInternet;

- (void)openMerchantSessionExpired:(NSString *)strMerchant;

//- (void)openCheckInFormDialog:(NSString *)strAddress withActionIndicator:(NSNumber *)numAction;

- (void)openCheckInFormDialog:(NSString *)strAddress withActionIndicator:(NSNumber *)numAction WithStreetAddress:(NSString *)strStreetAddress;

- (void)openCheckOutConfirmDialogWithTagObj:(CheckinoutVO *)checkinVO;;

- (void)openAutoCheckoutdialogWithTagObj:(CheckinoutVO *)checkinVO;

- (void)openAutoCheckinDialog;

- (void)submitCheckOutDetails:(FoodTruckVO *)foodTruckVO withTagObj:(CheckinoutVO *)checkinVO;

- (void)submitCheckINDetails:(FoodTruckVO *)foodTruckVO withTagObj:(CheckinoutVO *)checkinVO;

- (void)preOpenCheckinFormWithIndicator:(NSInteger)indicator;

- (void)openDetailsMyAccountCheckInDialog;

- (void)getOpenCloseDateTimes;

- (void)openSocialNetWorkShareDialogWithTitle:(NSString *)strTitle withIndicator:(NSNumber *)num withObj:(id)obj;

- (void) setMapIntialView;



@end
