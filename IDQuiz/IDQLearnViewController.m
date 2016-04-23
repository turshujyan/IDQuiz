//
//  IDQLearnViewController.m
//  IDQuiz
//
//  Created by Hermine on 4/19/16.
//  Copyright © 2016 Hermine. All rights reserved.
//

#import "IDQLearnViewController.h"

@interface IDQLearnViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation IDQLearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Programming in Objective-C - .pdf" ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
    [self.webView loadRequest:request];
}

- (IBAction)backButton:(UIButton *)sender {
       [self dismissViewControllerAnimated:YES completion:nil];
}


@end
