//
//  UserLOcationUtilities.h
//  AwayDay2012
//
//  Created by safadmoh on 14/09/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UserLocationUtilities : NSObject

@property(nonatomic,strong) CLLocationManager *locationManager;
-(id)init;
@end
