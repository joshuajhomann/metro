//
//  MTRMapViewController.m
//  metro
//
//  Created by Josh Homann on 2/23/16.
//  Copyright © 2016 josh. All rights reserved.
//
@import MapKit;
#import "MTRMapViewController.h"
#import "Vehicle.h"
#import "MTRConstants.h"

@interface MTRMapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSMutableArray<Vehicle*>* vehicles;
@property (nonatomic, strong) NSMutableArray<MKPointAnnotation*>* annotations;
@end

@implementation MTRMapViewController

- (void) viewDidLoad {
    self.vehicles = [NSMutableArray new];
    self.annotations = [NSMutableArray new];
}

- (void)setRouteId:(NSUInteger)routeId {
    _routeId = routeId;
    self.title = [NSString stringWithFormat:NSLocalizedString(@"mapview.title", nil), (unsigned long)routeId];
    [self getData];
}

- (void)getData {
    if (self.isLoading)
        return;
    [self.activityIndicator startAnimating];
    __weak typeof(self) weakSelf = self;
    [Vehicle getVehicleForRouteId:self.routeId CompletionHandler: ^(NSError *error, NSArray<Vehicle*> *vehicles) {
        weakSelf.isLoading = false;
        if (error != nil || vehicles.count == 0)
            return;
        [weakSelf.vehicles removeAllObjects];
        [weakSelf.vehicles addObjectsFromArray:vehicles];
        //Update UI on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateMap];
            [weakSelf.activityIndicator stopAnimating];
        });
    }];
}

- (void)updateMap {
    [self.mapView removeAnnotations:self.annotations];
    [self.annotations removeAllObjects];
    for (Vehicle* vehicle in self.vehicles) {
        MKPointAnnotation *annotation = [MKPointAnnotation new];
        annotation.coordinate = CLLocationCoordinate2DMake(vehicle.latitude, vehicle.longitude);
        annotation.title = [NSString stringWithFormat:NSLocalizedString(@"mapview.annotation.description", nil), (unsigned long)vehicle.id];
        annotation.subtitle = [NSString stringWithFormat:NSLocalizedString(@"mapview.annotation.subtitle", nil), (unsigned long)vehicle.elapseTime];
        [self.annotations addObject:annotation];
    }
    //Adding the annotations will zoom to fit all annotations on the map
    [self.mapView showAnnotations:self.annotations animated:YES];
}

#pragma - mark IBAction
- (IBAction)touchRefreshButton:(id)sender {
    [self getData];
}

@end
