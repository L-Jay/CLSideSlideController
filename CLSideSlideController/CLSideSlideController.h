//
//  CLSideSlideController.h
//  CLSideSlideController
//
//  Created by L on 14-3-18.
//  Copyright (c) 2014年 Cui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    CLSideSlideShowViewAnimationNormal = 0, //普通
    CLSideSlideShowViewAnimationScaleBig,   //副视图缩放变大
    CLSideSlideShowViewAnimationScaleSmall, //副视图缩放变小
    CLSideSlideShowViewAnimationDithering,  //抖动
    CLSideSlideShowViewAnimationPucker,     //折叠
    CLSideSlideShowViewAnimationFor7,       //主视图缩放
    CLSideSlideShowViewAnimationFor7Scale,  //主、副视图缩放
    CLSideSlideShowViewAnimationParallax,   //视差
}CLSideSlideShowViewAnimation;

@protocol CLSideSlideViewControllerDelegate;

@interface CLSideSlideController : UIViewController<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
///---------------------------------------------------------------------------------------
/// @name 左/右视图宽
///---------------------------------------------------------------------------------------
/**
 *	@brief	左视图露出宽.
 */
@property (nonatomic) CGFloat leftViewWidth;

/**
 *	@brief	右视图露出宽.
 */
@property (nonatomic) CGFloat rightViewWidth;

///---------------------------------------------------------------------------------------
/// @name 设置主/左/右视图
///---------------------------------------------------------------------------------------
/**
 *	@brief	主视图数组.
 *
 *	@discussion	所有需要在主视图呈现的ViewController都要放在viewControllers中.
 */
@property (nonatomic, retain) NSArray *viewControllers;

/**
 *	@brief	左视图.
 */
@property (nonatomic, retain) UIViewController *leftViewController;

/**
 *	@brief	右视图.
 */
@property (nonatomic, retain) UIViewController *rightViewController;

///---------------------------------------------------------------------------------------
/// @name 动画类型
///---------------------------------------------------------------------------------------
/**
 *	@brief	弹出副视图动画类型,默认为CLSideSlideShowViewAnimationNormal.
 *
 *	@discussion	详见"CLSideSlideController.h"中CLSideSlideShowViewAnimation.
 */
@property (nonatomic) CLSideSlideShowViewAnimation animationType;

/**
 *	@brief	SideSlidShowViewAnimationFor7动画缩放级别,默认为0.8,最小缩放级别0.5.
 */
@property (nonatomic) CGFloat animation7Scale;

///---------------------------------------------------------------------------------------
/// @name 左/右视图状态
///---------------------------------------------------------------------------------------
/**
 *	@brief	是否已弹出左视图,YES为是.
 */
@property (nonatomic, readonly) BOOL isShowLeftView;

/**
 *	@brief	是否已弹出右视图,YES为是.
 */
@property (nonatomic, readonly) BOOL isShowRightView;

///---------------------------------------------------------------------------------------
/// @name 当前主/左/右视图显示视图
///---------------------------------------------------------------------------------------
/**
 *	@brief	当前主视图的Index.
 */
@property (nonatomic, readonly) NSInteger currentSelectedIndex;

/**
 *	@brief	主视图当前显示的ViewController.
 *
 *	@discussion	如果是UINavigationController则返回内部的ViewController.
 */
@property (nonatomic, assign, readonly) UIViewController *currentViewController;

/**
 *	@brief	左视图当前显示的ViewController.
 *
 *	@discussion	如果是UINavigationController则返回内部的ViewController.
 */
@property (nonatomic, assign, readonly) UIViewController *leftCurrentViewController;

/**
 *	@brief	右视图当前显示的ViewController.
 *
 *	@discussion	如果是UINavigationController则返回内部的ViewController.
 */
@property (nonatomic, assign, readonly) UIViewController *rightCurrentViewController;

///---------------------------------------------------------------------------------------
/// @name 连续滑动
///---------------------------------------------------------------------------------------
/**
 *	@brief	滑动主视图是否连续性,默认为YES,可连续.
 */
