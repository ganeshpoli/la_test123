//
//  MapWorker.m
//  LunchAddict
//
//  Created by SPEROWARE on 02/08/14.
//  Copyright (c) 2014 lunchaddict. All rights reserved.
//

#import "MapWorker.h"
#import "AppUtil.h"
#import "AppMsg.h"
#import "FoodTruckVO.h"


@implementation MapWorker

@synthesize mapView;
@synthesize fdMiles;
@synthesize arrMarkers;


-(void) setDataOnMapView{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appdelegte.FOOD_TRUCK_MARKERS != nil) {
        
        [self.mapView clear];
        
        appdelegte.USER_MARKER.map = self.mapView;
        
        [appdelegte.FOOD_TRUCK_MARKERS removeAllObjects];
        self.arrMarkers = [[NSMutableArray alloc] init];
        
        if([appdelegte.FOOD_TRUCK_LIST count] > 0){
            
            for(FoodTruckVO *foodTruckVO in appdelegte.FOOD_TRUCK_LIST){
                CLLocationCoordinate2D location    = CLLocationCoordinate2DMake([foodTruckVO.lat doubleValue], [foodTruckVO.lng doubleValue]);
                GMSMarker *marker = [GMSMarker markerWithPosition:location];
                marker.icon = [AppUtil getFoodTruckStatusIcon:foodTruckVO.icon];
                marker.title    = [NSString stringWithFormat:@"%@%@",foodTruckVO.foodtruckid,foodTruckVO.locationid];
                marker.map  = self.mapView;
                foodTruckVO.marker  = marker;
                [appdelegte.FOOD_TRUCK_MARKERS setValue:foodTruckVO forKey:[NSString stringWithFormat:@"%@%@",foodTruckVO.foodtruckid,foodTruckVO.locationid]];
                
                if ([appdelegte.FOOD_TRUCK_LIST indexOfObject:foodTruckVO] < 10) {
                    self.fdMiles = [foodTruckVO.distance longValue];
                    [self.arrMarkers addObject:marker];
                }
            }
            
            
           // NSLog(@"Distance miles disatnce %ld",self.fdMiles);
            
            [self fitMarkers];
            
            
        }else{
            
            [AppUtil openErrorDialog:Sorry_MSG withmsg:NO_FOODTRUCK_MSG withdelegate:self];
        }
        
    }
    
    
    
}


- (void)fitMarkers{
    LAAppDelegate *appdelegte   = (LAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSArray* markers = self.arrMarkers;
    
    GMSCoordinateBounds *markerBounds = [[GMSCoordinateBounds alloc] init];
    for (GMSMarker *marker in markers)
    {
        markerBounds = [markerBounds includingCoordinate:marker.position];
    }
    
    //markerBounds = [markerBounds includingCoordinate:appdelegte.PREV_FOOD_TRUCK_LOCATION];
    
    //[self.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:markerBounds withPadding:30.0f]];
    
    CGPoint markerBoundsTopLeft = [self.mapView.projection pointForCoordinate:CLLocationCoordinate2DMake(markerBounds.northEast.latitude, markerBounds.southWest.longitude)];
    CGPoint markerBoundsBottomRight = [self.mapView.projection pointForCoordinate:CLLocationCoordinate2DMake(markerBounds.southWest.latitude, markerBounds.northEast.longitude)];
    
    
    CGPoint currentLocation = [self.mapView.projection pointForCoordinate:appdelegte.PREV_FOOD_TRUCK_LOCATION];
    
    CGPoint markerBoundsCurrentLocationMaxDelta = CGPointMake(MAX(fabs(currentLocation.x - markerBoundsTopLeft.x), fabs(currentLocation.x - markerBoundsBottomRight.x)), MAX(fabs(currentLocation.y - markerBoundsTopLeft.y), fabs(currentLocation.y - markerBoundsBottomRight.y)));
    
    
    CGSize centeredMarkerBoundsSize = CGSizeMake(2.0 * markerBoundsCurrentLocationMaxDelta.x, 2.0 * markerBoundsCurrentLocationMaxDelta.y);
    
    
    CGSize insetViewBoundsSize = CGSizeMake(self.mapView.bounds.size.width - 60 / 2.0 - 1, self.mapView.bounds.size.height - 69 / 2.0 - 1);
    
    CGFloat x1;
    CGFloat x2;
    
    
    if (centeredMarkerBoundsSize.width / centeredMarkerBoundsSize.height > insetViewBoundsSize.width / insetViewBoundsSize.height)
    {
        x1 = centeredMarkerBoundsSize.width;
        x2 = insetViewBoundsSize.width;
    }
    else
    {
        x1 = centeredMarkerBoundsSize.height;
        x2 = insetViewBoundsSize.height;
    }
    
    CGFloat zoom = log2(x2 * pow(2, self.mapView.camera.zoom) / x1);
    
    GMSCameraPosition* camera = [GMSCameraPosition cameraWithTarget:appdelegte.PREV_FOOD_TRUCK_LOCATION zoom:zoom];
    
    appdelegte.mapAnimated = YES;
    
    [self.mapView animateToCameraPosition:camera];
    
    [self.arrMarkers removeAllObjects];
}



@end
