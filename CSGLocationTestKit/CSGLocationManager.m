//
//  CSLocationManager.m
//  CSLocationTestKit
//
//  Created by rachel parsons on 1/30/13.
//  Copyright (c) 2013 Cardinal Solutions. All rights reserved.
//

#import "CSGLocationManager.h"

@interface CSGLocationManager(){
    BOOL _locationFound;
}

@property (strong, nonatomic) NSTimer *trackingTimer;
@property (strong, nonatomic) CLRegion *currentRegion;

@end

@implementation CSGLocationManager

+(CSGLocationManager*)sharedInstance{
	
	static CSGLocationManager *_sharedInstance = nil;
	static dispatch_once_t oncePredicate;
	
	dispatch_once(&oncePredicate, ^{
		_sharedInstance = [[CSGLocationManager alloc] init];
	});
	
	return _sharedInstance;
}

-(id)init{
    self = [super init];

    if(self){
		[self verifyLocationServicesPermissions];
    }

    return self;
}

-(void)verifyLocationServicesPermissions{
	BOOL enabled = CLLocationManager.locationServicesEnabled;
	if (enabled) {
		_locationManager = [[CLLocationManager alloc] init];
		
		_locationManager.delegate = self;
		_locationManager.distanceFilter = _distance ? _distance : 10;
		_locationManager.desiredAccuracy = _accuracy ? _accuracy : kCLLocationAccuracyBest;
		
		_trackingTime = 10;
		return;
	}else{
		[self.locationManager requestAlwaysAuthorization];
		[self.locationManager requestWhenInUseAuthorization];
	}
}

-(void)startLocationTracking{
	
	
    self.locationManager.distanceFilter = self.distance;
    self.locationManager.desiredAccuracy = self.accuracy;

    [self.locationManager startUpdatingLocation];
    self.trackingTimer = [NSTimer scheduledTimerWithTimeInterval:self.trackingTime target:self selector:@selector(stopLocationTracking) userInfo:nil repeats:NO];
}

-(void)stopLocationTracking{
    [self.locationManager stopUpdatingLocation];
    [self.trackingTimer invalidate];

    if(!_locationFound)
	    [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_TRACKING_STOPPED object:nil userInfo:nil];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    [self locationDidUpdateToNewLocation:newLocation fromLocation:oldLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self locationDidUpdateToNewLocation:locations[locations.count-1] fromLocation:nil];
}

-(void)locationDidUpdateToNewLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    if(newLocation.coordinate.latitude != oldLocation.coordinate.latitude || newLocation.coordinate.longitude != oldLocation.coordinate.longitude)
    {
        _locationFound = YES;

        self.currentLocation = newLocation;

        [self stopLocationTracking];

        [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_UPDATED_NOTIFICATION object:nil userInfo:@{kCurrentLocationKey:self.currentLocation}];
    }

}

-(void)startRegionMonitoring:(CLCircularRegion*)region{
    self.currentRegion = region;
    [self.locationManager startMonitoringForRegion:self.currentRegion];
}

-(void)stopRegionMonitoring{
    [self.locationManager stopMonitoringForRegion:self.currentRegion];
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_ENTERED_REGION object:nil];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(nonnull CLRegion *)region{
	[[NSNotificationCenter defaultCenter] postNotificationName:USER_LEFT_REGION object:nil];
}

@end
