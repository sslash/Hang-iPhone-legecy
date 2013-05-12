//
//  HANGVenue.h
//  Hang-iOS
//
//  Created by Henrik Glasø Skifjeld on 5/5/13.
//  Copyright (c) 2013 Hang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HANGVenue : NSObject

@property (strong, nonatomic) NSString *venueId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *distance;

- (id)initWithId:(NSString *)venueId andName:(NSString *)name andDistance:(NSNumber *)distance;

@end
