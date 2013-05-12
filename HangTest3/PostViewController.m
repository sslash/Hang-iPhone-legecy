//
//  PostViewController.m
//  HangTest3
//
//  Created by Thor Widlund on 5/12/13.
//  Copyright (c) 2013 Thor Widlund. All rights reserved.
//

#import "PostViewController.h"

@interface PostViewController ()

@end

@implementation PostViewController

@synthesize postDetails = _postDetails;
@synthesize postLabel = _postLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)postCommentBtnTouched:(id)sender {
    NSLog(@"post comment: %@", self.commentInput.text);
    [self sendCommentToApi: self.commentInput.text];
    self.commentInput.text = @"";
    [self.commentInput resignFirstResponder];
}

- (void) sendCommentToApi:(NSString*) text {
    
    NSString *ownerId = @"5";
    NSString *logString =
    [NSString stringWithFormat: @"Will send (comment: %@, to %@!", text, ownerId];
    NSLog(@"%@", logString);
    NSLog(@"ID: %@", [self.postDetails objectAtIndex:1]);
    id postId = [self.postDetails objectAtIndex:1];
    
    NSString *urlStr =
    [NSString stringWithFormat: @"http://hang.cloudfoundry.com/newComment/?postId=%@&ownerId=%@",
     postId, ownerId]; //TODO: change to post id
    
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc] initWithURL:
     [NSURL URLWithString:urlStr]];
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         text, @"text", nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    [request setHTTPBody:postdata];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [postdata
                                                         length]] forHTTPHeaderField:@"Content-Length"];
    
    (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"POSTVIEW");
    NSLog(@"%@", [self.postDetails objectAtIndex:0]);
    self.postLabel.text = [self.postDetails objectAtIndex:0];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