@property (nonatomic) BOOL scrollContinuous;

///---------------------------------------------------------------------------------------
/// @name 主/左/右视图阴影
///---------------------------------------------------------------------------------------
/**
 *	@brief	是否显示主视图阴影,默认为YES.
 */
@property (nonatomic) BOOL showMianViewShadow;

/**
 *	@brief	是否显示左视图阴影,默认为NO.
 *
 *	@discussion	左/右视图的阴影显示在设置动画效果的时候在内部已经设置,如果想要更改,在设置完动画后再设置阴影显示,否则设置动画后会被改回来.
 */
@property (nonatomic) BOOL showLeftViewShadow;


/**
 *	@brief	是否显示右视图阴影,默认为NO.
 *
 *	@discussion	左/右视图的阴影显示在设置动画效果的时候在内部已经设置,如果想要更改,在设置完动画后再设置阴影显示,否则设置动画后会被改回来.
 */
@property (nonatomic) BOOL showRightViewShadow;

///---------------------------------------------------------------------------------------
/// @name 左/右视图全屏显示
///---------------------------------------------------------------------------------------
/**
 *	@brief	左视图是否填满屏幕,默认为YES,填满.
 */
@property (nonatomic) BOOL leftViewFillScreen;

/**
 *	@brief	右视图是否填满屏幕,默认为YES,填满.
 */
@property (nonatomic) BOOL rightViewFillScreen;

///---------------------------------------------------------------------------------------
/// @name 主/左/右视图遮罩
///---------------------------------------------------------------------------------------
/**
 *	@brief	当弹出左/右视图的时候,主视图是否可接收手势,默认为YES,可接收.
 */
@property (nonatomic) BOOL canTouchWhenShow;

/**
 *	@brief	是否显示主视图遮罩当弹出左/右视图时,默认为NO,不显示.
 */
@property (nonatomic) BOOL showMainViewMask;

/**
 *	@brief	是否显示左视图遮罩当弹出主视图时,默认为NO,不显示.
 */
@property (nonatomic) BOOL showLeftViewMask;

/**
 *	@brief	是否显示右视图遮罩当弹出主视图时,默认为NO,不显示.
 */
@property (nonatomic) BOOL showRightViewMask;

///---------------------------------------------------------------------------------------
/// @name 背景图片
///---------------------------------------------------------------------------------------
/**
 *	@brief	背景图片,最底层,在所有视图之下.
 */
@property (nonatomic, copy) NSString *backgroundImage;

///---------------------------------------------------------------------------------------
/// @name 状态栏类型(iOS7)
///---------------------------------------------------------------------------------------
/**
 *	@brief	当前状态栏的样式,仅支持IOS7.
 */
@property (nonatomic) UIStatusBarStyle statusStyle;

///---------------------------------------------------------------------------------------
/// @name delegate
///---------------------------------------------------------------------------------------
/**
 *	@brief	CLSideSlideViewControllerDelegate,详见CLSideSlideController.h.
 */
@property (nonatomic, assign) id <CLSideSlideViewControllerDelegate> delegate;


///---------------------------------------------------------------------------------------
/// @name 弹出/隐藏左/右视图
///---------------------------------------------------------------------------------------
/**
 *	@brief	弹出左视图.
 *
 *	@param 	animation 	是否使用动画,YES为使用.
 */
- (void)showLeftViewWithAnimation:(BOOL)animation;

/**
 *	@brief	弹出右视图.
 *
 *	@param 	animation 	是否使用动画,YES为使用.
 */
- (void)showRightViewWithAnimation:(BOOL)animation;

/**
 *	@brief	隐藏左视图.
 *
 *	@param 	animation 	是否使用动画,YES为使用.
 */
- (void)hideLeftViewWithAnimation:(BOOL)animation;

/**
 *	@brief	隐藏右视图.
 *
 *	@param 	animation 	是否使用动画,YES为使用.
 */
- (void)hideRightViewWithAnimation:(BOOL)animation;

