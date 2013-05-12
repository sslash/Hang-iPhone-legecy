//
//  UrlFetcher.h
//  Hang-iOS
//
//  Created by Michael Gunnulfsen on 5/4/13.
//  Copyright (c) 2013 Hang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlFetcher : NSObject
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) id caller2;

- (void)fetchFoursquareData:(NSString*)lat andLongitude:(NSString*)longitude;

- (void)fetchPostsFromAPI:(NSString*)venueId;

- (id)initWithParam2:()param;

@end