//
//  SettingsVO.h
//  LunchAddict
//
//  Created by SPEROWARE on 31/07/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsVO : NSObject
@property (assign, nonatomic) double lat;
@property (assign, nonatomic) double lng;
@property (assign, nonatomic) float zoomLevel;
@property (assign, nonatomic) int refreshCount;
@property (assign, nonatomic) int longrefreshlimit;
@property (assign, nonatomic) int popupappearseconds;
@property (assign, nonatomic) int popupdisappearseconds;
@property (assign, nonatomic) int loginvalidationcount;
@property (assign, nonatomic) int minimumdistance;
@property (assign, nonatomic) int maxdistance;
@property (assign, nonatomic) int beforelogin;
@property (assign, nonatomic) int afterlogin;
@property (strong, nonatomic) NSString  *ftaddedbymerchanticon;
@property (strong, nonatomic) NSString  *ftaddedbyconsumericon;
@property (assign, nonatomic) int ftlistmaxlimit;

@end
