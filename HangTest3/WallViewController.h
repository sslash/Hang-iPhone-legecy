//
//  WallViewController.h
//  HangTest3
//
//  Created by Thor Widlund on 5/12/13.
//  Copyright (c) 2013 Thor Widlund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HANGVenue.h"
#import "UrlFetcher.h"
#import "APIURLFetcher.h"

@interface WallViewController : UIViewController <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UINavigationItem *navigationTitle;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *pushButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) IBOutlet NSMutableArray *tableData;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;
@property (strong, nonatomic) IBOutlet UITableView *placesTableView;
@property (strong, nonatomic) IBOutlet NSArray *placesTableData;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSMutableArray *venues;
@property (strong, nonatomic) HANGVenue *currentVenue;
@property (nonatomic) BOOL placesTablePressed;


- (void)sendPostToAPI:(NSString*)text;
- (void)fetchFoursqare;
- (void)done:(NSArray*) posts;

@end
