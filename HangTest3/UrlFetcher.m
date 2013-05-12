//
//  UrlFetcher.m
//  Hang-iOS
//
//  Created by Michael Gunnulfsen on 5/4/13.
//  Copyright (c) 2013 Hang. All rights reserved.
//

#import "UrlFetcher.h"
#import "HANGVenue.h"
#import "WallViewController.h"

@implementation UrlFetcher


/* FETCH FROM FOURSQUARE */

- (void)fetchFoursquareData:(NSString*)lat andLongitude:(NSString*)longitude
{
    NSString *urlStr =
    [NSString stringWithFormat:
     @"https://api.foursquare.com/v2/venues/search?ll=%@,%@&intent=checkin&client_id=ZXFJZ4XDXKVUKLVUAK5UZY1YONGCH43UDQ3VAJJXHNMESCSK&client_secret=C30YKWTH40QS2OBEGJJ5VGW4IOJHJRGHK4Y2VZECZGT2OO20&v=20130101", lat, longitude];
    self.responseData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:urlStr]];
    (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)fetchPostsFromAPI:(NSString*)venueId
{
    NSString *urlStr =
    [NSString stringWithFormat:
     @"http://hang.cloudfoundry.com/getWall/%@",
     venueId];
    
    self.responseData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:urlStr]];
    (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    // extract specific value...
    id code = [[res objectForKey:@"meta"] objectForKey:@"code"];
    
    if ([code integerValue] == 200) {
        NSArray *venues = [[res objectForKey:@"response"] objectForKey:@"venues"];
        NSMutableArray *venueArray = [[NSMutableArray alloc] init];
        
        for (id venue in venues) {
            
            NSString *venueId = [venue objectForKey:@"id"];
            NSString *venueName = [venue objectForKey:@"name"];
            NSNumber *venueDistance = [[venue objectForKey:@"location"] objectForKey:@"distance"];
            
            HANGVenue *v = [[HANGVenue alloc] initWithId:venueId andName:venueName andDistance:venueDistance];
            [venueArray addObject:v];
            
            NSLog(@"\nid: %@, name: %@, distance: %@", venueId, venueName, venueDistance);
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
        [venueArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        WallViewController *wvc;
        wvc = [self caller2];
        wvc.venues = venueArray;
    }
}


- (id)initWithParam2:()param {
    if ((self = [super init])) {
        self.caller2 = param;
    }
    return self;
}

@end