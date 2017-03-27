#CLSideSlideController

#####CLSideSlideController API <https://l-jay.github.io/CLSideSlideController/CLSideSlideController%20API/index.html>

* 
```
NSMutableArray *array = [NSMutableArray array];
    
    FirstViewController *first = [[FirstViewController alloc] init];
    first.navigationItem.leftBarButtonItem = BARBUTTON(@"left", nil);
    first.navigationItem.rightBarButtonItem = BARBUTTON(@"right", nil);
    [first setLeftBarItemShowLeftView:YES];
    [first setRightBarItemShowRightView:YES];
    UINavigationController *firstNav = [[UINavigationController alloc] initWithRootViewController:first];
    [array addObject:firstNav];
    [first release];
    [firstNav release];
    
    SecondTableViewController *second = [[SecondTableViewController alloc] init];
    second.navigationItem.leftBarButtonItem = BARBUTTON(@"left", nil);
    second.navigationItem.rightBarButtonItem = BARBUTTON(@"right", nil);
    [second setLeftBarItemShowLeftView:YES];
    [second setRightBarItemShowRightView:YES];
    UINavigationController *secondNav = [[UINavigationController alloc] initWithRootViewController:second];
    [array addObject:secondNav];
    [second release];
    [secondNav release];
    
    ThirdViewController *third = [[ThirdViewController alloc] init];
    [array addObject:third];
    [third release];
    
    FourViewController *four = [[FourViewController alloc] init];
    four.navigationItem.leftBarButtonItem = BARBUTTON(@"left", nil);
    four.navigationItem.rightBarButtonItem = BARBUTTON(@"right", nil);
    [four setLeftBarItemShowLeftView:YES];
    [four setRightBarItemShowRightView:YES];
    UINavigationController *fourNav = [[UINavigationController alloc] initWithRootViewController:four];
    [array addObject:fourNav];
    [four release];
    [fourNav release];
    
    FiveTableViewController *five = [[FiveTableViewController alloc] init];
    [array addObject:five];
    [five release];
    
    SixViewController *six = [[SixViewController alloc] init];
    six.navigationItem.leftBarButtonItem = BARBUTTON(@"left", nil);
    six.navigationItem.rightBarButtonItem = BARBUTTON(@"right", nil);
    [six setLeftBarItemShowLeftView:YES];
    [six setRightBarItemShowRightView:YES];
    UINavigationController *sixNav = [[UINavigationController alloc] initWithRootViewController:six];
    [array addObject:sixNav];
    [six release];
    [sixNav release];
    
    SevenTableViewController *seven = [[SevenTableViewController alloc] init];
    seven.navigationItem.leftBarButtonItem = BARBUTTON(@"left", nil);
    seven.navigationItem.rightBarButtonItem = BARBUTTON(@"right", nil);
    [seven setLeftBarItemShowLeftView:YES];
    [seven setRightBarItemShowRightView:YES];
    UINavigationController *sevNav = [[UINavigationController alloc] initWithRootViewController:seven];
    [array addObject:sevNav];
    [seven release];
    [sevNav release];
    
    
    EightViewController *eight = [[EightViewController alloc] init];
    [array addObject:eight];
    [eight release];
    
    
    NineTableViewController *nine = [[NineTableViewController alloc] init];
    [array addObject:nine];
    [nine release];
    
    TenViewController *ten = [[TenViewController alloc] init];
    ten.navigationItem.leftBarButtonItem = BARBUTTON(@"left", nil);
    ten.navigationItem.rightBarButtonItem = BARBUTTON(@"right", nil);
    [ten setLeftBarItemShowLeftView:YES];
    [ten setRightBarItemShowRightView:YES];
    UINavigationController *tenNav = [[UINavigationController alloc] initWithRootViewController:ten];
    [array addObject:tenNav];
    [ten release];
    [tenNav release];
    
    
    //==================
    LeftTableViewController *left = [[LeftTableViewController alloc] init];
    //UINavigationController *leftNav = [[UINavigationController alloc] initWithRootViewController:left];
    
    RightViewController *right = [[RightViewController alloc] init];
    
    
    //=======================
    CLSideSlideController *tabbar = [[CLSideSlideController alloc] init];
    tabbar.delegate = self;
    tabbar.viewControllers = array;
    tabbar.leftViewController = left;
    tabbar.rightViewController = right;
    
    
	//tabbar.leftViewWidth = 200;
	//tabbar.rightViewWidth = 200;
    //tabbar.leftViewFillScreen = NO;
    //tabbar.rightViewFillScreen = NO;
    
    //tabbar.animationType = CLSideSlideShowViewAnimationNormal;
    //tabbar.animationType = CLSideSlideShowViewAnimationScaleBig;
    //tabbar.animationType = CLSideSlideShowViewAnimationScaleSmall;
    //tabbar.animationType = CLSideSlideShowViewAnimationDithering;
    //tabbar.animationType = CLSideSlideShowViewAnimationFor7;
    tabbar.animationType = CLSideSlideShowViewAnimationFor7ScaleBig;
    //tabbar.animationType = CLSideSlideShowViewAnimationFor7ScaleSmall;
    //tabbar.animationType = CLSideSlideShowViewAnimationParallax;
    
    //tabbar.showMianViewShadow = NO;
    tabbar.showLeftViewShadow = YES;
    tabbar.showRightViewShadow = YES;
    
    tabbar.scrollContinuous = NO;
    
    //tabbar.canTouchWhenShow = NO;
    
    //tabbar.showMainViewMask = YES;
    //tabbar.showLeftViewMask = YES;
    //tabbar.showRightViewMask = YES;
        
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:tabbar];
    self.window.rootViewController = rootNav;
    
    [left release];
    //[leftNav release];
    [right release];
    [tabbar release];
```
* 
```
[self.sideSlideController showLeftViewWithAnimation:YES];
    [self.sideSlideController hideLeftViewWithAnimation:YES];
    [self.sideSlideController showRightViewWithAnimation:YES];
    [self.sideSlideController hideRightViewWithAnimation:YES];
```
显示、隐藏

###UIViewController(CLSideSlideController) Category
```
[self.sideSlideController hideLeftViewWithAnimation:YES];
```
UIViewController拓展属性,CLSideSlideController中所有ViewController都具有该属性.

###CLSideSlideViewControllerDelegate
<https://l-jay.github.io/CLSideSlideController/CLSideSlideController%20API/Protocols/CLSideSlideViewControllerDelegate.html>
