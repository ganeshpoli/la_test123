//
//  GeoCoder.h
//  LunchAddict
//
//  Created by SPEROWARE on 02/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GeoCoder : NSObject
@property(strong, nonatomic) CLGeocoder *appGeoCoder;
@property (nonatomic, assign) id delegate;

- (void)getAddressFromLocation:(CLLocation *)location;

- (void)getLatLongFromAddress:(NSString *)strAddress;



@end

@protocol GeoCoderDelegate
@required
- (void)partialAddressFromLocationSuccessCallback:(NSString *)address;
- (void)addressFromLocationSuccessCallback:(NSString *)address;
- (void)addressFromLocationFailureCallback:(NSError *)error;
- (void)locationFromAddressSuccessCallback:(CLLocation *)location;
- (void)locationFromAddressFailureCallback:(NSError *)error;
@end
