//
//  APIURLFetcher.h
//  Hang-iOS
//
//  Created by Michael Gunnulfsen on 5/5/13.
//  Copyright (c) 2013 Hang. All rights reserved.
//

#import "UrlFetcher.h"
#import "WallViewController.h"

@interface APIURLFetcher : UrlFetcher
@property (strong, nonatomic) id caller;

- (id)initWithParam:(id)param;

@end