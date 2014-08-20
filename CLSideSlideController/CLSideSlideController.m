//
//  CLSideSlideController.m
//  CLSideSlideController
//
//  Created by L on 14-3-18.
//  Copyright (c) 2014年 Cui. All rights reserved.
//

#import "CLSideSlideController.h"
#import "CLSideSlideUtils.h"

#define ParallaxDis 100

@interface CLSideSlideController ()

@property (nonatomic, retain) UITabBarController *mainController;

@property (nonatomic) BOOL leftAnimation;
@property (nonatomic) BOOL rightAnimation;

@property (nonatomic, readonly) BOOL canShowLeft;
@property (nonatomic, readonly) BOOL canShowRight;

@property (nonatomic, retain) UIControl *mainViewMask;
@property (nonatomic, retain) UIControl *leftViewMask;
@property (nonatomic, retain) UIControl *rightViewMask;

@property (nonatomic, retain) UIImageView *backgroundImageView;


@property (nonatomic) BOOL shouldReAddView; //beign 为0

@property (nonatomic) BOOL willShowLeft;
@property (nonatomic) BOOL willShowRight;


@property (nonatomic) BOOL is3DRotate;

@end

@implementation CLSideSlideController
#pragma mark - dealloc
- (void)dealloc
{
    SSRELEASE(_backgroundImage);
    
    SSRELEASE(_backgroundImageView);
    
    SSRELEASE(_mainViewMask);
    SSRELEASE(_leftViewMask);
    SSRELEASE(_rightViewMask);
    
    SSRELEASE(_mainController);
    SSRELEASE(_leftViewController);
    SSRELEASE(_rightViewController);
    
    SSRELEASE(_viewControllers);
    
    [super dealloc];
}

#pragma mark - init
- (id)init
{
    if (self = [super init]) {
        //============== KVO
        [self addObserver:self forKeyPath:@"viewControllers" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"leftViewController" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"rightViewController" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"showMianViewShadow" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"showLeftViewShadow" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"showRightViewShadow" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"animationType" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"leftViewFillScreen" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"rightViewFillScreen" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"canTouchWhenShow" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"showMainViewMask" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"showLeftViewMask" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"showRightViewMask" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"backgroundImage" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"statusStyle" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"animation7Scale" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        //============== ImageView
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:imageView];
        self.backgroundImageView = imageView;
        [imageView release];
        
        //============== RootView
        UITabBarController *tabbarController = [[UITabBarController alloc] init];
        tabbarController.tabBar.hidden = YES;
        
        if (!IOS7AndMore) {
            tabbarController.view.frame = self.view.bounds;
            UIView *view0 = [tabbarController.view.subviews objectAtIndex:0];
            UIView *view1 = [tabbarController.view.subviews objectAtIndex:1];
            UIView *contentV = [view0 isKindOfClass:[UITabBar class]] ? view1 : view0;
            contentV.frame = tabbarController.view.bounds;
        }
        
        tabbarController.moreNavigationController.delegate = self;
        //tabbarController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        tabbarController.view.layer.shadowOffset = CGSizeZero;
        tabbarController.view.layer.shadowOpacity = 0.7f;
        [self addChildViewController:tabbarController];
        [self.view addSubview:tabbarController.view];
        self.mainController = tabbarController;
        [tabbarController release];
        
        //============== MaskView
        UIControl *mainControl = [[UIControl alloc] initWithFrame:tabbarController.view.bounds];
        mainControl.alpha = 0;
        self.mainViewMask = mainControl;
        [mainControl release];
        
        UIControl *leftControl = [[UIControl alloc] init];
        leftControl.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        leftControl.alpha = 1;
        self.leftViewMask = leftControl;
        [leftControl release];
        
        UIControl *rightControl = [[UIControl alloc] init];
        rightControl.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        rightControl.alpha = 1;
        self.rightViewMask = rightControl;
        [rightControl release];
        
        //============== Gesture
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRootView:)];
        tapGesture.delegate = self;
        [self.mainController.view addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragContentView:)];
        panGesture.delegate = self;
        [self.mainController.view addGestureRecognizer:panGesture];
        [panGesture release];
        
        //============== InitData
        self.leftViewWidth = 280;
        self.rightViewWidth = 280;
        
        self.animationType = CLSideSlideShowViewAnimationNormal;
        self.animation7Scale = 0.8;
        
        self.scrollContinuous = YES;
        
        self.showMianViewShadow = YES;
        
        self.leftViewFillScreen = YES;
        self.rightViewFillScreen = YES;
        
        self.canTouchWhenShow = YES;
    }
    
    return self;
}

#pragma mark - Gesture
- (void)showRootView:(id)sender
{
    [self.view endEditing:YES];
    
    if (self.isShowLeftView)
        [self hideLeftViewWithAnimation:self.leftAnimation];
    
    if (self.isShowRightView)
        [self hideRightViewWithAnimation:self.rightAnimation];
}

