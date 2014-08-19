//
//  RightViewController.m
//  FNSideSlidController
//
//  Created by L on 14-4-3.
//  Copyright (c) 2014年 Cui. All rights reserved.
//

#import "RightViewController.h"
#import "NextViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController

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
	
    self.view.backgroundColor = ARCCOLOR;
    
    UILabel *lb = [[UILabel alloc] initWithFrame:self.view.bounds];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont boldSystemFontOfSize:100];
    lb.text = @"Right";
    [self.view addSubview:lb];
    [lb release];
    
    //例子
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(0, 0, 100, 100);
    bt.center = self.view.center;
    bt.backgroundColor = [UIColor orangeColor];
    [bt addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
    UIButton *bt2 = [UIButton buttonWithType:UIButtonTypeCustom];
    bt2.frame = CGRectMake(220, 0, 100, 100);
    bt2.backgroundColor = [UIColor blackColor];
    [bt2 addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt2];
}

- (void)hide
{
    [self.sideSlideController hideRightViewWithAnimation:YES];
}

- (void)test
{
//    UIViewController *controller = [[UIViewController alloc] init];
//    controller.view.backgroundColor = [UIColor orangeColor];
//    
//    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
//    bt.frame = CGRectMake(0, 0, 100, 100);
//    bt.center = self.view.center;
//    bt.backgroundColor = [UIColor blueColor];
//    [bt addTarget:self action:@selector(test2) forControlEvents:UIControlEventTouchUpInside];
//    [controller.view addSubview:bt];
//    
//    [self.sideSlidController.navigationController pushViewController:controller animated:YES];
//    [controller release];
//    
//    self.sideSlidController.navigationController.navigationBarHidden = NO;
    
//    [self.sideSlidController hideRightViewWithAnimation:YES];
//    self.sideSlidController.rightViewController = nil;
    
    NextViewController *vc = [[NextViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    [self.sideSlideController.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)test2
{
    self.sideSlideController.navigationController.navigationBarHidden = YES;
    [self.sideSlideController.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
