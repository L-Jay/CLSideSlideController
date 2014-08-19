//
//  ThirdViewController.m
//  UIViewControllerContainment
//
//  Created by L on 14-3-21.
//  Copyright (c) 2014年 Cui. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

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
    
    self.navigationItem.title = @"Third";
    
    self.view.backgroundColor = [UIColor colorWithRed:arc4random()%10*0.1 green:arc4random()%10*0.1 blue:arc4random()%10*0.1 alpha:1.0];
	
    UILabel *lb = [[UILabel alloc] initWithFrame:self.view.bounds];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont boldSystemFontOfSize:100];
    lb.text = @"Third";
    [self.view addSubview:lb];
    [lb release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
