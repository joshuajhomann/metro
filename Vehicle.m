//
//  Vehicle.m
//  metro
//
//  Created by Josh Homann on 2/23/16.
//  Copyright © 2016 josh. All rights reserved.
//

#import "Vehicle.h"
#import "MTRConstants.h"

#define VEHICLE_URL @"routes/%lu/vehicles/"
#define KEY_ROOT @"items"
#define KEY_LATITUDE @"latitude"
#define KEY_LONGITUDE @"longitude"
#define KEY_TIME @"seconds_since_report"
#define KEY_ID @"id"

@implementation Vehicle
+(void) getVehicleForRouteId: (NSUInteger)id  CompletionHandler: (void (^)(NSError *, NSArray<Vehicle*>*))completion {
    NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingString:[NSString stringWithFormat:VEHICLE_URL, (unsigned long)id]]];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            completion(error, nil);
            return;
        }
        NSError *JSONError = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
        if (JSONError !=nil) {
            completion(error, nil);
            return;
        }
        NSArray *items = dictionary[KEY_ROOT];
        NSMutableArray <Vehicle*> *vehicles = [NSMutableArray new];
        for (NSDictionary* item in items) {
            Vehicle * vehicle = [Vehicle new];
            vehicle.id = [item[KEY_ID] integerValue];
            vehicle.longitude = [item[KEY_LONGITUDE] doubleValue];
            vehicle.latitude = [item[KEY_LATITUDE] doubleValue];
            vehicle.elapseTime = [item[KEY_TIME] integerValue];
            [vehicles addObject:vehicle];
        }
        completion (nil, vehicles);
        
    }] resume];
}
@end
