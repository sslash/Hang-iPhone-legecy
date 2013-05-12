//
//  HANGVenue.m
//  Hang-iOS
//
//  Created by Henrik Glasø Skifjeld on 5/5/13.
//  Copyright (c) 2013 Hang. All rights reserved.
//

#import "HANGVenue.h"

@implementation HANGVenue

- (id)initWithId:(NSString *)venueId andName:(NSString *)name andDistance:(NSNumber *)distance
{
    self.venueId = venueId;
    self.name = name;
    self.distance = distance;
    
    return self;
}

@end
