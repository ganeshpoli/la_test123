//
//  LAInternetConnErrController.h
//  LunchAddict
//
//  Created by SPEROWARE on 04/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestAPIVO.h"


@interface LAInternetConnErrController : UIViewController{
    
}

@property(strong, nonatomic) IBOutlet UIButton *btnTryReConnect;
@property(strong, nonatomic) IBOutlet UIButton *btnSupportEmail;

@property(strong, nonatomic) RestAPIVO *restApiVO;
@property(strong, nonatomic) NSString *strErrMsg;

-(IBAction)tryToReConnectBtnClicked:(id)sender;
-(IBAction)supportBtnClicked:(id)sender;

@property (nonatomic, assign) BOOL showStatusBar;

-(void) intializeParameters:(RestAPIVO *)restVO withErrorMsg:(NSString *)strMsg;

@end
