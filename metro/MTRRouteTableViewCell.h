//
//  MTRRouteTableViewCell.h
//  metro
//
//  Created by Josh Homann on 2/24/16.
//  Copyright © 2016 josh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Route.h"

@interface MTRRouteTableViewCell : UITableViewCell
@property  (nonatomic, strong) Route* route;
@end