- (void)dragContentView:(UIPanGestureRecognizer *)panGesture
{
    CGFloat moveDistance = [panGesture translationInView:self.mainController.view].x;
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        [self.view endEditing:YES];
                
        //=================
        if (!self.isShowLeftView && !self.isShowRightView) {
            //=================
            if (moveDistance > 0) {
                self.willShowLeft = YES;
                self.willShowRight = NO;
            }
            else if (moveDistance < 0) {
                self.willShowLeft = NO;
                self.willShowRight = YES;
            }
            
            //=================
            if (moveDistance == 0 && !self.scrollContinuous) {
                self.shouldReAddView = YES;
                return;
            }else
                self.shouldReAddView = NO;
            
            //=================
            if ([self.delegate respondsToSelector:@selector(sideSlideController:willShowLeftViewController:)])
                [self.delegate sideSlideController:self willShowLeftViewController:moveDistance >= 0];
            
            
            //=================
            UIView *tempView = moveDistance > 0 ? self.leftViewController.view : self.rightViewController.view;
            
            //=================
            if (!self.scrollContinuous)
                [self.view insertSubview:tempView belowSubview:self.mainController.view];
            
            //=================
            switch (self.animationType) {
                case CLSideSlideShowViewAnimationScaleBig:
                case CLSideSlideShowViewAnimationScaleSmall:
                case CLSideSlideShowViewAnimationFor7Scale:
                {
                    if (self.scrollContinuous) {
                        [self.view insertSubview:self.leftViewController.view belowSubview:self.mainController.view];
                        [self.view insertSubview:self.rightViewController.view belowSubview:self.mainController.view];
                    }else {
                        [self.view insertSubview:tempView belowSubview:self.mainController.view];
                    }
                    
                    CGFloat scale = 0;
                    if (self.animationType == CLSideSlideShowViewAnimationScaleBig)
                        scale = 0.88;
                    else if (self.animationType == CLSideSlideShowViewAnimationScaleSmall)
                        scale = 1.12;
                    else
                        scale = 1.2;
                    
                    tempView.transform = CGAffineTransformMakeScale(scale, scale);
                }
                    break;
                default:
                    break;
            }
        }else if (self.isShowLeftView && !self.isShowRightView) {
            //=================
            if (moveDistance < 0) {
                if ([self.delegate respondsToSelector:@selector(sideSlideController:willHideLeftViewController:)])
                    [self.delegate sideSlideController:self willHideLeftViewController:YES];
            }
            
        }else if (!self.isShowLeftView && self.isShowRightView) {
            //=================
            if (moveDistance > 0) {
                if ([self.delegate respondsToSelector:@selector(sideSlideController:willHideLeftViewController:)])
                    [self.delegate sideSlideController:self willHideLeftViewController:NO];
            }
        }
    }else if (panGesture.state == UIGestureRecognizerStateChanged) {
        //=================
        if (self.scrollContinuous || self.shouldReAddView) {
            UIView *tempView = nil;
            if (self.mainController.view.ssMinX > 0) {
                tempView = self.leftViewController.view;
                
                [self.rightViewController.view removeFromSuperview];
            }
            else if (self.mainController.view.ssMaxX < self.view.ssWidth) {
                tempView = self.rightViewController.view;
                
                [self.leftViewController.view removeFromSuperview];
            }
            
            [self.view insertSubview:tempView belowSubview:self.mainController.view];
        }
        
        
        //================= 
        if (self.isShowLeftView && moveDistance < 0) {
            //================= Just One View
            if (!self.canShowRight && moveDistance <= -self.leftViewWidth) {
                moveDistance = -self.leftViewWidth;
            }
            
            //================= Postion
            CGFloat currentMinX = self.leftViewWidth + moveDistance;
            self.mainController.view.ssMoveMinX = self.scrollContinuous ? currentMinX : (currentMinX < 0 ? 0 : currentMinX);
            
        }else if (self.isShowRightView && moveDistance > 0) {
            //================= Just One View
            if (!self.canShowLeft && moveDistance >= self.rightViewWidth) {
                moveDistance = self.rightViewWidth;
            }
            
            //================= Postion
            CGFloat currentMaxX = self.view.ssWidth - self.rightViewWidth + moveDistance;
            self.mainController.view.ssMoveMaxX = self.scrollContinuous ? currentMaxX : (currentMaxX > self.view.ssWidth ? self.view.ssWidth : currentMaxX);
            
        }else if (!self.isShowLeftView && !self.isShowRightView){
            //================== Just One View
            if (!self.canShowRight && moveDistance < 0) {
                moveDistance = 0;
            }else if (!self.canShowLeft && moveDistance > 0) {
                moveDistance = 0;
            }
            
            //================== Continuous
            if (self.scrollContinuous) {
                if ((self.animationType == CLSideSlideShowViewAnimationFor7 || self.animationType == CLSideSlideShowViewAnimationFor7Scale) && self.mainController.view.ssMaxX < self.view.ssWidth)
                    self.mainController.view.ssMoveMaxX = self.view.ssWidth + moveDistance;
                else
                    self.mainController.view.ssMoveMinX = moveDistance;
            }
            else {
                //================= NO Continuous
                if (self.willShowLeft) {
                    if (moveDistance > self.leftViewWidth)
                        moveDistance = self.leftViewWidth;
                    else if (moveDistance < 0)
                        moveDistance = 0;
                    self.mainController.view.ssMoveMinX = moveDistance;
                }else if (self.willShowRight) {
                    if (moveDistance > 0)
                        moveDistance = 0;
                    else if (moveDistance < -self.rightViewWidth)
                        moveDistance = -self.rightViewWidth;
                    
                    self.mainController.view.ssMoveMaxX = self.view.ssWidth + moveDistance;
                }
            }
        }
        
        //================= Animation
        switch (self.animationType) {
            case CLSideSlideShowViewAnimationScaleBig: {
                if (self.mainController.view.ssMinX >= 0 && self.mainController.view.ssMinX <= self.leftViewWidth) {
                    CGFloat scale = 0.88 + self.mainController.view.ssMinX / self.leftViewWidth * 0.12;
                    self.leftViewController.view.transform = CGAffineTransformMakeScale(scale, scale);
                }else if (self.mainController.view.ssMaxX >= self.view.ssWidth - self.rightViewWidth && self.mainController.view.ssMaxX <= self.view.ssWidth) {
                    CGFloat scale = 0.88 + (self.view.ssWidth - self.mainController.view.ssMaxX) / self.rightViewWidth *0.12;
                    self.rightViewController.view.transform = CGAffineTransformMakeScale(scale, scale);
                }
            }
                break;
            case CLSideSlideShowViewAnimationScaleSmall: {
                if (self.mainController.view.ssMinX >= 0 && self.mainController.view.ssMinX <= self.leftViewWidth) {
                    CGFloat scale = 1.12 - self.mainController.view.ssMinX / self.leftViewWidth * 0.12;
                    self.leftViewController.view.transform = CGAffineTransformMakeScale(scale, scale);
                }else if (self.mainController.view.ssMaxX >= self.view.ssWidth - self.rightViewWidth && self.mainController.view.ssMaxX <= self.view.ssWidth) {
                    CGFloat scale = 1.12 - (self.view.ssWidth - self.mainController.view.ssMaxX) / self.rightViewWidth *0.12;
                    self.rightViewController.view.transform = CGAffineTransformMakeScale(scale, scale);
                }
            }
                break;
            case CLSideSlideShowViewAnimationFor7:
            case CLSideSlideShowViewAnimationFor7Scale:
                if (self.mainController.view.ssMinX >= 0 && self.mainController.view.ssMinX <= self.leftViewWidth) {
                    CGFloat scale = 1 - self.mainController.view.ssMinX / self.leftViewWidth * (1.0 - self.animation7Scale);
                    self.mainController.view.transform = CGAffineTransformMakeScale(scale, scale);
                    
                    //==============
                    if (self.animationType == CLSideSlideShowViewAnimationFor7Scale) {
                        CGFloat leftScale = 1.2 - self.mainController.view.ssMinX / self.leftViewWidth * 0.2;
                        self.leftViewController.view.transform = CGAffineTransformMakeScale(leftScale, leftScale);
                    }
                }else if (self.mainController.view.ssMaxX >= self.view.ssWidth - self.rightViewWidth && self.mainController.view.ssMaxX <= self.view.ssWidth) {
                    CGFloat scale = 1 - (self.view.ssWidth - self.mainController.view.ssMaxX) / self.rightViewWidth * (1 - self.animation7Scale);
                    self.mainController.view.transform = CGAffineTransformMakeScale(scale, scale);
                    
                    //==============
                    if (self.animationType == CLSideSlideShowViewAnimationFor7Scale) {
                        CGFloat rightScale = 1.2 - (self.view.ssWidth - self.mainController.view.ssMaxX) / self.rightViewWidth *0.2;
                        self.rightViewController.view.transform = CGAffineTransformMakeScale(rightScale, rightScale);
                    }
                }
                break;
            case CLSideSlideShowViewAnimationParallax:
                if (self.mainController.view.ssMinX >= 0 && self.mainController.view.ssMinX <= self.leftViewWidth) {
                    self.leftViewController.view.ssMoveMinX = self.mainController.view.ssMinX / self.leftViewWidth * ParallaxDis - ParallaxDis;
                    
                }else if (self.mainController.view.ssMaxX >= self.view.ssWidth - self.rightViewWidth && self.mainController.view.ssMaxX <= self.view.ssWidth) {
                    CGFloat currentMaxX = ParallaxDis - (self.view.ssWidth - self.mainController.view.ssMaxX) / self.rightViewWidth * ParallaxDis + self.view.ssWidth;
                    self.rightViewController.view.ssMoveMaxX = currentMaxX;
                }
                break;
            default:
                break;
        }
        
        //================= Alpha
        if (self.mainController.view.ssMinX >= 0 && self.mainController.view.ssMinX <= self.leftViewWidth) {
            
            CGFloat scale = self.mainController.view.ssMinX / self.leftViewWidth;
            self.mainViewMask.alpha = scale;
            self.leftViewMask.alpha = 1 - scale;
            
        }else if (self.mainController.view.ssMaxX >= self.view.ssWidth - self.rightViewWidth && self.mainController.view.ssMaxX <= self.view.ssWidth) {
            
            CGFloat scale = (self.view.ssWidth - self.mainController.view.ssMaxX) / self.rightViewWidth;
            self.mainViewMask.alpha = scale;
            self.rightViewMask.alpha = 1 - scale;
        }
        
    }else if (panGesture.state == UIGestureRecognizerStateEnded) {
        //=================
        if (self.mainController.view.ssMinX > self.leftViewWidth*0.5 && self.mainController.view.ssMaxX > self.view.ssWidth) {
            //=================
            if ([self.delegate respondsToSelector:@selector(sideSlideController:willShowLeftViewController:)])
                [self.delegate sideSlideController:self willShowLeftViewController:YES];
            
            
            //=================
            [UIView animateWithDuration:0.2 animations:^{
                self.mainController.view.ssMoveMinX = self.leftViewWidth;
                
                self.mainViewMask.alpha = 1.0;
                
                self.leftViewMask.alpha = 0;
                
                //================= Animation
                switch (self.animationType) {
                    case CLSideSlideShowViewAnimationScaleBig:
                    case CLSideSlideShowViewAnimationScaleSmall:
                        self.leftViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        break;
                    case CLSideSlideShowViewAnimationFor7:
                    case CLSideSlideShowViewAnimationFor7Scale:
                    {
                        self.mainController.view.transform = CGAffineTransformMakeScale(self.animation7Scale, self.animation7Scale);
                        
                        if (self.animationType == CLSideSlideShowViewAnimationFor7Scale)
                            self.leftViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    }
                        break;
                    case CLSideSlideShowViewAnimationParallax:
                        self.leftViewController.view.ssMoveMinX = 0;
                        break;
                    default:
                        break;
                }
            }completion:^(BOOL finish){
                _isShowLeftView = YES;
                _isShowRightView = NO;
                self.leftAnimation = YES;
                
                //=================
                if ([self.delegate respondsToSelector:@selector(sideSlideController:didShowLeftViewController:)])
                    [self.delegate sideSlideController:self didShowLeftViewController:YES];
            }];
        }else if (self.mainController.view.ssMaxX < self.view.ssWidth - self.rightViewWidth*0.5 && self.mainController.view.ssMinX < 0) {
            //=================
            if ([self.delegate respondsToSelector:@selector(sideSlideController:willShowLeftViewController:)])
                [self.delegate sideSlideController:self willShowLeftViewController:NO];
            
            
            //=================
            [UIView animateWithDuration:0.2 animations:^{
                //=================
                switch (self.animationType) {
                    case CLSideSlideShowViewAnimationScaleBig:
                    case CLSideSlideShowViewAnimationScaleSmall:
                        self.rightViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        break;
                    case CLSideSlideShowViewAnimationFor7:
                    case CLSideSlideShowViewAnimationFor7Scale:
                    {
                        self.mainController.view.transform = CGAffineTransformMakeScale(self.animation7Scale, self.animation7Scale);
                        
                        if (self.animationType == CLSideSlideShowViewAnimationFor7Scale)
                            self.rightViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    }
                        break;
                    case CLSideSlideShowViewAnimationParallax:
                        self.rightViewController.view.ssMoveMaxX = self.view.ssWidth;
                        break;
                    default:
                        break;
                }
                
                self.mainViewMask.alpha = 1.0;
                
                self.rightViewMask.alpha = 0;
                
                self.mainController.view.ssMoveMaxX = self.view.ssWidth - self.rightViewWidth;
            }completion:^(BOOL finish){
                _isShowLeftView = NO;
                _isShowRightView = YES;
                self.rightAnimation = YES;
                
                //=================
                if ([self.delegate respondsToSelector:@selector(sideSlideController:didShowLeftViewController:)])
                    [self.delegate sideSlideController:self didShowLeftViewController:NO];
            }];
        }else {
            [UIView animateWithDuration:0.2 animations:^{
                //=================
                switch (self.animationType) {
                    case CLSideSlideShowViewAnimationScaleBig:
                        self.leftViewController.view.transform = CGAffineTransformMakeScale(0.88, 0.88);
                        self.rightViewController.view.transform = CGAffineTransformMakeScale(0.88, 0.88);
                        break;
                    case CLSideSlideShowViewAnimationFor7:
                    case CLSideSlideShowViewAnimationFor7Scale:
                        self.mainController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        
                        if (self.animationType == CLSideSlideShowViewAnimationFor7Scale) {
                            self.leftViewController.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
                            self.rightViewController.view.transform = CGAffineTransformMakeScale(1.2, 0.88);
                        }
                        break;
                    case CLSideSlideShowViewAnimationParallax:
                        self.leftViewController.view.ssMoveMinX = -ParallaxDis;
                        self.rightViewController.view.ssMoveMaxX = self.view.ssWidth + ParallaxDis;
                    default:
                        break;
                }
                
                self.mainViewMask.alpha = 0;
                
                self.leftViewMask.alpha = 1;
                self.rightViewMask.alpha = 1;
                
                self.mainController.view.ssMoveMinX = 0;
            }completion:^(BOOL finish){
                if ([self.delegate respondsToSelector:@selector(sideSlideController:didHideLeftViewController:)]) {
                    if (self.isShowLeftView && !self.isShowRightView)
                        [self.delegate sideSlideController:self didHideLeftViewController:YES];
                    else if (!self.isShowLeftView && self.isShowRightView)
                        [self.delegate sideSlideController:self didHideLeftViewController:NO];
                }
                
                if ([self.delegate respondsToSelector:@selector(didShowRootViewControllerForSideSlideController:)])
                    [self.delegate didShowRootViewControllerForSideSlideController:self];
                
                
                _isShowLeftView = NO;
                _isShowRightView = NO;
                
                switch (self.animationType) {
                    case CLSideSlideShowViewAnimationScaleBig:
                        self.leftViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        self.rightViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        break;
                    case CLSideSlideShowViewAnimationParallax:
                        self.leftViewController.view.ssMoveMinX = 0;
                        self.rightViewController.view.ssMoveMinX = 0;
                    default:
                        break;
                }
                
                [self.leftViewController.view removeFromSuperview];
                [self.rightViewController.view removeFromSuperview];
                
                [self resizeMainView];
            }];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.is3DRotate)
        return NO;
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGFloat moveDistance = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.view].x;
        
        if (!self.isShowLeftView && !self.isShowRightView) {
            if ((moveDistance > 0 && !self.canShowLeft) || (moveDistance < 0 && !self.canShowRight))
                return NO;
        }
        else if (self.isShowLeftView && moveDistance > 0)
            return NO;
        else if (self.isShowRightView && moveDistance < 0)
            return NO;
        
        
        return YES;
    }else if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.isShowLeftView || self.isShowRightView)
            return YES;
        else
            return NO;
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        if (self.isShowLeftView || self.isShowRightView)
            return YES;
        else
            return NO;
    }

    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && !self.canShowLeft && !self.canShowRight)
        return NO;
    
    UIViewController *currentRootController = nil;
    if ([self.mainController.selectedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *tempNav = (UINavigationController *)self.mainController.selectedViewController;
        UINavigationController *moreNav = self.mainController.moreNavigationController;
        
        if (tempNav.rootController)
            currentRootController = tempNav.rootController;
        else if (moreNav && moreNav.viewControllers.count > 1)
            currentRootController = [moreNav.viewControllers objectAtIndex:1];
        }
    
    if (self.currentViewController == currentRootController || self.currentViewController == self.mainController.selectedViewController) {
        return YES;
    }
    
    return NO;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"viewControllers"]) {
        //=================
        for (UIViewController *controller in self.viewControllers)
            [self setSideSlideControllerForViewController:controller];
        
        self.mainController.viewControllers = self.viewControllers;
        
    }else if ([keyPath isEqualToString:@"leftViewController"]) {
        //=================
        if (!IOS7AndMore) {
            if ([self.leftViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *tempNav = (UINavigationController *)self.leftViewController;
                tempNav.view.frame = self.view.bounds;
            }else
                self.leftViewController.view.frame = self.view.bounds;
        }
        
        //=================
        if (self.leftViewController)
            _canShowLeft = YES;
        else {
            _canShowLeft = NO;
            
            return;
        }
        
        //=================
        self.leftViewController.view.layer.shadowOffset = CGSizeZero;
        self.leftViewController.view.layer.shadowOpacity = 0.7f;
        
        if (!self.leftViewFillScreen)
            self.leftViewController.view.ssWidth = self.leftViewWidth;
        
        self.leftViewMask.frame = self.leftViewController.view.bounds;
        
        if (self.showLeftViewMask)
            [self.leftViewController.view addSubview:self.leftViewMask];
        
        [self addChildViewController:self.leftViewController];
        
        [self setSideSlideControllerForViewController:self.leftViewController];
        
    }else if ([keyPath isEqualToString:@"rightViewController"]) {
        //=================
        if (!IOS7AndMore) {
            if ([self.rightViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *tempNav = (UINavigationController *)self.rightViewController;
                tempNav.view.frame = self.view.bounds;
            }else
                self.rightViewController.view.frame = self.view.bounds;
        }
        
        //=================
        if (self.rightViewController)
            _canShowRight = YES;
        else {
            _canShowRight = NO;
            
            return;
        }
        
        //=================
        self.rightViewController.view.layer.shadowOffset = CGSizeZero;
        self.rightViewController.view.layer.shadowOpacity = 0.7f;
        
        if (!self.rightViewFillScreen) {
            self.rightViewController.view.ssMoveMinX = self.view.ssWidth - self.rightViewWidth;
            self.rightViewController.view.ssWidth = self.rightViewWidth;
        }
        
        self.rightViewMask.frame = self.rightViewController.view.bounds;
        
        if (self.showRightViewMask)
            [self.rightViewController.view addSubview:self.rightViewMask];
        
        [self addChildViewController:self.rightViewController];
        
        [self setSideSlideControllerForViewController:self.rightViewController];
        
    }else if ([keyPath isEqualToString:@"showMianViewShadow"]) {
        //=================
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect: self.showMianViewShadow ? self.mainController.view.bounds : CGRectZero];
        self.mainController.view.layer.shadowPath = shadowPath.CGPath;
        
    }else if ([keyPath isEqualToString:@"showLeftViewShadow"]) {
        //=================
        CGRect shadowRect = self.showLeftViewShadow ? self.leftViewController.view.bounds : CGRectZero;
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:shadowRect];
        self.leftViewController.view.layer.shadowPath = shadowPath.CGPath;
        
    }else if ([keyPath isEqualToString:@"showRightViewShadow"]) {
        //=================
        CGRect shadowRect = self.showRightViewShadow ? self.rightViewController.view.bounds : CGRectZero;
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:shadowRect];
        self.rightViewController.view.layer.shadowPath = shadowPath.CGPath;
        
    }else if ([keyPath isEqualToString:@"animationType"]) {
        //=================
        if (self.animationType == CLSideSlideShowViewAnimationScaleBig ||
            self.animationType == CLSideSlideShowViewAnimationScaleSmall) {
            self.showLeftViewShadow = YES;
            self.showRightViewShadow = YES;
        }else {
            self.showLeftViewShadow = NO;
            self.showRightViewShadow = NO;
        }
        
        //=================
        if (self.animationType == CLSideSlideShowViewAnimationFor7 ||
            self.animationType == CLSideSlideShowViewAnimationFor7Scale) {
            if (self.isShowLeftView || self.isShowRightView)
                [UIView animateWithDuration:0.2 animations:^{
                   self.mainController.view.transform = CGAffineTransformMakeScale(self.animation7Scale, self.animation7Scale);
                }];
        }else {
            if ((self.isShowLeftView || self.isShowRightView) && self.mainController.view.transform.tx != 1)
                [UIView animateWithDuration:0.2 animations:^{
                    self.mainController.view.transform = CGAffineTransformMakeScale(1, 1);
                }];
        }
        
    }else if ([keyPath isEqualToString:@"leftViewFillScreen"]) {
        //=================
        if (!self.leftViewFillScreen)
            self.leftViewController.view.ssWidth = self.leftViewWidth;
        else
            self.leftViewController.view.ssWidth = self.view.ssWidth;
        
    }else if ([keyPath isEqualToString:@"rightViewFillScreen"]) {
        //=================
        if (!self.rightViewFillScreen) {
            self.rightViewController.view.ssMoveMinX = self.view.ssWidth - self.rightViewWidth;
            self.rightViewController.view.ssWidth = self.rightViewWidth;
        }else {
            self.rightViewController.view.ssMoveMinX = 0;
            self.rightViewController.view.ssWidth = self.view.ssWidth;
        }
        
    }else if ([keyPath isEqualToString:@"canTouchWhenShow"]) {
        //=================
        if (self.canTouchWhenShow)
            [self.mainViewMask removeFromSuperview];
        else
            [self.mainController.view addSubview:self.mainViewMask];
        
    }else if ([keyPath isEqualToString:@"showMainViewMask"]) {
        //=================
        self.mainViewMask.backgroundColor = self.showMainViewMask ? [UIColor colorWithWhite:0 alpha:0.4] : [UIColor clearColor];
        
    }else if ([keyPath isEqualToString:@"showLeftViewMask"]) {
        //=================
        if (self.showLeftViewMask)
            [self.leftViewController.view addSubview:self.leftViewMask];
        else
            [self.leftViewMask removeFromSuperview];
        
    }else if ([keyPath isEqualToString:@"showRightViewMask"]) {
        //=================
        if (self.showRightViewMask)
            [self.rightViewController.view addSubview:self.rightViewMask];
        else
            [self.rightViewMask removeFromSuperview];
        
    }else if ([keyPath isEqualToString:@"backgroundImage"]) {
        //=================
        self.backgroundImageView.image = [UIImage imageNamed:self.backgroundImage];
    }else if ([keyPath isEqualToString:@"statusStyle"]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        if (IOS7AndMore)
            [self setNeedsStatusBarAppearanceUpdate];
#endif
    }else if ([keyPath isEqualToString:@"animation7Scale"]) {
        if (self.animation7Scale < 0.5)
            self.animation7Scale = 0.5;
    }
}

