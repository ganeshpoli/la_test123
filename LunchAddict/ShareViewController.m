//
//  ShareViewController.m
//  LunchAddict
//
//  Created by SPEROWARE on 28/11/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

@synthesize showStatusBar;
@synthesize btnNoMayBeLater;
@synthesize btnYesPostit;
@synthesize textFieldHashTags;
@synthesize textViewShareData;
@synthesize checkBoxGoogleMapsLink;
@synthesize checkBoxIncludeLunchAddict;
@synthesize obj;
@synthesize textFieldCurrent;
@synthesize textViewCurrent;
@synthesize scrollView;
@synthesize mainview;

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
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
    
    [textViewShareData.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [textViewShareData.layer setBorderWidth:2.0];    
    textViewShareData.layer.cornerRadius = 5;
    textViewShareData.clipsToBounds = YES;
    
    checkBoxGoogleMapsLink.titleLabel.text = @"Include Google Maps link";
    [checkBoxGoogleMapsLink setCheckAlignment:M13CheckboxAlignmentLeft];
    [checkBoxGoogleMapsLink setCheckState:M13CheckboxStateChecked];
    
    checkBoxIncludeLunchAddict.titleLabel.text = @"Include @lunchaddict";
    [checkBoxIncludeLunchAddict setCheckAlignment:M13CheckboxAlignmentLeft];
    [checkBoxIncludeLunchAddict setCheckState:M13CheckboxStateChecked];
    
    btnNoMayBeLater.layer.cornerRadius = 4;
    btnNoMayBeLater.layer.borderWidth = 1;
    btnNoMayBeLater.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    
    btnYesPostit.layer.cornerRadius = 4;
    btnYesPostit.layer.borderWidth = 1;
    btnYesPostit.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    
    CGRect newFrame = self.mainview.frame;
    self.scrollView.contentSize = newFrame.size;
    
    [self.scrollView setScrollEnabled:NO];
   
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
}

