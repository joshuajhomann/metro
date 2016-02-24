//
//  MTRRouteTableViewController.m
//  metro
//
//  Created by Josh Homann on 2/23/16.
//  Copyright © 2016 josh. All rights reserved.
//

#import "MTRRouteTableViewController.h"
#import "Route.h"
#import "MTRConstants.h"
#import "MTRMapViewController.h"
#import "MTRRouteTableViewCell.h"

@interface MTRRouteTableViewController () <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSMutableArray<Route*>* routes;
@property (nonatomic, strong) NSMutableArray<Route*>* visibleRoutes;
@property (nonatomic, assign) NSUInteger selectedRow;
@end



@implementation MTRRouteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.routes = [NSMutableArray new];
    self.visibleRoutes = [NSMutableArray new];
    [self getData];
    //Support for pull to refresh
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    refreshControl.backgroundColor = COLOR_METRO_BLUE;
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(getData) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
}

- (void)getData {
    if (self.isLoading)
        return;
    __weak typeof(self) weakSelf = self;
    [Route getWithCompletionHandler:^(NSError *error, NSArray<Route*> *routes) {
        weakSelf.isLoading = false;
        if (error != nil || routes.count == 0)
            return;
        [weakSelf.routes removeAllObjects];
        [weakSelf.routes addObjectsFromArray:routes];
        //Update UI on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.visibleRoutes = [routes copy];
            weakSelf.searchBar.text = @"";
            [weakSelf.tableView reloadData];
            [weakSelf.refreshControl endRefreshing];
        });
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.visibleRoutes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MTRRouteTableViewCell *cell =  (MTRRouteTableViewCell*)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MTRRouteTableViewCell class])];
    cell.route = self.visibleRoutes[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:SEGUE_MTR_MAP_VIEW_CONTROLLER sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass: [MTRMapViewController class]])
        ((MTRMapViewController*)segue.destinationViewController).routeId = self.visibleRoutes[[self.tableView indexPathForSelectedRow].row].id;
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        self.visibleRoutes = [self.routes copy];
        return;
    }
    self.visibleRoutes = [NSMutableArray new];
    //Identify the routes matching the search string
    for (Route* route in self.routes)
        if ([route.fullDescription rangeOfString:searchText].location != NSNotFound)
            [self.visibleRoutes addObject:route];
    [self.tableView reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.visibleRoutes = [self.routes copy];
    [self.tableView reloadData];
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}
@end
