//
//  Route.m
//  metro
//
//  Created by Josh Homann on 2/23/16.
//  Copyright © 2016 josh. All rights reserved.
//

#import "Route.h"
#import "MTRConstants.h"
#define ROUTE_URL @"routes/"
#define KEY_ROUTES @"items"
#define KEY_ID @"id"
#define KEY_NAME @"display_name"

@implementation Route
+(void) getWithCompletionHandler: (void (^)(NSError *, NSArray<Route*>*))completion {
    NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingString:ROUTE_URL]];
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
        NSArray *items = dictionary[KEY_ROUTES];
        NSMutableArray <Route*> *routes = [NSMutableArray new];
        for (NSDictionary* item in items) {
            Route * route = [Route new];
            route.id = [item[KEY_ID] integerValue];
            route.fullDescription = item[KEY_NAME];
            //Strip out the id from the name
            NSRange range = [route.fullDescription rangeOfString:@" "];
            route.name = [route.fullDescription substringFromIndex:range.location+1];
            [routes addObject:route];
        }
        completion (nil, routes);
        
    }] resume];
}
@end