- (void)setSideSlideControllerForViewController:(UIViewController *)controller
{
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *tempController = (UINavigationController *)controller;
        tempController.rootController.sideSlideController = self;
        tempController.delegate = self;
    }else
        controller.sideSlideController = self;
}

#pragma mark - Show And Hide View
- (void)showLeftViewWithAnimation:(BOOL)animation
{
    if (!self.canShowLeft)
        return;
    
    if ([self.delegate respondsToSelector:@selector(sideSlideController:willShowLeftViewController:)])
        [self.delegate sideSlideController:self willShowLeftViewController:YES];
    
    [self.view endEditing:YES];
    
    self.leftAnimation = animation;
    
    [self showViewIsLeft:YES isShow:YES animation:animation];
}

- (void)showRightViewWithAnimation:(BOOL)animation
{
    if (!self.canShowRight)
        return;
    
    if ([self.delegate respondsToSelector:@selector(sideSlideController:willShowLeftViewController:)])
        [self.delegate sideSlideController:self willShowLeftViewController:NO];
    
    [self.view endEditing:YES];
    
    self.rightAnimation = animation;
    
    [self showViewIsLeft:NO isShow:YES animation:animation];
}

- (void)hideLeftViewWithAnimation:(BOOL)animation
{
    if ([self.delegate respondsToSelector:@selector(sideSlideController:willHideLeftViewController:)])
        [self.delegate sideSlideController:self willHideLeftViewController:YES];
    
    [self showViewIsLeft:YES isShow:NO animation:animation];
}

