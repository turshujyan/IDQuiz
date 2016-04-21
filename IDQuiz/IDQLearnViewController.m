//
//  IDQLearnViewController.m
//  IDQuiz
//
//  Created by Hermine on 4/19/16.
//  Copyright © 2016 Hermine. All rights reserved.
//

#import "IDQLearnViewController.h"

@interface IDQLearnViewController ()

@end

@implementation IDQLearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Programming in Objective-C.pdf" ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
