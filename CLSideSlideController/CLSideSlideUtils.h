//
//  CLSideSlideUtils.h
//  CLSideSlideController
//
//  Created by L on 14-3-18.
//  Copyright (c) 2014年 Cui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define IOS7AndMore ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)

#define SSRELEASE(exp) [exp release], exp = nil

#pragma mark - UINavigationController(CLSideSlid)
@interface UINavigationController(CLSideSlid)

@property (nonatomic, assign, readonly) UIView *contentView;
@property (nonatomic, assign, readonly) UIViewController *rootController;

@end

#pragma mark - UIBarButtonItem(CLSideSlid)
@interface UIBarButtonItem(CLSideSlid)

@property (nonatomic) BOOL animation;

@end

#pragma mark - UIViewExpand(CLSideSlid)
@interface UIView(CLSideSlid)

@property (nonatomic) CGFloat ssMinX;

@property (nonatomic) CGFloat ssMinY;

@property (nonatomic) CGFloat ssMaxX;

@property (nonatomic) CGFloat ssMaxY;

@property (nonatomic) CGFloat ssWidth;

@property (nonatomic) CGFloat ssHeight;


@end