- (void)hideRightViewWithAnimation:(BOOL)animation
{
    if ([self.delegate respondsToSelector:@selector(sideSlideController:willHideLeftViewController:)])
        [self.delegate sideSlideController:self willHideLeftViewController:NO];
    
    [self showViewIsLeft:NO isShow:NO animation:animation];
}

- (void)showViewIsLeft:(BOOL)isLeft isShow:(BOOL)isShow animation:(BOOL)animation
{
    //=================
    if ((isLeft && self.isShowLeftView && isShow) || (!isLeft && self.isShowRightView && isShow))
        return;
    
    //=================
    UIView *showView = isLeft ? self.leftViewController.view : self.rightViewController.view;
    
    if (!showView || ![showView isKindOfClass:[UIView class]])
        return;
    
    if (isShow)
        [self.view insertSubview:showView belowSubview:self.mainController.view];
    
    
    //=================
    if (animation) {
        switch (self.animationType) {
            case 0:
                [self animationNormal:isLeft isShow:isShow];
                break;
            case 1:
            case 2:
                [self animationSacle:isLeft isShow:isShow];
                break;
            case 3:
                [self animationDithering:isLeft isShow:isShow];
                break;
            case 4:
                [self animationPucker:isLeft isShow:isShow];
                break;
            case 5:
            case 6:
                [self animationFor7:isLeft isShow:isShow];
                break;
            case 7:
                [self animationParallax:isLeft isShow:isShow];
                break;
            default:
                [self animationNormal:isLeft isShow:isShow];
                break;
        }
    }else {
        if (isShow) {
            //=================
            self.mainController.view.ssMoveMinX = isLeft ? self.leftViewWidth : -self.rightViewWidth;
            
            //=================
            self.mainViewMask.alpha = 1.0;
            
            if (isLeft)
                self.leftViewMask.alpha = 0;
            else
                self.rightViewMask.alpha = 0;
            
            //=================
            if ([self.delegate respondsToSelector:@selector(sideSlideController:didShowLeftViewController:)])
                [self.delegate sideSlideController:self didShowLeftViewController:isLeft];
            
        }else {
            //=================
            self.mainController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.leftViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.rightViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
            //=================
            self.mainController.view.ssMoveMinX = 0;
            
            //=================
            self.mainViewMask.alpha = 0;
            
            self.leftViewMask.alpha = 1.0;
            self.rightViewMask.alpha = 1.0;
            
            //=================
            isLeft ? [self.leftViewController.view removeFromSuperview] : [self.rightViewController.view removeFromSuperview];
            
            //=================
            if ([self.delegate respondsToSelector:@selector(sideSlideController:didHideLeftViewController:)])
                [self.delegate sideSlideController:self didHideLeftViewController:isLeft];
            
            if ([self.delegate respondsToSelector:@selector(didShowRootViewControllerForSideSlideController:)])
                [self.delegate didShowRootViewControllerForSideSlideController:self];
        }
        
        //=================
        _isShowLeftView = isLeft&&isShow;
        _isShowRightView = !isLeft&&isShow;
    }
}

