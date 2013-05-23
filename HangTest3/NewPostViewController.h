//
//  NewPostViewController.h
//  Hang-iPhone
//
//  Created by Henrik Glasø Skifjeld on 5/23/13.
//  Copyright (c) 2013 Thor Widlund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WallViewController.h"

@interface NewPostViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *messageView;

@property (weak, nonatomic) WallViewController *wallViewController;

@end
