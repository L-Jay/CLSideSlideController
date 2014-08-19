//
//  SixViewController.m
//  
//
//  Created by L on 14-4-3.
//  Copyright (c) 2014年 Cui. All rights reserved.
//

#import "SixViewController.h"

@interface SixViewController ()

@end

@implementation SixViewController

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
	
    self.navigationItem.title = @"Six";
    
    self.view.backgroundColor = ARCCOLOR;
    
    UILabel *lb = [[UILabel alloc] initWithFrame:self.view.bounds];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont boldSystemFontOfSize:100];
    lb.text = @"Six";
    [self.view addSubview:lb];
    [lb release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
