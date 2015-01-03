//
//  MapWorker.h
//  LunchAddict
//
//  Created by SPEROWARE on 02/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "LAAppDelegate.h"


@interface MapWorker : NSObject

@property(strong, nonatomic) GMSMapView *mapView;
@property(assign, nonatomic) long fdMiles;
@property(strong, nonatomic) NSMutableArray *arrMarkers;


-(void) setDataOnMapView;
-(void) fitMarkers;


@end
