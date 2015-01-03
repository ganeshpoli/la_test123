//
//  LAMoreInfoViewController.h
//  LunchAddict
//
//  Created by SPEROWARE on 03/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodTruckVO.h"
#import "AddFoodTruckVO.h"


@interface LAMoreInfoViewController : UIViewController<UITextFieldDelegate>
@property(strong, nonatomic) IBOutlet UITextField *textFieldName;
@property(strong, nonatomic) IBOutlet UITextField *textFieldFacebook;
@property(strong, nonatomic) IBOutlet UITextField *textFieldWebsite;

@property(strong, nonatomic) IBOutlet UITextField *textFieldCurrent;

@property(strong, nonatomic) IBOutlet UIButton *btnOk;
@property(strong, nonatomic) IBOutlet UIButton *btnCancel;

-(IBAction)okBtnClicked:(id)sender;
-(IBAction)cancelBtnClicked:(id)sender;

@property (nonatomic, assign) BOOL showStatusBar;

@property(strong, nonatomic) FoodTruckVO *foodTruckVO;
@property(strong, nonatomic) AddFoodTruckVO *addFdVO;

- (void)intilizeparameters:(AddFoodTruckVO *)addVO withFoodTruckDetails:(FoodTruckVO *)fdVO;

@end
