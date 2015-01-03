//
//  GPSTracker.h
//  LunchAddict
//
//  Created by SPEROWARE on 01/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GPSTracker : NSObject <CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locMgr;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) int GPS_UPDATE;

@end

@protocol GPSTrackerDelegate
@required
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
@end
