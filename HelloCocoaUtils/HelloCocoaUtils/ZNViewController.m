//
//  ZNViewController.m
//  HelloCocoaUtils
//
//  Created by Zdenek Nemec on 12/29/12.
//  Copyright (c) 2012 zdne.org. All rights reserved.
//

#import "ZNViewController.h"

@interface ZNViewController ()

@end

@implementation ZNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.textView.placeholderText = @"Hello World";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
