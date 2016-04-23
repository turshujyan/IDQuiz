//
//  IDQRulesViewController.m
//  AMProgrammerTest
//
//  Created by Hermine on 4/7/16.
//  Copyright © 2016 Arman Markosyan. All rights reserved.
//

#import "IDQRulesViewController.h"

@interface IDQRulesViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation IDQRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"rules.pdf" ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
    [self.webView loadRequest:request];

}
- (IBAction)backButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
