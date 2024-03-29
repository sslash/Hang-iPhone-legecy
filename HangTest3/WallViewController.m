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
#import "NewPostViewController.h"

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
    
    
    // Set up the UIRefreshControl.
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull down to refresh"];
    //refreshControl.tintColor = [UIColor purpleColor];
    
    // Create a UITableViewController so we can use a UIRefreshControl.
    UITableViewController *tvc = [[UITableViewController alloc] initWithStyle:self.tableView.style];
    tvc.tableView = self.tableView;
    tvc.refreshControl = refreshControl;
    [self addChildViewController:tvc];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateCurrentVenue];
    [self setTopNavBar];
    [self fetchFoursqare];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing ..."];
    [self updateCurrentVenue];
    [refreshControl endRefreshing];
    NSLog(@"er det her?????");
    [self updateCurrentVenue];
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
    if (self.placesTablePressed == false ) {
        [self showPlacesTable];
    } else {
        [self hidePlacesTable];
    }
}

-(void) hidePlacesTable
{
    self.placesTablePressed = false;
    [self.placesTableView setAlpha:0];
    [self.placesTableView setNeedsDisplay];
}

-(void) showPlacesTable
{
    [self.placesTableView reloadData];
    self.placesTablePressed = true;
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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);

    [self fetchFoursqare];
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
        [self.placesTableView reloadData];
        
        bool changeCurrentVenue = YES;
        
        if (self.currentVenue != nil) {
            for (id venue in self.venues)
            {
                if ([self.currentVenue.venueId isEqualToString:[venue venueId]])
                {
                    changeCurrentVenue = NO;
                }
            }
        }
        
        if (changeCurrentVenue)
        {
            self.currentVenue = [self.venues objectAtIndex:0];
        }
        
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

- (void)updateNavBar
{
    [self updateCurrentVenue];
    [self setTopNavBar];
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
}

- (IBAction)pushButtonPressed:(id)sender {
    [self sendPostToAPI:self.textField.text];
    self.textField.text = @"";
    [self.textField resignFirstResponder];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView.restorationIdentifier isEqual: @"placesData"])
    {
        NSLog(@"%i", [self.venues count]);
        //return [self.placesTableData count];
        //return 5; // Should check if there are actually 4
        return [self.venues count];
    } else {
        return [self.tableData count] * 2 - 1; // with seperators
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView.restorationIdentifier isEqual: @"placesData"])
    {
        [[cell textLabel] setTextColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1]];
        [[cell textLabel] setFont:[UIFont systemFontOfSize:14.0]];

        if ([[[self.venues objectAtIndex:indexPath.row] name] isEqualToString:self.currentVenue.name])
        {
            cell.textLabel.text = @"";
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if ([tableView.restorationIdentifier isEqual: @"placesData"]){
        static NSString *CellIdentifier = @"placeCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:CellIdentifier];
        }
        
        // Set up the cell...
        HANGVenue *cellValue = [self.venues objectAtIndex:indexPath.row];
        cell.textLabel.text = cellValue.name;
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        return cell;
        
    } else {
    
        if (indexPath.row % 2 == 0)
        {
            static NSString *CellId = @"PostTableCell";
            PostTableCell *cell = (PostTableCell *)[tableView dequeueReusableCellWithIdentifier:CellId];
            if (cell == nil)
            {
                cell = (PostTableCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
            }
    
            NSDictionary * post = [self.tableData objectAtIndex:(indexPath.row / 2)];
            cell.postDate.text = [post objectForKey: @"timeCreated"];
            //cell.postDate.text = (NSString *)[post objectForKey: @"timeCreated"];
            cell.postText.text = [post objectForKey:@"text"];
            return cell;
        }
        else
        {
            static NSString *CELL_ID = @"SOME_STUPID_ID";
            
            UITableViewCell * cell2 = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
            
            if (cell2 == nil)
            {
                cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:CELL_ID];
            }
        
            cell2.contentView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
            [cell2 setUserInteractionEnabled:NO]; // prevent selection and other
            
            return cell2;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     if ([tableView.restorationIdentifier isEqual: @"placesData"])
     {
         if ([[[self.venues objectAtIndex:indexPath.row] name] isEqualToString:self.currentVenue.name])
         {
             return 0;
         }
         
         return 30;
     }
     else
     {
         if (indexPath.row % 2 == 1)
         {
             return 8;
         }
         else
         {
             return 78;
         }
     }
}


-(void) done:(NSArray*) posts {
    NSLog(@"Posts fetched. Will reload post data in GUI");
    [self.tableData setArray:posts];
    [self.tableView reloadData];
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
        PostViewController *postViewController = [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.tableView
                                    indexPathForSelectedRow];
        
        NSDictionary *post = [self.tableData objectAtIndex:myIndexPath.row];
 
        postViewController.postDetails = [[NSArray alloc]
                                             initWithObjects: [post objectForKey:@"text"],[post objectForKey:@"id"], nil];

    }
    else if ([[segue identifier] isEqualToString:@"NewPostSegue"])
    {
        NewPostViewController *newPostViewController = [segue destinationViewController];
        
        newPostViewController.wallViewController = self;
    }
    
    NSLog(@"%@", self.currentVenue.name);
}
// LOL
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tableView)
    {
        return;
    }
    
    NSLog(@"index path: %@", indexPath );
    int index = [indexPath indexAtPosition:1];
    
    NSLog(@"pressed: %d", index );
    self.currentVenue = [self.venues objectAtIndex:index];
    
    NSLog(@"%@", self.currentVenue.name);

    [self fetchPostsFromAPI];
    [self setTopNavBar];
    [self hidePlacesTable];
     
}

/*
 
 GET DATA FROM
 
 https://api.foursquare.com/v2/venues/search?ll=59.943830,10.718676&intent=checkin&client_id=ZXFJZ4XDXKVUKLVUAK5UZY1YONGCH43UDQ3VAJJXHNMESCSK&client_secret=C30YKWTH40QS2OBEGJJ5VGW4IOJHJRGHK4Y2VZECZGT2OO20&v=20130101
 
 (use deviceLocation method for ll param)
 
 
 http://agilewarrior.wordpress.com/2012/02/01/how-to-make-http-request-from-iphone-and-parse-json-result/
 
 */

@end
