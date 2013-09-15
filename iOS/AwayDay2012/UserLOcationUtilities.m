//
//  UserLOcationUtilities.m
//  AwayDay2012
//
//  Created by safadmoh on 14/09/13.
//
//

#import "UserLocationUtilities.h"
#import <CoreLocation/CoreLocation.h>

@implementation UserLocationUtilities

-(id)init
{
    self =[super init];
    if(self)
    {
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100
        [self.locationManager startUpdatingLocation];

    }
    return self;
}

@end
