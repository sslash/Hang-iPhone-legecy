//
//  PostViewController.h
//  HangTest3
//
//  Created by Thor Widlund on 5/12/13.
//  Copyright (c) 2013 Thor Widlund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostViewController : UIViewController<UITextFieldDelegate>


@property (strong, nonatomic) NSArray *postDetails;
@property (strong, nonatomic) IBOutlet UILabel *postLabel;
@property (strong, nonatomic) IBOutlet UITextField *commentInput;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *postCommentBtn;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@end
