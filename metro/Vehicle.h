//
//  Vehicle.h
//  metro
//
//  Created by Josh Homann on 2/23/16.
//  Copyright © 2016 josh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vehicle : NSObject
@property (nonatomic, assign) NSUInteger id;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) NSUInteger elapseTime;
+(void) getVehicleForRouteId: (NSUInteger)id  CompletionHandler: (void (^)(NSError *, NSArray<Vehicle*>*))completion;
@end
