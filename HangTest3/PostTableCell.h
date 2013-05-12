//
//  PostTableCell.h
//  HangTest3
//
//  Created by Thor Widlund on 5/12/13.
//  Copyright (c) 2013 Thor Widlund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *postDate;
@property (strong, nonatomic) IBOutlet UILabel *postText;

@end
