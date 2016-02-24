//
//  Route.h
//  metro
//
//  Created by Josh Homann on 2/23/16.
//  Copyright © 2016 josh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Route : NSObject
@property (nonatomic, assign) NSUInteger id;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* fullDescription;
+(void) getWithCompletionHandler: (void (^)(NSError *, NSArray<Route*>*))completion;
@end