#pragma mark - Rotate And Scale MainView
- (void)rotateScaleMainView
{
    //=================
    if (self.isShowLeftView || self.isShowRightView)
        return;
    
    //=================
    if (self.is3DRotate) {
        if ([self.delegate respondsToSelector:@selector(willRecoverMainViewForSideSlideController:)])
            [self.delegate willRecoverMainViewForSideSlideController:self];
    }else {
        if ([self.delegate respondsToSelector:@selector(willRotateSacleMianViewForSideSlideController:)])
            [self.delegate willRotateSacleMianViewForSideSlideController:self];
    }
    
    //=================
    [UIView animateWithDuration:0.2 animations:^{
        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DMakeScale(0.9, 0.9, 1);
        transform.m34 = 1.0f / (self.is3DRotate ? -400 : 400);
        transform = CATransform3DRotate(transform, M_PI / (self.is3DRotate ? 18 : -18), 1, 0, 0);
        self.mainController.view.layer.zPosition = 100;
        self.mainController.view.layer.transform = transform;
        
    }completion:^(BOOL finish){
        CGFloat scale = self.is3DRotate ? 1 : 0.88;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.mainController.view.transform = CGAffineTransformMakeScale(scale, scale);
            
        }completion:^(BOOL finish){
            //=================
            self.is3DRotate = !self.is3DRotate;
            
            //=================
            if (self.is3DRotate) {
                if ([self.delegate respondsToSelector:@selector(didRotateScaleMainViewForSideSlideController:)])
                    [self.delegate didRotateScaleMainViewForSideSlideController:self];
            }else {
                if ([self.delegate respondsToSelector:@selector(didRecoverMainViewForSideSlideController:)])
                    [self.delegate didRecoverMainViewForSideSlideController:self];
            }
        }];
    }];
}

