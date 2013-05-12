//
//  WallViewController.m
//  HangTest3
//
//  Created by Thor Widlund on 5/12/13.
//  Copyright (c) 2013 Thor Widlund. All rights reserved.
//

#import "WallViewController.h"
#import "PostViewController.h"
#import "PostTableCell.h"

@interface WallViewController ()

@end

@implementation WallViewController

CLLocationManager *locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Wall view did load");

    [self startUpdatingLocation];
    [self fetchFoursqare];
    [self updateCurrentVenue];
    [self setTopNavBar];
    self.tableData = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
    [self setPlaceLabelClickable];
}

- (void) setPlaceLabelClickable
{
    self.placeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap)];
    [self.placeLabel addGestureRecognizer:tapGesture];
    
    self.placesTableData = [[NSArray alloc] initWithObjects:@"sap",@"dap", nil];
    [self.placesTableView reloadData];
}

-(void) labelTap
{
    NSLog(@"nigga");
    [self.placesTableView setAlpha:1];
    [self.placesTableView setNeedsDisplay];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)startUpdatingLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void) fetchFoursqare
{
    
    NSString* lat = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude];
    NSString* longitude = [NSString stringWithFormat:@"%f", locationManager.location.coordinate.longitude];
    
    NSLog(@"Set nav bar title: %@", [self deviceLocation]);
	// Do any additional setup after loading the view.
    
    UrlFetcher * fetcher = [[UrlFetcher alloc] initWithParam2:self];
    [fetcher fetchFoursquareData:lat andLongitude:longitude];
}

- (void)updateCurrentVenue
{
    if ([self.venues count] > 0) {
        self.currentVenue = [self.venues objectAtIndex:0];
        [self fetchPostsFromAPI];
    } else {
        self.currentVenue = nil;
    }
}

- (void)setTopNavBar
{
    if (self.currentVenue != nil) {
        NSLog(@"name %@", self.currentVenue.name);
        self.placeLabel.text = self.currentVenue.name;

    } else {
        self.placeLabel.text = @"";
    }
}

- (void)sendPostToAPI:(NSString*)text
{
    NSString *ownerId = @"5";
    NSString *logString =
    [NSString stringWithFormat: @"Will send: %@, to %@!", text, ownerId];
    NSLog(@"%@", logString);
    
    NSString *urlStr =
    [NSString stringWithFormat: @"http://hang.cloudfoundry.com/newPost/?venueId=%@&ownerId=%@",
     self.currentVenue.venueId, ownerId];
    
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc] initWithURL:
     [NSURL URLWithString:urlStr]];
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         text, @"text", nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    [request setHTTPBody:postdata];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [postdata
                                                         length]] forHTTPHeaderField:@"Content-Length"];
    
    (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void) fetchPostsFromAPI {
    APIURLFetcher * fetcher = [[APIURLFetcher alloc] initWithParam:self];
    [fetcher fetchPostsFromAPI:self.currentVenue.venueId];
}
- (IBAction)f5ButtonPressed:(id)sender {
    [self updateCurrentVenue];
    [self setTopNavBar];
    [self fetchFoursqare];
    
    /* Fetch posts from wall */
}

- (IBAction)pushButtonPressed:(id)sender {
    NSLog(@"Text btn entered: ");
    NSLog(@"%@", self.textField.text);
    [self sendPostToAPI:self.textField.text];
    self.textField.text = @"";
    [self.textField resignFirstResponder];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView.restorationIdentifier isEqual: @"placesData"]){
        return [self.placesTableData count];
    }else {
        return [self.tableData count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"juuupp");
    
    if ([tableView.restorationIdentifier isEqual: @"placesData"]){
        static NSString *CellIdentifier = @"placeCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
        }
        
        // Set up the cell...
        NSString *cellValue = [self.placesTableData objectAtIndex:indexPath.row];
        cell.text = cellValue;
        
        return cell;
        
    } else {
    
        static NSString *CellId = @"postCell";
        PostTableCell *cell = (PostTableCell *)[tableView dequeueReusableCellWithIdentifier:CellId];
        if (cell == nil)
        {
            cell = (PostTableCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
        }
    
        NSDictionary * post = [self.tableData objectAtIndex:indexPath.row];
        cell.postDate.text = [post objectForKey: @"timeCreated"];
        //cell.postDate.text = (NSString *)[post objectForKey: @"timeCreated"];
        cell.postText.text = [post objectForKey:@"text"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     if ([tableView.restorationIdentifier isEqual: @"placesData"]){
         return 40;
     } else {
         return 78;
     }
}


-(void) done:(NSArray*) posts {
    [self.tableData setArray:posts];
    //self.tableData = posts;
    [self.tableView reloadData];
    //self.tableView.reloadData;
}

- (NSString *)deviceLocation {
    NSString *theLocation = [NSString stringWithFormat:@"%f,%f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    return theLocation;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSLog(@"prepareForSegue: %@", segue.identifier);
    

    if ([[segue identifier] isEqualToString:@"PostViewSegue"])
    {
        PostViewController *postViewController =
        [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.tableView
                                    indexPathForSelectedRow];
        
        NSDictionary * post = [self.tableData objectAtIndex:myIndexPath.row];
 
        postViewController.postDetails = [[NSArray alloc]
                                             initWithObjects: [post objectForKey:@"text"],
                                                                nil];
    }
}

/*
 
 GET DATA FROM
 
 https://api.foursquare.com/v2/venues/search?ll=59.943830,10.718676&intent=checkin&client_id=ZXFJZ4XDXKVUKLVUAK5UZY1YONGCH43UDQ3VAJJXHNMESCSK&client_secret=C30YKWTH40QS2OBEGJJ5VGW4IOJHJRGHK4Y2VZECZGT2OO20&v=20130101
 
 (use deviceLocation method for ll param)
 
 
 http://agilewarrior.wordpress.com/2012/02/01/how-to-make-http-request-from-iphone-and-parse-json-result/
 
 */

@end
