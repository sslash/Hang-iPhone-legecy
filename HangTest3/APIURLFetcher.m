//
//  APIURLFetcher.m
//  Hang-iOS
//
//  Created by Michael Gunnulfsen on 5/5/13.
//  Copyright (c) 2013 Hang. All rights reserved.
//

#import "APIURLFetcher.h"

@implementation APIURLFetcher


- (id)initWithParam:()param {
    if ((self = [super init])) {
        self.caller = param;
    }
    return self;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    // show all values
    for(id key in res) {
        
        id value = [res objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
    }
    
    NSArray * posts = [res objectForKey:@"posts"];
    
    WallViewController *wvc;
    wvc = [self caller];
    [wvc done:posts];
    
}

@end