#pragma mark - Animation Mehotds
- (void)animationNormal:(BOOL)isLeft isShow:(BOOL)isShow
{
    [UIView animateWithDuration:0.2 animations:^{
        if (isShow) {
            //=================
            self.mainController.view.ssMoveMinX = isLeft ? self.leftViewWidth : -self.rightViewWidth;
            
            //=================
            self.mainViewMask.alpha = 1.0;
            
            if (isLeft)
                self.leftViewMask.alpha = 0;
            else
                self.rightViewMask.alpha = 0;
        }
        else {
            //=================
            self.mainController.view.ssMoveMinX = 0;
            
            //=================
            self.mainViewMask.alpha = 0;
            
            self.leftViewMask.alpha = 1.0;
            self.rightViewMask.alpha = 1.0;
        }
    } completion:^(BOOL finish){
        [self finishIsLeft:isLeft isShow:isShow];
    }];
}

- (void)animationSacle:(BOOL)isLeft isShow:(BOOL)isShow
{
    //=================
    UIView *view = isLeft ? self.leftViewController.view : self.rightViewController.view;
    CGFloat changeScale = self.animationType == CLSideSlideShowViewAnimationScaleBig ? 0.88 : 1.12;
    
    //=================
    if (isShow)
        view.transform = CGAffineTransformMakeScale(changeScale, changeScale);
    
    //=================
    [UIView animateWithDuration:0.15 animations:^{
        //=================
        CGFloat scale = isShow ? 1.0 : changeScale;
        view.transform = CGAffineTransformMakeScale(scale, scale);
        
        //=================
        if (isShow) {
            //=================
            self.mainController.view.ssMoveMinX = isLeft ? self.leftViewWidth : -self.rightViewWidth;
            
            //=================
            self.mainViewMask.alpha = 1.0;
            
            if (isLeft)
                self.leftViewMask.alpha = 0;
            else
                self.rightViewMask.alpha = 0;
        }
        else {
            //=================
            self.mainController.view.ssMoveMinX = 0;
         
            //=================
            self.mainViewMask.alpha = 0;
            
            self.leftViewMask.alpha = 1.0;
            self.rightViewMask.alpha = 1.0;
        }
    }completion:^(BOOL finish){
        //=================
        view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        [self finishIsLeft:isLeft isShow:isShow];
    }];
}

