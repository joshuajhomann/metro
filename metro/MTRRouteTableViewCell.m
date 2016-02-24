//
//  MTRRouteTableViewCell.m
//  metro
//
//  Created by Josh Homann on 2/24/16.
//  Copyright © 2016 josh. All rights reserved.
//

#import "MTRRouteTableViewCell.h"

@interface MTRRouteTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *routeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeNumberLabel;

@end

@implementation MTRRouteTableViewCell
- (void)setRoute:(Route *)route {
    _route = route;
    self.routeNumberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)route.id];
    self.routeNameLabel.text = route.name;
}
@end
