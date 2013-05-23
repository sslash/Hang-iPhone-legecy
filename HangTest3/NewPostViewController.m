//
//  NewPostViewController.m
//  Hang-iPhone
//
//  Created by Henrik Glasø Skifjeld on 5/23/13.
//  Copyright (c) 2013 Thor Widlund. All rights reserved.
//

#import "NewPostViewController.h"
#import "WallViewController.h"

@interface NewPostViewController ()

@end

@implementation NewPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[((WallViewController*) self.parentViewController) sendPostToAPI:self.messageView.text];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressPublish:(id)sender {
    
    NSLog(@"%@", self.messageView.text);
    
    [self.wallViewController sendPostToAPI:self.messageView.text];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