- (void)animationDithering:(BOOL)isLeft isShow:(BOOL)isShow
{
    CGFloat duratoin1 = isShow ? 0.1 : 0.15;
    [UIView animateWithDuration:duratoin1 animations:^{
        self.mainController.view.ssMoveMinX = isLeft ? self.leftViewWidth + 20 : -self.rightViewWidth - 20;
        
        self.mainViewMask.alpha = isShow ? 1.0 : 0;
        
        if (isShow) {
            if (isLeft)
                self.leftViewMask.alpha = 0;
            else
                self.rightViewMask.alpha = 0;
        }
        else {
            self.leftViewMask.alpha = 1.0;
            self.rightViewMask.alpha = 1.0;
        }
        
    }completion:^(BOOL finish){
        CGFloat duratoin2 = isShow ? 0.1 : 0;
        [UIView animateWithDuration:duratoin2 animations:^{
            if (isShow)
                self.mainController.view.ssMoveMinX = isLeft ? self.leftViewWidth - 10 : -self.rightViewWidth + 10;
        }completion:^(BOOL finish){
            [UIView animateWithDuration:0.1 animations:^{
                self.mainController.view.ssMoveMinX = isShow ? (isLeft ? self.leftViewWidth : -self.rightViewWidth) : 0;
            }completion:^(BOOL finish){
                [self finishIsLeft:isLeft isShow:isShow];
            }];
        }];
    }];
}

- (void)animationPucker:(BOOL)isLeft isShow:(BOOL)isShow
{
    
}

- (void)animationFor7:(BOOL)isLeft isShow:(BOOL)isShow
{
    UIView *view = isLeft ? self.leftViewController.view : self.rightViewController.view;
    
    //=================
    if (isShow && self.animationType == CLSideSlideShowViewAnimationFor7Scale)
        view.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    //=================
    [UIView animateWithDuration:0.15 animations:^{
        CGFloat scale = isShow ? self.animation7Scale : 1.0;
        self.mainController.view.transform = CGAffineTransformMakeScale(scale, scale);
        
        if (isShow) {
            if (isLeft)
                self.mainController.view.ssMoveMinX = self.leftViewWidth;
            else
                self.mainController.view.ssMoveMaxX = self.view.ssWidth - self.rightViewWidth;
            
            
            self.mainViewMask.alpha = 1.0;
            
            if (isLeft)
                self.leftViewMask.alpha = 0;
            else
                self.rightViewMask.alpha = 0;
            
            //=================
            if (self.animationType == CLSideSlideShowViewAnimationFor7Scale)
                view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
        }else {
            self.mainController.view.ssMoveMinX = 0;
            
            self.mainViewMask.alpha = 0;
            
            self.leftViewMask.alpha = 1.0;
            self.rightViewMask.alpha = 1.0;
            
            //=================
            if (self.animationType == CLSideSlideShowViewAnimationFor7Scale)
                view.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }
    }completion:^(BOOL finish){
        //=================
        if (self.animationType == CLSideSlideShowViewAnimationFor7Scale)
            view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        [self finishIsLeft:isLeft isShow:isShow];
    }];
}

- (void)animationParallax:(BOOL)isLeft isShow:(BOOL)isShow
{
    //=================
    UIView *view = isLeft ? self.leftViewController.view : self.rightViewController.view;
    
    //=================
    if (isShow) {
        if (isLeft)
            view.ssMoveMinX = -ParallaxDis;
        else
            view.ssMoveMaxX = self.view.ssWidth + ParallaxDis;
    }
    
    //=================
    [UIView animateWithDuration:0.2 animations:^{
        if (isLeft) {
            view.ssMoveMinX = isShow ? 0 : -ParallaxDis;
            self.mainController.view.ssMoveMinX = isShow ? self.leftViewWidth : 0;
        }
        else {
            view.ssMoveMaxX = isShow ? self.view.ssWidth : self.view.ssWidth + ParallaxDis;
            self.mainController.view.ssMoveMinX = isShow ? -self.rightViewWidth : 0;
        }
        
        //=================
        if (isShow) {
            self.mainViewMask.alpha = 1.0;
            
            if (isLeft)
                self.leftViewMask.alpha = 0;
            else
                self.rightViewMask.alpha = 0;
        }
        else {
            self.mainViewMask.alpha = 0;
            
            self.leftViewMask.alpha = 1.0;
            self.rightViewMask.alpha = 1.0;
        }
        
    }completion:^(BOOL finish){
        view.ssMoveMinX = 0;
        [self finishIsLeft:isLeft isShow:isShow];
    }];
}

