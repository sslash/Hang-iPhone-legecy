//
//  Post.m
//  Hang-iPhone
//
//  Created by Thor Widlund on 9/10/13.
//  Copyright (c) 2013 Thor Widlund. All rights reserved.
//

#import "Post.h"

@implementation Post

- (Post *)init:(NSString *)venueId andOwnerId:(NSString *)ownerId andText:(NSString *)text
{
    self.venueId = venueId;
    self.ownerid = ownerId;
    self.text = text;
    self.timestamp = [NSDate date];
    
    return self;
}

@end
