//
//  LocationManager.m
//  ZombieMapAttack
//
//  Created by K Y on 6/19/19.
//  Copyright © 2019 KY. All rights reserved.
//

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationManager ()

@property (nonatomic, strong) CLLocationManager *manager;

@end

@interface LocationManager (CLLocation) <CLLocationManagerDelegate>

@end


@implementation LocationManager

+ (LocationManager *)sharedInstance {
    static LocationManager *sharedOnceInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedOnceInstance = [[self alloc] init];
    });
    return sharedOnceInstance;
}

/// Please do not call this, used the shared Instance
- (instancetype)init {
    self = [super init];
    if (self) {
        // do initialization here
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        
        // set up our CLLocation manager here
        _manager.distanceFilter = 10; // every 10 meters, we fire updates
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
}

- (void)start {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            NSLog(@"User did not authorize Location, show some error message here");
            break;
        case kCLAuthorizationStatusNotDetermined:
            [self.manager requestWhenInUseAuthorization];
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.manager startUpdatingLocation];
            // break;
    }
}

- (void)stop {
    [self.manager stopUpdatingLocation];
}

@end

@implementation LocationManager (CLLocation)

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            NSLog(@"User did not authorize Location, show some error message here");
            break;
        case kCLAuthorizationStatusNotDetermined:
            [self.manager requestWhenInUseAuthorization];
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.manager startUpdatingLocation];
            // break;
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *loc = locations.firstObject;
    NSLog(@"Did move to new location: %@", loc);
    [self.delegate didUpdateLocation: loc];
}

@end