- (void)finishIsLeft:(BOOL)isLeft isShow:(BOOL)isShow
{
    //=================
    _isShowLeftView = isLeft&&isShow;
    _isShowRightView = !isLeft&&isShow;
    
    //=================
    if (!isShow) {
        isLeft ? [self.leftViewController.view removeFromSuperview] : [self.rightViewController.view removeFromSuperview];
        
        //=================
        [self resizeMainView];
    }
    
    //=================
    if (isShow) {
        if ([self.delegate respondsToSelector:@selector(sideSlideController:didShowLeftViewController:)])
            [self.delegate sideSlideController:self didShowLeftViewController:isLeft];
    }else {
        if ([self.delegate respondsToSelector:@selector(sideSlideController:didHideLeftViewController:)]) {
            [self.delegate sideSlideController:self didHideLeftViewController:isLeft];
        }
        
        if ([self.delegate respondsToSelector:@selector(didShowRootViewControllerForSideSlideController:)]) {
            [self.delegate didShowRootViewControllerForSideSlideController:self];
        }
    }
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController == self.leftViewController) {
        //=================
        _leftCurrentViewController = viewController;
        
    }else if (navigationController == self.rightViewController) {
        //=================
        _rightCurrentViewController = viewController;
        
    }else {
        if (navigationController == self.mainController.moreNavigationController) {
            //=================
            if (navigationController.viewControllers.count < 2)
                return;
            
            UIViewController *rootcontroller = [navigationController.viewControllers objectAtIndex:1];
            if ([rootcontroller isKindOfClass:NSClassFromString(@"UIMoreListController")])
                return;
            
            if (!rootcontroller.navigationItem.leftBarButtonItem) {
                for (UIView *v in rootcontroller.navigationController.navigationBar.subviews) {
                    if ([v isKindOfClass:NSClassFromString(@"UINavigationItemButtonView")] && viewController.navigationItem.leftBarButtonItem == nil) {
                        UIView *barbutton = [[UIView alloc] initWithFrame:CGRectZero];
                        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barbutton];
                        [barbutton release];
                    }
                }
            }
            
            //=================
            if ([navigationController.viewControllers objectAtIndex:1] != viewController) {
                
                if (!viewController.sideSlideController)
                    viewController.sideSlideController = self;
            }
        }else {
            //=================
            if (navigationController.rootController != viewController) {
                
                if (!viewController.sideSlideController)
                    viewController.sideSlideController = self;
                
            }
        }
        
        //=================
        if (![viewController isKindOfClass:NSClassFromString(@"UIMoreListController")])
            _currentViewController = viewController;
    }
}

#pragma mark - Methods
- (void)selectViewControllerAtIndex:(NSInteger)index
{
    if (index > self.viewControllers.count || self.currentSelectedIndex == index)
        return;
    
    self.mainController.selectedIndex = index;
    _currentSelectedIndex = index;
    
    //解决more和不用显示navbar
    if (![self.mainController.selectedViewController isKindOfClass:[UINavigationController class]]) {
        _currentViewController = self.mainController.selectedViewController;
        
        self.mainController.moreNavigationController.navigationBarHidden = YES;
    }else
        self.mainController.moreNavigationController.navigationBarHidden = NO;
}

- (void)resizeMainView
{
    if (self.animationType == CLSideSlideShowViewAnimationFor7 ||
        self.animationType == CLSideSlideShowViewAnimationFor7Scale) {
        if (self.mainController.view.ssWidth != self.view.ssWidth)
            self.mainController.view.ssWidth = self.view.ssWidth;
        
        if (self.mainController.view.ssHeight != self.view.ssHeight)
            self.mainController.view.ssHeight = self.view.ssHeight;
    }
}

- (void)resizeTabbarControllerContentView
{
    if (self.mainController.view.subviews.count < 2)
        return;
    
    UIView *contentView = [[self.mainController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ? [self.mainController.view.subviews objectAtIndex:1] : [self.mainController.view.subviews objectAtIndex:0];
    
    if (contentView)
        contentView.frame = self.view.bounds;
}

#pragma mark - Status Methods

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusStyle;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#endif

#pragma mark - AutoRotate
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - view load status
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self removeObserver:self forKeyPath:@"viewControllers"];
    [self removeObserver:self forKeyPath:@"leftViewController"];
    [self removeObserver:self forKeyPath:@"rightViewController"];
    [self removeObserver:self forKeyPath:@"showMianViewShadow"];
    [self removeObserver:self forKeyPath:@"showLeftViewShadow"];
    [self removeObserver:self forKeyPath:@"showRightViewShadow"];
    [self removeObserver:self forKeyPath:@"animationType"];
    [self removeObserver:self forKeyPath:@"leftViewFillScreen"];
    [self removeObserver:self forKeyPath:@"rightViewFillScreen"];
    [self removeObserver:self forKeyPath:@"canTouchWhenShow"];
    [self removeObserver:self forKeyPath:@"showMainViewMask"];
    [self removeObserver:self forKeyPath:@"showLeftViewMask"];
    [self removeObserver:self forKeyPath:@"showRightViewMask"];
    [self removeObserver:self forKeyPath:@"backgroundImage"];
    [self removeObserver:self forKeyPath:@"statusStyle"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end


#pragma mark - UIViewController(CLSideSlideController)
@implementation UIViewController(CLSideSlideController)

static char const * const ssController = "ssController";

- (CLSideSlideController *)sideSlideController
{
    return objc_getAssociatedObject(self, ssController);
}

- (void)setSideSlideController:(CLSideSlideController *)sideSlideController
{
    objc_setAssociatedObject(self, ssController, sideSlideController, OBJC_ASSOCIATION_ASSIGN);
}


- (void)setLeftBarItemShowLeftView:(BOOL)animation
{
    UIBarButtonItem *leftItem = self.navigationItem.leftBarButtonItem;
    leftItem.animation = animation;
    leftItem.target = self;
    leftItem.action = @selector(showLeft:);
}

- (void)showLeft:(id)sender
{
    UIBarButtonItem *item = (UIBarButtonItem *)sender;
    
    if (self.sideSlideController.isShowLeftView)
        [self.sideSlideController hideLeftViewWithAnimation:item.animation];
    else
        [self.sideSlideController showLeftViewWithAnimation:item.animation];
}


- (void)setRightBarItemShowRightView:(BOOL)animation
{
    UIBarButtonItem *rightItem = self.navigationItem.rightBarButtonItem;
    rightItem.animation = animation;
    rightItem.target = self;
    rightItem.action = @selector(showRight:);
}

- (void)showRight:(id)sender
{
    UIBarButtonItem *item = (UIBarButtonItem *)sender;
    
    if (self.sideSlideController.isShowRightView)
        [self.sideSlideController hideRightViewWithAnimation:item.animation];
    else
        [self.sideSlideController showRightViewWithAnimation:item.animation];
}


@end