///---------------------------------------------------------------------------------------
/// @name 旋转缩放主视图
///---------------------------------------------------------------------------------------
/**
 *	@brief	旋转缩放主视图.
 *
 *	@param 	show 	YES,缩放;NO,复原.
 */
- (void)rotateScaleMainView;

///---------------------------------------------------------------------------------------
/// @name 选择当前显示主视图
///---------------------------------------------------------------------------------------
/**
 *	@brief	选择要显示的主视图.
 *
 *	@param 	Index 	选择视图在ViewControllers中得Index.
 */
- (void)selectViewControllerAtIndex:(NSInteger)index;

@end

#pragma mark - UIViewController(CLSideSlideController)

@interface UIViewController(CLSideSlideController)

///---------------------------------------------------------------------------------------
/// @name Property
///---------------------------------------------------------------------------------------
/**
 *	@brief	CLSideSlideController拓展属性,CLSideSlideController中所有ViewController都具有该属性.
 */
@property (nonatomic, assign) CLSideSlideController *sideSlideController;

///---------------------------------------------------------------------------------------
/// @name Methods
///---------------------------------------------------------------------------------------
/**
 *	@brief	设置NavigationBar的左按钮为弹出左视图.
 *
 *	@param 	animation 	是否使用动画,YES为使用.
 *
 *	@discussion	如果当前的ViewController在NavigationController中，可以用ViewController直接调用此方法来设置LeftBarButtonItem or RightBarButtonItem.
 */
- (void)setLeftBarItemShowLeftView:(BOOL)animation;

/**
 *	@brief	设置NavigationBar的右按钮为弹出右视图.
 *
 *	@param 	animation 	是否使用动画,YES为使用.
 *
 *	@discussion	如果当前的ViewController在NavigationController中，可以用ViewController直接调用此方法来设置LeftBarButtonItem or RightBarButtonItem.
 */
- (void)setRightBarItemShowRightView:(BOOL)animation;


@end

@protocol CLSideSlideViewControllerDelegate <NSObject>

@optional
/**
 *	@brief	将要弹出左/右视图.
 *
 *	@param 	isLeft 	BOOL型,为YES,为左视图,反之为右视图.
 */
- (void)sideSlideController:(CLSideSlideController *)sideSlideController willShowLeftViewController:(BOOL)isLeft;

/**
 *	@brief	已经弹出左/右视图.
 *
 *	@param 	isLeft 	BOOL型,为YES,为左视图,反之为右视图.
 */
- (void)sideSlideController:(CLSideSlideController *)sideSlideController didShowLeftViewController:(BOOL)isLeft;

/**
 *	@brief	将要隐藏左/右视图.
 *
 *	@param 	isLeft 	BOOL型,为YES,为左视图,反之为右视图.
 */
- (void)sideSlideController:(CLSideSlideController *)sideSlideController willHideLeftViewController:(BOOL)isLeft;

/**
 *	@brief	已经隐藏左/右视图.
 *
 *	@param 	isLeft 	BOOL型,为YES,为左视图,反之为右视图.
 */
- (void)sideSlideController:(CLSideSlideController *)sideSlideController didHideLeftViewController:(BOOL)isLeft;

/**
 *	@brief	已经显示主视图.
 */
- (void)didShowRootViewControllerForSideSlideController:(CLSideSlideController *)sideSlideController;

/**
 *	@brief	将要旋转缩放主视图.
 */
- (void)willRotateSacleMianViewForSideSlideController:(CLSideSlideController *)sideSlideController;

/**
 *	@brief	已经旋转缩放主视图.
 */
- (void)didRotateScaleMainViewForSideSlideController:(CLSideSlideController *)sideSlideController;

/**
 *	@brief	将要复原主视图.
 */
- (void)willRecoverMainViewForSideSlideController:(CLSideSlideController *)sideSlideController;

/**
 *	@brief	已经复原主视图.
 */
- (void)didRecoverMainViewForSideSlideController:(CLSideSlideController *)sideSlideController;

@end

