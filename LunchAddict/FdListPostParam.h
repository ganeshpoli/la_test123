//
//  FdListPostParam.h
//  LunchAddict
//
//  Created by SPEROWARE on 02/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FdListPostParam : NSObject

@property(strong, nonatomic) NSString *lat;
@property(strong, nonatomic) NSString *lng;
@property(strong, nonatomic) NSString *basedOn;
@property(strong, nonatomic) NSString *deviceId;
@property(strong, nonatomic) NSString *zoomLevel;

@end
