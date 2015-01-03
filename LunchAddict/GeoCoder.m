//
//  GeoCoder.m
//  LunchAddict
//
//  Created by SPEROWARE on 02/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "GeoCoder.h"
#import <AddressBookUI/AddressBookUI.h>

@implementation GeoCoder

@synthesize appGeoCoder;
@synthesize delegate;


- (id)init {
	self = [super init];
    
	if(self != nil) {
		self.appGeoCoder = [[CLGeocoder alloc] init];
	}
    
	return self;
}

- (void)getAddressFromLocation:(CLLocation *)location{
    [self.appGeoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //NSLog(@"Finding address");
        if (error) {
            //NSLog(@"Error %@", error.description);
            if([self.delegate conformsToProtocol:@protocol(GeoCoderDelegate)]) {
                [self.delegate addressFromLocationFailureCallback:error];
            }
            
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            if([self.delegate conformsToProtocol:@protocol(GeoCoderDelegate)]) {
                
                if (placemark.thoroughfare!=nil && placemark.locality !=nil) {
                    [self.delegate partialAddressFromLocationSuccessCallback:[NSString stringWithFormat:@"%@,%@",placemark.thoroughfare,placemark.locality]];
                }else if (placemark.thoroughfare != nil){
                    [self.delegate partialAddressFromLocationSuccessCallback:[NSString stringWithFormat:@"%@",placemark.thoroughfare]];
                }else if(placemark.locality != nil){
                    [self.delegate partialAddressFromLocationSuccessCallback:[NSString stringWithFormat:@"%@",placemark.locality]];
                }
                
                [self.delegate addressFromLocationSuccessCallback:[NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)]];
                
            }
            
        }
    }];
    
}

- (void)getLatLongFromAddress:(NSString *)strAddress{
    [self.appGeoCoder geocodeAddressString:strAddress completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            //NSLog(@"%@", error);
            if([self.delegate conformsToProtocol:@protocol(GeoCoderDelegate)]) {
                [self.delegate locationFromAddressFailureCallback:error];
            }
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            if([self.delegate conformsToProtocol:@protocol(GeoCoderDelegate)]) {
                [self.delegate locationFromAddressSuccessCallback:placemark.location];
            }
        }
    }];
    
}

@end