-(void) designView:(NSNumber *)indicator with:(id)dataobj{
    self.indicator = indicator;
    self.obj = dataobj;
    
    HashTagVO *hashTagVO = [AppDatabase getHastagDetails];
    
    switch ([self.indicator integerValue]) {
        case FACEBOOK_SHARE_ADDFOODTRUCK:{
            if (hashTagVO.loggedFacebookUser != nil && [[hashTagVO.loggedFacebookUser stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
                [self.textFieldHashTags setText:hashTagVO.loggedFacebookUser];
            }else{
                [self.textFieldHashTags setText:LOGGED_FACEBOOK_HASHTAG_USER];
            }
            
            if ([self.obj isMemberOfClass:[AddFoodTruckVO class]]) {
                AddFoodTruckVO *addFdVO = (AddFoodTruckVO *)self.obj;
                NSMutableString *stringMsg = [[NSMutableString alloc] init];
                
                [stringMsg appendString:[NSString stringWithFormat:ADD_FD_SOCIAL_SHARE_MSG,addFdVO.twitterHandler,addFdVO.partialAddress]];
                
                [textViewShareData setText:[stringMsg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            }
        }
            break;
            
        
        case FACEBOOK_SHARE_CHECKIN:{
            if (hashTagVO.loggedFacebookMar != nil && [[hashTagVO.loggedFacebookMar stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
                [self.textFieldHashTags setText:hashTagVO.loggedFacebookMar];
            }else{
                [self.textFieldHashTags setText:LOGGED_FACEBOOK_HASHTAG_MAR];
            }
            
            if ([self.obj isMemberOfClass:[CheckinoutVO class]]) {
                CheckinoutVO *checkInOutVO = (CheckinoutVO *)self.obj;
                
                NSMutableString *stringMsg = [[NSMutableString alloc] init];
                
                if (checkInOutVO.at!=nil && [[checkInOutVO.at stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
                    [stringMsg appendString:@"We will be at"];
                    [stringMsg appendString:@" "];
                    [stringMsg appendString:checkInOutVO.partiaAddress];
                    [stringMsg appendString:@" "];
                }
                
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:CHECK_IN_DATE_FORMATE];
                
                NSDate *now = [df dateFromString:[df stringFromDate:[NSDate date]]];
                NSDate *onDate = [df dateFromString:checkInOutVO.on];
                
                if ([onDate compare:now]== NSOrderedSame) {
                    [stringMsg appendString:@"today"];
                    [stringMsg appendString:@" "];
                }else{
                    [stringMsg appendString:checkInOutVO.on];
                    [stringMsg appendString:@" "];
                }
                
                [stringMsg appendString:checkInOutVO.from];
                [stringMsg appendString:@"-"];
                [stringMsg appendString:checkInOutVO.until];
                
                if ([[stringMsg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0){
                    textViewShareData.text = stringMsg;
                }
                
            }
        }
            break;
        case TWITTER_SHARE_ADDFOODTRUCK:{
            if (hashTagVO.loggedTwitterUser != nil && [[hashTagVO.loggedTwitterUser stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
                [self.textFieldHashTags setText:hashTagVO.loggedTwitterUser];
            }else{
                [self.textFieldHashTags setText:LOGGED_TWITTER_HASHTAG_USER];
            }
            
            if ([self.obj isMemberOfClass:[AddFoodTruckVO class]]) {
                AddFoodTruckVO *addFdVO = (AddFoodTruckVO *)self.obj;
                NSMutableString *stringMsg = [[NSMutableString alloc] init];
                
                [stringMsg appendString:[NSString stringWithFormat:ADD_FD_SOCIAL_SHARE_MSG,addFdVO.twitterHandler,addFdVO.partialAddress]];
                
                [textViewShareData setText:[stringMsg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            }
            
        }
            break;
        case TWITTER_SHARE_CHECKIN:{
            if (hashTagVO.loggedTwitterMar != nil && [[hashTagVO.loggedTwitterMar stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
                [self.textFieldHashTags setText:hashTagVO.loggedTwitterMar];
            }else{
                [self.textFieldHashTags setText:LOGGED_TWITTER_HASHTAG_MAR];
            }
            
            if ([self.obj isMemberOfClass:[CheckinoutVO class]]) {
                CheckinoutVO *checkInOutVO = (CheckinoutVO *)self.obj;
                
                NSMutableString *stringMsg = [[NSMutableString alloc] init];
                
                if (checkInOutVO.at!=nil && [[checkInOutVO.at stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
                    [stringMsg appendString:@"We will be at"];
                    [stringMsg appendString:@" "];
                    [stringMsg appendString:checkInOutVO.partiaAddress];
                    [stringMsg appendString:@" "];
                }
                
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:CHECK_IN_DATE_FORMATE];
                
                NSDate *now = [df dateFromString:[df stringFromDate:[NSDate date]]];
                NSDate *onDate = [df dateFromString:checkInOutVO.on];
                
                if ([onDate compare:now]== NSOrderedSame) {
                    [stringMsg appendString:@"today"];
                    [stringMsg appendString:@" "];
                }else{
                    [stringMsg appendString:checkInOutVO.on];
                    [stringMsg appendString:@" "];
                }
                
                [stringMsg appendString:checkInOutVO.from];
                [stringMsg appendString:@"-"];
                [stringMsg appendString:checkInOutVO.until];
                
                if ([[stringMsg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0){
                    textViewShareData.text = stringMsg;
                }
                
            }
        }
            break;
            
        default:
            break;
    }
    
    
    
    NSString *strMsg = [textViewShareData text];
    
    if(strMsg != nil && [[strMsg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] <= 0){
        
        [textViewShareData setTextColor:[UIColor lightGrayColor]];
        switch ([self.indicator integerValue]) {
                case FACEBOOK_SHARE_CHECKIN:{
                    textViewShareData.text  = CHECIN_SHARE_MSG;
                }
                    break;
                case FACEBOOK_SHARE_ADDFOODTRUCK:{
                    textViewShareData.text  = TODAY_FACEBOOK_ADD_FD_MSG1;
                }
                    break;
                case TWITTER_SHARE_CHECKIN:{
                    textViewShareData.text  = CHECIN_SHARE_MSG;
                }
                    break;
                case TWITTER_SHARE_ADDFOODTRUCK:{
                    textViewShareData.text  = TODAY_TWITTER_ADD_FD_MSG1;
                }
                    break;
                default:
                    break;
        }
        
    }
    
}

-(IBAction)btnYesPostitClicked:(id)sender{
    
    BOOL IS_TESTING = NO;
    
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
    
    NSNumber *shareindicator = self.indicator;
    
    NSString *strLocShareMsg = [textViewShareData.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strHashTags    = [textFieldHashTags.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
   
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:
//                                  HASH_TAG_REGULAR_EXP options:0 error:nil];
//    
//    NSMutableString *strtemp = [strHashTags mutableCopy];
//    NSMutableString *hasgTagBuilder = [[NSMutableString alloc] init];
//    
//    [regex replaceMatchesInString:strtemp options:0 range:NSMakeRange(0, [strHashTags length]) withTemplate:@","];
//    
//    NSArray *splitTempData = [strHashTags componentsSeparatedByString:@","];
//    
//    int j=0;
//    
//    for (int i=0; i<[splitTempData count]; i++) {
//        
//        NSString *str= [[splitTempData objectAtIndex:i] stringByReplacingOccurrencesOfString:@"#" withString:@""];
//        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
//        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//        if ([str length] > 0) {
//            if (j>0) {
//                [hasgTagBuilder appendString:@","];
//            }
//            
//            [hasgTagBuilder appendString:[NSString stringWithFormat:@"#%@",[str lowercaseString]]];
//                j++;
//            
//        }
//        
//    }
    
    
    strHashTags = [self getHastagsStr:strHashTags];
    
    if ([textViewShareData textColor]==[UIColor lightGrayColor]) {
        strLocShareMsg = @"";
    }
    
    if (strLocShareMsg == nil || [strLocShareMsg length] <= 0) {
        [self.navigationController.formSheetController.view makeToast:SHRE_MSG_NOT_EMPTY];
        return;
    }
    
    
    if (appdelegte.IS_ONLINE && appdelegte.userVO != nil) {
        
        NSMutableString *msgBuilder = [[NSMutableString alloc] init];
        
        [msgBuilder appendString:strLocShareMsg];
        [msgBuilder appendString:@" "];
        
        
        
        if ([strHashTags length] > 0) {
            
            NSArray *splitdata = [strHashTags componentsSeparatedByString:@" "];
            
            int k=0;
            
            for (int i=0; i<[splitdata count]; i++) {
                
                NSString *str = [[splitdata objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ([str length] > 0) {
                    if ([[str lowercaseString] rangeOfString:@"test_la"].location != NSNotFound) {
                        IS_TESTING = YES;
                        continue;
                    }
                        if (k>0) {
                            [msgBuilder appendString:@" "];
                        }
                        str= [str stringByReplacingOccurrencesOfString:@"#" withString:@""];
                        [msgBuilder appendString:[NSString stringWithFormat:@"#%@",[str lowercaseString]]];
                        k++;
                    
                }
                
            }
            
            
            
        }else{
            if (appdelegte.userVO.isMarchant) {
                switch ([shareindicator integerValue]) {
                    case FACEBOOK_SHARE_CHECKIN:
                    case FACEBOOK_SHARE_ADDFOODTRUCK:{
                        [msgBuilder appendString:LOGGED_FACEBOOK_HASHTAG_MAR];
                    }
                        break;
                    case TWITTER_SHARE_CHECKIN:
                    case TWITTER_SHARE_ADDFOODTRUCK:{
                        [msgBuilder appendString:LOGGED_TWITTER_HASHTAG_MAR];
                    }
                        break;
                    default:
                        break;
                }
            }else{
                switch ([shareindicator integerValue]) {
                    case FACEBOOK_SHARE_CHECKIN:
                    case FACEBOOK_SHARE_ADDFOODTRUCK:{
                        [msgBuilder appendString:LOGGED_FACEBOOK_HASHTAG_USER];
                    }
                        break;
                    case TWITTER_SHARE_CHECKIN:
                    case TWITTER_SHARE_ADDFOODTRUCK:{
                        [msgBuilder appendString:LOGGED_TWITTER_HASHTAG_USER];
                    }
                        break;
                    default:
                        break;
                }
                
            }
            
        }
        
        
        [msgBuilder appendString:@" "];
        [msgBuilder appendString:AT_RATE_OF_LUNCHADDICT];
        [msgBuilder appendString:@" "];
        
        
        switch ([self.indicator integerValue]) {
            case FACEBOOK_SHARE_ADDFOODTRUCK:{
                if ([self.obj isMemberOfClass:[AddFoodTruckVO class]]) {
                    AddFoodTruckVO *addFdVO = (AddFoodTruckVO *)self.obj;
                    
                    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                    
                    if (IS_TESTING) {
                        
                        NSString *strMsg = [[[NSString stringWithString:msgBuilder] stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"#" withString:@""];
                        
                        [params setValue:strMsg forKey:@"message"];
                    }else{
                        [params setValue:msgBuilder forKey:@"message"];
                    }
                    
                    if (self.checkBoxGoogleMapsLink.checkState == M13CheckboxStateChecked) {
                        
                        NSMutableString *googleMapslink = [[NSMutableString alloc] init];
                        [googleMapslink appendString:GOOGLE_MAP_LINKS];
                        [googleMapslink appendString:addFdVO.lat];
                        [googleMapslink appendString:@","];
                        [googleMapslink appendString:addFdVO.lng];
                        
                        [params setValue:googleMapslink forKey:@"link"];
                    }
                   
                    //facbook share
                    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
                        [AppUtil postMsgOnFacebookWall:params withIndicator:shareindicator];
                    }];
                    
                }
            }
                break;
                
                
            case FACEBOOK_SHARE_CHECKIN:{
                
                if ([self.obj isMemberOfClass:[CheckinoutVO class]]) {
                    CheckinoutVO *checkInOutVO = (CheckinoutVO *)self.obj;
                    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                    
                    if (IS_TESTING) {
                        
                        NSString *strMsg = [[[NSString stringWithString:msgBuilder] stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"#" withString:@""];
                        
                        [params setValue:strMsg forKey:@"message"];
                    }else{
                        [params setValue:msgBuilder forKey:@"message"];
                    }
                    
                    
                    if (self.checkBoxGoogleMapsLink.checkState == M13CheckboxStateChecked) {
                        
                        NSMutableString *googleMapslink = [[NSMutableString alloc] init];
                        [googleMapslink appendString:GOOGLE_MAP_LINKS];
                        [googleMapslink appendString:checkInOutVO.lat];
                        [googleMapslink appendString:@","];
                        [googleMapslink appendString:checkInOutVO.lng];
                        
                        [params setValue:googleMapslink forKey:@"link"];
                    }
                    
                    //facbook share
                    
                    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
                        [AppUtil postMsgOnFacebookWall:params withIndicator:shareindicator];
                    }];
                    
                }
            }
                break;
            case TWITTER_SHARE_ADDFOODTRUCK:{
               if ([self.obj isMemberOfClass:[AddFoodTruckVO class]]) {
                    AddFoodTruckVO *addFdVO = (AddFoodTruckVO *)self.obj;
                   
                   NSMutableString *twitterBuilder = [[NSMutableString alloc] init];
                   
                   if (IS_TESTING) {
                       NSString *strMsg = [[[NSString stringWithString:msgBuilder] stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"#" withString:@""];
                       
                       [twitterBuilder appendString:strMsg];
                       
                   }else{
                       NSString *strMsg = [NSString stringWithString:msgBuilder];
                       [twitterBuilder appendString:strMsg];
                   }
                   
                   
                   NSInteger length = [twitterBuilder length];
                   
                   if (self.checkBoxGoogleMapsLink.checkState == M13CheckboxStateChecked) {
                       length = length+GOOGLE_MAPS_LINKS_TWITTER_LENGTH;
                       [twitterBuilder appendString:GOOGLE_MAP_LINKS];
                       [twitterBuilder appendString:addFdVO.lat];
                       [twitterBuilder appendString:@","];
                       [twitterBuilder appendString:addFdVO.lng];
                   }
                   
                   
                   if (length <= 140 && [[twitterBuilder stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
                       
                       vc.socialNWDataObj = addFdVO;
                       
                       [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
                           
                           //NSLog(@"Add Food truck Tweet msg=%@", twitterBuilder);
                           
                           [vc postTweetUpdate:twitterBuilder withindicator:[[NSNumber alloc] initWithInteger:TWITTER_SHARE_ADDFOODTRUCK]];
                       }];
                       
                   }else{
                       [self.navigationController.formSheetController.view makeToast:[NSString stringWithFormat:TWEET_MSG_EXCEED_LIMIT,(length-140)]];
                       return;
                   }
                   
                }
            }
                break;
            case TWITTER_SHARE_CHECKIN:{
                if ([self.obj isMemberOfClass:[CheckinoutVO class]]) {
                    CheckinoutVO *checkInOutVO = (CheckinoutVO *)self.obj;
                    
                    NSMutableString *twitterBuilder = [[NSMutableString alloc] init];
                    
                    if (IS_TESTING) {
                        NSString *strMsg = [[[NSString stringWithString:msgBuilder] stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"#" withString:@""];
                        
                        [twitterBuilder appendString:strMsg];
                    }else{
                        NSString *strMsg = [NSString stringWithString:msgBuilder];
                        [twitterBuilder appendString:strMsg];
                    }
                    
                    
                    NSInteger length = [twitterBuilder length];
                    
                    if (self.checkBoxGoogleMapsLink.checkState == M13CheckboxStateChecked) {
                        length = length+GOOGLE_MAPS_LINKS_TWITTER_LENGTH;
                        [twitterBuilder appendString:GOOGLE_MAP_LINKS];
                        [twitterBuilder appendString:checkInOutVO.lat];
                        [twitterBuilder appendString:@","];
                        [twitterBuilder appendString:checkInOutVO.lng];
                    }
                    
                    
                    if (length <= 140 && [[twitterBuilder stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
                        
                        vc.socialNWDataObj = checkInOutVO;
                        
                        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
                            //NSLog(@"checkin Food truck Tweet msg=%@", twitterBuilder);
                            [vc postTweetUpdate:twitterBuilder withindicator:[[NSNumber alloc] initWithInteger:TWITTER_SHARE_CHECKIN]];
                        }];
                        
                    }else{
                        [self.navigationController.formSheetController.view makeToast:[NSString stringWithFormat:TWEET_MSG_EXCEED_LIMIT,(length-140)]];
                        return;
                    }
                }
            }
                break;
                
            default:
                break;
        }
        
        [AppUtil updateHashTags:strHashTags withIndicator:[shareindicator integerValue]];
        
    }    
}
-(IBAction)btnNoMayBeLaterClicked:(id)sender{
    
    
    NSNumber *shareindicator = self.indicator;
    id shareDataObj  = self.obj;
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
        LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
        LAViewController *vc    = (LAViewController *)appdelegte.window.rootViewController;
        
        switch ([shareindicator integerValue]) {
            case FACEBOOK_SHARE_ADDFOODTRUCK:{
                if (vc.mapView != nil) {
                    [vc getFoodTruckData];
                }
            }
                break;
                
            case TWITTER_SHARE_ADDFOODTRUCK:{
                if (appdelegte.userVO != nil && appdelegte.userVO.facebookLogin) {
                    
                    //Comment facebook share code due to facebook permission denied
                    
//                    [vc openSocialNetWorkShareDialogWithTitle:SHARE_FACEBOOK_TITLE withIndicator:[[NSNumber alloc] initWithInteger:FACEBOOK_SHARE_ADDFOODTRUCK] withObj:shareDataObj];
                    
                    if (vc.mapView != nil) {
                        [vc getFoodTruckData];
                    }
                    
                }else{
                    if (vc.mapView != nil) {
                        [vc getFoodTruckData];
                    }
                }
            }
                break;
                
            case FACEBOOK_SHARE_CHECKIN:{
                [AppUtil loadMapIntialView];
            }
                break;
                
            case TWITTER_SHARE_CHECKIN:{
                if (appdelegte.userVO != nil && appdelegte.userVO.facebookLogin) {
                    //Comment facebook share code due to facebook permission denied
//                    [vc openSocialNetWorkShareDialogWithTitle:SHARE_FACEBOOK_TITLE withIndicator:[[NSNumber alloc] initWithInteger:FACEBOOK_SHARE_CHECKIN] withObj:shareDataObj];
                    
                    [AppUtil loadMapIntialView];
                    
                }else{
                    [AppUtil loadMapIntialView];
                }
            }
                break;
                
            default:
                break;
        }
        
    }];
}

-(IBAction)checkBoxGoogleMapsLinkClicked:(id)sender{
    //NSLog(@"Google links clicked");
    
}
-(IBAction)checkBoxIncludeLunchAddictClicked:(id)sender{
    //NSLog(@"include lunch addict clicked");
    [checkBoxIncludeLunchAddict setCheckState:M13CheckboxStateChecked];
    [self.navigationController.formSheetController.view makeToast:UNCHECK_AT_RATE_LUNCH_ADDICT_HANDLE];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    //NSLog(@"textfield did end editting");
    
    [textField setText:[self getHastagsStr:textField.text]];
    
    textFieldCurrent    = nil;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //NSLog(@"textfield did begin editting");
    textFieldCurrent = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  NO;
}



- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if([[textViewCurrent.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:EMPTY_STRING]){
        
        [textViewCurrent setTextColor:[UIColor lightGrayColor]];
        
        if ([textViewCurrent isEqual:textViewShareData]) {
            
            
            switch ([self.indicator integerValue]) {
                case FACEBOOK_SHARE_CHECKIN:{
                     textViewCurrent.text  = CHECIN_SHARE_MSG;
                }
                    break;
                case FACEBOOK_SHARE_ADDFOODTRUCK:{
                    textViewCurrent.text  = TODAY_FACEBOOK_ADD_FD_MSG1;
                }
                    break;
                case TWITTER_SHARE_CHECKIN:{
                     textViewCurrent.text  = CHECIN_SHARE_MSG;
                }
                    break;
                case TWITTER_SHARE_ADDFOODTRUCK:{
                     textViewCurrent.text  = TODAY_TWITTER_ADD_FD_MSG1;
                }
                    break;
                default:
                    break;
            }
            
           
        }
        
    }
    
    textViewCurrent = nil;
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    textViewCurrent = textView;
    
    if ([textViewShareData textColor]==[UIColor lightGrayColor]) {
        textViewCurrent.text   = EMPTY_STRING;
        
        [textViewCurrent setTextColor:[UIColor blackColor]];
    }
    
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    
    if([text isEqualToString:@"\n"]){
        
        [textViewCurrent resignFirstResponder];
        
        if ([textView.text isEqualToString:EMPTY_STRING]) {
            
            [textView setTextColor:[UIColor lightGrayColor]];
            
            if ([textView isEqual:self.textViewShareData]) {
                
                switch ([self.indicator integerValue]) {
                    case FACEBOOK_SHARE_CHECKIN:{
                        textViewCurrent.text  = CHECIN_SHARE_MSG;
                    }
                        break;
                    case FACEBOOK_SHARE_ADDFOODTRUCK:{
                        textViewCurrent.text  = TODAY_FACEBOOK_ADD_FD_MSG1;
                    }
                        break;
                    case TWITTER_SHARE_CHECKIN:{
                        textViewCurrent.text  = CHECIN_SHARE_MSG;
                    }
                        break;
                    case TWITTER_SHARE_ADDFOODTRUCK:{
                        textViewCurrent.text  = TODAY_TWITTER_ADD_FD_MSG1;
                    }
                        break;
                    default:
                        break;
                }
                
            }
            
        }
        
    }
    
    return YES;
    
}


-(NSString *)getHastagsStr:(NSString *)str{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSNumber *shareindicator = self.indicator;
    
    if (str != nil && [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
        
        str = [str stringByReplacingOccurrencesOfString:@"#" withString:@" "];
        
        NSArray *splitdata = [str componentsSeparatedByString:@" "];
        NSMutableString *hasgTagBuilder = [[NSMutableString alloc] init];
        [hasgTagBuilder appendString:@" "];
        
        if ([splitdata count] > 0) {
            for (int i=0; i< [splitdata count]; i++) {
                
                NSString *tempStr = [[[splitdata objectAtIndex:i] stringByReplacingOccurrencesOfString:@"#" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                if([tempStr length] > 0){
                    [hasgTagBuilder appendString:[NSString stringWithFormat:@"#%@",tempStr]];
                    [hasgTagBuilder appendString:@" "];
                }
            }
        }
        
        
        return [hasgTagBuilder stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
    }else{
        if (appdelegte.userVO.isMarchant) {
            switch ([shareindicator integerValue]) {
                case FACEBOOK_SHARE_CHECKIN:
                case FACEBOOK_SHARE_ADDFOODTRUCK:{
                    return LOGGED_FACEBOOK_HASHTAG_MAR;
                }
                    
                case TWITTER_SHARE_CHECKIN:
                case TWITTER_SHARE_ADDFOODTRUCK:{
                    return LOGGED_TWITTER_HASHTAG_MAR;
                }
                    
                default:
                    return @"";
            }
        }else{
            switch ([shareindicator integerValue]) {
                case FACEBOOK_SHARE_CHECKIN:
                case FACEBOOK_SHARE_ADDFOODTRUCK:{
                    return LOGGED_FACEBOOK_HASHTAG_USER;
                }
                    break;
                case TWITTER_SHARE_CHECKIN:
                case TWITTER_SHARE_ADDFOODTRUCK:{
                    return LOGGED_TWITTER_HASHTAG_USER;
                }
                    break;
                default:
                   return @"";
            }
            
        }
    }
   
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
