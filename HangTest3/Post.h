//
//  Post.h
//  Hang-iPhone
//
//  Created by Thor Widlund on 9/10/13.
//  Copyright (c) 2013 Thor Widlund. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (strong, nonatomic) NSString *venueId;
@property (strong, nonatomic) NSString *ownerid;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *date;

- (Post *)init:(NSString *)venueId andOwnerId:(NSString *)ownerId andText:(NSString *)text;


@end
