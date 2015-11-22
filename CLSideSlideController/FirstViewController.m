
#import "FirstViewController.h"
#import "NextViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

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
    
    self.navigationItem.title = @"First";
    
    self.view.backgroundColor = [UIColor colorWithRed:arc4random()%10*0.1 green:arc4random()%10*0.1 blue:arc4random()%10*0.1 alpha:1.0];
	
    UILabel *lb = [[UILabel alloc] initWithFrame:self.view.bounds];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont boldSystemFontOfSize:100];
    lb.text = @"First";
    [self.view addSubview:lb];
    [lb release];
    
    UIButton *v1 = [[UIButton alloc] initWithFrame: CGRectMake(260, 90, 60, 60)];
    v1.backgroundColor = [UIColor orangeColor];
    v1.tag = 0;
    [v1 addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:v1];
}

- (void)test
{
//    [self.sideSlideController rotateScaleMainView];
    //self.sideSlidController.animationType = SideSlidShowViewAnimationScale;
    
//    UIView *v = [[UIView alloc] initWithFrame:self.view.bounds];
//    v.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//    v.layer.zPosition = 100;
//    [self.sideSlidController.view addSubview:v];
//    [v release];
    
//    UIViewController *cont = [[UIViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cont];
//    cont.view.backgroundColor = [UIColor orangeColor];
//    
//    UIButton *v1 = [[UIButton alloc] initWithFrame: CGRectMake(260, 90, 60, 60)];
//    v1.backgroundColor = [UIColor blackColor];
//    [v1 addTarget:self action:@selector(test2) forControlEvents:UIControlEventTouchUpInside];
//    [cont.view addSubview:v1];
//    [self.sideSlideController presentViewController:nav animated:YES completion:^{
//        
//    }];
//    [cont release];
    
    NextViewController *next = [[NextViewController alloc] init];
    [self.sideSlideController presentViewController:next animated:YES completion:^{
        NSLog(@"ed %@", self.sideSlideController.presentedViewController);
        NSLog(@"ing %@", self.sideSlideController.presentingViewController);
        NSLog(@" %@", self.sideSlideController.parentViewController);
    }];
    [next release];
}

- (void)test2
{
//    UIViewController *cont = [[UIViewController alloc] init];
//    cont.view.backgroundColor = [UIColor yellowColor];
//    self.sideSlidController.rightViewController = cont;
//    [cont release];
    
    [self.sideSlideController.parentViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"结束");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
