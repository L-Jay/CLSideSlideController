//
//  NextViewController.m
//  
//
//  Created by L on 14-5-14.
//  Copyright (c) 2014年 Cui. All rights reserved.
//

#import "NextViewController.h"

@interface NextViewController ()

@end

@implementation NextViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.navigationItem.leftBarButtonItem = BARBUTTON(@"back", @selector(goBack));
    self.view.backgroundColor = [UIColor blueColor];
    
    UIButton *v1 = [[UIButton alloc] initWithFrame: CGRectMake(260, 90, 60, 60)];
    v1.backgroundColor = [UIColor blackColor];
    [v1 addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:v1];
}

- (void)goBack
{
    NSLog(@"ing %@", self.presentingViewController);
    NSLog(@"-=-=-=-=-=%@", self.sideSlideController);
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
